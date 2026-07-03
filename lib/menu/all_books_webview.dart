import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import '../common/app_webview_config.dart';
import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';
import '../common/compact_web_url_bar.dart';
import '../common/webview_immersive_mixin.dart';

/*
Lưu vị trí cuộn (pixel + tỷ lệ %) + URL đầy đủ (kể cả #mục) + lịch sử trang.
 */

class AllBooksWebview extends StatefulWidget {
  static const String routeName = "AllBooksWebview_routeName";
  @override
  State<AllBooksWebview> createState() => _AllBooksWebviewState();
}

class _AllBooksWebviewState extends State<AllBooksWebview> 
    with WidgetsBindingObserver, SingleTickerProviderStateMixin, WebviewImmersiveMixin {
  static const int _maxHistoryEntries = 80;

  late final WebViewController _controller;
  late LanguageAllPageFalundafa languageAllPageFalundafa;
  double border10 = 10.0;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;
  String? _preserveScrollForUrlKey;
  bool _restoreScrollAfterFinish = false;

  @override
  void initState() {
    super.initState();
    initImmersive();
    WidgetsBinding.instance.addObserver(this);
    languageAllPageFalundafa = LanguageAllPageFalundafa.vietnamese;

    final WebViewController controller = AppWebViewConfig.createController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              progressLoadWeb = progress;
            });
          },
          onPageStarted: (String url) {
            onImmersivePageStarted();
            final leaving = _currentUrl;
            if (leaving != null &&
                leaving.isNotEmpty &&
                !BookWebViewScrollHelper.urlsMatch(leaving, url)) {
              unawaited(_captureScrollForUrl(leaving));
            }
            final destKey = BookWebViewScrollHelper.normalizeUrlKey(url);
            final preserve = _preserveScrollForUrlKey != null &&
                _preserveScrollForUrlKey == destKey;
            if (preserve) {
              _preserveScrollForUrlKey = null;
            } else if (!_restoreScrollAfterFinish) {
              _readingState = _readingState.withoutScrollForUrl(destKey);
            }
          },
          onPageFinished: (String url) {
            unawaited(_onPageFinished(url));
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
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
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    _controller = controller;
    // Trì hoãn load WebView sau frame đầu — giảm crash Chromium trên emulator 16KB.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_getLanguageEnumBook());
    });
  }

  void _onScrollReported(String message) {
    if (_isRestoringScroll || !mounted) return;
    
    handleImmersiveScrollReport(message);
    
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
      _readingState = _readingState.withScrollForUrl(
        BookWebViewScrollHelper.normalizeUrlKey(url),
        position,
      );
      _schedulePersist();
    } catch (e) {
      debugPrint('Scroll report parse error: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      unawaited(_flushReadingState());
    }
  }

  Future<void> _getLanguageEnumBook() async {
    await AppWebViewConfig.applyPlatformSettings(_controller);
    final shared = await SharedPreferences.getInstance();
    final languageEnumBook =
        shared.getString("LanguageAllPageFalundafa") ?? "vietnamese";
    languageAllPageFalundafa = LanguageAllPageFalundafa.values.byName(languageEnumBook);
    await _loadReadingStateAndOpenUrl();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadReadingStateAndOpenUrl() async {
    _readingState =
        await BookWebViewStateStore.load(languageAllPageFalundafa.languageCode);

    final defaultUrl = languageAllPageFalundafa.booksPage;
    var urlToLoad = _readingState.lastUrl ?? defaultUrl;

    var history = List<String>.from(_readingState.history);
    var historyIndex = _readingState.historyIndex;

    if (history.isEmpty) {
      history = <String>[urlToLoad];
      historyIndex = 0;
    } else {
      final existing = BookWebViewScrollHelper.historyIndexOf(history, urlToLoad);
      if (existing >= 0) {
        urlToLoad = history[existing];
        historyIndex = existing;
      } else {
        history.add(urlToLoad);
        historyIndex = history.length - 1;
      }
    }

    _readingState = _readingState.withNavigation(
      url: urlToLoad,
      history: history,
      historyIndex: historyIndex,
    );
    _currentUrl = urlToLoad;

    _preserveScrollForUrlKey =
        BookWebViewScrollHelper.normalizeUrlKey(urlToLoad);
    _restoreScrollAfterFinish = BookWebViewScrollHelper.scrollForUrl(
          _readingState.scrollByUrl,
          urlToLoad,
        ) !=
        null;

    await _controller.loadRequest(Uri.parse(urlToLoad));
  }

  Future<void> _onPageFinished(String url) async {
    if (!mounted || url.isEmpty) return;

    final resolvedUrl =
        await BookWebViewScrollHelper.readPageUrl(_controller) ??
            await _controller.currentUrl() ??
            url;
    _commitUrlToHistory(resolvedUrl);
    _isRestoringScroll = true;
    try {
      await installImmersiveScrollReporter(_controller);

      final saved = BookWebViewScrollHelper.scrollForUrl(
        _readingState.scrollByUrl,
        resolvedUrl,
      );
      if (_restoreScrollAfterFinish && saved != null) {
        await BookWebViewScrollHelper.restorePosition(
          _controller,
          saved,
          isMounted: () => mounted,
          useScrollRatio: true,
          retryDelaysMs: const <int>[300, 900, 1600],
        );
      }
      _restoreScrollAfterFinish = false;

      await _persistReadingState();
      await onImmersivePageFinished(scrollY: saved?.scrollY);
    } finally {
      _isRestoringScroll = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _commitUrlToHistory(String url) {
    var history = List<String>.from(_readingState.history);
    var index = _readingState.historyIndex;

    final existingIndex = BookWebViewScrollHelper.historyIndexOf(history, url);
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

    _readingState = _readingState.withScrollForUrl(
      BookWebViewScrollHelper.normalizeUrlKey(url),
      position,
    );
  }

  Future<void> _flushReadingState() async {
    _scrollSaveDebounce?.cancel();
    await _captureScrollForCurrentPage();
    await _persistReadingState();
  }

  Future<void> _captureScrollForCurrentPage() async {
    final url = await BookWebViewScrollHelper.readPageUrl(_controller) ??
        await _controller.currentUrl() ??
        _currentUrl;
    if (url == null || url.isEmpty) return;
    _currentUrl = url;
    await _captureScrollForUrl(url);
  }

  void _schedulePersist() {
    _scrollSaveDebounce?.cancel();
    _scrollSaveDebounce = Timer(const Duration(milliseconds: 600), () {
      unawaited(_persistReadingState());
    });
  }

  Future<void> _persistReadingState() async {
    final url = await BookWebViewScrollHelper.readPageUrl(_controller) ??
        await _controller.currentUrl() ??
        _currentUrl;
    if (url != null && url.isNotEmpty) {
      _readingState = _readingState.withNavigation(
        url: url,
        history: _readingState.history,
        historyIndex: _readingState.historyIndex,
      );
    }
    await BookWebViewStateStore.save(
      languageAllPageFalundafa.languageCode,
      _readingState,
    );
  }

  Future<void> _setLanguageEnumBook(LanguageAllPageFalundafa languageName) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("LanguageAllPageFalundafa", languageName.name);
  }

  Future<void> _onLanguageChanged(LanguageAllPageFalundafa value) async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    setState(() {
      languageAllPageFalundafa = value;
    });

    await _setLanguageEnumBook(value);
    await _loadReadingStateAndOpenUrl();
  }

  void _prepareNavigationTo(String url) {
    _preserveScrollForUrlKey =
        BookWebViewScrollHelper.normalizeUrlKey(url);
    _restoreScrollAfterFinish = BookWebViewScrollHelper.scrollForUrl(
          _readingState.scrollByUrl,
          url,
        ) !=
        null;
  }

  /// Về trang mục lục sách (`booksPage`) của ngôn ngữ đang chọn trong enum.
  Future<void> _goToBooksHomePage() async {
    await _captureScrollForCurrentPage();

    final homeUrl = languageAllPageFalundafa.booksPage;
    _currentUrl = homeUrl;
    _restoreScrollAfterFinish = false;
    _preserveScrollForUrlKey = null;
    _readingState = _readingState.withoutScrollForUrl(
      BookWebViewScrollHelper.normalizeUrlKey(homeUrl),
    );

    await _controller.loadRequest(Uri.parse(homeUrl));
    await _persistReadingState();
    if (mounted) setState(() {});
  }

  Future<void> _goBack() async {
    await _flushReadingState();

    if (await _controller.canGoBack()) {
      _restoreScrollAfterFinish = true;
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
      _prepareNavigationTo(url);
      await _controller.loadRequest(Uri.parse(url));
    }
  }

  Future<void> _goForward() async {
    await _flushReadingState();

    if (await _controller.canGoForward()) {
      _restoreScrollAfterFinish = true;
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
      _prepareNavigationTo(url);
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

  /// Android nút Back hệ thống: lùi WebView / lịch sử app trước khi thoát tab.
  Future<void> _onSystemBack() async {
    if (await _canGoBack()) {
      await _goBack();
      return;
    }
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    disposeImmersive();
    WidgetsBinding.instance.removeObserver(this);
    _scrollSaveDebounce?.cancel();
    unawaited(_flushReadingState());
    super.dispose();
  }

  Widget _buildToolbar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PopupMenuButton<LanguageAllPageFalundafa>(
          tooltip: 'Select language',
          position: PopupMenuPosition.under,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)),
          onSelected: (LanguageAllPageFalundafa value) {
            unawaited(_onLanguageChanged(value));
          },
          itemBuilder: (context) {
            return LanguageAllPageFalundafa.values
                .map(
                  (value) => PopupMenuItem<LanguageAllPageFalundafa>(
                    value: value,
                    height: 44,
                    child: Text(value.languageName),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  languageAllPageFalundafa.languageName,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () => unawaited(_goToBooksHomePage()),
          icon: const Icon(Icons.menu_book, size: 20),
          tooltip: 'Trang mục lục sách',
        ),
        const Spacer(),
        FutureBuilder<dynamic>(
          future: BrowserHelper.getCurrentUrl(_controller),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return IconButton(
                onPressed: () {
                  BrowserHelper.launchExternal(Uri.parse(snapshot.data.toString()));
                },
                icon: const Icon(Icons.open_in_new, size: 20),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        buildImmersiveToggleButton(),
      ],
    );
  }

  Widget _buildUrlBar() {
    return CompactWebUrlBar(
      controller: _controller,
      currentUrl: _currentUrl ?? languageAllPageFalundafa.booksPage,
      onBack: _goBack,
      onForward: _goForward,
      canGoBack: _canGoBack,
      canGoForward: _canGoForward,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildImmersiveScaffold(
      toolbar: _buildToolbar(),
      urlBar: _buildUrlBar(),
      onPop: _onSystemBack,
      body: (progressLoadWeb <= 20)
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
