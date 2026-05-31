import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Tab Book: ẩn menu bottom app + đồng bộ animation chrome với [chromeAnimation].
class BookTabChrome {
  BookTabChrome._();

  static final ValueNotifier<bool> immersive = ValueNotifier<bool>(false);

  /// Animation ẩn/hiện chrome — bottom menu trong main.dart dùng cùng controller.
  static Listenable? chromeAnimation;

  static const Curve chromeAnimCurve = Curves.easeInOut;

  static void bindChromeAnimation(Listenable animation) {
    chromeAnimation = animation;
  }

  static void unbindChromeAnimation(Listenable animation) {
    if (chromeAnimation == animation) {
      chromeAnimation = null;
    }
  }

  /// 0 = hiện; 1 = ẩn hoàn toàn.
  static double chromeSlideT() {
    final anim = chromeAnimation;
    if (anim is Animation<double>) {
      return chromeAnimCurve.transform(anim.value);
    }
    return immersive.value ? 1.0 : 0.0;
  }

  static Listenable get chromeListenable {
    final anim = chromeAnimation;
    if (anim != null) {
      return Listenable.merge([immersive, anim]);
    }
    return immersive;
  }
}
