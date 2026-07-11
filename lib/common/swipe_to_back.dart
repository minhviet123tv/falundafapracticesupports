import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

/// Mở trang với hiệu ứng swipe-to-back (kéo trang hiện tại sang phải, lộ trang trước).
class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T extends Object?>(
    BuildContext context,
    Widget page, {
    RouteSettings? settings,
    bool fullscreenDialog = false,
  }) {
    return Navigator.of(context).push<T>(
      SwipeBackPageRoute<T>(
        builder: (_) => page,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      ),
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page, {
    TO? result,
    RouteSettings? settings,
  }) {
    return Navigator.of(context).pushReplacement<T, TO>(
      SwipeBackPageRoute<T>(
        builder: (_) => page,
        settings: settings,
      ),
      result: result,
    );
  }
}

/// Route kiểu iOS: push từ phải; vuốt từ **mép trái hẹp** → kéo trang sang phải.
///
/// Vùng nhận gesture cố ý mỏng (~24px, giống iOS) để WebView/cuộn dọc
/// hoạt động bình thường trên phần còn lại của màn hình. Vùng 50% sẽ
/// chặn hold-to-scroll trên nửa trái (PlatformView).
class SwipeBackPageRoute<T> extends PageRoute<T>
    with CupertinoRouteTransitionMixin<T> {
  SwipeBackPageRoute({
    required this.builder,
    this.title,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.barrierDismissible = false,
  });

  final WidgetBuilder builder;

  @override
  final String? title;

  @override
  final bool maintainState;

  /// Chiều rộng mép trái nhận swipe-to-back (logical px). Giống Cupertino (~20).
  static const double startZoneWidth = 24;

  /// @Deprecated — giữ tên cũ cho API; luôn trả về bề rộng mép cố định / width.
  static const double startZoneFraction = 0;

  static const double _minFlingVelocity = 1.0;
  static const int _maxDroppedSwipeMs = 350;
  static const int _maxPageBackMs = 300;

  @override
  Widget buildContent(BuildContext context) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final bool linearTransition = navigator?.userGestureInProgress ?? false;
    return CupertinoPageTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: linearTransition,
      child: _SwipeBackGestureDetector<T>(
        enabledCallback: _isPopGestureEnabled,
        onStartPopGesture: _startPopGesture,
        child: child,
      ),
    );
  }

  bool _isPopGestureEnabled() {
    if (isFirst) return false;
    if (willHandlePopInternally) return false;
    if (fullscreenDialog) return false;
    if (animation!.status != AnimationStatus.completed) return false;
    if (secondaryAnimation!.status != AnimationStatus.dismissed) {
      return false;
    }
    if (navigator!.userGestureInProgress) return false;
    return popDisposition == RoutePopDisposition.pop;
  }

  _SwipeBackGestureController<T> _startPopGesture() {
    assert(controller != null);
    return _SwipeBackGestureController<T>(
      navigator: navigator!,
      controller: controller!,
    );
  }
}

class _SwipeBackGestureDetector<T> extends StatefulWidget {
  const _SwipeBackGestureDetector({
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  final Widget child;
  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_SwipeBackGestureController<T>> onStartPopGesture;

  @override
  State<_SwipeBackGestureDetector<T>> createState() =>
      _SwipeBackGestureDetectorState<T>();
}

class _SwipeBackGestureDetectorState<T>
    extends State<_SwipeBackGestureDetector<T>> {
  _SwipeBackGestureController<T>? _backGestureController;
  late HorizontalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _recognizer = HorizontalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(mounted);
    assert(_backGestureController == null);
    _backGestureController = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragUpdate(
      _convertToLogical(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(mounted);
    assert(_backGestureController != null);
    _backGestureController!.dragEnd(
      _convertToLogical(
        details.velocity.pixelsPerSecond.dx / context.size!.width,
      ),
    );
    _backGestureController = null;
  }

  void _handleDragCancel() {
    assert(mounted);
    _backGestureController?.dragEnd(0);
    _backGestureController = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _convertToLogical(double value) {
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return -value;
      case TextDirection.ltr:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    // Chỉ mép trái hẹp — phần còn lại để WebView nhận touch / scroll.
    final double zoneWidth = max(
      SwipeBackPageRoute.startZoneWidth,
      MediaQuery.paddingOf(context).left,
    );
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0,
          width: zoneWidth,
          top: 0,
          bottom: 0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _SwipeBackGestureController<T> {
  _SwipeBackGestureController({
    required this.navigator,
    required this.controller,
  }) {
    navigator.didStartUserGesture();
  }

  final AnimationController controller;
  final NavigatorState navigator;

  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  void dragEnd(double velocity) {
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    final bool animateForward;

    if (velocity.abs() >= SwipeBackPageRoute._minFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      final int ms = min(
        lerpDouble(
              SwipeBackPageRoute._maxDroppedSwipeMs,
              0,
              controller.value,
            )!
            .floor(),
        SwipeBackPageRoute._maxPageBackMs,
      );
      controller.animateTo(
        1.0,
        duration: Duration(milliseconds: ms),
        curve: animationCurve,
      );
    } else {
      navigator.pop();
      if (controller.isAnimating) {
        final int ms = lerpDouble(
          0,
          SwipeBackPageRoute._maxDroppedSwipeMs,
          controller.value,
        )!
            .floor();
        controller.animateBack(
          0.0,
          duration: Duration(milliseconds: ms),
          curve: animationCurve,
        );
      }
    }

    if (controller.isAnimating) {
      late AnimationStatusListener statusCallback;
      statusCallback = (AnimationStatus status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(statusCallback);
      };
      controller.addStatusListener(statusCallback);
    } else {
      navigator.didStopUserGesture();
    }
  }
}

/// Wrapper cũ — chỉ trả về [child]. Hiệu ứng do [SwipeBackPageRoute] / [AppNavigator.push].
class SwipeToBack extends StatelessWidget {
  final Widget child;
  final VoidCallback? onBack;
  final double startZoneFraction;
  final double minDistance;
  final double minVelocity;

  const SwipeToBack({
    super.key,
    required this.child,
    this.onBack,
    this.startZoneFraction = 0,
    this.minDistance = 72,
    this.minVelocity = 200,
  });

  @override
  Widget build(BuildContext context) => child;
}
