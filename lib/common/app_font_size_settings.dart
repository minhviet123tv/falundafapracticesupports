import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:falun_dafa_practice_supports/common/app_font_size_scale.dart';

/// Trạng thái « Kích thước chữ » — hydrate lúc mở app, lưu SharedPreferences.
class AppFontSizeSettings extends ChangeNotifier {
  AppFontSizeSettings._();
  static final AppFontSizeSettings instance = AppFontSizeSettings._();

  static const String prefsKey = 'app_font_size_scale_v1';

  AppFontSizeScale _scale = AppFontSizeScaleDefaults.value;
  bool _ready = false;

  AppFontSizeScale get scale => _scale;
  bool get isReady => _ready;

  double get scaleFactor => AppFontSizeScaleDefaults.factorFor(_scale);

  /// Đọc prefs; lần đầu → nấc gần hệ số phóng theo kích thước máy rồi lưu.
  Future<void> hydrate() async {
    final shared = await SharedPreferences.getInstance();
    final raw = shared.getString(prefsKey);
    if (raw == null || raw.trim().isEmpty) {
      final shortest = AppFontSizeScaleDefaults.currentViewportShortestSide();
      _scale = AppFontSizeScaleDefaults.recommendedForShortestSide(shortest);
      await shared.setString(
        prefsKey,
        AppFontSizeScaleDefaults.toStorage(_scale),
      );
    } else {
      _scale = AppFontSizeScaleDefaults.fromStorage(raw);
    }
    _ready = true;
    notifyListeners();
  }

  Future<void> save(AppFontSizeScale value) async {
    if (_scale == value && _ready) return;
    _scale = value;
    notifyListeners();
    final shared = await SharedPreferences.getInstance();
    await shared.setString(
      prefsKey,
      AppFontSizeScaleDefaults.toStorage(value),
    );
  }

  Future<void> resetToDefault() async {
    final shortest = AppFontSizeScaleDefaults.currentViewportShortestSide();
    await save(AppFontSizeScaleDefaults.recommendedForShortestSide(shortest));
  }
}
