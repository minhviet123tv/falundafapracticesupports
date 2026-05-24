import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

/// Chrome (AppBar + URL bar): WebView luôn dưới chrome khi chrome hiện.
///
/// Toolbar animate mượt; WebView chỉ resize **một lần** khi ẩn/hiện (tránh crash Chromium).
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

  /// WebView đã thụt xuống dưới chrome (false = full-height dưới status bar).
  bool _webViewChromeInsetApplied = true;

  DateTime? _lastScrollChromeHandleAt;
  DateTime? _lastChromeToggleAt;

  bool overlayChromeHideAllowed = false;

  bool _pageMainFrameFailed = false;
  double? _scrollChromeLastY;
  double _scrollChromeDirectionAccum = 0;

  AnimationController? _chromeRevealController;

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
  }

  void disposeScrollChromeReveal() {
    _chromeRevealController?.dispose();
    _chromeRevealController = null;
  }

  /// Hệ số layout WebView (0 = mở rộng, 1 = dưới chrome). Immersive: chỉ snap ở đầu/cuối.
  double scrollChromeRevealValue({
    required double immersiveProgress,
    required bool scrollHideEnabled,
    bool overlayChromeHideAllowed = false,
  }) {
    final t = immersiveProgress.clamp(0.0, 1.0);
    if (t >= 1.0) return 0;
    if (t > 0) return 1;
    if (!scrollHideEnabled || !overlayChromeHideAllowed) {
      return 1;
    }
    return _webViewChromeInsetApplied ? 1.0 : 0.0;
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
    _webViewChromeInsetApplied = overlayChromeVisible;
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
    if (visible) {
      _webViewChromeInsetApplied = false;
      if (mounted) setState(() {});
      if (controller != null) {
        unawaited(
          controller.animateTo(1, curve: chromeAnimCurve).then((_) {
            if (!mounted) return;
            _webViewChromeInsetApplied = true;
            setState(() {});
          }),
        );
      } else {
        _webViewChromeInsetApplied = true;
        if (mounted) setState(() {});
      }
    } else {
      _webViewChromeInsetApplied = false;
      if (mounted) setState(() {});
      if (controller != null) {
        unawaited(controller.animateTo(0, curve: chromeAnimCurve));
      }
    }
  }

  void applyOverlayChromeVisible(bool visible) {
    overlayChromeVisible = visible;
    _webViewChromeInsetApplied = visible;
    _chromeRevealController?.value = visible ? 1.0 : 0.0;
    if (mounted) setState(() {});
  }

  Widget wrapChromeBarForScrollHide(Widget bar, {required bool enabled}) {
    if (!enabled || !overlayChromeHideAllowed) return bar;
    final controller = _chromeRevealController;

    Widget buildBar(double reveal) {
      final clamped = reveal.clamp(0.0, 1.0);
      return ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: clamped,
          child: IgnorePointer(
            ignoring: clamped < 0.05,
            child: bar,
          ),
        ),
      );
    }

    if (controller == null) {
      return buildBar(overlayChromeVisible ? 1.0 : 0.0);
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => buildBar(controller.value),
      child: bar,
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
