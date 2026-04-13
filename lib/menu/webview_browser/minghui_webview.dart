import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features. | #docregion platform_imports
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../controller_app/link_all_page_and_api_enum.dart';
import '../../common/browser_helper.dart';

/*
webview_flutter: ^4.8.0
https://pub.dev/packages/webview_flutter/example
 */

// Trang widget mở web view
class MinghuiWebview extends StatefulWidget {

  static const String routeName = "VisaoconhanloaiWebview_routeName";

  @override
  State<MinghuiWebview> createState() => _MinghuiWebviewState();
}

class _MinghuiWebviewState extends State<MinghuiWebview> {

  //A. Dữ liệu toàn cục
  late final WebViewController _controller; // Bộ điều khiển cho webview
  late MinghuiEnum minghuiEnum;
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  var styleTextTitle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
  double border10 = 10.0;
  int progressLoadWeb = 0; // Báo tiến độ load web

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();

    // Khởi tạo ban đầu theo ngôn ngữ đầu tiên của list (Tránh lag khi chưa hiện được)
    // visaoconhanloaiEnum = VisaoconhanloaiEnum.values[0];
    minghuiEnum = MinghuiEnum.vietnamese;

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
              progressLoadWeb = progress;
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

      // Load URL trang web đầu tiên khi mới mở trang
      ..loadRequest(Uri.parse('${minghuiEnum.url}'));

    // Cài đặt cho thiết bị | #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    //II. Khai báo chính thức cho controller toàn cục
    _controller = controller;

    //III. Lấy ngôn ngữ lưu shared | Cập nhật load url theo ngôn ngữ đã lưu
    _getLanguageLink(); // Lấy ngôn ngữ lưu shared | Cập nhật load url theo ngôn ngữ đã lưu
  }

  //B.1 Lấy code ngôn ngữ lưu shared (modelOpenUrlFavorite)
  _getLanguageLink() async {
    final shared = await SharedPreferences.getInstance(); // shared
    String languageCode = await shared.getString("languageCodeMinghui") ?? "vietnamese"; // Lấy code
    minghuiEnum = MinghuiEnum.values.byName(languageCode); // Lấy enum từ code
    _controller.loadRequest(Uri.parse('${minghuiEnum.url}')); // Tải lại trang theo ngôn ngữ
    setState(() {}); // Cập nhật ngôn ngữ
  }

  //B.2 Hàm lưu ngôn ngữ trong Shared
  _saveLanguageLink (String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("languageCodeMinghui", languageCode);
  }

  // kiểm tra thuộc tính boolean mounted của lớp trạng thái setState((){})
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, size: 20),
          ),
          title: PopupMenuButton<MinghuiEnum>(
            tooltip: 'Select language',
            position: PopupMenuPosition.under,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)),
            onSelected: (MinghuiEnum value) {
              setState(() {
                minghuiEnum = value;
                _controller.loadRequest(Uri.parse(minghuiEnum.url));
                _saveLanguageLink(minghuiEnum.languageCode);
              });
            },
            itemBuilder: (context) {
              return MinghuiEnum.values
                  .map(
                    (value) => PopupMenuItem<MinghuiEnum>(
                      value: value,
                      height: 44,
                      child: Text(value.languageName),
                    ),
                  )
                  .toList();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(border10)),
                border: Border.all(color: Colors.white70),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    minghuiEnum.languageName,
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, size: 18),
                ],
              ),
            ),
          ),

          toolbarHeight: 40, // Gọn tối đa nhưng vẫn đủ khoảng đệm thao tác

          actions: [

            //I. Nút back lại phần trước của web
            IconButton(
              onPressed: () async {
                if(await _controller.canGoBack()){
                  _controller.goBack();
                }
              },
              icon: Icon(Icons.arrow_circle_left_outlined, size: 20,),
            ),

            //II. Nút back lại phần trước của web
            IconButton(
              onPressed: () async {
                if(await _controller.canGoForward()){
                  _controller.goForward();
                }
              },
              icon: Icon(Icons.arrow_circle_right_outlined, size: 20,),
            ),

            //III. Icon open web (out app)
            // FutureBuilder<dynamic>(
            //   future: _getCurrentURL(),
            //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //     if(snapshot.hasData){
            //       return IconButton(
            //         onPressed: (){
            //           _launchBrowserOutApp(Uri.parse(snapshot.data.toString()));
            //         },
            //         icon: Icon(Icons.open_in_new, size: 20,),
            //       );
            //     } else {
            //       return SizedBox();
            //     }
            //   },),

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

          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,

        body: Stack(
          children: [
            (progressLoadWeb <= 20)  /* Hiện icon loading, WebViewWidget theo tình trạng kết nối của url */
            ? Center(child: CircularProgressIndicator(),)
            :  WebViewWidget(controller: _controller),
          ],
        ),
        // floatingActionButton: ElevatedButton(onPressed: () {  }, child: Text("Language"),),
      ),
    );
  }
}
