import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// Cấu hình WebView dùng chung — UA giống Chrome, mixed content (Android), lazy images.
///
/// Lưu ý: emulator `sdk_gphone16k` (16KB page) hay SIGTRAP trong thread MemoryInfra
/// của Chromium — thường là lỗi WebView/emulator, không phải Dart. Thử máy thật
/// hoặc AVD 4KB. Chrome ẩn/hiện dùng overlay (không resize WebView).
class AppWebViewConfig {
  AppWebViewConfig._();

  /// User-Agent mobile Chrome (giảm chặn ảnh/CDN trên site như minghui.org).
  static const String chromeMobileUserAgent =
      'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36';

  static PlatformWebViewControllerCreationParams creationParams() {
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      return WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    }
    return const PlatformWebViewControllerCreationParams();
  }

  static WebViewController createController() {
    return WebViewController.fromPlatformCreationParams(creationParams());
  }

  /// Gọi sau khi gán delegate/channels, trước [loadRequest].
  static Future<void> applyPlatformSettings(
    WebViewController controller, {
    bool enableAndroidDebugging = false,
  }) async {
    await controller.setUserAgent(chromeMobileUserAgent);

    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      if (enableAndroidDebugging) {
        AndroidWebViewController.enableDebugging(true);
      }
      await platform.setMediaPlaybackRequiresUserGesture(false);
      // Cho phép ảnh http trên trang https (CDN cũ / mixed content).
      await platform.setMixedContentMode(MixedContentMode.alwaysAllow);
      try {
        final cookieManager = AndroidWebViewCookieManager(
          const PlatformWebViewCookieManagerCreationParams(),
        );
        await cookieManager.setAcceptThirdPartyCookies(platform, true);
      } catch (e) {
        debugPrint('AppWebViewConfig third-party cookies: $e');
      }
    } else if (platform is WebKitWebViewController) {
      await platform.setAllowsBackForwardNavigationGestures(true);
    }
  }

  /// Ép ảnh lazy-load / data-src / ảnh lỗi tải lại (ưu tiên minghui.org).
  static const String _forceImagesJs = r'''
(() => {
  function pickUrl(el) {
    const attrs = [
      'data-src', 'data-original', 'data-lazy-src', 'data-lazy',
      'data-url', 'data-image', 'data-actualsrc', 'data-echo'
    ];
    for (const a of attrs) {
      const v = el.getAttribute(a);
      if (v && v.trim() && !v.trim().startsWith('data:')) return v.trim();
    }
    const srcset = el.getAttribute('data-srcset') || el.getAttribute('data-lazy-srcset');
    if (srcset) {
      const first = srcset.split(',')[0];
      if (first) {
        const u = first.trim().split(/\s+/)[0];
        if (u) return u;
      }
    }
    return null;
  }

  function promote(el) {
    el.removeAttribute('loading');
    el.loading = 'eager';
    el.setAttribute('decoding', 'async');
    const fromData = pickUrl(el);
    if (fromData) {
      if (el.tagName === 'IMG' && el.getAttribute('src') !== fromData) {
        el.setAttribute('src', fromData);
      }
      if (el.tagName === 'SOURCE') {
        el.setAttribute('srcset', fromData);
      }
    }
    const ds = el.getAttribute('data-srcset');
    if (ds && el.tagName === 'IMG' && !el.getAttribute('srcset')) {
      el.setAttribute('srcset', ds);
    }
  }

  function reloadBroken(img) {
    const src = img.currentSrc || img.getAttribute('src');
    if (!src || src.startsWith('data:')) return;
    if (img.complete && img.naturalHeight > 0) return;
    img.removeAttribute('loading');
    img.loading = 'eager';
    const bust = src.indexOf('?') >= 0 ? '&' : '?';
    const next = src.replace(/([?&])_zfl=\d+/g, '').replace(/[?&]$/, '')
      + bust + '_zfl=' + Date.now();
    img.setAttribute('src', next);
  }

  function sweep() {
    document.querySelectorAll('img').forEach((img) => {
      promote(img);
      reloadBroken(img);
    });
    document.querySelectorAll('source[data-src], source[data-srcset]').forEach(promote);
    document.querySelectorAll('picture img').forEach((img) => {
      promote(img);
      reloadBroken(img);
    });
  }

  sweep();

  if (!window.__zflImgHooked) {
    window.__zflImgHooked = true;
    const mo = new MutationObserver(() => {
      clearTimeout(window.__zflImgMoTimer);
      window.__zflImgMoTimer = setTimeout(sweep, 120);
    });
    mo.observe(document.documentElement || document.body, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['src', 'data-src', 'data-original', 'data-lazy-src', 'srcset', 'class']
    });
    window.addEventListener('scroll', () => {
      clearTimeout(window.__zflImgScrollTimer);
      window.__zflImgScrollTimer = setTimeout(sweep, 200);
    }, { passive: true });
    window.addEventListener('load', sweep, { once: true });
  }
})();
''';

  /// Hỗ trợ menu/ảnh lazy-load (ưu tiên minghui.org).
  static Future<void> refreshLazyImages(WebViewController controller) async {
    try {
      await controller.runJavaScript(_forceImagesJs);
    } catch (e, st) {
      debugPrint('AppWebViewConfig.refreshLazyImages: $e\n$st');
    }
  }

  /// Gọi từ [NavigationDelegate.onPageFinished] khi cần.
  /// [nudgeLazyImages]: ép ảnh lazy; [retryImageLoads]: quét lại sau vài trăm ms–giây.
  static Future<void> onPageFinishedEnhancements(
    WebViewController controller, {
    bool nudgeLazyImages = false,
    bool retryImageLoads = false,
  }) async {
    if (!nudgeLazyImages && !retryImageLoads) return;

    await refreshLazyImages(controller);

    if (!retryImageLoads) return;

    // Trang minghui thường gắn ảnh lazy sau paint / khi cuộn — quét lại vài lần.
    for (final delayMs in const <int>[400, 1200, 2800]) {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      await refreshLazyImages(controller);
    }
  }
}
