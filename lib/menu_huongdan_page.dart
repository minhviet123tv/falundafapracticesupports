import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'menu/open_url_language_page.dart';
import 'menu/privacy_policy_page_html.dart';
import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'menu/huongdantapcoban.dart';
import 'menu/webview_browser/falundafa_webview.dart';
import 'menu/webview_browser/minghui_webview.dart';
import 'menu/webview_browser/visaoconhanloai_webview.dart';
import 'common/swipe_to_back.dart';

// Danh sách Menu trang chủ dạng Grid
class MenuHome extends StatelessWidget {
  static const String routeName = "GioiThieuPage_routeName";
  final textStyle1 = const TextStyle(fontSize: 20, color: Colors.black);
  final styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  MenuHome({super.key});

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            "Home",
            style: styleTextTitle,
          )),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: girdViewMenu(context),
        ),
      ),
    );
  }

  //D.1 Danh sách Menu trang chủ dạng Grid
  Widget girdViewMenu(BuildContext context) {
    return GridView.count(
        padding: const EdgeInsets.all(10),
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          //1. Item menu 1: Mở trang hướng dẫn tập cơ bản
          InkWell(
            onTap: () {
              AppNavigator.push(context, HuongDanTapCoBanPage());
            },
            child: itemMenu("assets/images/menu_item_2.jpg", "Hướng dẫn \ntập cơ bản"),
          ),

          //2. Item menu 2: Mở trang bài viết "Vì sao có nhân loại"
          InkWell(
            onTap: () {
              AppNavigator.push(context, VisaoconhanloaiWebview());
            },
            child: itemMenu("assets/images/menu_item_3.jpg", "How Humankind Came To Be?"),
          ),

          //3. Item menu 3: Mở trang web "Falundafa.org"
          InkWell(
            onTap: () {
              AppNavigator.push(
                context,
                OpenUrlPage(trangDichCuaLienKet: TrangDichCuaLienKet.falundafa),
              );
            },
            child: itemMenu("assets/images/menu_item_4.jpg", "Falundafa.org"),
          ),

          //4. Item menu 4: Mở webview minghui.org
          InkWell(
            onTap: () {
              AppNavigator.push(context, MinghuiWebview());
            },
            child: itemMenu("assets/images/menu_item_5.jpg", "Minghui.org"),
          ),

          //5. Item menu 5: Trang giới thiệu về App
          InkWell(
            onTap: () {
              _openIntro(context, listPageViewModelGioiThieuApp);
            },
            child: itemMenu("assets/images/menu_item_1.jpg", "About App"),
          ),

          //6. Item menu 6: Trang giới thiệu về chính sách bảo mật, thông tin liên hệ
          InkWell(
            onTap: () {
              AppNavigator.push(context, PrivacyPolicyPageHtml());
            },
            child: itemMenu("assets/images/menu_item_6.jpg", "Privacy policy & Contact"),
          ),
        ]);
  }

  //D.2 Widget item của từng sản phẩm trong grid
  Widget itemMenu(String imagePath, String text) {
    return Card(
      elevation: 8,
      // Độ cao (Tạo bóng)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Góc bo viền
      ),
      semanticContainer: true,
      // nơi chứa ngữ nghĩa
      clipBehavior: Clip.antiAliasWithSaveLayer,
      // Cho phép bo viền

      child: Stack(
        children: [
          //1. Lớp đầu tiên (dưới cùng): Ảnh nền (dùng double.infinity để lấp đầy ô chứa nó)
          Image.asset(
            imagePath, // path trong assets
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          //2. Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blue.withOpacity(0.9),
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(8),
              child: Center(
                  child: Text(
                text,
                style:
                    const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ],
      ),
    );
  }

  //D.3 Hàm mở link url trình duyệt bên ngoài app khi click
  Future<void> _launchBrowserOutApp(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  //E.1 Hàm mở lại trang kiểu intro
  void _openIntro(BuildContext context, List<PageViewModel> listPageViewModel) {
    AppNavigator.push(
      context,
      IntroductionScreenWidget(
        listPageViewModel: listPageViewModel,
        setPageIntro: SetPageIntro.gioithieuapp,
      ),
    );
  }
}
