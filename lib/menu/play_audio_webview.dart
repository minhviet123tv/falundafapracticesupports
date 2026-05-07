import 'package:flutter/material.dart';
import 'dart:async';

import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features. | #docregion platform_imports
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Import for iOS features.
import '../common/browser_helper.dart';

/*
webview_flutter: ^4.8.0
https://pub.dev/packages/webview_flutter/example
 */

// void main() => runApp(const MaterialApp(home: WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmph5i6al3ExcRdoWQUzS541l51c',)));

// Trang widget mở web view
class WebViewBrowserAudio extends StatefulWidget {

  static const String routeName = "WebViewBrowser_routeName";
  final String linkUrl; // Đường dẫn internet của video
  final String title; // Tiêu đề của video

  WebViewBrowserAudio({required this.linkUrl, required this.title,super.key});

  @override
  State<WebViewBrowserAudio> createState() => _WebViewBrowserAudioState();
}

class _WebViewBrowserAudioState extends State<WebViewBrowserAudio> {

  //A. Dữ liệu toàn cục
  late final WebViewController _controller; // Bộ điều khiển cho webview
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  bool _isWakelockActive = false;

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();
    // Keep screen awake while this audio webview is open.
    unawaited(_setWakelock(true));

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    //I. Tạo một controller của webview
    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    // Cài đặt các thuộc tính, thông số cần có để mở được web cho controller
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
            unawaited(_injectPlaybackTrackingScript());
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
          Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
                    ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },

          // Hàm Future openDialog | Có thể là dùng đối với trang web cần login
          // onHttpAuthRequest: (HttpAuthRequest request) {
          //   openDialog(request);
          // },
        ),
      )

      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
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

    // Cài đặt cho thiết bị | #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    //II. Khai báo chính thức cho controller toàn cục
    _controller = controller;
    _loadInitialContent();
  }

  @override
  void dispose() {
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
    } catch (_) {
      // Ignore errors while page is tearing down.
    }
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text(widget.title, style: textSize18,),
          actions: [
            //IV. Icon open web (out app)
            FutureBuilder<String?>(
              future: BrowserHelper.getCurrentUrl(_controller),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                if(snapshot.hasData){
                  return IconButton(
                    onPressed: (){
                      BrowserHelper.launchExternal(Uri.parse(snapshot.data!));
                    },
                    icon: Icon(Icons.open_in_new, size: 20,),
                  );
                } else {
                  return SizedBox();
                }
              },),
          ],
        ),
      
        body: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(),
            WebViewWidget(controller: _controller),
          ],
        ),
      
      ),
    );
  }
}
