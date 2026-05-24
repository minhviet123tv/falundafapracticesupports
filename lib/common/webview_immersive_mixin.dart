import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_scroll_helper.dart';
import 'compact_web_url_bar.dart';

/// Chrome (AppBar + URL) trên, WebView [Expanded] ngay dưới; ẩn chrome = thu chiều cao, WebView mở rộng theo.
mixin WebviewImmersiveMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  static const double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  static const double _scrollDirectionThreshold = 36;
  static const double _hideChromeBelowScrollPx = 36;
  static const double _revealChromeAtTopScrollPx = 20;
  static const double _minScrollableExtra = 40;
  static const Duration _immersiveToggleCooldown = Duration(milliseconds: 400);
  static const Duration _scrollHandleThrottle = Duration(milliseconds: 80);
  static const Duration _postHideRevealSuppress = Duration(milliseconds: 500);
  static const double _scrollImpulsePx = 12;
  static const Color _statusBarBackground = Colors.black;
  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const Duration _chromeAnimDuration = Duration(milliseconds: 220);
  static const Curve _chromeAnimCurve = Curves.easeInOut;
  static const double _toolbarHorizontalPadding = 10;

  /// 0 = chrome hiện đủ; 1 = chrome ẩn (WebView đã mở rộng lên).
  late final AnimationController immersiveAnim;
  final ValueNotifier<bool> immersiveActive = ValueNotifier<bool>(false);

  bool _overlayChromeVisible = true;
  double? _lastScrollY;
  double _directionalScrollAccum = 0;
  DateTime? _lastImmersiveToggleAt;
  DateTime? _lastScrollHandleAt;
  DateTime? _suppressChromeRevealUntil;

  bool get immersiveHasUrlBar => true;

  double get immersiveChromeBarHeight =>
      toolbarHeight +
      (immersiveHasUrlBar ? CompactWebUrlBar.barHeight : 0);

  ValueNotifier<bool>? get externalImmersiveNotifier => null;

  double get bottomNavReserve => 0;

  bool get inImmersiveMode => immersiveActive.value;

  bool get _chromeFullyHidden =>
      immersiveActive.value && immersiveAnim.value >= 1.0;

  void initImmersive() {
    immersiveAnim = AnimationController(
      vsync: this,
      duration: _chromeAnimDuration,
      value: 0,
    );
    externalImmersiveNotifier?.addListener(_onExternalImmersiveChanged);
  }

  void disposeImmersive() {
    externalImmersiveNotifier?.removeListener(_onExternalImmersiveChanged);
    if (externalImmersiveNotifier?.value == true) {
      externalImmersiveNotifier!.value = false;
    }
    immersiveActive.dispose();
    immersiveAnim.dispose();
  }

  void _onExternalImmersiveChanged() {
    if (externalImmersiveNotifier?.value != true &&
        immersiveActive.value &&
        mounted) {
      unawaited(exitImmersiveMode());
    }
  }

  bool _immersiveToggleCooldownActive() {
    final last = _lastImmersiveToggleAt;
    if (last == null) return false;
    return DateTime.now().difference(last) < _immersiveToggleCooldown;
  }

  bool _chromeRevealSuppressActive() {
    final until = _suppressChromeRevealUntil;
    if (until == null) return false;
    return DateTime.now().isBefore(until);
  }

  double _chromeRevealFactor() =>
      (1.0 - _chromeAnimCurve.transform(immersiveAnim.value)).clamp(0.0, 1.0);

  void handleImmersiveScrollReport(String message) {
    if (!mounted || immersiveAnim.isAnimating) return;
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final y = decoded['y'];
      final maxScroll = decoded['max'];
      if (y is! num) return;
      final scrollY = y.toDouble();
      final maxScrollPx = maxScroll is num ? maxScroll.toDouble() : 0.0;

      if (scrollY > _revealChromeAtTopScrollPx && _lastScrollHandleAt != null) {
        final elapsed = DateTime.now().difference(_lastScrollHandleAt!);
        if (elapsed < _scrollHandleThrottle) return;
      }
      _lastScrollHandleAt = DateTime.now();

      _updateChromeVisibilityFromScroll(scrollY, maxScrollPx);
    } catch (_) {}
  }

  void _updateChromeVisibilityFromScroll(double scrollY, double maxScroll) {
    if (!mounted) return;

    final minScrollable = immersiveChromeBarHeight + _minScrollableExtra;
    if (maxScroll < minScrollable) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (!_chromeFullyHidden) {
        unawaited(_showChromeLayout(bypassCooldown: true));
      }
      return;
    }

    if (scrollY <= _revealChromeAtTopScrollPx) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (_overlayChromeVisible || _chromeRevealSuppressActive()) {
        return;
      }
      unawaited(_showChromeLayout(bypassCooldown: true));
      return;
    }

    if (_overlayChromeVisible && scrollY < _hideChromeBelowScrollPx) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      return;
    }

    if (immersiveActive.value && _chromeRevealSuppressActive()) {
      return;
    }

    if (_immersiveToggleCooldownActive()) {
      if (_overlayChromeVisible) {
        _lastScrollY = scrollY;
      }
      return;
    }

    if (_lastScrollY != null) {
      final delta = scrollY - _lastScrollY!;
      if (delta != 0) {
        if (_overlayChromeVisible) {
          _applyScrollWhileChromeVisible(delta, scrollY);
        } else if (immersiveActive.value) {
          _applyScrollWhileChromeHidden(delta);
        }
      }
    }
    _lastScrollY = scrollY;
  }

  void _applyScrollWhileChromeVisible(double delta, double scrollY) {
    if (scrollY < _hideChromeBelowScrollPx) {
      _directionalScrollAccum = 0;
      return;
    }
    if (delta <= 0) {
      _directionalScrollAccum = 0;
      return;
    }
    if (_directionalScrollAccum < 0) {
      _directionalScrollAccum = 0;
    }
    _directionalScrollAccum += delta;
    if (_directionalScrollAccum >= _scrollDirectionThreshold ||
        delta >= _scrollImpulsePx) {
      _directionalScrollAccum = 0;
      unawaited(_hideChromeLayout());
    }
  }

  void _applyScrollWhileChromeHidden(double delta) {
    if (_chromeRevealSuppressActive() || immersiveAnim.isAnimating) {
      return;
    }
    if (delta >= 0) {
      _directionalScrollAccum = 0;
      return;
    }
    if (_directionalScrollAccum > 0) {
      _directionalScrollAccum = 0;
    }
    _directionalScrollAccum += delta;
    if (_directionalScrollAccum <= -_scrollDirectionThreshold ||
        delta <= -_scrollImpulsePx) {
      _directionalScrollAccum = 0;
      unawaited(_showChromeLayout());
    }
  }

  Future<void> _hideChromeLayout() async {
    if (!mounted ||
        immersiveAnim.isAnimating ||
        _chromeFullyHidden ||
        !_overlayChromeVisible) {
      return;
    }
    if (_immersiveToggleCooldownActive()) return;

    _lastImmersiveToggleAt = DateTime.now();
    _overlayChromeVisible = false;
    immersiveActive.value = true;
    externalImmersiveNotifier?.value = true;
    if (mounted) setState(() {});

    await immersiveAnim.forward();
    if (!mounted) return;

    _lastScrollY = null;
    _directionalScrollAccum = 0;
    _suppressChromeRevealUntil =
        DateTime.now().add(_postHideRevealSuppress);
    if (mounted) setState(() {});
  }

  Future<void> _showChromeLayout({bool bypassCooldown = false}) async {
    if (!mounted || immersiveAnim.isAnimating) return;
    if (_overlayChromeVisible && immersiveAnim.value <= 0) return;
    if (!bypassCooldown && _immersiveToggleCooldownActive()) return;

    _lastImmersiveToggleAt = DateTime.now();
    _suppressChromeRevealUntil = null;
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    immersiveActive.value = false;
    externalImmersiveNotifier?.value = false;
    if (mounted) setState(() {});

    await immersiveAnim.reverse();
    if (!mounted) return;

    _overlayChromeVisible = true;
    if (mounted) setState(() {});
  }

  Future<void> installImmersiveScrollReporter(WebViewController controller) async {
    await BookWebViewScrollHelper.installReporter(controller);
  }

  Future<void> onImmersivePageFinished() async {
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    _lastScrollHandleAt = null;
  }

  void onImmersivePageStarted() {
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    _lastScrollHandleAt = null;
  }

  Future<void> toggleImmersiveMode() async {
    if (inImmersiveMode) {
      await exitImmersiveMode();
    } else {
      await enterImmersiveMode();
    }
  }

  Future<void> enterImmersiveMode() async {
    if (!mounted || inImmersiveMode) return;
    await _hideChromeLayout();
  }

  Future<void> exitImmersiveMode() async {
    if (!mounted) return;
    await _showChromeLayout(bypassCooldown: true);
  }

  Future<bool> handleImmersiveSystemBack() async {
    if (immersiveActive.value) {
      await exitImmersiveMode();
      return true;
    }
    return false;
  }

  Widget buildImmersiveToggleButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: immersiveActive,
      builder: (context, immersive, _) {
        return IconButton(
          onPressed: () => toggleImmersiveMode(),
          icon: Icon(
            immersive ? Icons.fullscreen_exit : Icons.zoom_out_map,
            size: 20,
          ),
          tooltip: immersive ? 'Thu gọn' : 'Mở rộng màn hình',
        );
      },
    );
  }

  Widget buildImmersiveScaffold({
    required Widget toolbar,
    Widget? urlBar,
    required Widget body,
    VoidCallback? onPop,
  }) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (await handleImmersiveSystemBack()) return;
        onPop?.call();
      },
      child: ListenableBuilder(
        listenable: Listenable.merge([immersiveAnim, immersiveActive]),
        builder: (context, _) =>
            _buildImmersiveChrome(toolbar: toolbar, urlBar: urlBar, body: body),
      ),
    );
  }

  Widget _buildChromeBar({required Widget toolbar, Widget? urlBar}) {
    return Material(
      color: Colors.white,
      elevation: _chromeRevealFactor() > 0.05 ? 1 : 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _toolbarHorizontalPadding,
              ),
              child: toolbar,
            ),
          ),
          if (urlBar != null) urlBar,
        ],
      ),
    );
  }

  Widget _buildImmersiveChrome({
    required Widget toolbar,
    Widget? urlBar,
    required Widget body,
  }) {
    final topInset = MediaQuery.paddingOf(context).top;
    final readingMode = immersiveActive.value;
    final bottomPad = readingMode ? 0.0 : bottomNavReserve;
    final chromeReveal = _chromeRevealFactor();
    final statusBarOpaque = readingMode || immersiveAnim.value > 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: readingMode ? _immersiveOverlayStyle : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Column(
            children: [
              ColoredBox(
                color: statusBarOpaque
                    ? _statusBarBackground
                    : Colors.white,
                child: SizedBox(height: topInset),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: chromeReveal,
                  child: IgnorePointer(
                    ignoring: chromeReveal < 0.05,
                    child: _buildChromeBar(toolbar: toolbar, urlBar: urlBar),
                  ),
                ),
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
