import 'dart:convert';

import 'package:flutter/material.dart';

/// Ẩn/hiện AppBar + thanh URL khi cuộn (chỉ trượt overlay — không đổi khung WebView).
mixin WebviewScrollChromeMixin<T extends StatefulWidget> on State<T> {
  static const double scrollHideThreshold = 56;
  static const double scrollShowThreshold = 32;
  static const double minScrollableExtra = 40;
  static const Duration chromeAnimDuration = Duration(milliseconds: 220);
  static const Curve chromeAnimCurve = Curves.easeInOut;

  bool overlayChromeVisible = true;
  double? _scrollChromeLastY;
  double _scrollChromeDirectionAccum = 0;
  DateTime? _lastChromeVisibilityChange;

  void resetScrollChromeTracking() {
    _scrollChromeLastY = null;
    _scrollChromeDirectionAccum = 0;
    _lastChromeVisibilityChange = null;
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
      _setOverlayChromeVisible(true);
      return;
    }

    if (scrollY <= 20) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      _setOverlayChromeVisible(true);
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

        if (overlayChromeVisible) {
          if (_scrollChromeDirectionAccum >= scrollHideThreshold) {
            _setOverlayChromeVisible(false);
            _scrollChromeDirectionAccum = 0;
          }
        } else if (_scrollChromeDirectionAccum <= -scrollShowThreshold) {
          _setOverlayChromeVisible(true);
          _scrollChromeDirectionAccum = 0;
        }
      }
    }
    _scrollChromeLastY = scrollY;
  }

  void _setOverlayChromeVisible(bool visible) {
    if (visible == overlayChromeVisible) return;

    final now = DateTime.now();
    if (_lastChromeVisibilityChange != null &&
        now.difference(_lastChromeVisibilityChange!) < chromeAnimDuration) {
      return;
    }
    _lastChromeVisibilityChange = now;
    setState(() => overlayChromeVisible = visible);
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

  /// WebView chỉ đổi inset khi đang animate vào/ra chế độ mở rộng.
  /// Khi cuộn ẩn chrome: chỉ trượt overlay, không nhảy layout WebView.
  double webViewTopOffset({
    required double topInset,
    required double chromeBarHeight,
    required double immersiveProgress,
    required bool scrollHideEnabled,
  }) {
    final t = immersiveProgress.clamp(0.0, 1.0);

    if (t > 0 && t < 1.0) {
      return topInset + (1 - t) * chromeBarHeight;
    }

    if (scrollHideEnabled || t >= 1.0) {
      return topInset;
    }

    return topInset + chromeBarHeight;
  }
}
