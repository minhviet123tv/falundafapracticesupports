import 'package:flutter/material.dart';

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
  late final TextEditingController _urlController;
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();
    // Keep screen awake while this audio webview is open.
    WakelockPlus.enable();
    _urlController = TextEditingController(text: widget.linkUrl);

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
            final currentUrl = change.url;
            if (currentUrl != null && currentUrl.isNotEmpty) {
              _urlController.text = currentUrl;
            }
            debugPrint('url change to $currentUrl');
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

      // Trang web đầu tiên khi mới mở trang
      ..loadRequest(Uri.parse('${widget.linkUrl}')); // https://www.ganjingworld.com/embed/1fdmph5i6al3ExcRdoWQUzS541l51c

    // Cài đặt cho thiết bị | #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    //II. Khai báo chính thức cho controller toàn cục
    _controller = controller;
  }

  @override
  void dispose() {
    _urlController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _loadFromAddressBar() async {
    final input = _urlController.text.trim();
    if (input.isEmpty) return;
    final uri = Uri.tryParse(input);
    if (uri == null || !(uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Link không hợp lệ. Vui lòng dùng http/https.')),
      );
      return;
    }
    await _controller.loadRequest(uri);
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          title: Text(widget.title, style: textSize18,),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: TextField(
                controller: _urlController,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.go,
                onSubmitted: (_) => _loadFromAddressBar(),
                decoration: InputDecoration(
                  hintText: 'Nhập link audio...',
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: 'Mở link',
                    onPressed: _loadFromAddressBar,
                  ),
                ),
              ),
            ),
          ),
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
