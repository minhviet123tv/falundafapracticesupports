import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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
class VisaoconhanloaiWebview extends StatefulWidget {

  static const String routeName = "VisaoconhanloaiWebview_routeName";

  @override
  State<VisaoconhanloaiWebview> createState() => _VisaoconhanloaiWebviewState();
}

class _VisaoconhanloaiWebviewState extends State<VisaoconhanloaiWebview> {

  //A. Dữ liệu toàn cục
  late final WebViewController _controller; // Bộ điều khiển cho webview
  late VisaoconhanloaiEnum visaoconhanloaiEnum;
  var textSize16 = TextStyle(fontSize: 16);
  var textSize18 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  var styleTextTitle = TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
  double border10 = 10.0;
  // late double positionWeb1 = 0.0; // Phản hồi scroll từ web
  // late double positionWeb2 = 0.0; // Phản hồi scroll từ web
  // bool scrollDown = false;
  int progressLoadWeb = 0;

  //B. Khởi tạo khi mới mở
  @override
  void initState() {
    super.initState();

    // Khởi tạo ban đầu
    // visaoconhanloaiEnum = VisaoconhanloaiEnum.values[0];
    visaoconhanloaiEnum = VisaoconhanloaiEnum.vietnamese;

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

      // Scrip 1 nhận toạ độ scroll
      // ..addJavaScriptChannel('ARTICLE_SCROLL_CHANNEL', onMessageReceived: (progress) { // Logic thực hiện mỗi khi có thay đổi progress (tự cập nhật trạng thái)

          // setState(() {
          //   positionWeb1 = positionWeb2; // Cập nhật cho vị trí 1
          //   print(progress.message);
            // print('positionWeb1 $positionWeb1');
            // print('positionWeb2 $positionWeb2');
            // positionWeb2 = double.parse(progress.message.toString());
            //
            // if(positionWeb2 - positionWeb1 >= 10){
            //   setState((){scrollDown = true;});
            // }
            // if(positionWeb2 - positionWeb1 <= -20){
            //   setState((){scrollDown = false;});
            // }
            // if(positionWeb1 == 0 || positionWeb2 == 0){
            //   setState((){scrollDown = false;});
            // }
          // });
        // },
      // )

      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              progressLoadWeb = progress;
            });
            debugPrint('WebView is loading (progress : $progress %)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');

            // Scrip 2 nhận toạ độ scroll
            // controller.runJavaScript(
            //   //( progress = this.scrollY / ( document.body.scrollHeight - window.innerHeight ) ) * 100
            //   '''
            //   window.addEventListener('scroll', function() {
            //     progress = this.scrollY;
            //     window.ARTICLE_SCROLL_CHANNEL.postMessage(progress);
            //   });
            //   ''',
            // );
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint(
            '''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            '''
            );
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
      ..loadRequest(Uri.parse('${visaoconhanloaiEnum.url}'));

    // Cài đặt cho thiết bị | #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    //II. Khai báo chính thức cho controller toàn cục
    _controller = controller;

    _getLanguageLink(); // Lấy ngôn ngữ lưu shared | Cập nhật load url theo ngôn ngữ đã lưu
    // _connectLinkSource(visaoconhanloaiEnum.url); // Cập nhật tình trạng kết nối của url
  }

  //B.1 Lấy code ngôn ngữ lưu shared (modelOpenUrlFavorite)
  _getLanguageLink() async {
    final shared = await SharedPreferences.getInstance(); // shared
    String languageCode = await shared.getString("languageCodeVisaoconhanloai") ?? "vietnamese"; // Lấy code
    visaoconhanloaiEnum = VisaoconhanloaiEnum.values.byName(languageCode); // Lấy enum từ code
    _controller.loadRequest(Uri.parse('${visaoconhanloaiEnum.url}')); // Tải lại trang theo ngôn ngữ
    setState(() {}); // Cập nhật ngôn ngữ
  }

  //B.2 Hàm lưu ngôn ngữ trong Shared
  _saveLanguageLink (String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("languageCodeVisaoconhanloai", languageCode);
  }

  //B.3 Hàm xác định tình trạng kết nối của url theo kiểu http.get
  // Future<void> _connectLinkSource (String url) async {
  //   final response = await http.get(Uri.parse(url)); // http
  //   if (response.statusCode == 200) {
  //     hideLoading = true; // Trả tín hiệu kết nối được
  //   } else {
  //     hideLoading = false; // Tín hiệu không kết nối được
  //   }
  //   setState((){}); // Cập nhật cho bool tình trạng kết nối url
  // }

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
            child: DropdownMenu<VisaoconhanloaiEnum>(
              width: 130,
              initialSelection: visaoconhanloaiEnum, // Mới mở thì đặt theo ngôn ngữ đã khởi tạo trong init hoặc đã lấy từ shared (Nên dùng enum thay vì model)
              textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11), // Kiểu dáng, màu, cỡ chữ hiển thị của giá trị đã được chọn
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(border10), // Bo góc viền
                ),
                enabledBorder: OutlineInputBorder( // Viền ngoài của cả DropdownMenu
                  borderRadius: BorderRadius.circular(border10),
                  borderSide: BorderSide(color: Colors.transparent), // Màu viền ngoài
                ),
              ),

              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white), // Màu nền của item được chọn
                surfaceTintColor: WidgetStatePropertyAll(Colors.white), // màu ánh nền của item được chọn
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)), // Góc bo viền của viền bên ngoài
                ),
              ),

              // Thực hiện khi bấm chọn (Sử dụng giá trị của đối tượng)
              onSelected: (VisaoconhanloaiEnum? value) {
                setState(() {
                  visaoconhanloaiEnum = value!; // Cập nhật ngôn ngữ
                  _controller.loadRequest(Uri.parse('${visaoconhanloaiEnum.url}')); // Đặt và load lại url
                  _saveLanguageLink(visaoconhanloaiEnum.languageCode); // Lưu code ngôn ngữ vào trong shared (Không lưu cả enum mà chỉ mình ngôn ngữ rồi tìm lại enum theo listEnum.values.byName('');
                  // hideLoading = false; // Đặt lại tình trạng load url
                  // _connectLinkSource(visaoconhanloaiEnum.url); // Cập nhật tình trạng kết nối
                });
              },

              // Gán giá trị trong list cho trước vào list lựa chọn của button
              dropdownMenuEntries: VisaoconhanloaiEnum.values.map((VisaoconhanloaiEnum value){
                return DropdownMenuEntry<VisaoconhanloaiEnum>(
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

            //IV. Icon open web (out app)
            FutureBuilder<dynamic>(
              future: _getCurrentURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.hasData){
                  return IconButton(
                    onPressed: (){
                      _launchBrowserOutApp(Uri.parse(snapshot.data.toString()));
                    },
                    icon: Icon(Icons.open_in_new, size: 20,),
                  );
                } else {
                  return SizedBox();
                }
              },),

            //Icon open web
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
          backgroundColor: Colors.white,
        ),

        backgroundColor: Colors.white,

        body: (progressLoadWeb <= 20)  /* Hiện icon loading, WebViewWidget theo tình trạng kết nối của url (Luân phiên) */
          ? Center(child: Center(child: CircularProgressIndicator()),)
          : WebViewWidget(controller: _controller,),
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

//II. Danh sách liên kết ngôn ngữ bài viết "Vì sao có nhân loại" (Không trùng số lượng ngôn ngữ với trang minghui.org)
enum VisaoconhanloaiEnum {
  english("https://en.minghui.org/html/articles/2023/1/21/206697.html", "English", "english"),
  chinese1("https://big5.minghui.org/mh/articles/2023/1/20/%E7%82%BA%E7%94%9A%E9%BA%BC%E6%9C%83%E6%9C%89%E4%BA%BA%E9%A1%9E-455562.html", "正體中文", "chinese1"), // giản thể
  chinese2("https://www.minghui.org/mh/articles/2023/1/20/%E4%B8%BA%E4%BB%80%E4%B9%88%E4%BC%9A%E6%9C%89%E4%BA%BA%E7%B1%BB-455562.html", "中文简体", "chinese2"), // phồn thể
  bosanski("https://bs.minghui.org/articles/6858", "Bosanski", "bosanski"),
  deutsch("https://de.minghui.org/html/articles/2023/1/23/165840.html", "Deutsch", "deutsch"),
  espanol("https://es.minghui.org/html/articles/2023/1/21/126075.html", "Español", 'espanol'),
  farsi("https://fa.minghui.org/html/articles/2023/1/21/133405.html", "فارسی", 'farsi'),
  francais("https://fr.minghui.org/html/articles/2023/1/21/103887.html", "Français", 'francais'),
  hebrew("https://he.minghui.org/html/articles/2023/1/23/41878.html", "עברית", 'hebrew'),
  hrvatski("https://hr.minghui.org/articles/6858", "Hrvatski", 'hrvatski'),
  indonesia("https://id.minghui.org/html/articles/2023/1/25/130727.html", "Bahasa Indonesia", 'indonesia'),
  italiano("https://it.minghui.org/html/articles/2023/1/25/21201.html", "Italiano", 'italiano'),
  japan("https://jp.minghui.org/2023/01/23/89043.html", "日本語", 'japan'),
  korean("https://www.minghui.or.kr/archives/masters-recent-articles/118601", "한국어", 'korean'),
  polski("https://pl.minghui.org/html/articles/2023/1/23/911.html", "Polski", 'polski'),
  portugues("https://pt.minghui.org/html/articles/2023/1/21/8438.html", "Português", 'portugues'),
  russian("https://ru.minghui.org/html/articles/2023/1/21/1172085.html", "Русский", 'russian'),
  slovencina("https://sk.minghui.org/2023/01/21/preco-existuje-ludstvo", "Slovenčina", 'slovencina'),
  srpski("https://sr.minghui.org/articles/6858", "Српски", 'srpski'),
  thai("https://th.minghui.org/html/articles/2023/1/31/3010.html", "ไทย", 'thai'),
  vietnamese("https://vn.minghui.org/jw/kinh_van_20230120.html", "Tiếng Việt", 'vietnamese'),
  turkce("https://tr.minghui.org/html/articles/2023/1/24/11239.html", "Türkçe", 'turkce'),
  ukrainian("https://uk.minghui.org/html/articles/2023/1/20/1155.html", "Українська", 'ukrainian')
  ;

  // Các tham số và hàm khởi tạo
  final String url;
  final String languageName;
  final String languageCode;
  const VisaoconhanloaiEnum(this.url, this.languageName, this.languageCode);

}
