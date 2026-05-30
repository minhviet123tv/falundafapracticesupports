import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_url_resolver.dart';

/// Một hàng: lùi / tiến / ô địa chỉ (hẹp) / tải lại / đi.
class CompactWebUrlBar extends StatefulWidget {
  static const double barHeight = 36;

  /// Icon duyệt web (dùng thống nhất trên mọi trang có thanh browser).
  static const IconData backIcon = Icons.arrow_circle_left_outlined;
  static const IconData forwardIcon = Icons.arrow_circle_right_outlined;
  static const double navIconSize = 20;

  final WebViewController controller;
  final String? currentUrl;
  final EdgeInsetsGeometry? padding;
  final Future<void> Function()? onBack;
  final Future<void> Function()? onForward;
  final Future<bool> Function()? canGoBack;
  final Future<bool> Function()? canGoForward;

  const CompactWebUrlBar({
    super.key,
    required this.controller,
    this.currentUrl,
    this.padding,
    this.onBack,
    this.onForward,
    this.canGoBack,
    this.canGoForward,
  });

  @override
  State<CompactWebUrlBar> createState() => _CompactWebUrlBarState();
}

class _CompactWebUrlBarState extends State<CompactWebUrlBar> {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: WebUrlResolver.displayForUrl(widget.currentUrl),
    );
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(CompactWebUrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing &&
        widget.currentUrl != null &&
        widget.currentUrl != oldWidget.currentUrl) {
      _textController.text = WebUrlResolver.displayForUrl(widget.currentUrl);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearAddress() {
    _textController.clear();
    setState(() => _editing = true);
    _focusNode.requestFocus();
  }

  Future<void> _go() async {
    final raw = _textController.text.trim();
    if (raw.isEmpty) return;
    _focusNode.unfocus();
    setState(() => _editing = false);
    try {
      final uri = WebUrlResolver.resolve(raw);
      await widget.controller.loadRequest(uri);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở địa chỉ này')),
      );
    }
  }

  Future<void> _handleBack() async {
    if (widget.onBack != null) {
      await widget.onBack!();
      return;
    }
    if (await widget.controller.canGoBack()) {
      await widget.controller.goBack();
    }
  }

  Future<void> _handleForward() async {
    if (widget.onForward != null) {
      await widget.onForward!();
      return;
    }
    if (await widget.controller.canGoForward()) {
      await widget.controller.goForward();
    }
  }

  Future<bool> _resolveCanGoBack() async {
    if (widget.canGoBack != null) return widget.canGoBack!();
    return widget.controller.canGoBack();
  }

  Future<bool> _resolveCanGoForward() async {
    if (widget.canGoForward != null) return widget.canGoForward!();
    return widget.controller.canGoForward();
  }

  Widget _navIcon({
    required IconData icon,
    required VoidCallback onPressed,
    required Future<bool> Function() enabled,
  }) {
    return FutureBuilder<bool>(
      future: enabled(),
      builder: (context, snapshot) {
        final canPress = snapshot.data ?? false;
        return SizedBox(
          width: 32,
          height: 32,
          child: IconButton(
            onPressed: canPress ? onPressed : null,
            icon: Icon(
              icon,
              size: CompactWebUrlBar.navIconSize,
              color: canPress ? null : Colors.grey.shade400,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            visualDensity: VisualDensity.compact,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.padding ?? const EdgeInsets.symmetric(horizontal: 4);

    return Material(
      color: const Color(0xFFF5F5F5),
      child: SizedBox(
        height: CompactWebUrlBar.barHeight,
        child: Padding(
          padding: pad,
          child: Row(
            children: [
              _navIcon(
                icon: CompactWebUrlBar.backIcon,
                onPressed: () => unawaited(_handleBack()),
                enabled: _resolveCanGoBack,
              ),
              _navIcon(
                icon: CompactWebUrlBar.forwardIcon,
                onPressed: () => unawaited(_handleForward()),
                enabled: _resolveCanGoForward,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Địa chỉ hoặc tìm kiếm',
                    hintStyle: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    suffixIcon: _textController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: _clearAddress,
                            icon: const Icon(Icons.close, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 28,
                              minHeight: 28,
                            ),
                            tooltip: 'Xóa',
                            visualDensity: VisualDensity.compact,
                          ),
                  ),
                  textInputAction: TextInputAction.go,
                  onTap: () => setState(() => _editing = true),
                  onChanged: (_) => setState(() => _editing = true),
                  onSubmitted: (_) => _go(),
                ),
              ),
              _icon(Icons.refresh, () => widget.controller.reload()),
              _icon(Icons.arrow_forward, _go, tooltip: 'Đi'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(
    IconData icon,
    VoidCallback onPressed, {
    String? tooltip,
    double iconSize = 16,
  }) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
