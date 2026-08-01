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
    const gridPadding = 10.0;
    const crossSpacing = 10.0;
    const labelHPad = 6.0;
    const labelVPad = 10.0;

    final titles = <String>[
      _ui.basicPracticeGuideMenu,
      _ui.humankindMenuTitle,
      'Falundafa.org',
      'Minghui.org',
      _ui.aboutAppMenuTitle,
      _ui.privacyMenuTitle,
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScaler = MediaQuery.textScalerOf(context);
    final cellWidth = (screenWidth - gridPadding * 2 - crossSpacing) / 2;
    final labelMaxWidth = (cellWidth - labelHPad * 2).clamp(40.0, double.infinity);

    final labelStyle = AppTextStyles.title(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    var maxTextHeight = 0.0;
    for (final title in titles) {
      final painter = TextPainter(
        text: TextSpan(text: title, style: labelStyle),
        textAlign: TextAlign.center,
        maxLines: 4,
        textDirection: Directionality.of(context),
        textScaler: textScaler,
      )..layout(maxWidth: labelMaxWidth);
      if (painter.height > maxTextHeight) {
        maxTextHeight = painter.height;
      }
    }
    final labelBarHeight = maxTextHeight + labelVPad * 2;

    return GridView.count(
      padding: const EdgeInsets.all(gridPadding),
      crossAxisCount: 2,
      crossAxisSpacing: crossSpacing,
      mainAxisSpacing: 10,
      // Vuông hơn (trước ~0.72), vẫn cao hơn rộng.
      childAspectRatio: 0.88,
      children: [
        InkWell(
          onTap: () {
            AppNavigator.push(context, const HuongDanTapCoBanPage())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_2.jpg',
            titles[0],
            labelBarHeight: labelBarHeight,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(context, VisaoconhanloaiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_3.jpg',
            titles[1],
            labelBarHeight: labelBarHeight,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(
              context,
              OpenUrlPage(trangDichCuaLienKet: TrangDichCuaLienKet.falundafa),
            ).then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_4.jpg',
            titles[2],
            labelBarHeight: labelBarHeight,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, MinghuiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_5.jpg',
            titles[3],
            labelBarHeight: labelBarHeight,
          ),
        ),
        InkWell(
          onTap: () {
            _openAboutAppIntro(context);
          },
          child: itemMenu(
            'assets/images/menu_item_1.jpg',
            titles[4],
            labelBarHeight: labelBarHeight,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, const PrivacyPolicyPageHtml())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_6.jpg',
            titles[5],
            labelBarHeight: labelBarHeight,
          ),
        ),
      ],
    );
  }

  Widget itemMenu(
    String imagePath,
    String text, {
    required double labelBarHeight,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: labelBarHeight,
              color: Colors.blue.withValues(alpha: 0.85),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
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
