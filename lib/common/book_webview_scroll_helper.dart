import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_state_store.dart';

/// JavaScript + thao tác cuộn dùng chung cho WebView đọc sách (tab Book, All Books).
class BookWebViewScrollHelper {
  /// Chiều cao AppBar/toolbar đọc sách (tab Book immersive + overlay).
  static const double bookAppBarHeightPx = 44;

  static int _restoreGeneration = 0;
  static int? _activeRestoreGeneration;

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

  /// Hủy retry `scrollTo` đang chờ — chỉ khi người dùng cuộn tay trong lúc restore.
  static void cancelPendingRestoresOnUserScroll() {
    if (_activeRestoreGeneration != null) {
      _restoreGeneration++;
      _activeRestoreGeneration = null;
    }
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

  /// Đã ở đúng vị trí lưu thì không restore lại.
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

  /// Throttle báo cáo scroll — giảm áp lực bridge/WebView (đặc biệt emulator 16KB).
  static const int scrollReporterMinIntervalMs = 200;

  static const String installReporterJs = '''
(function() {
  if (window.__zflScrollHooked) return;
  window.__zflScrollHooked = true;
  var persistTimer = null;
  var rafPending = false;
  var lastPostMs = 0;
  var minInterval = $scrollReporterMinIntervalMs;
  function report(force) {
    var el = document.scrollingElement || document.documentElement;
    var y = window.pageYOffset || el.scrollTop || 0;
    var viewH = window.innerHeight || document.documentElement.clientHeight || 0;
    var max = Math.max(0, (el.scrollHeight || 0) - viewH);
    var ratio = max > 0 ? y / max : 0;
    var now = Date.now();
    if (!force && now - lastPostMs < minInterval) return;
    lastPostMs = now;
    if (window.ScrollReporter) {
      ScrollReporter.postMessage(JSON.stringify({y: y, ratio: ratio, max: max, url: location.href}));
    }
  }
  window.addEventListener('scroll', function() {
    if (!rafPending) {
      rafPending = true;
      requestAnimationFrame(function() {
        rafPending = false;
        report(false);
      });
    }
    clearTimeout(persistTimer);
    persistTimer = setTimeout(function() { report(true); }, 350);
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

  /// URL thật trên trang (gồm hash) — ổn định hơn `WebViewController.currentUrl()` trên SPA.
  static Future<String?> readPageUrl(WebViewController controller) async {
    try {
      final result =
          await controller.runJavaScriptReturningResult('location.href');
      dynamic href = result;
      if (result is String) {
        final trimmed = result.trim();
        if (trimmed.isEmpty) return null;
        try {
          href = jsonDecode(trimmed);
        } catch (_) {
          href = trimmed;
        }
      }
      if (href is! String) return null;
      final url = href.trim();
      if (url.isEmpty || url == 'about:blank') return null;
      return url;
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
    bool useScrollRatio = false,
    List<int> retryDelaysMs = const <int>[500],
  }) async {
    if (position.scrollY <= 0 &&
        position.scrollRatio <= 0 &&
        scrollOffsetPx == 0) {
      return;
    }

    final generation = ++_restoreGeneration;
    _activeRestoreGeneration = generation;

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

    try {
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
    } finally {
      if (_activeRestoreGeneration == generation) {
        _activeRestoreGeneration = null;
      }
    }
  }

  static Future<void> installReporter(WebViewController controller) async {
    try {
      await controller.runJavaScript(installReporterJs);
    } catch (_) {}
  }
}
