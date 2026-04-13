import 'dart:async';
import 'package:flutter/material.dart';
import 'memory_config.dart';

/// Bọc app; bật [showMemoryInfo] khi cần overlay debug.
class MemoryMonitor extends StatefulWidget {
  final Widget child;
  final bool showMemoryInfo;

  const MemoryMonitor({
    super.key,
    required this.child,
    this.showMemoryInfo = false,
  });

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
      _memoryTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted) return;
        setState(() => _memoryInfo = MemoryConfig.getMemoryInfo());
        if (!MemoryConfig.isMemoryWithinLimit()) _showMemoryWarning();
      });
    }
  }

  @override
  void dispose() {
    _memoryTimer?.cancel();
    super.dispose();
  }

  void _showMemoryWarning() {
    if (!mounted) return;
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
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
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
