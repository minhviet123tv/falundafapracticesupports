import 'package:flutter/material.dart';

/// Font đứng đóng gói (Roboto Variable) — cùng hướng với CEO Calendar,
/// chữ Latin/Vietnamese đồng nhất giữa iOS và Android, không tải mạng.
class AppTextStyles {
  static const String fontFamily = 'AppSans';

  static TextStyle title({
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 18,
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
    double fontSize = 15,
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
      titleTextStyle: AppTextStyles.title(fontSize: 18),
      toolbarTextStyle: AppTextStyles.title(fontSize: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: AppTextStyles.body(
        color: Colors.blue,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: AppTextStyles.body(
        color: const Color.fromARGB(255, 71, 71, 71),
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),
  );
}
