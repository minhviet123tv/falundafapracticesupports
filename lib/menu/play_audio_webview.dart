import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../common/browser_helper.dart';

// Trình duyệt gọn trong app: thanh địa chỉ, lùi/tiến/tải lại, mở URL âm thanh khi vào.
class WebViewBrowserAudio extends StatefulWidget {
  static const String routeName = 'WebViewBrowser_routeName';
  final String linkUrl;
  final String title;

  WebViewBrowserAudio({
    required this.linkUrl,
    required this.title,
    super.key,
  });

  @override
  State<WebViewBrowserAudio> createState() => _WebViewBrowserAudioState();
}

class _WebViewBrowserAudioState extends State<WebViewBrowserAudio> {
  late final WebViewController _controller;
  late final TextEditingController _addressController;
  final FocusNode _addressFocus = FocusNode();
  /// Cập nhật riêng thanh tải để không rebuild TextField địa chỉ mỗi tick → tránh giật con trỏ/chữ.
  final ValueNotifier<int> _loadProgressNotifier = ValueNotifier<int>(0);

  var textSize18 = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  bool _isWakelockActive = false;

  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _embedsOfflineFile = false;

  @override
  void initState() {
    super.initState();
    unawaited(_setWakelock(true));

    _addressController = TextEditingController(text: widget.linkUrl.trim());

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
            _loadProgressNotifier.value = progress.clamp(0, 100);
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
            if (_embedsOfflineFile) return;
            _applyAddressBarFromWeb(url);
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
            await _injectPlaybackTrackingScript();
            if (!mounted) return;
            if (_embedsOfflineFile) {
              _applyAddressBarFromWeb(widget.linkUrl.trim());
              _embedsOfflineFile = false;
            } else {
              _applyAddressBarFromWeb(url);
            }
            _loadProgressNotifier.value = 0;
            await _syncNavButtons();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('HTTP error: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            final u = change.url;
            if (u == null || u.isEmpty) return;
            if (_embedsOfflineFile) return;
            _applyAddressBarFromWeb(u);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..addJavaScriptChannel(
        'PlaybackState',
        onMessageReceived: (JavaScriptMessage message) {
          final state = message.message.toLowerCase();
          if (state == 'play') {
            unawaited(_setWakelock(true));
          } else if (state == 'pause' || state == 'ended') {
            unawaited(_setWakelock(false));
          }
        },
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
    unawaited(_applyChromeUserAgentAndLoad());
  }

  /// Google và nhiều site chặn / không render nếu dùng UA kiểu WebView; load sau khi gán UA.
  Future<void> _applyChromeUserAgentAndLoad() async {
    try {
      await _controller.setUserAgent(BrowserHelper.webViewChromeUserAgent);
    } catch (e) {
      debugPrint('setUserAgent: $e');
    }
    if (!mounted) return;
    await _loadInitialContent();
  }

  /// Không ghi đè ô địa chỉ khi người dùng đang gõ/chọn chữ — tránh nhảy layout và “giãn” chữ.
  void _applyAddressBarFromWeb(String url) {
    if (!mounted || url.isEmpty) return;
    if (_addressFocus.hasFocus) return;
    setState(() {
      _addressController.text = url;
    });
  }

  @override
  void dispose() {
    _loadProgressNotifier.dispose();
    _addressController.dispose();
    _addressFocus.dispose();
    unawaited(_pauseAllMedia());
    unawaited(_setWakelock(false));
    super.dispose();
  }

  Future<void> _setWakelock(bool enabled) async {
    if (_isWakelockActive == enabled) return;
    _isWakelockActive = enabled;
    if (enabled) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }

  Future<void> _syncNavButtons() async {
    final back = await _controller.canGoBack();
    final forward = await _controller.canGoForward();
    if (!mounted) return;
    setState(() {
      _canGoBack = back;
      _canGoForward = forward;
    });
  }

  Future<void> _injectPlaybackTrackingScript() async {
    await _controller.runJavaScript('''
      (() => {
        if (window.__fdPlaybackTrackingInstalled) return;
        window.__fdPlaybackTrackingInstalled = true;

        const send = (value) => {
          if (window.PlaybackState && window.PlaybackState.postMessage) {
            window.PlaybackState.postMessage(value);
          }
        };

        const bindMedia = (media) => {
          if (!media || media.__fdPlaybackBound) return;
          media.__fdPlaybackBound = true;
          media.addEventListener('play', () => send('play'));
          media.addEventListener('playing', () => send('play'));
          media.addEventListener('pause', () => send('pause'));
          media.addEventListener('ended', () => send('ended'));
        };

        const bindAll = () => {
          document.querySelectorAll('audio, video').forEach(bindMedia);
        };

        bindAll();
        const observer = new MutationObserver(() => bindAll());
        observer.observe(document.documentElement, { childList: true, subtree: true });
      })();
    ''');
  }

  Future<void> _loadInitialContent() async {
    final link = widget.linkUrl.trim();
    final uri = Uri.tryParse(link);
    final isLocalFile = uri != null && uri.scheme == 'file';

    if (isLocalFile) {
      _embedsOfflineFile = true;
      final html = '''
      <!doctype html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
          <style>
            body {
              margin: 0;
              padding: 16px;
              background: #111;
              color: #fff;
              font-family: Arial, sans-serif;
            }
            audio {
              width: 100%;
              margin-top: 12px;
            }
          </style>
        </head>
        <body>
          <div>Offline audio</div>
          <audio controls autoplay>
            <source src="$link" type="audio/mpeg">
            Trình phát không hỗ trợ file audio này.
          </audio>
        </body>
      </html>
      ''';
      await _controller.loadHtmlString(html);
      return;
    }

    await _controller.loadRequest(Uri.parse(link));
  }

  Future<void> _navigateToTypedAddress() async {
    FocusScope.of(context).unfocus();
    final uri = BrowserHelper.resolveNavigationUri(_addressController.text);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Địa chỉ không hợp lệ')),
      );
      return;
    }
    _embedsOfflineFile = false;
    await _controller.loadRequest(uri);
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      await _syncNavAfterMove();
    }
  }

  Future<void> _goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
      await _syncNavAfterMove();
    }
  }

  Future<void> _syncNavAfterMove() async {
    final url = await _controller.currentUrl();
    if (!mounted) return;
    if (!_addressFocus.hasFocus &&
        url != null &&
        url.isNotEmpty) {
      setState(() {
        _addressController.text = url;
      });
    }
    await _syncNavButtons();
  }

  Future<void> _openExternalBrowser() async {
    final uri = BrowserHelper.resolveNavigationUri(_addressController.text) ??
        Uri.tryParse(_addressController.text.trim());
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không mở được: địa chỉ không hợp lệ')),
      );
      return;
    }
    await BrowserHelper.launchExternal(uri);
  }

  Future<void> _pauseAllMedia() async {
    try {
      await _controller.runJavaScript('''
        (() => {
          document.querySelectorAll('audio, video').forEach((media) => {
            if (!media.paused) {
              media.pause();
            }
          });
        })();
      ''');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(widget.title, style: textSize18),
          actions: [
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Mở trình duyệt ngoài',
              onPressed: _openExternalBrowser,
            ),
          ],
        ),
        body: Column(
          children: [
            Material(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Quay lại',
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: _canGoBack ? _goBack : null,
                    ),
                    IconButton(
                      tooltip: 'Tiến',
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: _canGoForward ? _goForward : null,
                    ),
                    IconButton(
                      tooltip: 'Tải lại',
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _controller.reload(),
                    ),
                    Expanded(
                      child: ListenableBuilder(
                        listenable: Listenable.merge([
                          _addressController,
                          _addressFocus,
                        ]),
                        builder: (context, _) {
                          final showClear = _addressFocus.hasFocus &&
                              _addressController.text.isNotEmpty;
                          return TextField(
                            controller: _addressController,
                            focusNode: _addressFocus,
                            autocorrect: false,
                            enableSuggestions: false,
                            smartDashesType: SmartDashesType.disabled,
                            smartQuotesType: SmartQuotesType.disabled,
                            spellCheckConfiguration:
                                const SpellCheckConfiguration.disabled(),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText:
                                  'https://... hoặc tên trang / từ khóa',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surface,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              suffixIcon: showClear
                                  ? IconButton(
                                      tooltip: 'Xóa URL',
                                      icon: const Icon(Icons.clear, size: 20),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      onPressed: () {
                                        _addressController.clear();
                                      },
                                    )
                                  : null,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              letterSpacing: 0,
                              height: 1.25,
                            ),
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.go,
                            onSubmitted: (_) =>
                                _navigateToTypedAddress(),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Đi tới',
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _navigateToTypedAddress,
                    ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _loadProgressNotifier,
              builder: (context, progress, _) {
                if (progress <= 0 || progress >= 100) {
                  return const SizedBox.shrink();
                }
                return LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 2,
                );
              },
            ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
