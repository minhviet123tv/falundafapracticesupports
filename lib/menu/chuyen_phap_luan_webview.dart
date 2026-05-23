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
import '../common/webview_scroll_chrome_mixin.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';
import '../common/compact_web_url_bar.dart';

/// Tab Book: đọc Chuyển Pháp Luân online theo [LanguageNameOfChuyenPhapLuan].
class ChuyenPhapLuanWebview extends StatefulWidget {
  static const String routeName = 'ChuyenPhapLuanWebview_routeName';

  @override
  State<ChuyenPhapLuanWebview> createState() => _ChuyenPhapLuanWebviewState();
}

class _ChuyenPhapLuanWebviewState extends State<ChuyenPhapLuanWebview>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin, WebviewScrollChromeMixin {
  static const String _prefsLanguageKey = 'LanguageNameOfChuyenPhapLuan';
  static const int _maxHistoryEntries = 80;
  static const double _toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  double get _chromeBarHeight => _toolbarHeight + CompactWebUrlBar.barHeight;
  static const Color _statusBarBackground = Colors.black;
  static const SystemUiOverlayStyle _immersiveOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const Duration _immersiveAnimDuration = Duration(milliseconds: 220);
  static const double _overlayToolbarHorizontalPadding = 10;

  late final WebViewController _controller;
  late final AnimationController _immersiveAnim;
  late LanguageNameOfChuyenPhapLuan _language;
  final double _border10 = 10.0;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;
  VoidCallback? _chromeListener;

  String get _languageCode => _language.name;

  bool get _inImmersiveMode => _immersiveAnim.value >= 1.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _immersiveAnim = AnimationController(
      vsync: this,
      duration: _immersiveAnimDuration,
    );
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

    _controller = controller;
    _chromeListener = () {
      if (!BookTabChrome.immersive.value &&
          _immersiveAnim.value > 0 &&
          mounted) {
        unawaited(_exitImmersiveMode());
      }
    };
    BookTabChrome.immersive.addListener(_chromeListener!);
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
      final maxScroll = decoded['max'];
      if (url is! String || url.isEmpty) return;
      if (y is! num) return;

      final maxScrollPx = maxScroll is num ? maxScroll.toDouble() : 0.0;
      updateOverlayChromeFromScroll(
        y.toDouble(),
        maxScrollPx,
        _chromeBarHeight,
      );

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
      await _persistReadingState();
    } finally {
      _isRestoringScroll = false;
    }

    resetScrollChromeTracking();
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

  Future<void> _toggleImmersiveMode() async {
    if (_inImmersiveMode || _immersiveAnim.status == AnimationStatus.forward) {
      await _exitImmersiveMode();
    } else {
      await _enterImmersiveMode();
    }
  }

  Future<void> _enterImmersiveMode() async {
    if (_immersiveAnim.status == AnimationStatus.forward) return;
    await _captureScrollForCurrentPage();
    await _persistReadingState();
    if (!mounted) return;
    overlayChromeVisible = false;
    resetScrollChromeTracking();
    BookTabChrome.immersive.value = true;
    await _immersiveAnim.forward();
  }

  Future<void> _exitImmersiveMode() async {
    if (_immersiveAnim.status == AnimationStatus.reverse) return;
    await _captureScrollForCurrentPage();
    await _persistReadingState();
    if (!mounted) return;
    overlayChromeVisible = true;
    resetScrollChromeTracking();
    BookTabChrome.immersive.value = false;
    await _immersiveAnim.reverse();
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

  Future<bool> _canGoBack() async {
    if (await _controller.canGoBack()) return true;
    return _readingState.historyIndex > 0;
  }

  Future<void> _onSystemBack() async {
    if (_immersiveAnim.value > 0) {
      await _exitImmersiveMode();
      return;
    }
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
    if (_chromeListener != null) {
      BookTabChrome.immersive.removeListener(_chromeListener!);
    }
    if (BookTabChrome.immersive.value) {
      BookTabChrome.immersive.value = false;
    }
    _immersiveAnim.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _scrollSaveDebounce?.cancel();
    unawaited(_captureScrollForCurrentPage());
    unawaited(_persistReadingState());
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

  List<Widget> _navigationActions({required bool immersive}) {
    return [
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
      IconButton(
        onPressed: () => unawaited(_toggleImmersiveMode()),
        icon: Icon(
          immersive ? Icons.fullscreen_exit : Icons.zoom_out_map,
          size: 20,
        ),
        tooltip: immersive ? 'Thu gọn' : 'Mở rộng màn hình',
      ),
    ];
  }

  /// AppBar tab Book + thanh địa chỉ (một khối chrome).
  Widget _buildBookChromeBar() {
    final immersive = BookTabChrome.immersive.value;
    final showElevation = !immersive || overlayChromeVisible;
    return GestureDetector(
      onTap: () => CompactWebUrlBar.dismissUrlFieldFocus(context),
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: Colors.white,
        elevation: showElevation ? 1 : 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: _toolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _overlayToolbarHorizontalPadding,
                ),
                child: Row(
                  children: [
                    _languageMenuButton(),
                    IconButton(
                      onPressed: () => unawaited(_goToZflHomePage()),
                    icon: const Icon(Icons.menu_book, size: 20),
                    tooltip: 'Về đầu sách',
                  ),
                  const Spacer(),
                  ..._navigationActions(immersive: immersive),
                ],
              ),
            ),
          ),
            CompactWebUrlBar(
              controller: _controller,
              currentUrl: _currentUrl ?? _language.urlChuyenPhapLuan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookToolbarLayer(double immersiveProgress) {
    var bar = wrapChromeBarForScrollHide(
      _buildBookChromeBar(),
      enabled: true,
    );

    // Thu gọn: giữ AppBar tab Book hiện, chỉ animate WebView + menu bottom.
    if (_immersiveAnim.status == AnimationStatus.reverse) {
      return ClipRect(child: bar);
    }

    if (immersiveProgress >= 1.0) {
      return ClipRect(child: bar);
    }

    // Mở rộng: trượt AppBar tab Book lên rồi ẩn (cùng một widget).
    final curved = Curves.easeInOut.transform(immersiveProgress);
    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, -curved * _chromeBarHeight),
        child: Opacity(
          opacity: (1 - curved).clamp(0.0, 1.0),
          child: IgnorePointer(
            ignoring: curved > 0.5,
            child: bar,
          ),
        ),
      ),
    );
  }

  Widget _webViewBody() {
    final content = progressLoadWeb <= 20
        ? const Center(child: CircularProgressIndicator())
        : WebViewWidget(controller: _controller);
    return DismissKeyboardWhenWebViewTapped(child: content);
  }

  Widget _buildUnifiedChrome(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomNavReserve = kBottomNavigationBarHeight + bottomInset;
    final t = Curves.easeInOut.transform(_immersiveAnim.value);
    final bottomPad = (1 - t) * bottomNavReserve;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t >= 0.5 ? _immersiveOverlayStyle : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: webViewTopOffset(
                  topInset: topInset,
                  chromeBarHeight: _chromeBarHeight,
                  immersiveProgress: t,
                  scrollHideEnabled: true,
                ),
                left: 0,
                right: 0,
                bottom: 0,
                child: _webViewBody(),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: t,
                  child: ColoredBox(
                    color: _statusBarBackground,
                    child: SizedBox(height: topInset),
                  ),
                ),
              ),
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                child: _buildBookToolbarLayer(t),
              ),
            ],
          ),
        ),
      ),
    );
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
      child: AnimatedBuilder(
        animation: _immersiveAnim,
        builder: (context, child) => _buildUnifiedChrome(context),
      ),
    );
  }
}
