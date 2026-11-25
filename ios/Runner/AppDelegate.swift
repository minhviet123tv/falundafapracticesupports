import Flutter
import UIKit
import WebKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: "com.mvdragon.falundafapracticesupports/webview_fullscreen",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "enableElementFullscreen" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let enabledCount = self?.enableElementFullscreenOnWebViews() ?? 0
      result(enabledCount)
    }
  }

  /// Bật HTML Fullscreen API cho mọi WKWebView đang hiện (mặc định iOS tắt).
  @discardableResult
  private func enableElementFullscreenOnWebViews() -> Int {
    var count = 0
    for window in UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .flatMap({ $0.windows })
    {
      count += enableElementFullscreen(in: window)
    }
    return count
  }

  private func enableElementFullscreen(in view: UIView) -> Int {
    var count = 0
    if let webView = view as? WKWebView {
      if #available(iOS 15.4, *) {
        webView.configuration.preferences.isElementFullscreenEnabled = true
        count += 1
      }
    }
    for child in view.subviews {
      count += enableElementFullscreen(in: child)
    }
    return count
  }
}
