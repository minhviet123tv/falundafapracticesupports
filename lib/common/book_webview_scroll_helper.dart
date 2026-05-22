import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_state_store.dart';

/// JavaScript + thao tác cuộn dùng chung cho tab ZFL Book và màn hình mở rộng.
class BookWebViewScrollHelper {
  /// Chiều cao AppBar/toolbar Book (tab + mở rộng phải trùng để bù ± đúng).
  static const double bookAppBarHeightPx = 44;

  static int _restoreGeneration = 0;

  /// Tab Book → Mở rộng: AppBar nổi đè WebView → cuộn **lên** (âm) bằng [bookAppBarHeightPx].
  static double scrollOffsetOpeningFullscreenFromBookTab() {
    return -bookAppBarHeightPx;
  }

  /// Mở rộng → tab Book: lưu scroll **xuống** (dương) để khớp tọa độ tab (layout không đè).
  static BookScrollPosition positionForBookTabFromFullscreen(
    BookScrollPosition fullscreenPosition,
  ) {
    return BookScrollPosition(
      scrollY: fullscreenPosition.scrollY + bookAppBarHeightPx,
      scrollRatio: 0,
    );
  }

  /// Chuẩn hóa URL làm khóa lưu cuộn (tránh lệch http/https, slash cuối).
  static String normalizeUrlKey(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return url;
    var path = uri.path;
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return uri.replace(path: path).toString();
  }

  /// Hủy các lần `scrollTo` trễ (retry) — gọi khi người dùng cuộn tay.
  static void cancelPendingRestores() {
    _restoreGeneration++;
  }

  /// Tìm vị trí cuộn đã lưu theo URL gốc hoặc URL chuẩn hóa.
  static BookScrollPosition? scrollForUrl(
    Map<String, BookScrollPosition> scrollByUrl,
    String url,
  ) {
    final direct = scrollByUrl[url];
    if (direct != null) return direct;
    final normalized = normalizeUrlKey(url);
    if (normalized != url) {
      return scrollByUrl[normalized];
    }
    return null;
  }

  static bool positionsClose(
    BookScrollPosition a,
    BookScrollPosition b, {
    double pixelTolerance = 28,
    double ratioTolerance = 0.015,
  }) {
    if (a.scrollRatio > 0.01 && b.scrollRatio > 0.01) {
      return (a.scrollRatio - b.scrollRatio).abs() <= ratioTolerance;
    }
    return (a.scrollY - b.scrollY).abs() <= pixelTolerance;
  }

  /// Đã ở đúng vị trí lưu (kể cả bù AppBar khi mở rộng) thì không restore lại.
  static bool shouldSkipRestore(
    BookScrollPosition saved,
    BookScrollPosition? current, {
    double scrollOffsetPx = 0,
    bool useScrollRatio = true,
  }) {
    if (current == null) return false;
    if (scrollOffsetPx != 0 || !useScrollRatio) {
      final targetY = (saved.scrollY + scrollOffsetPx).clamp(0.0, double.infinity);
      return (current.scrollY - targetY).abs() <= 28;
    }
    return positionsClose(current, saved);
  }
  static const String readPositionJs = '''
(function() {
  var el = document.scrollingElement || document.documentElement;
  var y = window.pageYOffset || el.scrollTop || document.body.scrollTop || 0;
  var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
  var max = Math.max(0, (el.scrollHeight || 0) - viewH);
  var ratio = max > 0 ? y / max : 0;
  return JSON.stringify({y: y, ratio: ratio, max: max, url: location.href});
})()
''';

  static const String installReporterJs = '''
(function() {
  if (window.__zflScrollHooked) return;
  window.__zflScrollHooked = true;
  var persistTimer = null;
  var rafPending = false;
  function report() {
    var el = document.scrollingElement || document.documentElement;
    var y = window.pageYOffset || el.scrollTop || 0;
    var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
    var max = Math.max(0, (el.scrollHeight || 0) - viewH);
    var ratio = max > 0 ? y / max : 0;
    if (window.ScrollReporter) {
      ScrollReporter.postMessage(JSON.stringify({y: y, ratio: ratio, max: max, url: location.href}));
    }
  }
  window.addEventListener('scroll', function() {
    if (!rafPending) {
      rafPending = true;
      requestAnimationFrame(function() {
        rafPending = false;
        report();
      });
    }
    clearTimeout(persistTimer);
    persistTimer = setTimeout(report, 350);
  }, {passive: true});
})();
''';

  /// [scrollOffsetPx]: cộng vào scrollY sau khi tính (âm = cuộn lên, dương = cuộn xuống).
  /// [useScrollRatio]: false = dùng pixel tab Book (ổn định khi đổi WebView / chiều cao viewport).
  static String restorePositionJs(
    BookScrollPosition position, {
    double scrollOffsetPx = 0,
    bool useScrollRatio = true,
  }) {
    final ratio = position.scrollRatio;
    final targetY = position.scrollY.round();
    final offset = scrollOffsetPx.round();
    final useRatio = useScrollRatio && ratio > 0.01;
    return '''
(function() {
  var el = document.scrollingElement || document.documentElement;
  var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
  var max = Math.max(0, (el.scrollHeight || 0) - viewH);
  var y = ${useRatio ? 'Math.round(max * $ratio)' : '$targetY'};
  y = Math.min(Math.max(0, y + $offset), max);
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
    double scrollOffsetPx = 0,
    bool useScrollRatio = true,
    List<int> retryDelaysMs = const <int>[350, 700, 1200],
  }) async {
    if (position.scrollY <= 0 &&
        position.scrollRatio <= 0 &&
        scrollOffsetPx == 0) {
      return;
    }

    final generation = ++_restoreGeneration;

    Future<void> applyOnce() async {
      if (generation != _restoreGeneration) return;
      await controller.runJavaScript(
        restorePositionJs(
          position,
          scrollOffsetPx: scrollOffsetPx,
          useScrollRatio: useScrollRatio,
        ),
      );
    }

    await applyOnce();

    for (final delayMs in retryDelaysMs) {
      await Future<void>.delayed(Duration(milliseconds: delayMs));
      if (generation != _restoreGeneration) return;
      if (isMounted != null && !isMounted()) return;

      final current = await readPosition(controller);
      if (shouldSkipRestore(
        position,
        current,
        scrollOffsetPx: scrollOffsetPx,
        useScrollRatio: useScrollRatio,
      )) {
        return;
      }

      await applyOnce();
    }
  }

  static Future<void> installReporter(WebViewController controller) async {
    try {
      await controller.runJavaScript(installReporterJs);
    } catch (_) {}
  }
}
