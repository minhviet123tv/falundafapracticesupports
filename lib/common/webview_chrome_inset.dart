import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_scroll_helper.dart';
import 'compact_web_url_bar.dart';

/// Spacer đầu trang web = chiều cao AppBar + browser (overlay), cuộn cùng nội dung.
class WebViewChromeInset {
  WebViewChromeInset._();

  static const String spacerId = '__zfl_chrome_spacer';

  static double contentHeight({
    bool hasUrlBar = true,
    double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx,
  }) =>
      toolbarHeight + (hasUrlBar ? CompactWebUrlBar.barHeight : 0);

  static String _installJs(double heightPx) => '''
(function(h) {
  var ID = '$spacerId';
  var el = document.getElementById(ID);
  var y = window.pageYOffset || document.documentElement.scrollTop || 0;
  if (el) {
    var oldH = parseFloat(el.style.height) || 0;
    el.style.height = h + 'px';
    if (y > 0 && Math.abs(oldH - h) > 0.5) {
      window.scrollTo(0, Math.max(0, y + (h - oldH)));
    }
    return;
  }
  el = document.createElement('div');
  el.id = ID;
  el.setAttribute('aria-hidden', 'true');
  el.style.cssText =
    'display:block;width:100%;height:' + h + 'px;margin:0;padding:0;' +
    'border:0;flex-shrink:0;pointer-events:none;box-sizing:border-box;' +
    'background:transparent;';
  var root = document.body || document.documentElement;
  if (root.firstChild) {
    root.insertBefore(el, root.firstChild);
  } else {
    root.appendChild(el);
  }
  if (y > 0) {
    window.scrollTo(0, y + h);
  }
})(${heightPx.toStringAsFixed(0)});
''';

  static Future<void> install(
    WebViewController controller,
    double heightPx,
  ) async {
    if (heightPx <= 0) return;
    try {
      await controller.runJavaScript(_installJs(heightPx));
    } catch (_) {}
  }
}
