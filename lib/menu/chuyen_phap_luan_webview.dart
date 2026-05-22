import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';
import 'zfl_book_fullscreen_webview.dart';

/// Tab Book: đọc Chuyển Pháp Luân online theo [LanguageNameOfChuyenPhapLuan].
class ChuyenPhapLuanWebview extends StatefulWidget {
  static const String routeName = 'ChuyenPhapLuanWebview_routeName';

  @override
  State<ChuyenPhapLuanWebview> createState() => _ChuyenPhapLuanWebviewState();
}

class _ChuyenPhapLuanWebviewState extends State<ChuyenPhapLuanWebview>
    with WidgetsBindingObserver {
  static const String _prefsLanguageKey = 'LanguageNameOfChuyenPhapLuan';
  static const int _maxHistoryEntries = 80;

  late final WebViewController _controller;
  late LanguageNameOfChuyenPhapLuan _language;
  final double _border10 = 10.0;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;
  bool _restoreScrollAfterFullscreen = false;

  String get _languageCode => _language.name;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _language = LanguageNameOfChuyenPhapLuan.vietnamese;

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
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
            final leaving = _currentUrl;
            if (leaving != null && leaving.isNotEmpty && leaving != url) {
              unawaited(_captureScrollForUrl(leaving));
            }
            _readingState = _readingState.withoutScrollForUrl(
              BookWebViewScrollHelper.normalizeUrlKey(url),
            );
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadSavedLanguageAndOpen());
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

  Future<void> _loadSavedLanguageAndOpen() async {
    final shared = await SharedPreferences.getInstance();
    final savedName = shared.getString(_prefsLanguageKey) ?? 'vietnamese';
    try {
      _language = LanguageNameOfChuyenPhapLuan.values.byName(savedName);
    } catch (_) {
      _language = LanguageNameOfChuyenPhapLuan.vietnamese;
    }
    await _loadReadingStateAndOpenUrl();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadReadingStateAndOpenUrl() async {
    _readingState = await BookWebViewStateStore.load(_languageCode);

    final defaultUrl = _language.urlChuyenPhapLuan;
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

    final resolvedUrl =
        await BookWebViewScrollHelper.readPageUrl(_controller) ??
            await _controller.currentUrl() ??
            url;
    _commitUrlToHistory(resolvedUrl);
    _isRestoringScroll = true;
    try {
      await BookWebViewScrollHelper.installReporter(_controller);
      if (_restoreScrollAfterFullscreen) {
        _restoreScrollAfterFullscreen = false;
        await _restoreScrollForUrl(resolvedUrl, afterFullscreen: true);
      }
      await _persistReadingState();
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

    _readingState = _readingState.withOnlyCurrentScroll(
      BookWebViewScrollHelper.normalizeUrlKey(url),
      position,
    );
  }

  Future<void> _captureScrollForCurrentPage() async {
    final url = await BookWebViewScrollHelper.readPageUrl(_controller) ??
        await _controller.currentUrl() ??
        _currentUrl;
    if (url == null || url.isEmpty) return;
    _currentUrl = url;
    await _captureScrollForUrl(url);
  }

  Future<void> _restoreScrollForUrl(
    String url, {
    bool afterFullscreen = false,
  }) async {
    final saved = BookWebViewScrollHelper.scrollForUrl(
      _readingState.scrollByUrl,
      url,
    );
    if (saved == null) return;
    if (saved.scrollY <= 0 && saved.scrollRatio <= 0) return;

    const useScrollRatio = false;

    BookWebViewScrollHelper.cancelPendingRestoresOnUserScroll();
    final current = await BookWebViewScrollHelper.readPosition(_controller);
    if (BookWebViewScrollHelper.shouldSkipRestore(
      saved,
      current,
      useScrollRatio: useScrollRatio,
    )) {
      return;
    }

    if (!_isRestoringScroll) {
      _isRestoringScroll = true;
      try {
        await BookWebViewScrollHelper.restorePosition(
          _controller,
          saved,
          isMounted: () => mounted,
          useScrollRatio: useScrollRatio,
        );
      } finally {
        _isRestoringScroll = false;
      }
      return;
    }

    await BookWebViewScrollHelper.restorePosition(
      _controller,
      saved,
      isMounted: () => mounted,
      useScrollRatio: useScrollRatio,
      retryDelaysMs: const <int>[500],
    );
  }

  Future<void> _openFullScreen() async {
    final url = await BookWebViewScrollHelper.readPageUrl(_controller) ??
        await _controller.currentUrl() ??
        _currentUrl;
    if (url == null || url.isEmpty || !mounted) return;

    _currentUrl = url;
    await _captureScrollForUrl(url);
    final scrollNow =
        await BookWebViewScrollHelper.readPosition(_controller) ??
            BookWebViewScrollHelper.scrollForUrl(_readingState.scrollByUrl, url);
    await _persistReadingState();

    final returned = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => ZflBookFullScreenWebview(
          languageCode: _languageCode,
          initialUrl: url,
          homeUrl: _language.urlChuyenPhapLuan,
          initialScroll: scrollNow,
          openedFromBookTab: true,
        ),
      ),
    );

    if (!mounted || returned != true) return;
    _restoreScrollAfterFullscreen = true;
    await _syncFromStoreAfterFullScreen();
    if (mounted) setState(() {});
  }

  Future<void> _syncFromStoreAfterFullScreen() async {
    _readingState = await BookWebViewStateStore.load(_languageCode);
    final targetUrl = _readingState.lastUrl;
    if (targetUrl == null || targetUrl.isEmpty) return;

    final currentUrl = await _controller.currentUrl() ?? _currentUrl;
    _currentUrl = targetUrl;

    final samePage = BookWebViewScrollHelper.normalizeUrlKey(currentUrl ?? '') ==
        BookWebViewScrollHelper.normalizeUrlKey(targetUrl);

    if (!samePage) {
      await _controller.loadRequest(Uri.parse(targetUrl));
      return;
    }

    if (_restoreScrollAfterFullscreen) {
      _isRestoringScroll = true;
      try {
        await BookWebViewScrollHelper.installReporter(_controller);
        await _restoreScrollForUrl(targetUrl, afterFullscreen: true);
      } finally {
        _isRestoringScroll = false;
      }
    } else {
      await BookWebViewScrollHelper.installReporter(_controller);
    }
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
    await BookWebViewStateStore.save(_languageCode, _readingState);
  }

  Future<void> _saveLanguagePreference(LanguageNameOfChuyenPhapLuan value) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(_prefsLanguageKey, value.name);
  }

  Future<void> _onLanguageChanged(LanguageNameOfChuyenPhapLuan value) async {
    await _captureScrollForCurrentPage();
    await _persistReadingState();

    setState(() {
      _language = value;
    });

    await _saveLanguagePreference(value);
    await _loadReadingStateAndOpenUrl();
  }

  /// Về đầu sách Chuyển Pháp Luân (`urlChuyenPhapLuan`) của ngôn ngữ hiện tại.
  Future<void> _goToZflHomePage() async {
    await _captureScrollForCurrentPage();

    final homeUrl = _language.urlChuyenPhapLuan;
    _currentUrl = homeUrl;
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
  void setState(VoidCallback fn) {
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
                PopupMenuButton<LanguageNameOfChuyenPhapLuan>(
                  tooltip: 'Chọn ngôn ngữ',
                  position: PopupMenuPosition.under,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_border10),
                  ),
                  onSelected: (LanguageNameOfChuyenPhapLuan value) {
                    unawaited(_onLanguageChanged(value));
                  },
                  itemBuilder: (context) {
                    return LanguageNameOfChuyenPhapLuan.values
                        .map(
                          (value) => PopupMenuItem<LanguageNameOfChuyenPhapLuan>(
                            value: value,
                            height: 44,
                            child: Text(value.tengoc),
                          ),
                        )
                        .toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(_border10)),
                      border: Border.all(color: Colors.white70),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _language.tengoc,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, size: 18),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => unawaited(_goToZflHomePage()),
                  icon: const Icon(Icons.menu_book, size: 20),
                  tooltip: 'Về đầu sách',
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
              FutureBuilder<dynamic>(
                future: BrowserHelper.getCurrentUrl(_controller),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      onPressed: () {
                        BrowserHelper.launchExternal(
                          Uri.parse(snapshot.data.toString()),
                        );
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
      ),
    );
  }
}
