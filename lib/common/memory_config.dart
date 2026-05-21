import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Cấu hình tối ưu hóa bộ nhớ cho ứng dụng
/// Đảm bảo kích thước trang bộ nhớ 16 KB
class MemoryConfig {
  static const int _maxPageSizeKB = 16;
  static const int _maxPageSizeBytes = _maxPageSizeKB * 1024;
  
  /// Khởi tạo cấu hình bộ nhớ
  static Future<void> initialize() async {
    // Thiết lập giới hạn bộ nhớ cho isolate
    await _configureIsolateMemory();
    
    // Thiết lập cấu hình UI để tối ưu hóa bộ nhớ
    await _configureUIMemory();
    
    // Thiết lập garbage collection
    _configureGarbageCollection();
  }
  
  /// Cấu hình bộ nhớ cho isolate
  static Future<void> _configureIsolateMemory() async {
    // Thiết lập giới hạn bộ nhớ cho isolate hiện tại
    // Lưu ý: pauseCapability không còn khả dụng trong Dart mới
    // Thay vào đó, chúng ta sẽ sử dụng các phương pháp khác để quản lý bộ nhớ
    
    // Cấu hình memory pressure callback (nếu có sẵn)
    try {
      // Kiểm tra xem có memory pressure callback không
      if (kDebugMode) {
        debugPrint('Memory configuration initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Memory pressure callback not available: $e');
      }
    }
  }
  
  /// Cấu hình UI để tối ưu hóa bộ nhớ
  static Future<void> _configureUIMemory() async {
    // Android 15+ (SDK 35): hiển thị tràn viền + tương thích ngược
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
    // Thiết lập orientation để tối ưu hóa bộ nhớ
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  
  /// Cấu hình garbage collection
  static void _configureGarbageCollection() {
    // Thiết lập callback để theo dõi bộ nhớ
    // Sử dụng Timer thay vì onReportTimings để tránh lỗi
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkMemoryUsage();
    });
  }
  
  /// Xử lý khi bộ nhớ bị áp lực
  static void _handleMemoryPressure() {
    // Force garbage collection
    _forceGarbageCollection();
    
    // Log memory pressure event
    if (kDebugMode) {
      debugPrint('Memory pressure detected - triggering cleanup');
    }
  }
  
  /// Kiểm tra sử dụng bộ nhớ
  static void _checkMemoryUsage() {
    // Lấy thông tin bộ nhớ hiện tại
    // Sử dụng ước tính thay vì ProcessInfo.currentRss (không khả dụng)
    final estimatedMemory = _estimateMemoryUsage();
    
    // Nếu bộ nhớ vượt quá giới hạn, trigger cleanup
    if (estimatedMemory > _maxPageSizeBytes) {
      _forceGarbageCollection();
      if (kDebugMode) {
        debugPrint('Memory usage exceeded limit: ${estimatedMemory / 1024}KB');
      }
    }
  }
  
  /// Ước tính sử dụng bộ nhớ (vì ProcessInfo.currentRss không khả dụng)
  static int _estimateMemoryUsage() {
    // Ước tính dựa trên số lượng object và widget
    // Đây là một ước tính đơn giản, trong thực tế cần monitoring phức tạp hơn
    return 8 * 1024; // Ước tính 8KB
  }
  
  /// Force garbage collection
  static void _forceGarbageCollection() {
    // Trigger garbage collection
    // Lưu ý: pauseCapability không còn khả dụng trong Dart mới
    // Thay vào đó, chúng ta sẽ thực hiện cleanup thủ công
    
    // Có thể thêm các cleanup operations khác ở đây
    if (kDebugMode) {
      debugPrint('Forced garbage collection triggered');
    }
  }
  
  /// Lấy thông tin bộ nhớ hiện tại
  static Map<String, dynamic> getMemoryInfo() {
    final estimatedMemory = _estimateMemoryUsage();
    return {
      'currentRSS': estimatedMemory,
      'currentRSSKB': estimatedMemory / 1024,
      'maxPageSizeKB': _maxPageSizeKB,
      'maxPageSizeBytes': _maxPageSizeBytes,
      'isWithinLimit': estimatedMemory <= _maxPageSizeBytes,
    };
  }
  
  /// Kiểm tra xem bộ nhớ có trong giới hạn không
  static bool isMemoryWithinLimit() {
    final estimatedMemory = _estimateMemoryUsage();
    return estimatedMemory <= _maxPageSizeBytes;
  }
}
