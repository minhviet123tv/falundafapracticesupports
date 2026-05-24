import 'dart:convert';

import 'package:flutter/material.dart';

/// Chrome (AppBar + URL bar): WebView luôn dưới chrome khi chrome hiện.
///
/// Ẩn/hiện do cuộn: [AnimationController] 0↔1 (cùng toolbar + WebView), không resize
/// từng frame khi ngón tay vẫn cuộn.
mixin WebviewScrollChromeMixin<T extends StatefulWidget> on State<T> {
  static const String chromeHideBlockedMessage =
      'Trang đang lỗi hoặc không cuộn được — không thể ẩn thanh công cụ.';

  static const double scrollImpulsePx = 12;
  static const double scrollAccumPx = 28;
  static const double minScrollableExtra = 40;
  static const Duration chromeAnimDuration = Duration(milliseconds: 200);
  static const Curve chromeAnimCurve = Curves.easeInOut;
  static const Duration chromeToggleCooldown = Duration(milliseconds: 400);
  static const Duration scrollChromeHandleThrottle = Duration(milliseconds: 100);
  static const double showChromeAtTopPx = 8;
  static const double hideChromeBelowScrollPx = 36;

  bool overlayChromeVisible = true;
  DateTime? _lastScrollChromeHandleAt;
  DateTime? _lastChromeToggleAt;

  bool overlayChromeHideAllowed = false;

  bool _pageMainFrameFailed = false;
  double? _scrollChromeLastY;
  double _scrollChromeDirectionAccum = 0;

  AnimationController? _chromeRevealController;
  VoidCallback? _chromeRevealListener;

  bool get pageMainFrameFailed => _pageMainFrameFailed;

  bool get isChromeRevealAnimating =>
      _chromeRevealController?.isAnimating ?? false;

  void initScrollChromeReveal(TickerProvider vsync) {
    disposeScrollChromeReveal();
    _chromeRevealController = AnimationController(
      vsync: vsync,
      duration: chromeAnimDuration,
      value: 1,
    );
    _chromeRevealListener = () {
      if (mounted) setState(() {});
    };
    _chromeRevealController!.addListener(_chromeRevealListener!);
  }

  void disposeScrollChromeReveal() {
    final c = _chromeRevealController;
    final listener = _chromeRevealListener;
    if (c != null && listener != null) {
      c.removeListener(listener);
    }
    _chromeRevealController?.dispose();
    _chromeRevealController = null;
    _chromeRevealListener = null;
  }

  /// Hệ số 0…1 cho layout chrome (scroll-hide). Immersive dùng [immersiveProgress].
  double scrollChromeRevealValue({
    required double immersiveProgress,
    required bool scrollHideEnabled,
    bool overlayChromeHideAllowed = false,
  }) {
    final t = immersiveProgress.clamp(0.0, 1.0);
    if (t > 0) {
      if (t >= 1.0) return 0;
      return 1 - t;
    }
    if (!scrollHideEnabled || !overlayChromeHideAllowed) {
      return 1;
    }
    return _chromeRevealController?.value ??
        (overlayChromeVisible ? 1.0 : 0.0);
  }

  double webViewChromeRevealFactor({
    required double immersiveProgress,
    required bool scrollHideEnabled,
    bool overlayChromeHideAllowed = false,
  }) =>
      scrollChromeRevealValue(
        immersiveProgress: immersiveProgress,
        scrollHideEnabled: scrollHideEnabled,
        overlayChromeHideAllowed: overlayChromeHideAllowed,
      );

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

  bool _chromeToggleCooldownActive() {
    final last = _lastChromeToggleAt;
    if (last == null) return false;
    return DateTime.now().difference(last) < chromeToggleCooldown;
  }

  void handleScrollChromeReport(
    String message,
    double chromeBarHeight, {
    bool scrollHideEnabled = true,
  }) {
    if (!mounted) return;
    if (isChromeRevealAnimating) return;
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final y = decoded['y'];
      final maxScroll = decoded['max'];
      if (y is! num) return;
      final scrollY = y.toDouble();

      if (scrollY > showChromeAtTopPx && _lastScrollChromeHandleAt != null) {
        final elapsed = DateTime.now().difference(_lastScrollChromeHandleAt!);
        if (elapsed < scrollChromeHandleThrottle) return;
      }
      _lastScrollChromeHandleAt = DateTime.now();

      final maxScrollPx = maxScroll is num ? maxScroll.toDouble() : 0.0;
      updateOverlayChromeFromScroll(
        scrollY,
        maxScrollPx,
        chromeBarHeight,
        scrollHideEnabled: scrollHideEnabled,
      );
    } catch (_) {}
  }

  void updateOverlayChromeFromScroll(
    double scrollY,
    double maxScroll,
    double chromeBarHeight, {
    bool scrollHideEnabled = true,
  }) {
    if (!mounted || isChromeRevealAnimating) return;

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
      _setOverlayChromeVisible(true, bypassCooldown: true);
      return;
    }

    if (scrollY <= showChromeAtTopPx) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      _setOverlayChromeVisible(true, bypassCooldown: true);
      return;
    }

    if (overlayChromeVisible && scrollY < hideChromeBelowScrollPx) {
      _scrollChromeLastY = scrollY;
      _scrollChromeDirectionAccum = 0;
      return;
    }

    if (_chromeToggleCooldownActive()) {
      _scrollChromeLastY = scrollY;
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
            scrollY >= hideChromeBelowScrollPx &&
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

  void _setOverlayChromeVisible(
    bool visible, {
    bool bypassCooldown = false,
  }) {
    if (visible == overlayChromeVisible) return;
    if (!bypassCooldown && _chromeToggleCooldownActive()) return;
    if (isChromeRevealAnimating) return;

    _lastChromeToggleAt = DateTime.now();
    overlayChromeVisible = visible;

    final controller = _chromeRevealController;
    if (controller != null) {
      controller.animateTo(
        visible ? 1.0 : 0.0,
        curve: chromeAnimCurve,
      );
    } else if (mounted) {
      setState(() {});
    }
  }

  void applyOverlayChromeVisible(bool visible) {
    _setOverlayChromeVisible(visible, bypassCooldown: true);
  }

  Widget wrapChromeBarForScrollHide(Widget bar, {required bool enabled}) {
    if (!enabled || !overlayChromeHideAllowed) return bar;
    final reveal = (_chromeRevealController?.value ??
            (overlayChromeVisible ? 1.0 : 0.0))
        .clamp(0.0, 1.0);
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: reveal,
        child: IgnorePointer(
          ignoring: reveal < 0.05,
          child: bar,
        ),
      ),
    );
  }

  Widget buildWebViewPositioned({
    required double top,
    required Widget child,
    double bottom = 0,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: 0,
      right: 0,
      child: child,
    );
  }

  double webViewTopOffset({
    required double topInset,
    required double chromeBarHeight,
    required double immersiveProgress,
    required bool scrollHideEnabled,
    bool overlayChromeHideAllowed = false,
  }) {
    final factor = webViewChromeRevealFactor(
      immersiveProgress: immersiveProgress,
      scrollHideEnabled: scrollHideEnabled,
      overlayChromeHideAllowed: overlayChromeHideAllowed,
    );
    return topInset + factor * chromeBarHeight;
  }
}
