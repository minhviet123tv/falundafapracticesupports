import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features. | #docregion platform_imports
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Import for iOS features.
import 'package:url_launcher/url_launcher.dart';

/*
webview_flutter: ^4.8.0
https://pub.dev/packages/webview_flutter/example
 */

// void main() => runApp(const MaterialApp(home: WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmph5i6al3ExcRdoWQUzS541l51c',)));

// Trang widget mở web view
class WebViewBrowser extends StatefulWidget {

  static const String routeName = "WebViewBrowser_routeName";
  final String linkUrl; // Đường dẫn internet của video
  final String title; // Tiêu đề của video
  final String textHuongDan;

  WebViewBrowser({required this.linkUrl, required this.title, required this.textHuongDan,  super.key});

  @override
  State<WebViewBrowser> createState() => _WebViewBrowserState();
}

class _WebViewBrowserState extends State<WebViewBrowser> {

  //A. Dữ liệu toàn cục
  late final WebViewController _controller; // Bộ điều khiển cho webview
  // static const String countKeyName = "countLogin"; // Tên key của đếm login trong shared
  late bool? hideSuggest = false; // Ẩn gợi ý
  static const String hideSuggestName = "hideSuggest";
  // Color? colorBg = Colors.green; // Màu nền (Đặt theo tình trạng nút gợi ý)
  late int? countLoginNumber = 10; // Đếm số lần login lưu, load trong shared
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  late int loadProgress = 0;

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();

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
            setState(() {
              loadProgress = progress;
            });
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

    //III. Lấy tình trạng nút gợi ý
    _getHideSussgest();
  }

  //B.1 Lấy số lần login hiện tại
  // Future<void> _getCountLogin() async {
  //   final shared = await SharedPreferences.getInstance(); // Tạo Shared
  //   int count = shared.getInt(countKeyName) ?? 0; // Lấy số đã lưu | Giá trị mặc định là 0
  //   countLoginNumber = count; // Gán cho biến toàn cục (nhanh nhất có thể để kịp load cho trang)
  //   setState(() { }); // Phải cập nhật lại (UI) theo biến toàn cục (vì khi mới mở chưa có giá trị)
  // }

  //B.2 Lấy tình trạng nút gợi ý
  Future<void> _getHideSussgest () async {
    final shared = await SharedPreferences.getInstance();
    hideSuggest = shared.getBool(hideSuggestName) ?? false;
    setState(() { });
  }

  //B.3 Cập nhật tình trạng nút gợi ý
  Future<void> _setHideSuggest () async {
    final shared = await SharedPreferences.getInstance();
    hideSuggest = !hideSuggest!;
    shared.setBool(hideSuggestName, hideSuggest ?? false); // Lưu tình trạng
    setState(() { });
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: hideSuggest == false ? Colors.green : Colors.black,
        appBar: AppBar(
          title: Text(widget.title, style: textSize18,),
          actions: [

            //Icon open web
            IconButton(
              onPressed: (){
                _launchInBrowser(Uri.parse(widget.linkUrl));
              },
              icon: Icon(Icons.zoom_out_map, size: 20),
            ),
          ],
        ),
      
        body: Column(
          children: [
            if (hideSuggest == false)
            Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: Text('Lưu ý: ${widget.textHuongDan}', style: textSize16, textAlign: TextAlign.center,)),
            ),
            Expanded(child: Stack(
              alignment: Alignment.center,
              children: [
                loadProgress <= 20 ? CircularProgressIndicator()
                : WebViewWidget(controller: _controller),
              ],
            )),
            rowBottom(),
          ],
        ),
      
      ),
    );
  }

  //D.1
  Widget rowBottom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        //1. Chữ hướng dẫn play video
        if (hideSuggest == false)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(" Chọn ", style: textSize16,),
                Icon(Icons.zoom_out_map,),
                Text(" để phóng to", style: textSize16,),
                SizedBox(width: 10,),
              ],
            ),
          ),

        //2. Button
        Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [

              if (hideSuggest == false)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (){
                        // final key = new GlobalKey<ScaffoldState>();
                        Clipboard.setData(ClipboardData(text: widget.linkUrl));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã sao chép link!"),));
                      },
                      child: Text("copy link video"),
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: (){
                      _setHideSuggest(); // Thay đổi tình trạng nút ẩn hiện và lưu shared
                    },
                    child: (){
                      if(hideSuggest == false){
                        return Text("Ẩn lưu ý");
                      }
                      if(hideSuggest == true){
                        return Text("Lưu ý");
                      }
                    }(),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  //D.2
  //D.1 Hàm mở link url khi click
    Future<void> _launchInBrowser(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.inAppWebView,)) {
        throw Exception('Could not launch $url');
      }
    }
}
