import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';

/// Màn hình đọc sách toàn màn hình — dùng chung BookWebViewStateStore với tab ZFL Book.
class ZflBookFullScreenWebview extends StatefulWidget {
  final String languageCode;
  final String initialUrl;
  final BookScrollPosition? initialScroll;

  const ZflBookFullScreenWebview({
    super.key,
    required this.languageCode,
    required this.initialUrl,
    this.initialScroll,
  });

  @override
  State<ZflBookFullScreenWebview> createState() => _ZflBookFullScreenWebviewState();
}

class _ZflBookFullScreenWebviewState extends State<ZflBookFullScreenWebview>
    with WidgetsBindingObserver {
  static const int _maxHistoryEntries = 80;

  late final WebViewController _controller;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initController();
    unawaited(_openInitialPage());
  }

  void _initController() {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() => progressLoadWeb = progress);
            }
          },
          onPageStarted: (String url) {
            final leaving = _currentUrl;
            if (leaving != null && leaving.isNotEmpty && leaving != url) {
              unawaited(_captureScrollForUrl(leaving));
            }
          },
          onPageFinished: (String url) {
            unawaited(_onPageFinished(url));
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            final url = change.url;
            if (url != null && url.isNotEmpty) {
              _currentUrl = url;
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'ScrollReporter',
        onMessageReceived: (JavaScriptMessage message) {
          _onScrollReported(message.message);
        },
      );

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  Future<void> _openInitialPage() async {
    _readingState = await BookWebViewStateStore.load(widget.languageCode);
    _currentUrl = widget.initialUrl;

    if (widget.initialScroll != null &&
        (widget.initialScroll!.scrollY > 0 || widget.initialScroll!.scrollRatio > 0)) {
      _readingState = _readingState.withScroll(widget.initialUrl, widget.initialScroll!);
    }

    _commitUrlToHistory(widget.initialUrl);
    await _controller.loadRequest(Uri.parse(widget.initialUrl));
  }

  void _onScrollReported(String message) {
    if (_isRestoringScroll || !mounted) return;
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final url = decoded['url'];
      final y = decoded['y'];
      final ratio = decoded['ratio'];
      if (url is! String || url.isEmpty) return;
      if (y is! num) return;

      final position = BookScrollPosition(
        scrollY: y.toDouble(),
        scrollRatio: ratio is num ? ratio.clamp(0.0, 1.0).toDouble() : 0,
      );
      if (position.scrollY <= 0 && position.scrollRatio <= 0) return;

      _currentUrl = url;
      _readingState = _readingState.withScroll(url, position);
      _schedulePersist();
    } catch (_) {}
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      unawaited(_captureScrollForCurrentPage());
      unawaited(_persistReadingState());
    }
  }

  Future<void> _onPageFinished(String url) async {
    if (!mounted || url.isEmpty) return;

    final resolvedUrl = await _controller.currentUrl() ?? url;
    _commitUrlToHistory(resolvedUrl);
    await BookWebViewScrollHelper.installReporter(_controller);
    await _restoreScrollForUrl(resolvedUrl);
    await _persistReadingState();
    if (mounted) setState(() {});
  }

  void _commitUrlToHistory(String url) {
    var history = List<String>.from(_readingState.history);
    var index = _readingState.historyIndex;

    final existingIndex = history.indexOf(url);
    if (existingIndex >= 0) {
      index = existingIndex;
    } else {
      if (index < history.length - 1) {
        history = history.sublist(0, index + 1);
      }
      history.add(url);
      if (history.length > _maxHistoryEntries) {
        final overflow = history.length - _maxHistoryEntries;
        history = history.sublist(overflow);
        index = history.length - 1;
      } else {
        index = history.length - 1;
      }
    }

    _currentUrl = url;
    _readingState = _readingState.withNavigation(
      url: url,
      history: history,
      historyIndex: index,
    );
  }

  Future<void> _captureScrollForUrl(String url) async {
    if (url.isEmpty || _isRestoringScroll) return;
    final position = await BookWebViewScrollHelper.readPosition(_controller);
    if (position == null) return;
    if (position.scrollY <= 0 && position.scrollRatio <= 0) return;
    _readingState = _readingState.withScroll(url, position);
  }

  Future<void> _captureScrollForCurrentPage() async {
    final url = await _controller.currentUrl() ?? _currentUrl;
    if (url == null || url.isEmpty) return;
    await _captureScrollForUrl(url);
    _currentUrl = url;
  }

  Future<void> _restoreScrollForUrl(String url) async {
    final saved = _readingState.scrollForUrl(url);
    if (saved == null) return;
    if (saved.scrollY <= 0 && saved.scrollRatio <= 0) return;

    _isRestoringScroll = true;
    try {
      await BookWebViewScrollHelper.restorePosition(
        _controller,
        saved,
        isMounted: () => mounted,
      );
    } finally {
      _isRestoringScroll = false;
    }
  }

  void _schedulePersist() {
    _scrollSaveDebounce?.cancel();
    _scrollSaveDebounce = Timer(const Duration(milliseconds: 600), () {
      unawaited(_persistReadingState());
    });
  }

  Future<void> _persistReadingState() async {
    final url = await _controller.currentUrl() ?? _currentUrl;
    if (url != null && url.isNotEmpty) {
      _readingState = _readingState.withNavigation(
        url: url,
        history: _readingState.history,
        historyIndex: _readingState.historyIndex,
      );
    }
    await BookWebViewStateStore.save(widget.languageCode, _readingState);
  }

  Future<void> _closeAndReturn() async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _goBack() async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return;
    }

    if (_readingState.historyIndex > 0) {
      final newIndex = _readingState.historyIndex - 1;
      final url = _readingState.history[newIndex];
      _readingState = _readingState.withNavigation(
        url: url,
        history: _readingState.history,
        historyIndex: newIndex,
      );
      _currentUrl = url;
      await _controller.loadRequest(Uri.parse(url));
    }
  }

  Future<void> _goForward() async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    if (await _controller.canGoForward()) {
      await _controller.goForward();
      return;
    }

    if (_readingState.historyIndex < _readingState.history.length - 1) {
      final newIndex = _readingState.historyIndex + 1;
      final url = _readingState.history[newIndex];
      _readingState = _readingState.withNavigation(
        url: url,
        history: _readingState.history,
        historyIndex: newIndex,
      );
      _currentUrl = url;
      await _controller.loadRequest(Uri.parse(url));
    }
  }

  Future<bool> _canGoBack() async {
    if (await _controller.canGoBack()) return true;
    return _readingState.historyIndex > 0;
  }

  Future<bool> _canGoForward() async {
    if (await _controller.canGoForward()) return true;
    return _readingState.historyIndex < _readingState.history.length - 1;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollSaveDebounce?.cancel();
    unawaited(_captureScrollForCurrentPage());
    unawaited(_persistReadingState());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          unawaited(_closeAndReturn());
        }
      },
      child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => unawaited(_closeAndReturn()),
        ),
        title: const Text('ZFL Book', style: TextStyle(fontSize: 16)),
        toolbarHeight: 44,
        actions: [
          FutureBuilder<bool>(
            future: _canGoBack(),
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return IconButton(
                onPressed: enabled ? () => unawaited(_goBack()) : null,
                icon: Icon(
                  Icons.arrow_circle_left_outlined,
                  color: enabled ? null : Colors.grey.shade400,
                ),
              );
            },
          ),
          FutureBuilder<bool>(
            future: _canGoForward(),
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return IconButton(
                onPressed: enabled ? () => unawaited(_goForward()) : null,
                icon: Icon(
                  Icons.arrow_circle_right_outlined,
                  color: enabled ? null : Colors.grey.shade400,
                ),
              );
            },
          ),
          FutureBuilder<String?>(
            future: BrowserHelper.getCurrentUrl(_controller),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return IconButton(
                onPressed: () {
                  BrowserHelper.launchExternal(Uri.parse(snapshot.data!));
                },
                icon: const Icon(Icons.open_in_new, size: 20),
              );
            },
          ),
        ],
      ),
      body: progressLoadWeb <= 20
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
      ),
    );
  }
}
