import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Khởi tạo UI toàn cục (status bar, hướng màn hình).
class MemoryConfig {
  static Future<void> initialize() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (kDebugMode) debugPrint('MemoryConfig initialized');
  }

  /// Dữ liệu tĩnh cho overlay debug (không phản ánh RSS thật).
  static Map<String, dynamic> getMemoryInfo() => {
        'currentRSS': 8 * 1024,
        'currentRSSKB': 8.0,
        'maxPageSizeKB': 16,
        'maxPageSizeBytes': 16 * 1024,
        'isWithinLimit': true,
      };

  static bool isMemoryWithinLimit() => true;
}
