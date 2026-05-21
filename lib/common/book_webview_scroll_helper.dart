import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_state_store.dart';

/// JavaScript + thao tác cuộn dùng chung cho tab ZFL Book và màn hình mở rộng.
class BookWebViewScrollHelper {
  static const String readPositionJs = '''
(function() {
  var el = document.scrollingElement || document.documentElement;
  var y = window.pageYOffset || el.scrollTop || document.body.scrollTop || 0;
  var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
  var max = Math.max(0, (el.scrollHeight || 0) - viewH);
  var ratio = max > 0 ? y / max : 0;
  return JSON.stringify({y: y, ratio: ratio, url: location.href});
})()
''';

  static const String installReporterJs = '''
(function() {
  if (window.__zflScrollHooked) return;
  window.__zflScrollHooked = true;
  var timer = null;
  function report() {
    var el = document.scrollingElement || document.documentElement;
    var y = window.pageYOffset || el.scrollTop || 0;
    var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
    var max = Math.max(0, (el.scrollHeight || 0) - viewH);
    var ratio = max > 0 ? y / max : 0;
    if (window.ScrollReporter) {
      ScrollReporter.postMessage(JSON.stringify({y: y, ratio: ratio, url: location.href}));
    }
  }
  window.addEventListener('scroll', function() {
    clearTimeout(timer);
    timer = setTimeout(report, 350);
  }, {passive: true});
  report();
})();
''';

  static String restorePositionJs(BookScrollPosition position) {
    final ratio = position.scrollRatio;
    final targetY = position.scrollY.round();
    return '''
(function() {
  var el = document.scrollingElement || document.documentElement;
  var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
  var max = Math.max(0, (el.scrollHeight || 0) - viewH);
  var y = $ratio > 0.01 ? Math.round(max * $ratio) : $targetY;
  window.scrollTo(0, y);
})();
''';
  }

  static BookScrollPosition? parseScrollMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return null;
      final url = decoded['url'];
      final y = decoded['y'];
      final ratio = decoded['ratio'];
      if (url is! String || url.isEmpty) return null;
      if (y is! num) return null;
      final position = BookScrollPosition(
        scrollY: y.toDouble(),
        scrollRatio: ratio is num ? ratio.clamp(0.0, 1.0).toDouble() : 0,
      );
      if (position.scrollY <= 0 && position.scrollRatio <= 0) return null;
      return position;
    } catch (_) {
      return null;
    }
  }

  static Future<BookScrollPosition?> readPosition(WebViewController controller) async {
    try {
      final result = await controller.runJavaScriptReturningResult(readPositionJs);
      dynamic decoded = result;
      if (result is String) {
        final trimmed = result.trim();
        if (trimmed.isEmpty) return null;
        decoded = jsonDecode(trimmed);
      }
      if (decoded is! Map) return null;
      final y = decoded['y'];
      final ratio = decoded['ratio'];
      if (y is! num) return null;
      return BookScrollPosition(
        scrollY: y.toDouble(),
        scrollRatio: ratio is num ? ratio.clamp(0.0, 1.0).toDouble() : 0,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<void> restorePosition(
    WebViewController controller,
    BookScrollPosition position, {
    bool Function()? isMounted,
  }) async {
    if (position.scrollY <= 0 && position.scrollRatio <= 0) return;

    Future<void> applyOnce() async {
      await controller.runJavaScript(restorePositionJs(position));
    }

    await applyOnce();
    for (final delayMs in <int>[400, 900, 1600]) {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      if (isMounted != null && !isMounted()) return;
      await applyOnce();
    }
  }

  static Future<void> installReporter(WebViewController controller) async {
    try {
      await controller.runJavaScript(installReporterJs);
    } catch (_) {}
  }
}
