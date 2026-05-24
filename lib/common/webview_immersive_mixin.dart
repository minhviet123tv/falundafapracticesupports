import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'book_webview_scroll_helper.dart';
import 'compact_web_url_bar.dart';
import 'webview_scroll_chrome_mixin.dart';

/// Chế độ mở rộng trong tab (ẩn AppBar, cuộn để hiện lại) — tab Book hoặc trang push từ Home.
mixin WebviewImmersiveMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T>, WebviewScrollChromeMixin<T> {
  WebviewScrollChromeMixin<T> get _scrollChrome => this as WebviewScrollChromeMixin<T>;

  static const double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  static const Color _statusBarBackground = Colors.black;
  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const Duration _immersiveAnimDuration =
      WebviewScrollChromeMixin.chromeAnimDuration;
  static const double _toolbarHorizontalPadding = 10;

  late final AnimationController immersiveAnim;
  final ValueNotifier<bool> immersiveActive = ValueNotifier<bool>(false);

  bool _scrollHideEnabled = false;
  double _scrollChromeBarHeight = toolbarHeight;

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
    _scrollChrome.initScrollChromeReveal(this);
    externalImmersiveNotifier?.addListener(_onExternalImmersiveChanged);
  }

  void disposeImmersive() {
    _scrollChrome.disposeScrollChromeReveal();
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
    if (!mounted || !_scrollHideEnabled) return;
    handleScrollChromeReport(
      message,
      _scrollChromeBarHeight,
      scrollHideEnabled: _scrollHideEnabled,
    );
  }

  Future<void> installImmersiveScrollReporter(
    WebViewController controller, {
    bool Function()? canRun,
  }) async {
    await BookWebViewScrollHelper.installReporter(
      controller,
      canRun: canRun,
    );
  }

  Future<void> onImmersivePageFinished() async {
    resetScrollChromeTracking();
  }

  Future<void> refreshImmersiveChromeHideAllowed(
    WebViewController controller, {
    bool Function()? canRun,
  }) async {
    if (pageMainFrameFailed) {
      setOverlayChromeHideAllowed(false);
      return;
    }
    final maxScroll = await BookWebViewScrollHelper.readMaxScrollExtent(
      controller,
      canRun: canRun,
    );
    updateOverlayChromeHideFromPageMetrics(
      maxScroll: maxScroll ?? 0,
      chromeBarHeight: _scrollChromeBarHeight,
    );
  }

  void _showChromeHideBlockedMessage() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(WebviewScrollChromeMixin.chromeHideBlockedMessage)),
    );
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
    if (!overlayChromeHideAllowed) {
      _showChromeHideBlockedMessage();
      return;
    }
    resetScrollChromeTracking();
    immersiveActive.value = true;
    externalImmersiveNotifier?.value = true;
    await immersiveAnim.forward();
  }

  Future<void> exitImmersiveMode() async {
    if (immersiveAnim.status == AnimationStatus.reverse) return;
    if (!mounted) return;
    _scrollChrome.applyOverlayChromeVisible(true);
    resetScrollChromeTracking();
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
        final canExpand = overlayChromeHideAllowed || immersive;
        return IconButton(
          onPressed: canExpand ? () => toggleImmersiveMode() : _showChromeHideBlockedMessage,
          icon: Icon(
            immersive ? Icons.fullscreen_exit : Icons.zoom_out_map,
            size: 20,
            color: canExpand ? null : Colors.grey,
          ),
          tooltip: immersive
              ? 'Thu gọn'
              : (canExpand
                  ? 'Mở rộng màn hình'
                  : WebviewScrollChromeMixin.chromeHideBlockedMessage),
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
    _scrollHideEnabled = urlBar != null;
    _scrollChromeBarHeight = _chromeBarHeight(urlBar);

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
    final reveal = _scrollChrome.webViewChromeRevealFactor(
      immersiveProgress: t,
      scrollHideEnabled: _scrollHideEnabled,
      overlayChromeHideAllowed: overlayChromeHideAllowed,
    );
    final bottomPad = bottomNavReserve * reveal;
    final chromeHeight = _scrollChromeBarHeight;
    final webTop = webViewTopOffset(
      topInset: topInset,
      chromeBarHeight: chromeHeight,
      immersiveProgress: t,
      scrollHideEnabled: _scrollHideEnabled,
      overlayChromeHideAllowed: overlayChromeHideAllowed,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t >= 0.5 ? _immersiveOverlayStyle : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _scrollChrome.buildWebViewPositioned(
                top: webTop,
                child: urlBar != null
                    ? DismissKeyboardWhenWebViewTapped(child: body)
                    : body,
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
    final chromeHeight = _scrollChromeBarHeight;

    Widget bar = GestureDetector(
      onTap: () => CompactWebUrlBar.dismissUrlFieldFocus(context),
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: Colors.white,
        elevation: (!immersiveActive.value || overlayChromeVisible) ? 1 : 0,
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
      ),
    );

    if (_scrollHideEnabled && overlayChromeHideAllowed) {
      bar = wrapChromeBarForScrollHide(bar, enabled: true);
    }

    if (immersiveAnim.status == AnimationStatus.reverse) {
      return ClipRect(child: bar);
    }

    if (t >= 1.0) {
      return ClipRect(child: bar);
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
