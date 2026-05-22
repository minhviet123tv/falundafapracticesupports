import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import '../common/book_webview_scroll_helper.dart';
import '../common/book_webview_state_store.dart';
import '../common/browser_helper.dart';

/// Màn hình đọc sách toàn màn hình — dùng chung BookWebViewStateStore với tab ZFL Book.
class ZflBookFullScreenWebview extends StatefulWidget {
  final String languageCode;
  final String initialUrl;
  final BookScrollPosition? initialScroll;
  /// Mở từ tab Book: bù cuộn −44px (cuộn lên) vì AppBar nổi đè phần đầu WebView.
  final bool openedFromBookTab;

  const ZflBookFullScreenWebview({
    super.key,
    required this.languageCode,
    required this.initialUrl,
    this.initialScroll,
    this.openedFromBookTab = false,
  });

  @override
  State<ZflBookFullScreenWebview> createState() => _ZflBookFullScreenWebviewState();
}

class _ZflBookFullScreenWebviewState extends State<ZflBookFullScreenWebview>
    with WidgetsBindingObserver {
  static const int _maxHistoryEntries = 80;
  static const double _toolbarHeight = BookWebViewScrollHelper.bookAppBarHeightPx;
  /// Tổng px cuộn cùng chiều (cộng dồn) để ẩn/hiện — hoạt động cả cuộn chậm.
  static const double _scrollDirectionThreshold = 36;
  /// Chỉ ẩn AppBar khi trang cuộn được ít nhất bằng chiều cao toolbar + khoảng đệm.
  static const double _minScrollableExtra = 40;

  late final WebViewController _controller;
  int progressLoadWeb = 0;

  BookReadingState _readingState = BookReadingState.empty();
  String? _currentUrl;
  Timer? _scrollSaveDebounce;
  bool _isRestoringScroll = false;
  bool _appBarVisible = true;
  double? _lastScrollY;
  double _directionalScrollAccum = 0;
  /// Bù scroll một lần khi mở từ tab Book (AppBar nổi đè — cuộn lên bằng chiều cao toolbar).
  bool _pendingBookTabScrollCompensation = false;
  /// Bù scroll khi mở không từ tab Book (toolbar overlay, cuộn lên).
  bool _compensateAppBarOnNextRestore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appBarVisible = true;
    if (widget.openedFromBookTab) {
      _pendingBookTabScrollCompensation = true;
    }
    final initial = widget.initialScroll;
    if (!widget.openedFromBookTab &&
        initial != null &&
        (initial.scrollY > 0 || initial.scrollRatio > 0)) {
      _compensateAppBarOnNextRestore = true;
    }
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
      _readingState = _readingState.withScroll(
        BookWebViewScrollHelper.normalizeUrlKey(widget.initialUrl),
        widget.initialScroll!,
      );
    }

    _commitUrlToHistory(widget.initialUrl);
    await _controller.loadRequest(Uri.parse(widget.initialUrl));
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
      final maxScroll = decoded['max'];
      if (url is! String || url.isEmpty) return;
      if (y is! num) return;

      final maxScrollPx =
          maxScroll is num ? maxScroll.toDouble() : 0.0;
      _updateAppBarFromScroll(y.toDouble(), maxScrollPx);

      final position = BookScrollPosition(
        scrollY: y.toDouble(),
        scrollRatio: ratio is num ? ratio.clamp(0.0, 1.0).toDouble() : 0,
      );
      if (position.scrollY <= 0 && position.scrollRatio <= 0) return;

      _currentUrl = url;
      _readingState = _readingState.withScroll(
        BookWebViewScrollHelper.normalizeUrlKey(url),
        position,
      );
      _schedulePersist();
    } catch (_) {}
  }

  /// Ẩn thanh điều hướng khi cuộn xuống, hiện lại khi cuộn lên hoặc gần đầu trang.
  /// Chỉ áp dụng khi nội dung đủ dài để cuộn (max >= toolbar + đệm).
  void _updateAppBarFromScroll(double scrollY, double maxScroll) {
    if (_isRestoringScroll || !mounted) return;

    final minScrollable = _toolbarHeight + _minScrollableExtra;
    if (maxScroll < minScrollable) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (!_appBarVisible) {
        setState(() => _appBarVisible = true);
      }
      return;
    }

    if (scrollY <= 20) {
      _lastScrollY = scrollY;
      _directionalScrollAccum = 0;
      if (!_appBarVisible) {
        setState(() => _appBarVisible = true);
      }
      return;
    }

    if (_lastScrollY != null) {
      final delta = scrollY - _lastScrollY!;
      if (delta != 0) {
        if (delta > 0 && _directionalScrollAccum < 0) {
          _directionalScrollAccum = 0;
        } else if (delta < 0 && _directionalScrollAccum > 0) {
          _directionalScrollAccum = 0;
        }
        _directionalScrollAccum += delta;

        var nextVisible = _appBarVisible;
        if (_directionalScrollAccum >= _scrollDirectionThreshold) {
          nextVisible = false;
          _directionalScrollAccum = 0;
        } else if (_directionalScrollAccum <= -_scrollDirectionThreshold) {
          nextVisible = true;
          _directionalScrollAccum = 0;
        }
        if (nextVisible != _appBarVisible) {
          setState(() => _appBarVisible = nextVisible);
        }
      }
    }
    _lastScrollY = scrollY;
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
    _isRestoringScroll = true;
    try {
      await BookWebViewScrollHelper.installReporter(_controller);
      await _restoreScrollForUrl(resolvedUrl);
      await _persistReadingState();
    } finally {
      _isRestoringScroll = false;
    }
    _lastScrollY = null;
    _directionalScrollAccum = 0;
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
    var position = await BookWebViewScrollHelper.readPosition(_controller);
    if (position == null) return;
    if (widget.openedFromBookTab) {
      position = BookWebViewScrollHelper.positionForBookTabFromFullscreen(position);
    }
    if (position.scrollY <= 0 && position.scrollRatio <= 0) return;
    _readingState = _readingState.withScroll(
      BookWebViewScrollHelper.normalizeUrlKey(url),
      position,
    );
  }

  Future<void> _captureScrollForCurrentPage() async {
    final url = await _controller.currentUrl() ?? _currentUrl;
    if (url == null || url.isEmpty) return;
    await _captureScrollForUrl(url);
    _currentUrl = url;
  }

  Future<void> _restoreScrollForUrl(String url) async {
    final applyBookTabCompensation =
        _pendingBookTabScrollCompensation && widget.openedFromBookTab;

    BookScrollPosition? saved;
    if (applyBookTabCompensation && widget.initialScroll != null) {
      saved = widget.initialScroll;
    } else {
      saved = BookWebViewScrollHelper.scrollForUrl(_readingState.scrollByUrl, url);
      if (saved == null &&
          widget.initialScroll != null &&
          BookWebViewScrollHelper.normalizeUrlKey(url) ==
              BookWebViewScrollHelper.normalizeUrlKey(widget.initialUrl)) {
        saved = widget.initialScroll;
      }
    }

    if (saved == null) return;

    var scrollOffsetPx = 0.0;
    var useScrollRatio = true;
    if (applyBookTabCompensation && mounted) {
      _pendingBookTabScrollCompensation = false;
      scrollOffsetPx =
          BookWebViewScrollHelper.scrollOffsetOpeningFullscreenFromBookTab();
      useScrollRatio = false;
    } else if (_compensateAppBarOnNextRestore && mounted) {
      _compensateAppBarOnNextRestore = false;
      scrollOffsetPx =
          BookWebViewScrollHelper.scrollOffsetOpeningFullscreenFromBookTab();
    }

    if (saved.scrollY <= 0 &&
        saved.scrollRatio <= 0 &&
        scrollOffsetPx == 0) {
      return;
    }

    BookWebViewScrollHelper.cancelPendingRestores();
    final current = await BookWebViewScrollHelper.readPosition(_controller);
    if (BookWebViewScrollHelper.shouldSkipRestore(
      saved,
      current,
      scrollOffsetPx: scrollOffsetPx,
      useScrollRatio: useScrollRatio,
    )) {
      return;
    }

    await BookWebViewScrollHelper.restorePosition(
      _controller,
      saved,
      isMounted: () => mounted,
      scrollOffsetPx: scrollOffsetPx,
      useScrollRatio: useScrollRatio,
      retryDelaysMs: applyBookTabCompensation
          ? const <int>[400, 900, 1500]
          : const <int>[350, 700, 1200],
    );
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

  LanguageAllPageFalundafa get _languageEnum {
    return LanguageAllPageFalundafa.values.firstWhere(
      (e) => e.languageCode == widget.languageCode,
      orElse: () => LanguageAllPageFalundafa.vietnamese,
    );
  }

  Future<void> _goToBooksHomePage() async {
    await _captureScrollForCurrentPage();

    final homeUrl = _languageEnum.booksPage;
    _currentUrl = homeUrl;
    _readingState = _readingState.withScroll(
      homeUrl,
      const BookScrollPosition(scrollY: 0, scrollRatio: 0),
    );

    if (mounted) setState(() => _appBarVisible = true);
    await _controller.loadRequest(Uri.parse(homeUrl));
    await _persistReadingState();
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
    // Không lưu cuộn ở dispose — tránh ghi đè (race) sau _closeAndReturn đã persist về tab Book.
    super.dispose();
  }

  Widget _buildCollapsibleToolbar(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: _appBarVisible ? 1 : 0,
      child: SizedBox(
        height: _toolbarHeight,
        child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => unawaited(_closeAndReturn()),
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Book',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      onPressed: () => unawaited(_goToBooksHomePage()),
                      icon: const Icon(Icons.menu_book, size: 20),
                      tooltip: 'Trang mục lục sách',
                      padding: const EdgeInsets.only(left: 2, right: 4),
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }

  /// Giống vùng phía trên tab main (SafeArea + status bar trong suốt → nền đen hệ thống).
  static const Color _statusBarBackground = Colors.black;

  static const SystemUiOverlayStyle _fullscreenOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          unawaited(_closeAndReturn());
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _fullscreenOverlayStyle,
        child: Scaffold(
          backgroundColor: Colors.white,
          // Status bar cố định (đen); nội dung WebView bắt đầu từ dưới status bar.
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                bottom: 0,
                child: progressLoadWeb <= 20
                    ? const Center(child: CircularProgressIndicator())
                    : WebViewWidget(controller: _controller),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ColoredBox(
                  color: _statusBarBackground,
                  child: SizedBox(height: topInset),
                ),
              ),
              Positioned(
                top: topInset,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: IgnorePointer(
                    ignoring: !_appBarVisible,
                    child: AnimatedSlide(
                      offset: _appBarVisible ? Offset.zero : const Offset(0, -1),
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      child: _buildCollapsibleToolbar(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
