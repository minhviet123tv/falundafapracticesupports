import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_scroll_helper.dart';
import 'compact_web_url_bar.dart';

/// Chrome (AppBar + URL): WebView luôn full dưới status bar; ẩn/hiện chỉ [AnimatedSlide].
mixin WebviewImmersiveMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  static const double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  static const double _scrollDirectionThreshold = 36;
  static const double _hideChromeBelowScrollPx = 36;
  static const double _revealChromeAtTopScrollPx = 20;
  static const double _minScrollableExtra = 40;
  static const Duration _immersiveToggleCooldown = Duration(milliseconds: 400);
  static const Duration _scrollHandleThrottle = Duration(milliseconds: 80);
  static const double _scrollImpulsePx = 12;
  static const Color _statusBarBackground = Colors.black;
  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const Duration _chromeSlideDuration = Duration(milliseconds: 220);
  static const Curve _chromeSlideCurve = Curves.easeInOut;
  static const double _toolbarHorizontalPadding = 10;

  late final AnimationController immersiveAnim;
  final ValueNotifier<bool> immersiveActive = ValueNotifier<bool>(false);

  /// Chrome overlay đang trượt xuống (hiện). false = đã trượt lên (ẩn).
  bool _overlayChromeVisible = true;
  double? _lastScrollY;
  double _directionalScrollAccum = 0;
  DateTime? _lastImmersiveToggleAt;
  DateTime? _lastScrollHandleAt;

  bool get immersiveHasUrlBar => true;

  double get immersiveChromeBarHeight =>
      toolbarHeight +
      (immersiveHasUrlBar ? CompactWebUrlBar.barHeight : 0);

  ValueNotifier<bool>? get externalImmersiveNotifier => null;

  double get bottomNavReserve => 0;

  bool get inImmersiveMode => immersiveActive.value;

  void initImmersive() {
    immersiveAnim = AnimationController(
      vsync: this,
      duration: _chromeSlideDuration,
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

  void handleImmersiveScrollReport(String message) {
    if (!mounted) return;
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
      _setOverlayChromeVisible(true, bypassCooldown: true);
      return;
    }

    if (scrollY <= _revealChromeAtTopScrollPx) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      _setOverlayChromeVisible(true, bypassCooldown: true);
      return;
    }

    if (_overlayChromeVisible && scrollY < _hideChromeBelowScrollPx) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      return;
    }

    if (_immersiveToggleCooldownActive()) {
      _lastScrollY = scrollY;
      return;
    }

    if (_lastScrollY != null) {
      final delta = scrollY - _lastScrollY!;
      if (delta != 0) {
        if (delta > 0 && _directionalScrollAccum < 0) {
          _directionalScrollAccum = 0;
        } else if (delta < 0 && _directionalScrollAccum > 0) {
          _directionalScrollAccum = 0;
        }
        _directionalScrollAccum += delta;

        var nextVisible = _overlayChromeVisible;
        if (_directionalScrollAccum >= _scrollDirectionThreshold ||
            delta >= _scrollImpulsePx) {
          nextVisible = false;
          _directionalScrollAccum = 0;
        } else if (_directionalScrollAccum <= -_scrollDirectionThreshold ||
            delta <= -_scrollImpulsePx) {
          nextVisible = true;
          _directionalScrollAccum = 0;
        }
        _setOverlayChromeVisible(nextVisible);
      }
    }
    _lastScrollY = scrollY;
  }

  void _setOverlayChromeVisible(
    bool visible, {
    bool bypassCooldown = false,
  }) {
    if (visible == _overlayChromeVisible) return;
    if (!bypassCooldown && _immersiveToggleCooldownActive()) return;

    _lastImmersiveToggleAt = DateTime.now();
    _overlayChromeVisible = visible;
    final readingMode = !visible;
    immersiveActive.value = readingMode;
    externalImmersiveNotifier?.value = readingMode;
    immersiveAnim.value = readingMode ? 1.0 : 0.0;
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
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    _setOverlayChromeVisible(false);
  }

  Future<void> exitImmersiveMode() async {
    if (!mounted) return;
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    _setOverlayChromeVisible(true, bypassCooldown: true);
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

  Widget _buildImmersiveChrome({
    required Widget toolbar,
    Widget? urlBar,
    required Widget body,
  }) {
    final topInset = MediaQuery.paddingOf(context).top;
    final readingMode = immersiveActive.value;
    final bottomPad = readingMode ? 0.0 : bottomNavReserve;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: readingMode ? _immersiveOverlayStyle : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                bottom: 0,
                child: body,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: readingMode ? 1.0 : 0.0,
                  child: ColoredBox(
                    color: _statusBarBackground,
                    child: SizedBox(height: topInset),
                  ),
                ),
              ),
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                child: _buildToolbarLayer(toolbar: toolbar, urlBar: urlBar),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarLayer({required Widget toolbar, Widget? urlBar}) {
    final bar = Material(
      color: Colors.white,
      elevation: _overlayChromeVisible ? 1 : 0,
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

    return ClipRect(
      child: IgnorePointer(
        ignoring: !_overlayChromeVisible,
        child: AnimatedSlide(
          offset: _overlayChromeVisible
              ? Offset.zero
              : const Offset(0, -1),
          duration: _chromeSlideDuration,
          curve: _chromeSlideCurve,
          child: bar,
        ),
      ),
    );
  }
}
