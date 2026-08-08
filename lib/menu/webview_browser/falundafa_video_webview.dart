import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/app_language_sync.dart';
import '../../common/app_webview_config.dart';
import '../../common/book_reading_placement_dialog.dart';
import '../../common/browser_helper.dart';
import '../../common/compact_web_url_bar.dart';
import '../../common/language_menu_order.dart';
import '../../common/webview_immersive_mixin.dart';
import '../../controller_app/link_internet_sachchuyenphapluan_quocte.dart';

/// Loại trang falundafa.org mở trong trình duyệt in-app.
enum FalundafaVideoKind {
  /// Hướng dẫn tập (videoPage) — `#exercise-player`
  exerciseGuide,

  /// Video 9 bài giảng (video9Lession) — `#lecture-player` / `#g9day_video`
  nineLectures,

  /// Trang giới thiệu (introduction)
  introduction,

  /// Liên hệ lớp học địa phương (connect_to_classes)
  connectToClasses,
}

/// Trình duyệt in-app cho trang video falundafa; cuộn sẵn tới khối player.
class FalundafaVideoWebview extends StatefulWidget {
  static const String routeName = 'FalundafaVideoWebview_routeName';

  final FalundafaVideoKind kind;

  /// Hiện dialog đặt điện thoại (giống tab Book) khi mở trang.
  final bool showPlacementDialog;

  const FalundafaVideoWebview({
    super.key,
    this.kind = FalundafaVideoKind.exerciseGuide,
    this.showPlacementDialog = false,
  });

  @override
  State<FalundafaVideoWebview> createState() => _FalundafaVideoWebviewState();
}

class _FalundafaVideoWebviewState extends State<FalundafaVideoWebview>
    with SingleTickerProviderStateMixin, WebviewImmersiveMixin {
  late final WebViewController _controller;
  late LanguageAllPageFalundafa _language;
  final double _border10 = 10.0;
  int progressLoadWeb = 0;
  String? _currentUrl;
  bool _pendingScrollToVideo = false;
  bool _initialPageReady = false;
  bool _placementDialogShown = false;

  String get _pageUrl => switch (widget.kind) {
        FalundafaVideoKind.exerciseGuide => _language.videoPage,
        FalundafaVideoKind.nineLectures => _language.video9Lession,
        FalundafaVideoKind.introduction => _language.introduction,
        FalundafaVideoKind.connectToClasses => _language.connect_to_classes,
      };

  bool get _isVideoKind =>
      widget.kind == FalundafaVideoKind.exerciseGuide ||
      widget.kind == FalundafaVideoKind.nineLectures;

  /// Video Lesson / trang giới thiệu / liên hệ: không ẩn chrome khi scroll.
  @override
  bool get immersiveScrollHidesChrome =>
      widget.kind == FalundafaVideoKind.exerciseGuide;

  @override
  void initState() {
    super.initState();
    initImmersive();
    _language = LanguageAllPageFalundafa.vietnamese;

    final WebViewController controller = AppWebViewConfig.createController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (!mounted) return;
            setState(() => progressLoadWeb = progress);
          },
          onPageStarted: (String url) {
            onImmersivePageStarted();
          },
          onPageFinished: (String url) {
            _currentUrl = url;
            unawaited(_onPageFinished());
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) _currentUrl = change.url;
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            // Cho phép Ganjing / media embed; chỉ chặn điều hướng full-page YouTube
            // (không chặn iframe embed — thường không đi qua đây).
            if (!request.isMainFrame) {
              return NavigationDecision.navigate;
            }
            if (url.startsWith('https://www.youtube.com/') ||
                url.startsWith('https://m.youtube.com/') ||
                url.startsWith('https://youtu.be/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'ScrollReporter',
        onMessageReceived: (JavaScriptMessage message) {
          handleImmersiveScrollReport(message.message);
        },
      );

    _controller = controller;
    unawaited(_bootstrapWebView());
  }

  Future<void> _bootstrapWebView() async {
    await AppWebViewConfig.applyPlatformSettings(
      _controller,
      allowsBackForwardNavigationGestures: false,
      optimizeForEmbeddedVideo: true,
    );
    await _loadPreferredLanguageAndOpen();
    if (!mounted) return;
    // Hiện dialog sau frame đầu (giống tab Book); key riêng để không bị
    // "không hiện lại" của Book chặn Video Lesson.
    if (widget.showPlacementDialog && !_placementDialogShown) {
      _placementDialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await BookReadingPlacementDialog.showIfNeeded(
          context,
          languageCode: _language.languageCode,
          prefsKey: BookReadingPlacementDialog.prefsKeyVideoLesson,
        );
      });
    }
  }

  Future<void> _loadPreferredLanguageAndOpen() async {
    final preferred = await AppLanguageSync.preferredOrEnglish();
    final matched = AppLanguageSync.matchAllBooksLanguage(preferred);
    _language = matched ?? LanguageAllPageFalundafa.english;
    _pendingScrollToVideo = _isVideoKind;
    _currentUrl = _pageUrl;
    await _controller.loadRequest(Uri.parse(_pageUrl));
    if (mounted) setState(() {});
  }

  Future<void> _onPageFinished() async {
    await AppWebViewConfig.onPageFinishedEnhancements(
      _controller,
      nudgeLazyImages: true,
    );
    await _injectVideoPlaybackHelpers();
    await installImmersiveScrollReporter(_controller);
    await onImmersivePageFinished();
    if (_pendingScrollToVideo && _isVideoKind) {
      _pendingScrollToVideo = false;
      await Future<void>.delayed(const Duration(milliseconds: 350));
      await _scrollToVideoSection();
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await _scrollToVideoSection();
    } else {
      _pendingScrollToVideo = false;
    }
    if (mounted) {
      setState(() => _initialPageReady = true);
    }
  }

  /// CSS + iframe allow + quan sát iframe mới khi bấm Play (Ganjing embed).
  Future<void> _injectVideoPlaybackHelpers() async {
    if (!_isVideoKind) return;
    final chromeOffset = (immersiveChromeBarHeight + 12).round();
    try {
      await _controller.runJavaScript('''
        (function () {
          if (window.__fdafaVideoHelpersInstalled) return;
          window.__fdafaVideoHelpersInstalled = true;

          var style = document.createElement('style');
          style.textContent = `
            #exercise-player, #lecture-player, #g9day_video, #lecture-player-outer,
            .exercise-video-heading, .exercise-player {
              scroll-margin-top: ${chromeOffset}px !important;
            }
            #exercise-player iframe, #lecture-player iframe, .exercise-player iframe {
              width: 100% !important;
              min-height: 220px !important;
              max-height: 70vh !important;
              border: 0 !important;
            }
          `;
          document.head.appendChild(style);

          function enhanceIframe(iframe) {
            if (!iframe || iframe.nodeName !== 'IFRAME') return;
            iframe.setAttribute(
              'allow',
              'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; fullscreen'
            );
            iframe.setAttribute('allowfullscreen', 'true');
            iframe.setAttribute('playsinline', 'true');
            iframe.setAttribute('webkitallowfullscreen', 'true');
            try { iframe.style.width = '100%'; } catch (e) {}
          }

          document.querySelectorAll('iframe').forEach(enhanceIframe);
          var obs = new MutationObserver(function (mutations) {
            mutations.forEach(function (m) {
              m.addedNodes.forEach(function (node) {
                if (node.nodeName === 'IFRAME') enhanceIframe(node);
                if (node.querySelectorAll) {
                  node.querySelectorAll('iframe').forEach(enhanceIframe);
                }
              });
            });
          });
          obs.observe(document.documentElement, { childList: true, subtree: true });
        })();
      ''');
    } catch (e, st) {
      debugPrint('FalundafaVideoWebview helpers: $e\n$st');
    }
  }

  Future<void> _scrollToVideoSection() async {
    final chromeOffset = (immersiveChromeBarHeight + 8).round();
    final isNine = widget.kind == FalundafaVideoKind.nineLectures;
    try {
      await _controller.runJavaScript('''
        (function () {
          ${isNine ? '''
          var listEl =
            document.getElementById('g9day') ||
            document.getElementById('g9day_video') ||
            document.getElementById('lecture-player-outer');
          var playerEl =
            document.getElementById('lecture-player') ||
            document.getElementById('player-container-image') ||
            document.querySelector('h2');
          // Ưu tiên khối có nút Bài giảng 1…9; nếu chỉ còn player thì chừa khoảng trên.
          var el = listEl || playerEl;
          var extraGap = listEl ? 12 : 148;
          ''' : '''
          var el =
            document.getElementById('exercise-player') ||
            document.querySelector('.exercise-video-heading') ||
            document.querySelector('h2.exercise-video-heading') ||
            document.querySelector('video') ||
            document.querySelector('h2');
          var extraGap = 0;
          '''}
          if (!el) return;
          var rect = el.getBoundingClientRect();
          var y = rect.top + window.pageYOffset - $chromeOffset - extraGap;
          window.scrollTo({ top: Math.max(0, y), left: 0, behavior: 'auto' });
        })();
      ''');
    } catch (_) {
      // Trang không có neo video — bỏ qua.
    }
  }

  Future<void> _onLanguageChanged(LanguageAllPageFalundafa value) async {
    setState(() => _language = value);
    final shared = await SharedPreferences.getInstance();
    await shared.setString('LanguageAllPageFalundafa', value.name);
    await AppLanguageSync.onUserSelected(value.languageCode);
    _pendingScrollToVideo = _isVideoKind;
    _currentUrl = _pageUrl;
    await _controller.loadRequest(Uri.parse(_pageUrl));
  }

  @override
  void dispose() {
    disposeImmersive();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
          tooltip: 'Quay lại',
        ),
        PopupMenuButton<LanguageAllPageFalundafa>(
          tooltip: 'Chọn ngôn ngữ',
          position: PopupMenuPosition.under,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_border10),
          ),
          onSelected: (LanguageAllPageFalundafa value) {
            unawaited(_onLanguageChanged(value));
          },
          itemBuilder: (context) {
            final ordered = LanguageMenuOrder.sort(
              LanguageAllPageFalundafa.values,
              name: (e) => e.name,
              label: (e) => e.languageName,
            );
            return ordered
                .map(
                  (value) => PopupMenuItem<LanguageAllPageFalundafa>(
                    value: value,
                    height: 44,
                    child: Text(
                      value.languageName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Text(
                    _language.languageName,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
        const Spacer(),
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
        buildImmersiveToggleButton(),
      ],
    );
  }

  Widget _buildUrlBar() {
    return CompactWebUrlBar(
      controller: _controller,
      currentUrl: _currentUrl ?? _pageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Không tháo WebView khi progress tụt (iframe Ganjing đang tải) —
    // nếu không sẽ mất player / khó bấm Play.
    final showLoading = !_initialPageReady && progressLoadWeb <= 20;

    return buildImmersiveScaffold(
      toolbar: _buildToolbar(),
      urlBar: _buildUrlBar(),
      enableEdgeSwipeToPop: false,
      onPop: () => Navigator.pop(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          WebViewWidget(controller: _controller),
          if (showLoading)
            const ColoredBox(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
