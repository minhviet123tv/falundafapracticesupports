import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font đứng chung (Noto Sans) — tránh tiêu đề bị bè ngang trên iOS/Android.
class AppTextStyles {
  static String? get fontFamily => GoogleFonts.notoSans().fontFamily;

  static TextStyle title({
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 18,
  }) {
    return GoogleFonts.notoSans(
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
    return GoogleFonts.notoSans(
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
  );

  final textTheme = GoogleFonts.notoSansTextTheme(base.textTheme).apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black87,
  );

  return base.copyWith(
    textTheme: textTheme,
    primaryTextTheme: GoogleFonts.notoSansTextTheme(base.primaryTextTheme),
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
