import 'dart:async';

import 'dart:convert';



import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:webview_flutter/webview_flutter.dart';



import 'book_webview_scroll_helper.dart';

import 'compact_web_url_bar.dart';

import 'webview_chrome_inset.dart';



/// WebView full màn hình; AppBar + browser overlay trượt lên/xuống (không resize WebView).

/// Đầu trang web có spacer ([WebViewChromeInset]) cao bằng chrome.

mixin WebviewImmersiveMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {

  static const double toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;

  static const double _revealChromeAtTopScrollPx = 6;

  static const double _scrollUpRevealThreshold = 24;

  static const Duration _immersiveToggleCooldown = Duration(milliseconds: 280);

  static const Duration _scrollHandleThrottle = Duration(milliseconds: 80);

  static const Duration _postHideRevealSuppress = Duration(milliseconds: 400);

  static const Color _statusBarBackground = Colors.black;
  static const Color _statusBarBackgroundNormal = Colors.white;

  static const SystemUiOverlayStyle _normalOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: _statusBarBackgroundNormal,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static const Duration _chromeAnimDuration = Duration(milliseconds: 220);

  static const Curve _chromeAnimCurve = Curves.easeInOut;

  static const double _toolbarHorizontalPadding = 10;



  late final AnimationController immersiveAnim;



  final ValueNotifier<bool> immersiveActive = ValueNotifier<bool>(false);



  bool _overlayChromeVisible = true;

  bool _immersiveLockedByButton = false;

  double? _lastScrollY;

  double _directionalScrollAccum = 0;

  DateTime? _lastImmersiveToggleAt;

  DateTime? _lastScrollHandleAt;

  DateTime? _suppressChromeRevealUntil;

  bool _immersiveScrollReady = false;



  bool get immersiveHasUrlBar => true;



  double get immersiveChromeBarHeight => WebViewChromeInset.contentHeight(

        hasUrlBar: immersiveHasUrlBar,

        toolbarHeight: toolbarHeight,

      );



  ValueNotifier<bool>? get externalImmersiveNotifier => null;



  double get bottomNavReserve => 0;

  /// Cuộn xuống ẩn chrome không chờ cooldown (tab Book).
  bool get immersiveScrollHideIgnoresCooldown => false;

  /// Tích lũy cuộn xuống (px) trước khi ẩn chrome; mặc định 24px.
  double get immersiveScrollDownHideThresholdPx => _scrollUpRevealThreshold;

  /// Tích lũy cuộn lên (px) trước khi hiện chrome; mặc định 24px.
  double get immersiveScrollUpRevealThresholdPx => _scrollUpRevealThreshold;

  /// Hiện chrome ngay khi ở đầu trang và cuộn lên.
  bool get immersiveScrollRevealAtTopInstant => true;

  /// Hiện chrome bằng scroll lên khi đang khóa bởi nút Mở rộng.
  bool get immersiveScrollRevealWhenLockedByButton => false;

  /// Cuộn lên hiện chrome ngay sau khi vừa ẩn (tab Book).
  bool get immersiveScrollRevealIgnoresSuppress => false;

  /// Dùng touch/wheel intent (ẩn/hiện tức thì); tắt khi dùng ngưỡng px.
  bool get immersiveScrollUsesTouchIntent => false;

  /// Cho phép đảo chiều ẩn/hiện khi animation đang chạy.
  bool get immersiveScrollHandlesDuringAnimation => false;

  /// Bỏ throttle 80ms giữa các báo cáo scroll (tab Book).
  bool get immersiveScrollIgnoresThrottle => false;

  /// Cuộn ẩn/hiện chrome tức thì, không animate 220ms (tab Book).
  bool get immersiveScrollSnapsChrome => false;

  /// Khoảng cách tối thiểu giữa hai báo cáo scroll từ JS (ms).
  int get immersiveScrollReportMinIntervalMs =>
      BookWebViewScrollHelper.scrollReporterMinIntervalMs;

  /// Luôn hiện chrome khi trang load xong (tab Book).
  bool get immersiveScrollResetChromeOnPageOpen => false;

  bool get inImmersiveMode =>
      immersiveActive.value || immersiveAnim.value > 0.5;



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



  void handleImmersiveScrollReport(String message) {

    if (!mounted) return;

    try {

      final decoded = jsonDecode(message);

      if (decoded is! Map) return;

      final y = decoded['y'];

      if (y is! num) return;

      final scrollY = y.toDouble();

      if (decoded['init'] == true) {

        _lastScrollY = scrollY;

        return;

      }

      if (immersiveScrollSnapsChrome && !_immersiveScrollReady) {

        _lastScrollY = scrollY;

        return;

      }

      final intent = decoded['intent'];

      if (intent is String &&
          immersiveScrollUsesTouchIntent &&
          _immersiveScrollReady) {

        _handleScrollIntent(intent, scrollY);

        return;

      }

      if (immersiveAnim.isAnimating) {

        if (immersiveScrollHandlesDuringAnimation) {

          _updateChromeVisibilityFromScrollDuringAnimation(scrollY);

        }

        return;

      }



      if (scrollY > _revealChromeAtTopScrollPx &&
          !immersiveScrollIgnoresThrottle &&
          _lastScrollHandleAt != null) {

        final elapsed = DateTime.now().difference(_lastScrollHandleAt!);

        if (elapsed < _scrollHandleThrottle) return;

      }

      _lastScrollHandleAt = DateTime.now();



      _updateChromeVisibilityFromScroll(scrollY);

    } catch (_) {}

  }

  void _handleScrollIntent(String intent, double scrollY) {

    if (!mounted) return;

    _lastScrollY = scrollY;

    if (_immersiveLockedByButton) return;

    if (immersiveAnim.isAnimating && immersiveScrollHandlesDuringAnimation) {

      immersiveAnim.stop();

    } else if (immersiveAnim.isAnimating) {

      return;

    }

    if (intent == 'down' && _overlayChromeVisible) {

      unawaited(_hideChromeLayout(fromScroll: true));

      return;

    }

    if (intent == 'up' && !_overlayChromeVisible) {

      unawaited(_showChromeLayout(bypassCooldown: true, fromScroll: true));

    }

  }

  void _updateChromeVisibilityFromScrollDuringAnimation(double scrollY) {

    if (!mounted) return;

    final prevY = _lastScrollY;

    _lastScrollY = scrollY;

    if (prevY == null) return;

    final delta = scrollY - prevY;

    if (delta == 0) return;

    final status = immersiveAnim.status;

    if (status == AnimationStatus.forward &&

        delta < 0 &&

        !_immersiveLockedByButton) {

      immersiveAnim.stop();

      unawaited(_showChromeLayout(bypassCooldown: true, fromScroll: true));

      return;

    }

    if (status == AnimationStatus.reverse && delta > 0) {

      immersiveAnim.stop();

      unawaited(_hideChromeLayout(fromScroll: true));

    }

  }



  void _updateChromeVisibilityFromScroll(double scrollY) {

    if (!mounted) return;



    final prevY = _lastScrollY;

    if (prevY == null) {

      _lastScrollY = scrollY;

      return;

    }

    _lastScrollY = scrollY;

    final delta = scrollY - prevY;

    if (delta == 0) return;



    if (_overlayChromeVisible && !immersiveAnim.isAnimating) {

      if (delta > 0) {

        if (_directionalScrollAccum < 0) {

          _directionalScrollAccum = 0;

        }

        _directionalScrollAccum += delta;

        final hideThreshold = immersiveScrollDownHideThresholdPx;

        if (hideThreshold <= 0 ||

            _directionalScrollAccum >= hideThreshold) {

          _directionalScrollAccum = 0;

          final cooldownOk = immersiveScrollHideIgnoresCooldown ||

              !_immersiveToggleCooldownActive();

          if (cooldownOk) {

            unawaited(_hideChromeLayout(fromScroll: true));

          }

        }

      } else {

        _directionalScrollAccum = 0;

      }

      return;

    }



    final suppressOk = immersiveScrollRevealIgnoresSuppress ||

        !_chromeRevealSuppressActive();

    final revealLockedOk = !_immersiveLockedByButton ||

        immersiveScrollRevealWhenLockedByButton;

    if (!_overlayChromeVisible &&

        !immersiveAnim.isAnimating &&

        suppressOk &&

        revealLockedOk) {

      if (immersiveScrollRevealAtTopInstant &&

          scrollY <= _revealChromeAtTopScrollPx &&

          delta <= 0) {

        unawaited(_showChromeLayout(bypassCooldown: true, fromScroll: true));

        return;

      }

      if (delta < 0) {

        if (immersiveScrollUpRevealThresholdPx <= 0) {

          unawaited(_showChromeLayout(

            bypassCooldown: immersiveScrollHideIgnoresCooldown,

            fromScroll: true,

          ));

          return;

        }

        if (_directionalScrollAccum > 0) {

          _directionalScrollAccum = 0;

        }

        _directionalScrollAccum += delta;

        if (_directionalScrollAccum <= -immersiveScrollUpRevealThresholdPx) {

          _directionalScrollAccum = 0;

          unawaited(_showChromeLayout(fromScroll: true));

        }

      } else {

        _directionalScrollAccum = 0;

      }

    }

  }



  Future<void> _hideChromeLayout({bool fromScroll = false}) async {

    if (!mounted || !_overlayChromeVisible) {

      return;

    }

    if (immersiveAnim.isAnimating) {

      if (!(fromScroll && immersiveScrollSnapsChrome)) {

        return;

      }

      immersiveAnim.stop();

    }

    if (_immersiveToggleCooldownActive() &&

        !(fromScroll && immersiveScrollHideIgnoresCooldown)) {

      return;

    }



    if (fromScroll) {

      _immersiveLockedByButton = false;

    }



    _lastImmersiveToggleAt = DateTime.now();

    if (!(fromScroll && immersiveScrollRevealIgnoresSuppress)) {

      _suppressChromeRevealUntil = DateTime.now().add(

        _chromeAnimDuration + _postHideRevealSuppress,

      );

    }

    _overlayChromeVisible = false;

    if (mounted) setState(() {});



    if (fromScroll && immersiveScrollSnapsChrome) {

      immersiveAnim.value = 1.0;

      immersiveActive.value = true;

      externalImmersiveNotifier?.value = true;

      _directionalScrollAccum = 0;

      if (mounted) setState(() {});

      return;

    }



    await immersiveAnim.forward();

    if (!mounted) return;

    immersiveActive.value = true;

    externalImmersiveNotifier?.value = true;

    if (!fromScroll) {

      _lastScrollY = null;

    }

    _directionalScrollAccum = 0;

    if (mounted) setState(() {});

  }



  Future<void> _showChromeLayout({

    bool bypassCooldown = false,

    bool fromScroll = false,

  }) async {

    if (!mounted) return;

    if (immersiveAnim.isAnimating) {

      if (!(fromScroll && immersiveScrollSnapsChrome)) {

        return;

      }

      immersiveAnim.stop();

    }

    if (_overlayChromeVisible && immersiveAnim.value <= 0) return;

    if (!bypassCooldown && _immersiveToggleCooldownActive()) return;



    _lastImmersiveToggleAt = DateTime.now();

    _suppressChromeRevealUntil = null;

    if (!fromScroll) {

      _lastScrollY = null;

    }

    _directionalScrollAccum = 0;

    if (fromScroll && immersiveScrollRevealWhenLockedByButton) {

      _immersiveLockedByButton = false;

    }

    _overlayChromeVisible = true;

    if (mounted) setState(() {});



    if (fromScroll && immersiveScrollSnapsChrome) {

      immersiveAnim.value = 0.0;

      immersiveActive.value = false;

      externalImmersiveNotifier?.value = false;

      if (mounted) setState(() {});

      return;

    }



    await immersiveAnim.reverse();

    if (!mounted) return;

    immersiveActive.value = false;

    externalImmersiveNotifier?.value = false;

    if (mounted) setState(() {});

  }



  Future<void> installImmersivePageChrome(WebViewController controller) async {

    await WebViewChromeInset.install(controller, immersiveChromeBarHeight);

    await BookWebViewScrollHelper.installReporter(
      controller,
      minIntervalMs: immersiveScrollReportMinIntervalMs,
    );

  }



  Future<void> installImmersiveScrollReporter(WebViewController controller) async {

    await installImmersivePageChrome(controller);

  }



  Future<void> onImmersivePageFinished({double? scrollY}) async {

    _lastScrollY = scrollY;

    _directionalScrollAccum = 0;

    _lastScrollHandleAt = null;

    if (immersiveScrollResetChromeOnPageOpen && !_immersiveLockedByButton) {

      immersiveAnim.stop();

      _overlayChromeVisible = true;

      immersiveActive.value = false;

      externalImmersiveNotifier?.value = false;

      immersiveAnim.value = 0.0;

      _suppressChromeRevealUntil = null;

    }

    _immersiveScrollReady = true;

    if (mounted) setState(() {});

  }



  void onImmersivePageStarted() {

    _immersiveScrollReady = false;

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

    _immersiveLockedByButton = true;

    await _hideChromeLayout();

  }



  Future<void> exitImmersiveMode() async {

    if (!mounted) return;

    _immersiveLockedByButton = false;

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



  double _chromeBarHeight(Widget? urlBar) =>

      toolbarHeight + (urlBar != null ? CompactWebUrlBar.barHeight : 0);



  Widget _buildChromeBar({

    required Widget toolbar,

    Widget? urlBar,

    bool showElevation = true,

  }) {

    return Material(

      color: Colors.white,

      elevation: showElevation ? 1 : 0,

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

    final chromeHeight = _chromeBarHeight(urlBar);

    final slideT = _chromeAnimCurve.transform(immersiveAnim.value);

    final readingMode = slideT > 0.5;

    final bottomPad = readingMode ? 0.0 : bottomNavReserve;



    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: readingMode ? _immersiveOverlayStyle : _normalOverlayStyle,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Column(
            children: [
              ColoredBox(
                color: readingMode
                    ? _statusBarBackground
                    : _statusBarBackgroundNormal,
                child: SizedBox(
                  height: topInset,
                  width: double.infinity,
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    body,
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipRect(
                        child: Transform.translate(
                          offset: Offset(0, -slideT * chromeHeight),
                          child: IgnorePointer(
                            ignoring: slideT > 0.92,
                            child: _buildChromeBar(
                              toolbar: toolbar,
                              urlBar: urlBar,
                              showElevation: slideT < 0.08,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}


