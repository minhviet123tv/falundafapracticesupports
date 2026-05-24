import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Gọi JavaScript an toàn — bỏ qua khi widget đã dispose hoặc WebView đang teardown.
class WebViewJsSafe {
  WebViewJsSafe._();

  static Future<void> run(
    WebViewController controller,
    String javaScript, {
    required bool Function() canRun,
  }) async {
    if (!canRun()) return;
    try {
      await controller.runJavaScript(javaScript);
    } catch (e, st) {
      debugPrint('WebViewJsSafe.run: $e\n$st');
    }
  }

  static Future<Object?> returningResult(
    WebViewController controller,
    String javaScript, {
    required bool Function() canRun,
  }) async {
    if (!canRun()) return null;
    try {
      return await controller.runJavaScriptReturningResult(javaScript);
    } catch (e, st) {
      debugPrint('WebViewJsSafe.returningResult: $e\n$st');
      return null;
    }
  }
}

/// Đặt [webViewJsAllowed] = false trước [super.dispose] để chặn JS nền.
mixin WebViewJsHost<T extends StatefulWidget> on State<T> {
  bool webViewJsAllowed = true;

  bool get canRunWebViewJs => webViewJsAllowed && mounted;

  @override
  void dispose() {
    webViewJsAllowed = false;
    super.dispose();
  }
}
