import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import '../common/app_webview_config.dart';
import '../common/book_tab_chrome.dart';
import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';
import '../common/compact_web_url_bar.dart';
import '../common/webview_immersive_mixin.dart';

/// Tab Book: đọc Chuyển Pháp Luân online theo [LanguageNameOfChuyenPhapLuan].
class ChuyenPhapLuanWebview extends StatefulWidget {
  static const String routeName = 'ChuyenPhapLuanWebview_routeName';

  @override
  State<ChuyenPhapLuanWebview> createState() => _ChuyenPhapLuanWebviewState();
}

class _ChuyenPhapLuanWebviewState extends State<ChuyenPhapLuanWebview>
    with
        WidgetsBindingObserver,
        SingleTickerProviderStateMixin,
        WebviewImmersiveMixin {
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
  String? _preserveScrollForUrlKey;
  bool _restoreScrollAfterFinish = false;

  String get _languageCode => _language.name;

  @override
  ValueNotifier<bool>? get externalImmersiveNotifier => BookTabChrome.immersive;

  /// Menu bottom là overlay trong main.dart — không resize WebView.
  @override
  double get bottomNavReserve => 0;

  /// Cuộn xuống → ẩn AppBar + browser + menu bottom ngay.
  @override
  bool get immersiveScrollHideIgnoresCooldown => true;

  @override
  double get immersiveScrollUpRevealThresholdPx => 0;

  @override
  bool get immersiveScrollRevealIgnoresSuppress => true;

  @override
  bool get immersiveScrollHandlesDuringAnimation => true;

  @override
  bool get immersiveScrollIgnoresThrottle => true;

  @override
  bool get immersiveScrollSnapsChrome => true;

  /// Báo cáo scroll mỗi frame — phản hồi ẩn/hiện ngay lần cuộn đầu.
  @override
  int get immersiveScrollReportMinIntervalMs => 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initImmersive();
    BookTabChrome.bindChromeAnimation(immersiveAnim);
    _language = LanguageNameOfChuyenPhapLuan.vietnamese;

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
            onImmersivePageStarted();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadSavedLanguageAndOpen());
    });
  }

  void _onScrollReported(String message) {
    if (_isRestoringScroll || !mounted) {
      return;
    }
    BookWebViewScrollHelper.cancelPendingRestoresOnUserScroll();
    try {
      final decoded = jsonDecode(message);
      if (decoded is! Map) return;
      final url = decoded['url'];
      final y = decoded['y'];
      final ratio = decoded['ratio'];
      if (url is! String || url.isEmpty) return;
      if (y is! num) return;

      handleImmersiveScrollReport(message);

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

  Future<void> _loadSavedLanguageAndOpen() async {
    await AppWebViewConfig.applyPlatformSettings(_controller);
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
      await installImmersivePageChrome(_controller);

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
    } finally {
      _isRestoringScroll = false;
    }

    final scrollPos = await BookWebViewScrollHelper.readPosition(_controller);
    await onImmersivePageFinished(scrollY: scrollPos?.scrollY ?? 0);
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

  @override
  Future<void> toggleImmersiveMode() async {
    if (inImmersiveMode) {
      await _exitImmersiveMode();
    } else {
      await _enterImmersiveMode();
    }
  }

  Future<void> _enterImmersiveMode() async {
    if (!mounted || inImmersiveMode) return;
    unawaited(_captureScrollForCurrentPage());
    unawaited(_persistReadingState());
    await enterImmersiveMode();
  }

  Future<void> _exitImmersiveMode() async {
    if (!mounted) return;
    await _captureScrollForCurrentPage();
    await _persistReadingState();
    if (!mounted) return;
    await exitImmersiveMode();
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

  void _prepareNavigationTo(String url) {
    _preserveScrollForUrlKey =
        BookWebViewScrollHelper.normalizeUrlKey(url);
    _restoreScrollAfterFinish = BookWebViewScrollHelper.scrollForUrl(
          _readingState.scrollByUrl,
          url,
        ) !=
        null;
  }

  /// Về đầu sách Chuyển Pháp Luân (`urlChuyenPhapLuan`) của ngôn ngữ hiện tại.
  Future<void> _goToZflHomePage() async {
    await _captureScrollForCurrentPage();

    final homeUrl = _language.urlChuyenPhapLuan;
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

  Future<void> _onSystemBack() async {
    if (await handleImmersiveSystemBack()) return;
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
    BookTabChrome.unbindChromeAnimation(immersiveAnim);
    disposeImmersive();
    WidgetsBinding.instance.removeObserver(this);
    _scrollSaveDebounce?.cancel();
    unawaited(_flushReadingState());
    super.dispose();
  }

  Widget _languageMenuButton() {
    return PopupMenuButton<LanguageNameOfChuyenPhapLuan>(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _language.tengoc.replaceAll('\n', ' '),
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
    );
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        _languageMenuButton(),
        IconButton(
          onPressed: () => unawaited(_goToZflHomePage()),
          icon: const Icon(Icons.menu_book, size: 20),
          tooltip: 'Về đầu sách',
        ),
        const Spacer(),
        FutureBuilder<dynamic>(
          future: BrowserHelper.getCurrentUrl(_controller),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                BrowserHelper.launchExternal(
                  Uri.parse(snapshot.data.toString()),
                );
              },
              icon: const Icon(Icons.open_in_new, size: 20),
            );
          },
        ),
        buildImmersiveToggleButton(),
      ],
    );
  }

  Widget _buildUrlBar() {
    return CompactWebUrlBar(
      controller: _controller,
      currentUrl: _currentUrl ?? _language.urlChuyenPhapLuan,
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
      onPop: () {
        unawaited(_onSystemBack());
      },
      body: progressLoadWeb <= 20
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
