import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_scroll_helper.dart';
import 'compact_web_url_bar.dart';

/// Chế độ mở rộng trong tab (ẩn AppBar, cuộn để hiện lại) — tab Book hoặc trang push từ Home.
mixin WebviewImmersiveMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  static const double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  static const double _scrollDirectionThreshold = 36;
  static const double _minScrollableExtra = 40;
  static const Color _statusBarBackground = Colors.black;
  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const Duration _immersiveAnimDuration = Duration(milliseconds: 220);
  static const Curve _immersiveAnimCurve = Curves.easeInOut;
  static const double _toolbarHorizontalPadding = 10;

  late final AnimationController immersiveAnim;
  final ValueNotifier<bool> immersiveActive = ValueNotifier<bool>(false);

  bool _overlayAppBarVisible = false;
  double? _lastScrollY;
  double _directionalScrollAccum = 0;

  /// Tab Book: [BookTabChrome.immersive]. Trang push từ Home: để null.
  ValueNotifier<bool>? get externalImmersiveNotifier => null;

  /// Tab Book: chiều cao menu bottom. Trang push: 0.
  double get bottomNavReserve => 0;

  bool get inImmersiveMode => immersiveAnim.value >= 1.0;

  void initImmersive() {
    immersiveAnim = AnimationController(
      vsync: this,
      duration: _immersiveAnimDuration,
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
        immersiveAnim.value > 0 &&
        mounted) {
      exitImmersiveMode();
    }
  }

  void handleImmersiveScrollReport(String message) {
    if (!mounted || !inImmersiveMode) return;
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final y = decoded['y'];
      final maxScroll = decoded['max'];
      if (y is! num) return;
      final maxScrollPx = maxScroll is num ? maxScroll.toDouble() : 0.0;
      _updateOverlayAppBarFromScroll(y.toDouble(), maxScrollPx);
    } catch (_) {}
  }

  void _updateOverlayAppBarFromScroll(double scrollY, double maxScroll) {
    if (!mounted || !inImmersiveMode) return;

    final minScrollable = toolbarHeight + _minScrollableExtra;
    if (maxScroll < minScrollable) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (!_overlayAppBarVisible) {
        setState(() => _overlayAppBarVisible = true);
      }
      return;
    }

    if (scrollY <= 20) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (!_overlayAppBarVisible) {
        setState(() => _overlayAppBarVisible = true);
      }
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

        var nextVisible = _overlayAppBarVisible;
        if (_directionalScrollAccum >= _scrollDirectionThreshold) {
          nextVisible = false;
          _directionalScrollAccum = 0;
        } else if (_directionalScrollAccum <= -_scrollDirectionThreshold) {
          nextVisible = true;
          _directionalScrollAccum = 0;
        }
        if (nextVisible != _overlayAppBarVisible) {
          setState(() => _overlayAppBarVisible = nextVisible);
        }
      }
    }
    _lastScrollY = scrollY;
  }

  Future<void> installImmersiveScrollReporter(WebViewController controller) async {
    await BookWebViewScrollHelper.installReporter(controller);
  }

  Future<void> onImmersivePageFinished() async {
    _lastScrollY = null;
    _directionalScrollAccum = 0;
  }

  Future<void> toggleImmersiveMode() async {
    if (inImmersiveMode || immersiveAnim.status == AnimationStatus.forward) {
      await exitImmersiveMode();
    } else {
      await enterImmersiveMode();
    }
  }

  Future<void> enterImmersiveMode() async {
    if (immersiveAnim.status == AnimationStatus.forward) return;
    if (!mounted) return;
    _overlayAppBarVisible = false;
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    immersiveActive.value = true;
    externalImmersiveNotifier?.value = true;
    await immersiveAnim.forward();
  }

  Future<void> exitImmersiveMode() async {
    if (immersiveAnim.status == AnimationStatus.reverse) return;
    if (!mounted) return;
    _overlayAppBarVisible = true;
    _lastScrollY = null;
    _directionalScrollAccum = 0;
    immersiveActive.value = false;
    externalImmersiveNotifier?.value = false;
    await immersiveAnim.reverse();
  }

  Future<bool> handleImmersiveSystemBack() async {
    if (immersiveAnim.value > 0) {
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
      child: AnimatedBuilder(
        animation: immersiveAnim,
        builder: (context, _) =>
            _buildImmersiveChrome(toolbar: toolbar, urlBar: urlBar, body: body),
      ),
    );
  }

  double _chromeBarHeight(Widget? urlBar) =>
      toolbarHeight + (urlBar != null ? CompactWebUrlBar.barHeight : 0);

  Widget _buildImmersiveChrome({
    required Widget toolbar,
    Widget? urlBar,
    required Widget body,
  }) {
    final topInset = MediaQuery.paddingOf(context).top;
    final t = Curves.easeInOut.transform(immersiveAnim.value);
    final bottomPad = (1 - t) * bottomNavReserve;
    final chromeHeight = _chromeBarHeight(urlBar);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t >= 0.5 ? _immersiveOverlayStyle : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: topInset + (1 - t) * chromeHeight,
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
                  opacity: t,
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
    final t = Curves.easeInOut.transform(immersiveAnim.value);
    final useScrollHide = immersiveActive.value;
    final chromeHeight = _chromeBarHeight(urlBar);

    Widget bar = Material(
      color: Colors.white,
      elevation: (!immersiveActive.value || _overlayAppBarVisible) ? 1 : 0,
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

    if (useScrollHide) {
      bar = AnimatedSlide(
        offset: _overlayAppBarVisible
            ? Offset.zero
            : const Offset(0, -1),
        duration: _immersiveAnimDuration,
        curve: _immersiveAnimCurve,
        child: bar,
      );
    }

    if (immersiveAnim.status == AnimationStatus.reverse) {
      return ClipRect(
        child: IgnorePointer(
          ignoring: useScrollHide && !_overlayAppBarVisible,
          child: bar,
        ),
      );
    }

    if (t >= 1.0) {
      return ClipRect(
        child: IgnorePointer(
          ignoring: useScrollHide && !_overlayAppBarVisible,
          child: bar,
        ),
      );
    }

    final curved = Curves.easeInOut.transform(t);
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, -curved * chromeHeight),
        child: Opacity(
          opacity: (1 - curved).clamp(0.0, 1.0),
          child: IgnorePointer(
            ignoring: curved > 0.5,
            child: bar,
          ),
        ),
      ),
    );
  }
}
