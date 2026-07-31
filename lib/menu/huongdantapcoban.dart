import 'dart:async';

import 'package:flutter/material.dart';
import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/app_text_theme.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';
import 'package:falun_dafa_practice_supports/menu/simple_webview.dart';

import 'intro_list_widget_body.dart';
import 'introduction_screen.dart';

class HuongDanTapCoBanPage extends StatefulWidget {
  static const String routeName = 'Menu2HuongDanTapCoBanPage_routeName';

  const HuongDanTapCoBanPage({super.key});

  @override
  State<HuongDanTapCoBanPage> createState() => _HuongDanTapCoBanPageState();
}

class _HuongDanTapCoBanPageState extends State<HuongDanTapCoBanPage> {
  NewAreaLang _lang = NewAreaLang.english;
  bool _ready = false;

  NewAreaUiStrings get _ui => NewAreaUiStrings(_lang);

  @override
  void initState() {
    super.initState();
    unawaited(_loadLanguage());
  }

  Future<void> _loadLanguage() async {
    final loaded =
        await NewAreaLanguageStore.load(NewAreaLanguageKeys.huongDanTapCoBan);
    if (!mounted) return;
    setState(() {
      _lang = loaded;
      _ready = true;
    });
  }

  Future<void> _onLanguageChanged(NewAreaLang lang) async {
    await AppLanguageSync.onUserSelected(lang.name);
    if (!mounted) return;
    setState(() => _lang = lang);
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _ui.basicPracticeGuide,
            style: AppTextStyles.title(color: Colors.black87, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          actions: [
            NewAreaLanguageMenu(
              current: _lang,
              available: NewAreaLang.values,
              onChanged: (lang) => unawaited(_onLanguageChanged(lang)),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Center(child: _gridViewMenu(context)),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _openDemo({
    required BuildContext context,
    required String linkUrl,
    required String title,
    required String textHuongDan,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WebViewBrowser(
          linkUrl: linkUrl,
          title: title,
          textHuongDan: textHuongDan,
          lang: _lang,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  Widget _gridViewMenu(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.68,
      children: [
        InkWell(
          onTap: () => _openIntro(context),
          child: itemMenu('assets/images/menu_item_2.jpg', _ui.basicPracticeGuide),
        ),
        InkWell(
          onTap: () {
            _openDemo(
              context: context,
              linkUrl:
                  'https://www.ganjingworld.com/vi-VN/embed/1feprapkl1i77D9YXA1UBoCtd10s1c',
              title: 'Bài 1: Phật Triển Thiên Thủ Pháp',
              textHuongDan: _ui.tipMirror,
            );
          },
          child: itemMenu('assets/images/anh_bai_1.jpg', _ui.demoPractitioner(1)),
        ),
        InkWell(
          onTap: () {
            _openDemo(
              context: context,
              linkUrl:
                  'https://www.ganjingworld.com/embed/1fdmq7mob016ej27ndenbGNr21511c',
              title: 'Bài 2: Pháp Luân Trang Pháp',
              textHuongDan: _ui.tipSame,
            );
          },
          child: itemMenu('assets/images/anh_bai_2.jpg', _ui.demoPractitioner(2)),
        ),
        InkWell(
          onTap: () {
            _openDemo(
              context: context,
              linkUrl:
                  'https://www.ganjingworld.com/embed/1fdmqjv549d5B8SAxJfBd7M5F11u1c',
              title: 'Bài 3: Quán Thông Lưỡng Cực Pháp',
              textHuongDan: _ui.tipMirror,
            );
          },
          child: itemMenu('assets/images/anh_bai_3.jpg', _ui.demoPractitioner(3)),
        ),
        InkWell(
          onTap: () {
            _openDemo(
              context: context,
              linkUrl:
                  'https://www.ganjingworld.com/embed/1fdmtv3fpd19ENgfFOQCoXuu41fe1c',
              title: 'Bài 4: Pháp Luân Chu Thiên Pháp',
              textHuongDan: _ui.tipExercise4,
            );
          },
          child: itemMenu('assets/images/anh_bai_4.jpg', _ui.demoPractitioner(4)),
        ),
        InkWell(
          onTap: () {
            _openDemo(
              context: context,
              linkUrl:
                  'https://www.ganjingworld.com/embed/1fdnvgqme2u2yk7Jy0s0VWcsL1ev1c',
              title: 'Bài 5: Thần Thông Gia Trì Pháp',
              textHuongDan: _ui.tipMirror,
            );
          },
          child: itemMenu('assets/images/anh_bai_5.jpg', _ui.demoPractitioner(5)),
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
              color: Colors.blue,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    text,
                    style: AppTextStyles.title(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openIntro(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IntroductionScreenWidget(
          pagesBuilder: buildHuongDanTapCoBanPages,
          setPageIntro: SetPageIntro.tapcoban,
          languagePrefsKey: NewAreaLanguageKeys.huongDanTapCoBan,
        ),
      ),
    );
  }
}
