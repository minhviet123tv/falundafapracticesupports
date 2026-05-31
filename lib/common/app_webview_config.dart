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
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

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
      await platform.setMixedContentMode(MixedContentMode.compatibilityMode);
    } else if (platform is WebKitWebViewController) {
      await platform.setAllowsBackForwardNavigationGestures(true);
    }
  }

  /// Hỗ trợ menu/ảnh lazy-load (ưu tiên minghui.org).
  static Future<void> refreshLazyImages(WebViewController controller) async {
    try {
      await controller.runJavaScript('''
        (() => {
          const imgs = document.querySelectorAll('img');
          imgs.forEach((img) => {
            const src = img.currentSrc || img.src;
            if (!src) return;
            if (!img.complete || img.naturalHeight === 0) {
              const copy = src;
              img.removeAttribute('loading');
              img.src = '';
              img.src = copy;
            }
          });
        })();
      ''');
    } catch (e, st) {
      debugPrint('AppWebViewConfig.refreshLazyImages: $e\n$st');
    }
  }

  /// Gọi từ [NavigationDelegate.onPageFinished] khi cần.
  static Future<void> onPageFinishedEnhancements(
    WebViewController controller, {
    bool nudgeLazyImages = false,
  }) async {
    if (nudgeLazyImages) {
      await refreshLazyImages(controller);
    }
  }
}
