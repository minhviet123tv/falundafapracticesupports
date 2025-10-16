import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features. | #docregion platform_imports
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../link_internet_sachchuyenphapluan_quocte.dart'; // Import for iOS features.

/*
webview_flutter: ^4.8.0
https://pub.dev/packages/webview_flutter/example
 */

// Trang widget mở web view
class AllBooksWebview extends StatefulWidget {
  static const String routeName = "AllBooksWebview_routeName";
  @override
  State<AllBooksWebview> createState() => _AllBooksWebviewState();
}

class _AllBooksWebviewState extends State<AllBooksWebview> {

  //A. Dữ liệu toàn cục
  late final WebViewController _controller; // Bộ điều khiển cho webview
  // late LanguageAllPageFalundafa languageAllPageFalundafa;
  late LanguageAllPageFalundafa languageAllPageFalundafa;
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  var styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);
  double border10 = 10.0;
  int progressLoadWeb = 0; // Báo tiến độ load web

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();

    // languageAllPageFalundafa = LanguageAllPageFalundafa.vietnamese;
    languageAllPageFalundafa = LanguageAllPageFalundafa.vietnamese; // Khởi tạo ban đầu

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
      ..loadRequest(Uri.parse('${languageAllPageFalundafa.booksPage}'));

    // Cài đặt cho thiết bị | #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    //II. Khai báo chính thức cho controller toàn cục
    _controller = controller;
    _getLanguageEnumBook(); // Lấy ngôn ngữ lưu shared | Cập nhật load url theo enum ngôn ngữ đã lưu

  }

  //B.1 Lấy ngôn ngữ lưu shared
  Future<void> _getLanguageEnumBook() async {
    final shared = await SharedPreferences.getInstance();
    String languageEnumBook = await shared.getString("LanguageAllPageFalundafa") ?? "vietnamese";
    languageAllPageFalundafa = LanguageAllPageFalundafa.values.byName(languageEnumBook); // Đổi String đã lưu shared sang enum bởi list enum
    _controller.loadRequest(Uri.parse('${languageAllPageFalundafa.booksPage}')); // Load lại trang cho webview
    setState((){}); // Cập nhật ngôn ngữ
  }

  //B.2 Hàm lưu ngôn ngữ trong Shared
  Future<void> _setLanguageEnumBook(LanguageAllPageFalundafa languageName) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("LanguageAllPageFalundafa", languageName.name); // Lưu tên đơn (Không phải giá trị bên trong hay tengoc)
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

          //I. Chọn ngôn ngữ
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(border10)), // Bo viền container
              color: Colors.transparent,
            ),
            // DropdownMenu
            child: DropdownMenu<LanguageAllPageFalundafa>(
              width: 130,
              initialSelection: languageAllPageFalundafa, // Mới mở thì đặt theo ngôn ngữ đã khởi tạo trong init hoặc đã lấy từ shared
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11), // Kiểu dáng, màu, cỡ chữ hiển thị của giá trị đã được chọn
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(border10),
                ),
                enabledBorder: OutlineInputBorder( // Viền ngoài của cả DropdownMenu
                  borderRadius: BorderRadius.circular(border10),
                  borderSide: BorderSide(color: Colors.transparent), // Màu viền ngoài
                ),
              ),

              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white), // Màu nền của item được chọn
                surfaceTintColor: WidgetStatePropertyAll(Colors.white), // màu ánh nền
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)), // Góc bo viền của viền bên ngoài
                ),
              ),

              // Thực hiện khi bấm chọn (Sử dụng giá trị của đối tượng)
              onSelected: (LanguageAllPageFalundafa? value) {
                setState(() {
                  languageAllPageFalundafa = value!; // Cập nhật enum ngôn ngữ
                  _controller.loadRequest(Uri.parse('${languageAllPageFalundafa.booksPage}')); // Đặt và load lại url
                  // if(languageNameOfChuyenPhapLuan == LanguageNameOfChuyenPhapLuan.more){
                  //   _launchInBrowser(Uri.parse(languageNameOfChuyenPhapLuan.urlChuyenPhapLuan)); // Mở trình duyệt và return code (Trường hợp xem thêm ngôn ngữ phải mở xem ở browser)
                  //   return;
                  // }
                  _setLanguageEnumBook(languageAllPageFalundafa); // Lưu ngôn ngữ vào trong shared
                });
              },

              // Gán giá trị trong list cho trước vào list lựa chọn của button
              dropdownMenuEntries: LanguageAllPageFalundafa.values.map((LanguageAllPageFalundafa value) {
                return DropdownMenuEntry<LanguageAllPageFalundafa>(
                  value: value,
                  label: value.languageName,
                  style: MenuItemButton.styleFrom(
                    foregroundColor: Colors.black, //text color
                    backgroundColor: Colors.white, //unselected background color,
                    textStyle: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),

          toolbarHeight: 35, // Chiều cao của AppBar

          //II. Các icon điều khiển
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
              icon: Icon(Icons.arrow_circle_right_outlined, size: 20),
            ),

            //III. Icon open web (out app)
            FutureBuilder<dynamic>(
              future: _getCurrentURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return IconButton(
                    onPressed: (){
                      _launchBrowserOutApp(Uri.parse(snapshot.data.toString()));
                    },
                    icon: Icon(Icons.picture_as_pdf_rounded, size: 20,),
                  );
                } else {
                  return SizedBox();
                }
              },),

            //IV. Icon open web (out app)
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

            //V. Icon open web (In App)
            FutureBuilder<dynamic>(
              future: _getCurrentURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return IconButton(
                    onPressed: (){
                      setState((){});
                      _launchBrowserInApp(Uri.parse(snapshot.data.toString()));
                    },
                    icon: Icon(Icons.zoom_out_map, size: 20,),
                  );
                } else {
                  return SizedBox();
                }
              },),

          ],

          backgroundColor: Colors.white, // background của AppBar
        ),
        backgroundColor: Colors.white, // background của trang

        body: (progressLoadWeb <= 20)  /* Hiện icon loading, WebViewWidget theo tình trạng kết nối của url (Luân phiên) */
            ? Center(child: CircularProgressIndicator(),)
            :  WebViewWidget(controller: _controller),
      ),
    );
  }

  //D.1 Hàm mở link url trình duyệt in app khi click (tương đương zoom không gian)
  Future<void> _launchBrowserInApp(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView,)) {
      throw Exception('Could not launch $url');
    }
  }

  //D.2 Hàm mở link url trình duyệt bên ngoài app khi click
  Future<void> _launchBrowserOutApp(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $url');
    }
  }

  //D.3 Lấy url hiện tại của trình duyệt
  Future<dynamic> _getCurrentURL() async {
    dynamic currentURL = await _controller.currentUrl();
    return currentURL;
  }
  
}
