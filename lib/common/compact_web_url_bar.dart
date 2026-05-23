import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'web_url_resolver.dart';

/// Một hàng: lùi / tiến / ô địa chỉ (hẹp) / tải lại / đi.
class CompactWebUrlBar extends StatefulWidget {
  static const double barHeight = 36;

  /// Ô địa chỉ đang được focus (dùng để hạ focus khi chạm WebView).
  static final ValueNotifier<bool> urlFieldFocused = ValueNotifier<bool>(false);

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

  /// Gọi từ toolbar / WebView — hạ bàn phím và bỏ focus ô địa chỉ.
  static void dismissUrlFieldFocus(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    urlFieldFocused.value = false;
  }
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
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    CompactWebUrlBar.urlFieldFocused.value = _focusNode.hasFocus;
    if (!_focusNode.hasFocus && _editing && mounted) {
      setState(() => _editing = false);
    }
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
    _focusNode.removeListener(_onFocusChanged);
    if (CompactWebUrlBar.urlFieldFocused.value) {
      CompactWebUrlBar.urlFieldFocused.value = false;
    }
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Hạ bàn phím và bỏ focus ô địa chỉ.
  void _dismissKeyboard() {
    if (!mounted) return;
    _focusNode.unfocus();
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    CompactWebUrlBar.urlFieldFocused.value = false;
    if (_editing) {
      setState(() => _editing = false);
    }
  }

  void _clearAddress() {
    _textController.clear();
    setState(() => _editing = true);
    _focusNode.requestFocus();
  }

  Future<void> _go() async {
    final raw = _textController.text.trim();
    if (raw.isEmpty) return;
    _dismissKeyboard();
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

    return GestureDetector(
      onTap: _dismissKeyboard,
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: const Color(0xFFF5F5F5),
        child: SizedBox(
          height: CompactWebUrlBar.barHeight,
          child: Padding(
            padding: pad,
            child: Row(
              children: [
                _historyButton(isBack: true),
                _historyButton(isBack: false),
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
                  onTap: () {
                    setState(() => _editing = true);
                    CompactWebUrlBar.urlFieldFocused.value = true;
                  },
                  onTapOutside: (_) => _dismissKeyboard(),
                  onChanged: (_) => setState(() => _editing = true),
                  onSubmitted: (_) => _go(),
                ),
                ),
                _icon(Icons.refresh, () {
                  _dismissKeyboard();
                  widget.controller.reload();
                }),
                _icon(Icons.arrow_forward, _go, tooltip: 'Đi'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _historyButton({required bool isBack}) {
    return FutureBuilder<bool>(
      future: isBack
          ? widget.controller.canGoBack()
          : widget.controller.canGoForward(),
      builder: (context, snapshot) {
        final enabled = snapshot.data ?? false;
        return SizedBox(
          width: 32,
          height: 32,
          child: IconButton(
            onPressed: enabled
                ? () async {
                    _dismissKeyboard();
                    if (isBack) {
                      await widget.controller.goBack();
                    } else {
                      await widget.controller.goForward();
                    }
                  }
                : null,
            icon: Icon(
              isBack
                  ? Icons.arrow_circle_left_outlined
                  : Icons.arrow_circle_right_outlined,
              size: 20,
              color: enabled ? null : Colors.grey.shade400,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            tooltip: isBack ? 'Lùi' : 'Tiến',
            visualDensity: VisualDensity.compact,
          ),
        );
      },
    );
  }

  Widget _icon(IconData icon, VoidCallback onPressed, {String? tooltip}) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        onPressed: () {
          _dismissKeyboard();
          onPressed();
        },
        icon: Icon(icon, size: 16),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// Chạm WebView khi bàn phím mở hoặc ô URL đang focus → hạ bàn phím + bỏ focus.
class DismissKeyboardWhenWebViewTapped extends StatelessWidget {
  const DismissKeyboardWhenWebViewTapped({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: CompactWebUrlBar.urlFieldFocused,
      builder: (context, urlFieldFocused, _) {
        final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
        if (!keyboardOpen && !urlFieldFocused) return child;

        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            Positioned.fill(
              child: GestureDetector(
                onTap: () => CompactWebUrlBar.dismissUrlFieldFocus(context),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        );
      },
    );
  }
}
