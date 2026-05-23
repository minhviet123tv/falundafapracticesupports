import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_url_resolver.dart';

/// Một hàng: lùi / tiến / ô địa chỉ (hẹp) / tải lại / đi.
class CompactWebUrlBar extends StatefulWidget {
  static const double barHeight = 36;

  final WebViewController controller;
  final String? currentUrl;
  final EdgeInsetsGeometry? padding;

  const CompactWebUrlBar({
    super.key,
    required this.controller,
    this.currentUrl,
    this.padding,
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
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
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
              _icon(
                Icons.arrow_back_ios_new,
                () async {
                  if (await widget.controller.canGoBack()) {
                    await widget.controller.goBack();
                  }
                },
              ),
              _icon(
                Icons.arrow_forward_ios,
                () async {
                  if (await widget.controller.canGoForward()) {
                    await widget.controller.goForward();
                  }
                },
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
                  ),
                  textInputAction: TextInputAction.go,
                  onTap: () => setState(() => _editing = true),
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

  Widget _icon(IconData icon, VoidCallback onPressed, {String? tooltip}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
