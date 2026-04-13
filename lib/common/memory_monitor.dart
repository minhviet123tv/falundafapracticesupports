import 'dart:async';
import 'package:flutter/material.dart';
import 'memory_config.dart';

/// Widget để theo dõi và hiển thị thông tin bộ nhớ
class MemoryMonitor extends StatefulWidget {
  final Widget child;
  final bool showMemoryInfo;
  
  const MemoryMonitor({
    Key? key,
    required this.child,
    this.showMemoryInfo = false,
  }) : super(key: key);

  @override
  State<MemoryMonitor> createState() => _MemoryMonitorState();
}

class _MemoryMonitorState extends State<MemoryMonitor> {
  Timer? _memoryTimer;
  Map<String, dynamic> _memoryInfo = {};
  
  @override
  void initState() {
    super.initState();
    if (widget.showMemoryInfo) {
      _startMemoryMonitoring();
    }
  }
  
  @override
  void dispose() {
    _memoryTimer?.cancel();
    super.dispose();
  }
  
  void _startMemoryMonitoring() {
    _memoryTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _memoryInfo = MemoryConfig.getMemoryInfo();
        });
        
        // Kiểm tra xem bộ nhớ có vượt quá giới hạn không
        if (!MemoryConfig.isMemoryWithinLimit()) {
          _showMemoryWarning();
        }
      }
    });
  }
  
  void _showMemoryWarning() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Memory usage: ${(_memoryInfo['currentRSSKB'] as double).toStringAsFixed(1)}KB / 16KB',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showMemoryInfo && _memoryInfo.isNotEmpty)
          Positioned(
            top: 50,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Memory: ${(_memoryInfo['currentRSSKB'] as double).toStringAsFixed(1)}KB',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Limit: ${_memoryInfo['maxPageSizeKB']}KB',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_memoryInfo['currentRSSKB'] as double) / 
                                  (_memoryInfo['maxPageSizeKB'] as int),
                      child: Container(
                        decoration: BoxDecoration(
                          color: (_memoryInfo['isWithinLimit'] as bool) 
                              ? Colors.green 
                              : Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Mixin để thêm khả năng theo dõi bộ nhớ cho các widget
mixin MemoryMonitorMixin<T extends StatefulWidget> on State<T> {
  Timer? _memoryTimer;
  bool _isMemoryMonitoring = false;
  
  /// Bắt đầu theo dõi bộ nhớ
  void startMemoryMonitoring({Duration interval = const Duration(seconds: 10)}) {
    if (_isMemoryMonitoring) return;
    
    _isMemoryMonitoring = true;
    _memoryTimer = Timer.periodic(interval, (timer) {
      if (mounted) {
        _onMemoryCheck();
      }
    });
  }
  
  /// Dừng theo dõi bộ nhớ
  void stopMemoryMonitoring() {
    _memoryTimer?.cancel();
    _memoryTimer = null;
    _isMemoryMonitoring = false;
  }
  
  /// Callback khi kiểm tra bộ nhớ
  void _onMemoryCheck() {
    final memoryInfo = MemoryConfig.getMemoryInfo();
    final isWithinLimit = MemoryConfig.isMemoryWithinLimit();
    
    onMemoryCheck(memoryInfo, isWithinLimit);
  }
  
  /// Override method này để xử lý khi kiểm tra bộ nhớ
  void onMemoryCheck(Map<String, dynamic> memoryInfo, bool isWithinLimit) {
    // Override trong subclass để xử lý
  }
  
  @override
  void dispose() {
    stopMemoryMonitoring();
    super.dispose();
  }
}
