import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const MethodChannel _fullscreenChannel = MethodChannel(
    'com.mvdragon.falundafapracticesupports/webview_fullscreen',
  );

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
  ///
  /// [allowsBackForwardNavigationGestures]: iOS WKWebView lịch sử qua vuốt.
  /// Tắt trên trang đọc dài để không tranh gesture với scroll.
  /// [optimizeForEmbeddedVideo]: cookie bên thứ 3 + media inline (Ganjing iframe).
  /// Trên iOS không ép UA Android — player video cần Safari UA để bật fullscreen.
  static Future<void> applyPlatformSettings(
    WebViewController controller, {
    bool enableAndroidDebugging = false,
    bool allowsBackForwardNavigationGestures = true,
    bool optimizeForEmbeddedVideo = false,
  }) async {
    final platform = controller.platform;
    final isIosVideo = optimizeForEmbeddedVideo &&
        defaultTargetPlatform == TargetPlatform.iOS;
    if (!isIosVideo) {
      await controller.setUserAgent(chromeMobileUserAgent);
    }

    if (platform is AndroidWebViewController) {
      if (enableAndroidDebugging) {
        AndroidWebViewController.enableDebugging(true);
      }
      await platform.setMediaPlaybackRequiresUserGesture(false);
      await platform.setMixedContentMode(MixedContentMode.compatibilityMode);
      if (optimizeForEmbeddedVideo) {
        try {
          final cookieManager = WebViewCookieManager();
          final cookiePlatform = cookieManager.platform;
          if (cookiePlatform is AndroidWebViewCookieManager) {
            await cookiePlatform.setAcceptThirdPartyCookies(platform, true);
          }
        } catch (e, st) {
          debugPrint('AppWebViewConfig third-party cookies: $e\n$st');
        }
      }
    } else if (platform is WebKitWebViewController) {
      await platform.setAllowsBackForwardNavigationGestures(
        allowsBackForwardNavigationGestures,
      );
    }
  }

  /// Bật fullscreen cho video HTML/iframe trong WebView.
  ///
  /// Android: nhận `onShowCustomView` và đẩy widget fullscreen.
  /// iOS: bật `WKPreferences.isElementFullscreenEnabled` (mặc định tắt).
  static Future<void> enableEmbeddedVideoFullscreen(
    WebViewController controller,
    BuildContext context,
  ) async {
    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      var fullscreenOpen = false;
      await platform.setCustomWidgetCallbacks(
        onShowCustomWidget: (Widget widget, void Function() onHidden) {
          if (fullscreenOpen) return;
          fullscreenOpen = true;
          Navigator.of(context, rootNavigator: true)
              .push(
            MaterialPageRoute<void>(
              fullscreenDialog: true,
              builder: (BuildContext routeContext) {
                return Scaffold(
                  backgroundColor: Colors.black,
                  body: widget,
                );
              },
            ),
          )
              .whenComplete(() {
            fullscreenOpen = false;
            onHidden();
          });
        },
        onHideCustomWidget: () {
          if (!fullscreenOpen) return;
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) {
            navigator.pop();
          }
        },
      );
      return;
    }

    if (platform is WebKitWebViewController) {
      try {
        await _fullscreenChannel.invokeMethod<int>('enableElementFullscreen');
      } catch (e, st) {
        debugPrint('AppWebViewConfig enableElementFullscreen: $e\n$st');
      }
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
