import 'dart:async';

import 'package:flutter/material.dart';
import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/app_text_theme.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';
import 'package:falun_dafa_practice_supports/common/swipe_to_back.dart';
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title(color: Colors.black87, fontSize: 19),
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
    AppNavigator.push(
      context,
      WebViewBrowser(
        linkUrl: linkUrl,
        title: title,
        textHuongDan: textHuongDan,
        lang: _lang,
      ),
    );
  }

  Widget _gridViewMenu(BuildContext context) {
    const gridPadding = 10.0;
    const crossSpacing = 10.0;
    const labelHPad = 8.0;
    const labelVPad = 14.0;

    final titles = <String>[
      _ui.basicPracticeGuide,
      _ui.demoPractitioner(1),
      _ui.demoPractitioner(2),
      _ui.demoPractitioner(3),
      _ui.demoPractitioner(4),
      _ui.demoPractitioner(5),
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;
    final textScaler = MediaQuery.textScalerOf(context);
    final cellWidth = (screenWidth - gridPadding * 2 - crossSpacing) / 2;
    final labelMaxWidth =
        (cellWidth - labelHPad * 2).clamp(40.0, double.infinity);

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
        maxLines: 2,
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
      // Vuông hơn (trước ~0.68), vẫn cao hơn rộng.
      childAspectRatio: 0.88,
      children: [
        InkWell(
          onTap: () => _openIntro(context),
          child: itemMenu(
            'assets/images/menu_item_2.jpg',
            titles[0],
            labelBarHeight: labelBarHeight,
          ),
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
          child: itemMenu(
            'assets/images/anh_bai_1.jpg',
            titles[1],
            labelBarHeight: labelBarHeight,
          ),
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
          child: itemMenu(
            'assets/images/anh_bai_2.jpg',
            titles[2],
            labelBarHeight: labelBarHeight,
          ),
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
          child: itemMenu(
            'assets/images/anh_bai_3.jpg',
            titles[3],
            labelBarHeight: labelBarHeight,
          ),
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
          child: itemMenu(
            'assets/images/anh_bai_4.jpg',
            titles[4],
            labelBarHeight: labelBarHeight,
          ),
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
          child: itemMenu(
            'assets/images/anh_bai_5.jpg',
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
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            height: labelBarHeight,
            width: double.infinity,
            color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Text(
              text,
              style: AppTextStyles.title(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _openIntro(BuildContext context) {
    AppNavigator.push(
      context,
      IntroductionScreenWidget(
        pagesBuilder: buildHuongDanTapCoBanPages,
        setPageIntro: SetPageIntro.tapcoban,
        languagePrefsKey: NewAreaLanguageKeys.huongDanTapCoBan,
      ),
    );
  }
}
