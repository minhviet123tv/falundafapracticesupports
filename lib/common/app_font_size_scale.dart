import 'package:flutter/widgets.dart';

/// Mức « Kích thước chữ » toàn app — nhân với text scale hệ thống.
enum AppFontSizeScale {
  ultraSmall,
  extraSmall,
  small,
  normal,
  large,
  extraLarge,
  ultraLarge,
  superLarge,
  maximum,
}

/// Giá trị mặc định và parse prefs cho [AppFontSizeScale].
abstract final class AppFontSizeScaleDefaults {
  static const AppFontSizeScale value = AppFontSizeScale.normal;

  static const List<AppFontSizeScale> _legacyV1ByIndex = [
    AppFontSizeScale.extraSmall,
    AppFontSizeScale.small,
    AppFontSizeScale.normal,
    AppFontSizeScale.large,
    AppFontSizeScale.extraLarge,
  ];

  static const double previousMaxFactor = 1.58;
  static const double superLargeFactor = 1.80;
  static const double maximumFactor = 2.02;

  static double currentViewportShortestSide() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return 400;
    final view = views.first;
    final w = view.physicalSize.width / view.devicePixelRatio;
    final h = view.physicalSize.height / view.devicePixelRatio;
    return w < h ? w : h;
  }

  /// Hệ số nhân lên text scale hệ thống (giống ceo_calendar).
  static double factorFor(AppFontSizeScale scale) {
    return switch (scale) {
      AppFontSizeScale.ultraSmall => 0.68,
      AppFontSizeScale.extraSmall => 0.80,
      AppFontSizeScale.small => 0.88,
      AppFontSizeScale.normal => 1.08,
      AppFontSizeScale.large => 1.20,
      AppFontSizeScale.extraLarge => 1.38,
      AppFontSizeScale.ultraLarge => previousMaxFactor,
      AppFontSizeScale.superLarge => superLargeFactor,
      AppFontSizeScale.maximum => maximumFactor,
    };
  }

  /// Chọn nấc gần nhất với hệ số phóng chữ theo kích thước máy (lần đầu cài).
  /// Công thức khớp [AppTextStyles.deviceTextScaleFactor] (tránh import vòng).
  static double deviceTextScaleFactor(double shortestSide) {
    const referenceShortestSide = 400.0;
    const comfortScale = 1.12;
    final relative = shortestSide / referenceShortestSide;
    if (shortestSide < 600) {
      return (comfortScale * relative).clamp(1.04, 1.20);
    }
    final tablet = comfortScale * (1.02 + (shortestSide - 600) / 1000);
    return tablet.clamp(1.28, 1.48);
  }

  static AppFontSizeScale recommendedForShortestSide(double shortestSide) {
    return recommendedForDeviceFactor(deviceTextScaleFactor(shortestSide));
  }

  static AppFontSizeScale recommendedForDeviceFactor(double deviceFactor) {
    var best = AppFontSizeScale.normal;
    var bestDist = double.infinity;
    for (final candidate in AppFontSizeScale.values) {
      final dist = (factorFor(candidate) - deviceFactor).abs();
      if (dist < bestDist) {
        bestDist = dist;
        best = candidate;
      }
    }
    return best;
  }

  static AppFontSizeScale fromStorage(String? raw) {
    if (raw == null || raw.trim().isEmpty) return value;
    final t = raw.trim();
    for (final candidate in AppFontSizeScale.values) {
      if (candidate.name == t) return candidate;
    }
    final index = int.tryParse(t);
    if (index != null) {
      if (index >= 0 && index < _legacyV1ByIndex.length) {
        return _legacyV1ByIndex[index];
      }
      if (index >= 0 && index < AppFontSizeScale.values.length) {
        return AppFontSizeScale.values[index];
      }
    }
    return value;
  }

  static String toStorage(AppFontSizeScale scale) => scale.name;
}
