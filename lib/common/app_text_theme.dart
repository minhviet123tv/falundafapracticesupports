import 'package:flutter/material.dart';

/// Font đứng đóng gói (Roboto Variable) — cùng hướng với CEO Calendar,
/// chữ Latin/Vietnamese đồng nhất giữa iOS và Android, không tải mạng.
class AppTextStyles {
  static const String fontFamily = 'AppSans';

  /// Mốc thiết bị thử nghiệm: iPhone 11 Pro Max / Pixel 5 / Note 9
  /// (shortestSide ~390–414 logical px).
  static const double referenceShortestSide = 400;

  /// Hệ số “dễ đọc” trên máy thử nghiệm (người già / trẻ em).
  /// 1.0 = cỡ design cũ; 1.16 ≈ to hơn ~16%.
  static const double comfortScale = 1.16;

  /// Hệ số phóng chữ theo kích thước màn hình (shortestSide).
  /// Máy thử nghiệm ≈ [comfortScale]; tablet/iPad to hơn, có trần để không vỡ layout.
  static double deviceTextScaleFactor(double shortestSide) {
    final relative = shortestSide / referenceShortestSide;
    if (shortestSide < 600) {
      // Điện thoại: quanh mốc thử nghiệm, chữ mặc định đã to hơn design cũ.
      return (comfortScale * relative).clamp(1.06, 1.24);
    }
    // Tablet / iPad: to hơn nữa; trần 1.48 để AppBar / lưới / bottom nav không vỡ.
    final tablet = comfortScale * (1.02 + (shortestSide - 600) / 1000);
    return tablet.clamp(1.30, 1.48);
  }

  static TextStyle title({
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 19,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: 0,
      height: 1.25,
    );
  }

  static TextStyle body({
    Color color = Colors.black87,
    FontWeight fontWeight = FontWeight.w400,
    double fontSize = 16,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      letterSpacing: 0,
      height: 1.35,
    );
  }
}

/// Bọc [child] với [TextScaler] theo kích thước thiết bị.
/// Nhân thêm với hệ số chữ hệ thống (accessibility) nếu người dùng đã chỉnh.
Widget wrapWithDeviceTextScale(BuildContext context, Widget? child) {
  final shortest = MediaQuery.sizeOf(context).shortestSide;
  final device = AppTextStyles.deviceTextScaleFactor(shortest);
  final mq = MediaQuery.of(context);
  final system = mq.textScaler.scale(1.0);
  return MediaQuery(
    data: mq.copyWith(
      textScaler: TextScaler.linear(system * device),
    ),
    child: child ?? const SizedBox.shrink(),
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    fontFamily: AppTextStyles.fontFamily,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: AppTextStyles.fontFamily,
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
    ),
    primaryTextTheme: base.primaryTextTheme.apply(
      fontFamily: AppTextStyles.fontFamily,
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: AppTextStyles.title(fontSize: 19),
      toolbarTextStyle: AppTextStyles.title(fontSize: 17),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: AppTextStyles.body(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      unselectedLabelStyle: AppTextStyles.body(
        color: const Color.fromARGB(255, 71, 71, 71),
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
    ),
  );
}
