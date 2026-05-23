import 'dart:convert';

import 'package:flutter/material.dart';

/// Ẩn/hiện AppBar + thanh URL khi cuộn (chỉ trượt overlay — không đổi khung WebView).
mixin WebviewScrollChromeMixin<T extends StatefulWidget> on State<T> {
  static const String chromeHideBlockedMessage =
      'Trang đang lỗi hoặc không cuộn được — không thể ẩn thanh công cụ.';

  /// Cuộn nhanh: một báo cáo nhảy ≥ [scrollImpulsePx] → ẩn/hiện ngay.
  static const double scrollImpulsePx = 3;

  /// Cuộn chậm: scrollTop thường +0–1px/lần — cộng dồn cùng hướng rồi toggle.
  static const double scrollAccumPx = 2;

  static const double minScrollableExtra = 40;
  static const Duration chromeAnimDuration = Duration(milliseconds: 200);
  static const Curve chromeAnimCurve = Curves.easeInOut;

  bool overlayChromeVisible = true;

  /// false khi trang lỗi hoặc không đủ nội dung cuộn — không ẩn AppBar / không vào mở rộng.
  bool overlayChromeHideAllowed = false;

  bool _pageMainFrameFailed = false;
  double? _scrollChromeLastY;
  double _scrollChromeDirectionAccum = 0;

  bool get pageMainFrameFailed => _pageMainFrameFailed;

  void onWebViewPageLoadStarted() {
    _pageMainFrameFailed = false;
    setOverlayChromeHideAllowed(false);
    resetScrollChromeTracking();
  }

  void onWebViewMainFrameError() {
    _pageMainFrameFailed = true;
    setOverlayChromeHideAllowed(false);
  }

  void setOverlayChromeHideAllowed(bool allowed) {
    if (overlayChromeHideAllowed == allowed) {
      if (!allowed && !overlayChromeVisible) {
        _setOverlayChromeVisible(true);
      }
      return;
    }
    overlayChromeHideAllowed = allowed;
    if (!allowed) {
      _setOverlayChromeVisible(true);
    }
    if (mounted) setState(() {});
  }

  void updateOverlayChromeHideFromPageMetrics({
    required double maxScroll,
    required double chromeBarHeight,
  }) {
    if (_pageMainFrameFailed) {
      setOverlayChromeHideAllowed(false);
      return;
    }
    final minScrollable = chromeBarHeight + minScrollableExtra;
    setOverlayChromeHideAllowed(maxScroll >= minScrollable);
  }

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

    if (!_pageMainFrameFailed) {
      final minScrollable = chromeBarHeight + minScrollableExtra;
      final shouldAllow = maxScroll >= minScrollable;
      if (shouldAllow != overlayChromeHideAllowed) {
        setOverlayChromeHideAllowed(shouldAllow);
      }
    }

    if (!overlayChromeHideAllowed) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      if (!overlayChromeVisible) {
        _setOverlayChromeVisible(true);
      }
      return;
    }

    final minScrollable = chromeBarHeight + minScrollableExtra;
    if (maxScroll < minScrollable) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      _setOverlayChromeVisible(true);
      return;
    }

    // Đầu trang: luôn hiện thanh (giống Chrome).
    if (scrollY <= 8) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      _setOverlayChromeVisible(true);
      return;
    }

    if (_scrollChromeLastY != null) {
      final delta = scrollY - _scrollChromeLastY!;
      if (delta > 0) {
        if (_scrollChromeDirectionAccum < 0) {
          _scrollChromeDirectionAccum = 0;
        }
        _scrollChromeDirectionAccum += delta;
        if (overlayChromeVisible &&
            (delta >= scrollImpulsePx ||
                _scrollChromeDirectionAccum >= scrollAccumPx)) {
          _setOverlayChromeVisible(false);
          _scrollChromeDirectionAccum = 0;
        }
      } else if (delta < 0) {
        if (_scrollChromeDirectionAccum > 0) {
          _scrollChromeDirectionAccum = 0;
        }
        _scrollChromeDirectionAccum += delta;
        if (!overlayChromeVisible &&
            (delta <= -scrollImpulsePx ||
                _scrollChromeDirectionAccum <= -scrollAccumPx)) {
          _setOverlayChromeVisible(true);
          _scrollChromeDirectionAccum = 0;
        }
      }
    }
    _scrollChromeLastY = scrollY;
  }

  void _setOverlayChromeVisible(bool visible) {
    if (visible == overlayChromeVisible) return;
    setState(() => overlayChromeVisible = visible);
  }

  Widget wrapChromeBarForScrollHide(Widget bar, {required bool enabled}) {
    if (!enabled || !overlayChromeHideAllowed) return bar;
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

  /// Vị trí `top` của WebView trong [Stack].
  ///
  /// - **Cuộn ẩn toolbar** ([overlayChromeHideAllowed]): WebView cố định dưới status bar,
  ///   toolbar chỉ trượt overlay — tránh giật khi ẩn/hiện (không đổi layout WebView).
  /// - **Toolbar luôn hiện** (trang lỗi / không đủ cuộn): WebView bắt đầu dưới toolbar + URL bar.
  /// - **Đang animate mở rộng**: interpolate giữa hai vị trí.
  double webViewTopOffset({
    required double topInset,
    required double chromeBarHeight,
    required double immersiveProgress,
    required bool scrollHideEnabled,
    bool overlayChromeHideAllowed = false,
  }) {
    final t = immersiveProgress.clamp(0.0, 1.0);

    if (t > 0 && t < 1.0) {
      return topInset + (1 - t) * chromeBarHeight;
    }

    if (scrollHideEnabled && overlayChromeHideAllowed) {
      return topInset;
    }

    return topInset + chromeBarHeight;
  }
}
