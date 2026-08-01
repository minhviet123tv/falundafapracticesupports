import 'package:flutter/cupertino.dart';

/// Mở trang với transition kiểu iOS: đẩy từ phải sang, back có hiệu ứng trượt về.
///
/// [Navigator.pop] / vuốt mép trái đều animate trang hiện tại trượt sang phải
/// và lộ trang trước — giống khi back từ webview audio.
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

  /// Mở từ trên hạ xuống; back thì trang trượt lên phía trên.
  /// Dùng cho: Vì sao có nhân loại, Falundafa.org, tab Book.
  static Future<T?> pushFromTop<T extends Object?>(
    BuildContext context,
    Widget page, {
    RouteSettings? settings,
  }) {
    return Navigator.of(context).push<T>(
      VerticalFromTopPageRoute<T>(
        builder: (_) => page,
        settings: settings,
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

/// [CupertinoPageRoute] — swipe-to-back + slide transition trên mọi platform.
class SwipeBackPageRoute<T> extends CupertinoPageRoute<T> {
  SwipeBackPageRoute({
    required super.builder,
    super.settings,
    super.fullscreenDialog,
    super.title,
    super.maintainState,
  });
}

/// Mở: từ trên hạ xuống. Back: trượt lên phía trên.
class VerticalFromTopPageRoute<T> extends PageRouteBuilder<T> {
  VerticalFromTopPageRoute({
    required WidgetBuilder builder,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            // begin (0,-1): ngoài mép trên → end (0,0): vào giữa màn hình.
            // reverse (back): trang trượt lên phía trên.
            final offset = Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(curved);
            return SlideTransition(position: offset, child: child);
          },
          transitionDuration: const Duration(milliseconds: 320),
          reverseTransitionDuration: const Duration(milliseconds: 280),
        );
}
