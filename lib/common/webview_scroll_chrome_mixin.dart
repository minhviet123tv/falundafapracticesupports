import 'dart:convert';

import 'package:flutter/material.dart';

/// Ẩn/hiện AppBar + thanh URL khi cuộn (giống chế độ mở rộng — AnimatedSlide).
mixin WebviewScrollChromeMixin<T extends StatefulWidget> on State<T> {
  static const double scrollDirectionThreshold = 36;
  static const double minScrollableExtra = 40;
  static const Duration chromeAnimDuration = Duration(milliseconds: 220);
  static const Curve chromeAnimCurve = Curves.easeInOut;

  bool overlayChromeVisible = true;
  double? _scrollChromeLastY;
  double _scrollChromeDirectionAccum = 0;

  void resetScrollChromeTracking() {
    _scrollChromeLastY = null;
    _scrollChromeDirectionAccum = 0;
  }

  void handleScrollChromeReport(String message, double chromeBarHeight) {
    if (!mounted) return;
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final y = decoded['y'];
      final maxScroll = decoded['max'];
      if (y is! num) return;
      final maxScrollPx = maxScroll is num ? maxScroll.toDouble() : 0.0;
      updateOverlayChromeFromScroll(y.toDouble(), maxScrollPx, chromeBarHeight);
    } catch (_) {}
  }

  void updateOverlayChromeFromScroll(
    double scrollY,
    double maxScroll,
    double chromeBarHeight,
  ) {
    if (!mounted) return;

    final minScrollable = chromeBarHeight + minScrollableExtra;
    if (maxScroll < minScrollable) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      if (!overlayChromeVisible) {
        setState(() => overlayChromeVisible = true);
      }
      return;
    }

    if (scrollY <= 20) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      if (!overlayChromeVisible) {
        setState(() => overlayChromeVisible = true);
      }
      return;
    }

    if (_scrollChromeLastY != null) {
      final delta = scrollY - _scrollChromeLastY!;
      if (delta != 0) {
        if (delta > 0 && _scrollChromeDirectionAccum < 0) {
          _scrollChromeDirectionAccum = 0;
        } else if (delta < 0 && _scrollChromeDirectionAccum > 0) {
          _scrollChromeDirectionAccum = 0;
        }
        _scrollChromeDirectionAccum += delta;

        var nextVisible = overlayChromeVisible;
        if (_scrollChromeDirectionAccum >= scrollDirectionThreshold) {
          nextVisible = false;
          _scrollChromeDirectionAccum = 0;
        } else if (_scrollChromeDirectionAccum <= -scrollDirectionThreshold) {
          nextVisible = true;
          _scrollChromeDirectionAccum = 0;
        }
        if (nextVisible != overlayChromeVisible) {
          setState(() => overlayChromeVisible = nextVisible);
        }
      }
    }
    _scrollChromeLastY = scrollY;
  }

  Widget wrapChromeBarForScrollHide(Widget bar, {required bool enabled}) {
    if (!enabled) return bar;
    return AnimatedSlide(
      offset: overlayChromeVisible ? Offset.zero : const Offset(0, -1),
      duration: chromeAnimDuration,
      curve: chromeAnimCurve,
      child: ClipRect(
        child: IgnorePointer(
          ignoring: !overlayChromeVisible,
          child: bar,
        ),
      ),
    );
  }

  /// [immersiveProgress]: 0 = bình thường, 1 = mở rộng toàn màn (ẩn chrome cố định).
  double webViewTopOffset({
    required double topInset,
    required double chromeBarHeight,
    required double immersiveProgress,
    required bool scrollHideEnabled,
  }) {
    final t = immersiveProgress.clamp(0.0, 1.0);
    if (t >= 1.0) {
      return topInset + (overlayChromeVisible ? chromeBarHeight : 0);
    }
    if (t > 0) {
      return topInset + (1 - t) * chromeBarHeight;
    }
    if (scrollHideEnabled && !overlayChromeVisible) {
      return topInset;
    }
    return topInset + chromeBarHeight;
  }
}
