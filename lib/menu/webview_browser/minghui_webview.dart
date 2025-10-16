import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features. | #docregion platform_imports
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:url_launcher/url_launcher.dart';

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

    // Khởi tạo ban đầu theo ngôn ngữ đầu tiên của list
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
          title: Container(
            margin: EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(border10)), // Bo viền container
              color: Colors.transparent,
            ),

            // DropdownMenu
            child: DropdownMenu<MinghuiEnum>(
              width: 140,
              initialSelection: minghuiEnum, // Mới mở thì đặt theo ngôn ngữ đã khởi tạo trong init hoặc đã lấy từ shared (dùng enum thay vì model)
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
              onSelected: (MinghuiEnum? value) {
                setState(() {
                  minghuiEnum = value!; // Cập nhật ngôn ngữ
                  _controller.loadRequest(Uri.parse('${minghuiEnum.url}')); // Đặt và load lại url
                  _saveLanguageLink(minghuiEnum.languageCode); // Lưu code ngôn ngữ vào trong shared (Không lưu cả enum mà chỉ mình ngôn ngữ rồi tìm lại enum theo listEnum.values.byName('');
                });
              },

              // Gán giá trị trong list cho trước vào list lựa chọn của button
              dropdownMenuEntries: MinghuiEnum.values.map((MinghuiEnum value){
                return DropdownMenuEntry<MinghuiEnum>(
                  value: value, // Giá trị cả model
                  label: value.languageName, // Nhãn hiển thị
                  style: MenuItemButton.styleFrom(
                    foregroundColor: Colors.black, // Màu text
                    backgroundColor: Colors.white, // Màu nền,
                    textStyle: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),

          toolbarHeight: 35, // Chiều cao của AppBar

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
            FutureBuilder<dynamic>(
              future: _getCurrentURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return IconButton(
                    onPressed: (){
                      _launchBrowserInApp(Uri.parse(snapshot.data.toString()));
                    },
                    icon: Icon(Icons.zoom_out_map, size: 20,),
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

  //D.1 Hàm mở link url khi click (In app)
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

//II. Các danh sách liên kết
enum MinghuiEnum {
  english("https://en.minghui.org/", "English", "english"),
  chinese1("https://big5.minghui.org/", "正體中文", "chinese1"), // phồn thể
  chinese2("https://www.minghui.org/", "简体中文", 'chinese2'), // giản thể
  arabic("https://ar.minghui.org/", "العربية", "arabic"),
  bosanski("https://bs.minghui.org/", "Bosanski", "bosanski"),
  cesky("https://cs.minghui.org/", "Česky", 'cesky'),
  deutsch("https://de.minghui.org/", "Deutsch", "deutsch"),
  espanol("https://es.minghui.org/", "Español", 'espanol'),
  farsi("https://fa.minghui.org/", "فارسی", 'farsi'),
  francais("https://fr.minghui.org/", "Francais", 'francais'),
  hebrew("https://he.minghui.org/", "עברית", 'hebrew'),
  hrvatski("https://hr.minghui.org/", "Hrvatski", 'hrvatski'),
  indonesia("https://id.minghui.org/", "Indonesian", 'indonesia'),
  italiano("https://it.minghui.org/", "Italiano", 'italiano'),
  japan("https://jp.minghui.org/", "日本語", 'japan'),
  korean("https://www.minghui.or.kr/", "한국어", 'korean'),
  polski("https://pl.minghui.org/", "Polski", 'polski'),
  portugues("https://pt.minghui.org/", "Português", 'portugues'),
  russian("https://ru.minghui.org/", "Русский", 'russian'),
  slovencina("https://sk.minghui.org/", "Slovenčina", 'slovencina'),
  srpski("https://sr.minghui.org/", "Српски", 'srpski'),
  thai("https://th.minghui.org/", "ไทย", 'thai'),
  vietnamese("https://daiphap.org/access?url=https%3A%2F%2Fvn.minghui.org%2Fnews", "Tiếng Việt", 'vietnamese'), // https://vn.minghui.org/news
  turkce("https://tr.minghui.org/", "Türkçe", 'turkce'),
  ukrainian("https://uk.minghui.org/", "Українська", 'ukrainian')
  ;

  final String url;
  final String languageName;
  final String languageCode;
  const MinghuiEnum (this.url, this.languageName, this.languageCode);
}
