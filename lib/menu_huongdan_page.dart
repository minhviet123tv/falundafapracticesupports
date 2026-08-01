import 'dart:async';

import 'package:flutter/material.dart';

import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/app_text_theme.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';
import 'package:falun_dafa_practice_supports/common/swipe_to_back.dart';
import 'menu/open_url_language_page.dart';
import 'menu/privacy_policy_page_html.dart';
import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'menu/huongdantapcoban.dart';
import 'menu/webview_browser/minghui_webview.dart';
import 'menu/webview_browser/visaoconhanloai_webview.dart';

/// Danh sách Menu trang chủ dạng Grid — nhãn theo ngôn ngữ đang chọn.
class MenuHome extends StatefulWidget {
  static const String routeName = 'GioiThieuPage_routeName';

  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  NewAreaLang _lang = NewAreaLang.english;
  bool _ready = false;

  NewAreaUiStrings get _ui => NewAreaUiStrings(_lang);

  @override
  void initState() {
    super.initState();
    unawaited(_loadLanguage());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Làm mới khi quay lại Home sau khi đổi ngôn ngữ ở vùng khác.
    unawaited(_loadLanguage(silent: true));
  }

  Future<void> _loadLanguage({bool silent = false}) async {
    final preferred = await AppLanguageSync.preferredOrEnglish();
    final lang =
        NewAreaLang.fromCanonical(preferred) ?? NewAreaLang.english;
    if (!mounted) return;
    if (silent && lang == _lang && _ready) return;
    setState(() {
      _lang = lang;
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      // Đồng bộ nhãn khi đổi ngôn ngữ ở tab/vùng khác rồi quay về Home.
      unawaited(_loadLanguage(silent: true));
    }
    if (!_ready) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Home',
              style: AppTextStyles.title(fontSize: 19),
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Center(child: _gridViewMenu(context)),
      ),
    );
  }

  Widget _gridViewMenu(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.72,
      children: [
        InkWell(
          onTap: () {
            AppNavigator.push(context, const HuongDanTapCoBanPage())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_2.jpg',
            _ui.basicPracticeGuideMenu,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(context, VisaoconhanloaiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_3.jpg',
            _ui.humankindMenuTitle,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(
              context,
              OpenUrlPage(trangDichCuaLienKet: TrangDichCuaLienKet.falundafa),
            ).then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu('assets/images/menu_item_4.jpg', 'Falundafa.org'),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, MinghuiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu('assets/images/menu_item_5.jpg', 'Minghui.org'),
        ),
        InkWell(
          onTap: () {
            _openAboutAppIntro(context);
          },
          child: itemMenu(
            'assets/images/menu_item_1.jpg',
            _ui.aboutAppMenuTitle,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, const PrivacyPolicyPageHtml())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_6.jpg',
            _ui.privacyMenuTitle,
          ),
        ),
      ],
    );
  }

  Widget itemMenu(String imagePath, String text) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.blue.withValues(alpha: 0.95),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                child: Center(
                  child: Text(
                    text,
                    style: AppTextStyles.title(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAboutAppIntro(BuildContext context) {
    AppNavigator.push(
      context,
      IntroductionScreenWidget(
        pagesBuilder: buildAboutAppPages,
        setPageIntro: SetPageIntro.gioithieuapp,
        languagePrefsKey: NewAreaLanguageKeys.aboutApp,
      ),
    ).then((_) => _loadLanguage(silent: true));
  }
}
