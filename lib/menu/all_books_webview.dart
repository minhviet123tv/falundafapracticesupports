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
import '../common/webview_js_safe.dart';

/*
Lưu vị trí cuộn (pixel + tỷ lệ %) + URL đầy đủ (kể cả #mục) + lịch sử trang.
 */

class AllBooksWebview extends StatefulWidget {
  static const String routeName = "AllBooksWebview_routeName";
  @override
  State<AllBooksWebview> createState() => _AllBooksWebviewState();
}

class _AllBooksWebviewState extends State<AllBooksWebview>
    with WidgetsBindingObserver, WebViewJsHost {
  static const int _maxHistoryEntries = 80;

  late final WebViewController _controller;
  late LanguageAllPageFalundafa languageAllPageFalundafa;
  double border10 = 10.0;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;
  bool _stripScrollOnNextPageStart = false;
  bool _skipScrollRestoreOnFinish = false;
  int _suppressStripNavigationCount = 0;
  int _pageFinishGeneration = 0;

  @override
  void initState() {
    super.initState();
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
            if (request.isMainFrame) {
              if (_suppressStripNavigationCount > 0) {
                _suppressStripNavigationCount--;
              } else if (BookWebViewScrollHelper.isHashOnlyNavigation(
                _currentUrl,
                request.url,
              )) {
                _skipScrollRestoreOnFinish = true;
                _stripScrollOnNextPageStart = false;
              } else {
                _stripScrollOnNextPageStart = true;
                _skipScrollRestoreOnFinish = false;
              }
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
    BookWebViewScrollHelper.cancelPendingRestoresOnUserScroll();
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
      _readingState = _readingState.withOnlyCurrentScroll(
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
      unawaited(_captureScrollForCurrentPage());
      unawaited(_persistReadingState());
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
    final urlToLoad = _readingState.lastUrl ?? defaultUrl;

    final aligned = BookWebViewScrollHelper.alignHistoryForResume(
      _readingState.history,
      _readingState.historyIndex,
      urlToLoad,
    );

    _readingState = _readingState.withNavigation(
      url: urlToLoad,
      history: aligned.history,
      historyIndex: aligned.historyIndex,
    );
    _currentUrl = urlToLoad;
    _stripScrollOnNextPageStart = false;
    _suppressStripNavigationCount = 3;

    await _controller.loadRequest(Uri.parse(urlToLoad));
  }

  Future<void> _onPageFinished(String url) async {
    if (!mounted || url.isEmpty) return;
    final finishGeneration = ++_pageFinishGeneration;

    final resolvedUrl = await BookWebViewScrollHelper.readPageUrl(
          _controller,
          canRun: () => canRunWebViewJs,
        ) ??
        await _controller.currentUrl() ??
        url;
    if (!mounted || finishGeneration != _pageFinishGeneration) return;

    if (_stripScrollOnNextPageStart) {
      _readingState = _readingState.withoutScrollForUrl(
        BookWebViewScrollHelper.normalizeUrlKey(resolvedUrl),
      );
      _stripScrollOnNextPageStart = false;
    }

    _readingState = BookWebViewScrollHelper.commitUrlToHistory(
      _readingState,
      resolvedUrl,
      maxEntries: _maxHistoryEntries,
    );
    _currentUrl = resolvedUrl;

    final skipRestore = _skipScrollRestoreOnFinish;
    _skipScrollRestoreOnFinish = false;

    _isRestoringScroll = true;
    try {
      await BookWebViewScrollHelper.installReporter(
        _controller,
        canRun: () => canRunWebViewJs,
      );
      if (!skipRestore) {
        await BookWebViewScrollHelper.restoreScrollIfSaved(
          _controller,
          _readingState,
          resolvedUrl,
          isMounted: () => mounted,
          setRestoring: (restoring) => _isRestoringScroll = restoring,
        );
      }
      if (!mounted || finishGeneration != _pageFinishGeneration) return;
      await _persistReadingState();
    } finally {
      _isRestoringScroll = false;
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _captureScrollForUrl(String url) async {
    if (url.isEmpty || _isRestoringScroll) return;

    final position = await BookWebViewScrollHelper.readPosition(
      _controller,
      canRun: () => canRunWebViewJs,
    );
    if (position == null) return;
    if (position.scrollY <= 0 && position.scrollRatio <= 0) return;

    _readingState = _readingState.withOnlyCurrentScroll(
      BookWebViewScrollHelper.normalizeUrlKey(url),
      position,
    );
  }

  Future<void> _captureScrollForCurrentPage() async {
    if (!canRunWebViewJs) return;
    final url = await BookWebViewScrollHelper.readPageUrl(
          _controller,
          canRun: () => canRunWebViewJs,
        ) ??
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
    if (!canRunWebViewJs) {
      await BookWebViewStateStore.save(
        languageAllPageFalundafa.languageCode,
        _readingState,
      );
      return;
    }
    final url = await BookWebViewScrollHelper.readPageUrl(
          _controller,
          canRun: () => canRunWebViewJs,
        ) ??
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

  /// Về trang mục lục sách (`booksPage`) của ngôn ngữ đang chọn trong enum.
  Future<void> _goToBooksHomePage() async {
    await _captureScrollForCurrentPage();

    final homeUrl = languageAllPageFalundafa.booksPage;
    _currentUrl = homeUrl;
    _stripScrollOnNextPageStart = true;
    _readingState = _readingState.withOnlyCurrentScroll(
      BookWebViewScrollHelper.normalizeUrlKey(homeUrl),
      const BookScrollPosition(scrollY: 0, scrollRatio: 0),
    );

    await _controller.loadRequest(Uri.parse(homeUrl));
    await _persistReadingState();
    if (mounted) setState(() {});
  }

  Future<void> _goBack() async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    if (await _controller.canGoBack()) {
      _stripScrollOnNextPageStart = false;
      _suppressStripNavigationCount = 3;
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
      _stripScrollOnNextPageStart = false;
      _suppressStripNavigationCount = 3;
      await _controller.loadRequest(Uri.parse(url));
    }
  }

  Future<void> _goForward() async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    if (await _controller.canGoForward()) {
      _stripScrollOnNextPageStart = false;
      _suppressStripNavigationCount = 3;
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
      _stripScrollOnNextPageStart = false;
      _suppressStripNavigationCount = 3;
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
    WidgetsBinding.instance.removeObserver(this);
    _scrollSaveDebounce?.cancel();
    if (canRunWebViewJs) {
      unawaited(
        _captureScrollForCurrentPage().whenComplete(() {
          unawaited(BookWebViewStateStore.save(
            languageAllPageFalundafa.languageCode,
            _readingState,
          ));
        }),
      );
    } else {
      unawaited(BookWebViewStateStore.save(
        languageAllPageFalundafa.languageCode,
        _readingState,
      ));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          unawaited(_onSystemBack());
        }
      },
      child: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
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
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(border10)),
                    border: Border.all(color: Colors.white70),
                  ),
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
            ],
          ),
          toolbarHeight: BookWebViewScrollHelper.bookAppBarHeightPx,
          actions: [
            FutureBuilder<bool>(
              future: _canGoBack(),
              builder: (context, snapshot) {
                final enabled = snapshot.data ?? false;
                return IconButton(
                  onPressed: enabled ? () => unawaited(_goBack()) : null,
                  icon: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 20,
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
                    size: 20,
                    color: enabled ? null : Colors.grey.shade400,
                  ),
                );
              },
            ),
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
          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: (progressLoadWeb <= 20)
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: _controller),
      ),
    ),
    );
  }
}
