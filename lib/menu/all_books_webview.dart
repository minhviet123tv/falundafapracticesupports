import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';
import 'zfl_book_fullscreen_webview.dart';

/*
Lưu vị trí cuộn (pixel + tỷ lệ %) + URL đầy đủ (kể cả #mục) + lịch sử trang.
 */

class AllBooksWebview extends StatefulWidget {
  static const String routeName = "AllBooksWebview_routeName";
  @override
  State<AllBooksWebview> createState() => _AllBooksWebviewState();
}

class _AllBooksWebviewState extends State<AllBooksWebview> with WidgetsBindingObserver {
  static const int _maxHistoryEntries = 80;

  late final WebViewController _controller;
  late LanguageAllPageFalundafa languageAllPageFalundafa;
  double border10 = 10.0;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    languageAllPageFalundafa = LanguageAllPageFalundafa.vietnamese;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
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
            // Chỉ lưu cuộn trang đang RỜI (URL khác URL mới) — tránh ghi đè bằng 0 khi mở lại app.
            final leaving = _currentUrl;
            if (leaving != null && leaving.isNotEmpty && leaving != url) {
              unawaited(_captureScrollForUrl(leaving));
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

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
    // Trì hoãn load WebView sau frame đầu — giảm crash Chromium trên emulator 16KB.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_getLanguageEnumBook());
    });
  }

  void _onScrollReported(String message) {
    if (_isRestoringScroll || !mounted) return;
    BookWebViewScrollHelper.cancelPendingRestores();
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

    var history = List<String>.from(_readingState.history);
    var historyIndex = _readingState.historyIndex;

    if (history.isEmpty) {
      history = <String>[urlToLoad];
      historyIndex = 0;
    } else if (!history.contains(urlToLoad)) {
      history.add(urlToLoad);
      historyIndex = history.length - 1;
    } else {
      historyIndex = history.indexOf(urlToLoad);
    }

    _readingState = _readingState.withNavigation(
      url: urlToLoad,
      history: history,
      historyIndex: historyIndex,
    );
    _currentUrl = urlToLoad;

    await _controller.loadRequest(Uri.parse(urlToLoad));
  }

  Future<void> _onPageFinished(String url) async {
    if (!mounted || url.isEmpty) return;

    final resolvedUrl = await _controller.currentUrl() ?? url;
    _commitUrlToHistory(resolvedUrl);
    await BookWebViewScrollHelper.installReporter(_controller);
    await _restoreScrollForUrl(resolvedUrl);
    await _persistReadingState();

    if (mounted) {
      setState(() {});
    }
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

    BookWebViewScrollHelper.cancelPendingRestores();
    final current = await BookWebViewScrollHelper.readPosition(_controller);
    if (BookWebViewScrollHelper.shouldSkipRestore(saved, current)) {
      return;
    }

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

  /// Mở toàn màn hình tại đúng URL + vị trí cuộn hiện tại; khi quay lại đồng bộ tab.
  Future<void> _openFullScreen() async {
    final url = await _controller.currentUrl() ?? _currentUrl;
    if (url == null || url.isEmpty || !mounted) return;

    await _captureScrollForCurrentPage();
    final scrollNow = _readingState.scrollForUrl(url) ??
        await BookWebViewScrollHelper.readPosition(_controller);
    await _persistReadingState();

    final returned = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => ZflBookFullScreenWebview(
          languageCode: languageAllPageFalundafa.languageCode,
          initialUrl: url,
          initialScroll: scrollNow,
          openedFromBookTab: true,
        ),
      ),
    );

    if (!mounted || returned != true) return;
    await _syncFromStoreAfterFullScreen();
    if (mounted) setState(() {});
  }

  /// Sau khi đóng màn hình mở rộng: load lại URL + cuộn từ kho lưu chung.
  Future<void> _syncFromStoreAfterFullScreen() async {
    _readingState =
        await BookWebViewStateStore.load(languageAllPageFalundafa.languageCode);
    final targetUrl = _readingState.lastUrl;
    if (targetUrl == null || targetUrl.isEmpty) return;

    final currentUrl = await _controller.currentUrl() ?? _currentUrl;
    _currentUrl = targetUrl;

    if (currentUrl != targetUrl) {
      await _controller.loadRequest(Uri.parse(targetUrl));
      return;
    }

    await BookWebViewScrollHelper.installReporter(_controller);
    await _restoreScrollForUrl(targetUrl);
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
    _readingState = _readingState.withScroll(
      homeUrl,
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
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
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
    return SafeArea(
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
          toolbarHeight: 40,
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
            IconButton(
              onPressed: () => unawaited(_openFullScreen()),
              icon: const Icon(Icons.zoom_out_map, size: 20),
              tooltip: 'Mở rộng màn hình',
            ),
          ],
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: (progressLoadWeb <= 20)
            ? const Center(child: CircularProgressIndicator())
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}
