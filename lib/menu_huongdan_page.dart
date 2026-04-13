import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'menu/open_url_language_page.dart';
import 'menu/privacy_policy_page_html.dart';
import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'menu/huongdantapcoban.dart';
import 'menu/webview_browser/minghui_webview.dart';
import 'menu/webview_browser/visaoconhanloai_webview.dart';

/// Trang chủ — lưới menu.
class MenuHome extends StatelessWidget {
  static const String routeName = 'GioiThieuPage_routeName';

  final styleTextTitle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

  MenuHome({super.key});

  static void _push(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = Duration.zero,
    bool slideFromBottom = false,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder<void>(
        transitionDuration: transitionDuration,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: slideFromBottom
            ? (context, animation, _, child) {
                final tween = Tween(begin: const Offset(0, 1), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.ease));
                return SlideTransition(position: animation.drive(tween), child: child);
              }
            : (_, __, ___, child) => child,
      ),
    );
  }

  void _openIntro(BuildContext context, List<PageViewModel> pages) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => IntroductionScreenWidget(
          listPageViewModel: pages,
          setPageIntro: SetPageIntro.gioithieuapp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Home', style: styleTextTitle)),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: GridView.count(
            padding: const EdgeInsets.all(10),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              InkWell(
                onTap: () => _push(context, HuongDanTapCoBanPage()),
                child: itemMenu('assets/images/menu_item_2.jpg', 'Hướng dẫn \ntập cơ bản'),
              ),
              InkWell(
                onTap: () => _push(context, VisaoconhanloaiWebview(), slideFromBottom: true),
                child: itemMenu('assets/images/menu_item_3.jpg', 'Why there is mankind?'),
              ),
              InkWell(
                onTap: () => _push(
                  context,
                  OpenUrlPage(trangDichCuaLienKet: TrangDichCuaLienKet.falundafa),
                ),
                child: itemMenu('assets/images/menu_item_4.jpg', 'Falundafa.org'),
              ),
              InkWell(
                onTap: () => _push(context, MinghuiWebview()),
                child: itemMenu('assets/images/menu_item_5.jpg', 'Minghui.org'),
              ),
              InkWell(
                onTap: () => _openIntro(context, listPageViewModelGioiThieuApp),
                child: itemMenu('assets/images/menu_item_1.jpg', 'About App'),
              ),
              InkWell(
                onTap: () => _push(context, PrivacyPolicyPageHtml(), slideFromBottom: true),
                child: itemMenu('assets/images/menu_item_6.jpg', 'Privacy policy & Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemMenu(String imagePath, String text) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.blue.withValues(alpha: 0.9),
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
