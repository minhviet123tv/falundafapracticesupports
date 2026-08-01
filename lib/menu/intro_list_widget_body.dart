import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:falun_dafa_practice_supports/common/new_area_content_i18n.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';

/*
Nơi chứa dữ liệu sẵn cho intro — Vùng ngôn ngữ mới.
 */

//I. Dữ liệu chung — cỡ logical (trước TextScaler thiết bị).
// Trên máy thử nghiệm (comfortScale 1.16): body ≈ 18→21, title intro ≈ 28→32.
var styleTextIntro1 = TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w700);
var styleTextBody2 = TextStyle(fontSize: 18.0, color: Colors.black);
var styleTextNumberPage = TextStyle(fontSize: 17.0, color: Colors.grey);
var colorIconAudioPlay = Colors.deepPurple;

enum SetPageIntro {molandau ,gioithieuapp, tapcoban}

const pageDecoration = PageDecoration(
  titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
  bodyTextStyle: TextStyle(fontSize: 21.0),
  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.green,
  imagePadding: EdgeInsets.zero,
  fullScreen: false,
);

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
    throw Exception('Could not launch $url');
  }
}

PageDecoration get _introPageDecoration => pageDecoration.copyWith(
      bodyFlex: 7,
      imageFlex: 3,
      bodyAlignment: Alignment.topCenter,
      imageAlignment: Alignment.bottomCenter,
    );

Widget _tableCellText(String text, {TextStyle? style}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Center(
      child: Text(text, style: style, textAlign: TextAlign.center),
    ),
  );
}

Widget _tableCellIcon(IconData icon, {Color? color}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Center(child: Icon(icon, color: color)),
  );
}

// ---------------------------------------------------------------------------
// About App
// ---------------------------------------------------------------------------

List<PageViewModel> buildAboutAppPages(NewAreaLang lang) {
  return [
    _aboutAppPage1(lang),
    _aboutAppPage2Features(lang),
  ];
}

/// Giữ tương thích chỗ gọi cũ (sẽ ưu tiên builder + prefs).
List<PageViewModel> get listPageViewModelGioiThieuApp =>
    buildAboutAppPages(NewAreaLang.english);

PageViewModel _aboutAppPage1(NewAreaLang lang) {
  final ui = NewAreaUiStrings(lang);
  final body = NewAreaContentI18n.aboutBody(lang);

  return PageViewModel(
    title: ui.aboutAppTitle,
    reverse: true,
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(body, style: styleTextBody2, textAlign: TextAlign.justify),
          Row(children: [
            const Icon(Icons.arrow_right),
            InkWell(
              onTap: () {
                _launchInBrowser(Uri.parse('https://www.falundafa.org/'));
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Home: ',
                      style: styleTextBody2.copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'www.falundafa.org ',
                      style: styleTextBody2.copyWith(color: Colors.blue),
                    ),
                  ],
                  style: styleTextBody2,
                ),
              ),
            ),
          ]),
          Row(children: [
            const Icon(Icons.arrow_right),
            InkWell(
              onTap: () {
                _launchInBrowser(Uri.parse('https://www.minghui.org/'));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'News: ',
                      style: styleTextBody2.copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'www.minghui.org ',
                      style: styleTextBody2.copyWith(color: Colors.blue),
                    ),
                  ],
                  style: styleTextBody2,
                ),
              ),
            ),
          ]),
          if (NewAreaContentI18n.aboutPage1IsTranslated(lang))
            googleTranslateFooterNote(lang),
          Text('\n1', style: styleTextNumberPage, textAlign: TextAlign.center),
        ],
      ),
    ),
    decoration: _introPageDecoration,
  );
}

PageViewModel _aboutAppPage2Features(NewAreaLang lang) {
  final ui = NewAreaUiStrings(lang);

  return PageViewModel(
    title: ui.featuresTitle,
    reverse: true,
    bodyWidget: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            border: TableBorder.all(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            columnWidths: const {
              0: FractionColumnWidth(.375),
              1: FractionColumnWidth(.30),
              2: FractionColumnWidth(.325),
            },
            children: [
              TableRow(children: [
                _tableCellText(ui.feature, style: styleTextIntro1),
                _tableCellText(ui.lesson, style: styleTextIntro1),
                _tableCellText(ui.practiceMusic, style: styleTextIntro1),
              ]),
              TableRow(children: [
                _tableCellText(ui.useInternet),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
              ]),
              TableRow(children: [
                _tableCellText(ui.saveLatest),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
              ]),
              TableRow(children: [
                _tableCellText(ui.downloadToPhone),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
                _tableCellIcon(Icons.check_circle, color: Colors.green),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                columnWidths: const {
                  0: FractionColumnWidth(.40),
                  1: FractionColumnWidth(.60),
                },
                children: [
                  TableRow(children: [
                    _tableCellText(
                      ui.button,
                      style: styleTextBody2.copyWith(fontWeight: FontWeight.w700),
                    ),
                    _tableCellText(
                      ui.uses,
                      style: styleTextBody2.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ]),
                  TableRow(children: [
                    _tableCellIcon(Icons.play_circle_fill,
                        color: Colors.orangeAccent),
                    _tableCellText(ui.listenViewOnline),
                  ]),
                  TableRow(children: [
                    _tableCellIcon(Icons.download, color: colorIconAudioPlay),
                    _tableCellText(ui.downloadToPhone),
                  ]),
                  TableRow(children: [
                    _tableCellIcon(Icons.zoom_out_map),
                    _tableCellText(ui.extend),
                  ]),
                  TableRow(children: [
                    _tableCellIcon(Icons.open_in_new),
                    _tableCellText(ui.openInBrowser),
                  ]),
                  TableRow(children: [
                    _tableCellIcon(Icons.picture_as_pdf),
                    _tableCellText(ui.readDownloadPdf),
                  ]),
                ],
              ),
              Center(
                child: Text('\n2',
                    style: styleTextNumberPage, textAlign: TextAlign.center),
              ),
              // Trang Features gốc tiếng Anh → bản dịch có chú thích Google.
              if (lang != NewAreaLang.english) googleTranslateFooterNote(lang),
            ],
          ),
        ),
      ],
    ),
    decoration: _introPageDecoration,
  );
}

// ---------------------------------------------------------------------------
// Hướng dẫn tập cơ bản
// ---------------------------------------------------------------------------

List<PageViewModel> buildHuongDanTapCoBanPages(NewAreaLang lang) {
  return [
    _huongDanOverviewPage(lang),
    _huongDanExercisePage(lang),
  ];
}

List<PageViewModel> get listPageViewModelHuongDanTapCoBan =>
    buildHuongDanTapCoBanPages(NewAreaLang.english);

PageViewModel _huongDanOverviewPage(NewAreaLang lang) {
  final ui = NewAreaUiStrings(lang);

  return PageViewModel(
    title: ui.overviewGuideTitle,
    reverse: true,
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            NewAreaContentI18n.overviewBody1(lang),
            style: styleTextBody2,
            textAlign: TextAlign.justify,
          ),
          Text(
            NewAreaContentI18n.overviewBody2(lang),
            style: styleTextBody2,
            textAlign: TextAlign.justify,
          ),
          if (NewAreaContentI18n.practiceIsTranslated(lang))
            googleTranslateFooterNote(lang),
          Text('\n1', style: styleTextNumberPage, textAlign: TextAlign.right),
        ],
      ),
    ),
    decoration: _introPageDecoration,
  );
}

PageViewModel _huongDanExercisePage(NewAreaLang lang) {
  final ui = NewAreaUiStrings(lang);

  return PageViewModel(
    title: ui.exercisesTitle,
    reverse: true,
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            NewAreaContentI18n.exerciseIntro(lang),
            style: styleTextBody2,
            textAlign: TextAlign.justify,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('assets/images/anh_bai_1.jpg',
                width: double.infinity),
          ),
          Text(
            NewAreaContentI18n.exerciseBody(lang),
            style: styleTextBody2,
            textAlign: TextAlign.justify,
          ),
          if (NewAreaContentI18n.practiceIsTranslated(lang))
            googleTranslateFooterNote(lang),
          Text('\n2', style: styleTextNumberPage, textAlign: TextAlign.right),
        ],
      ),
    ),
    decoration: _introPageDecoration,
  );
}

/// Thin wrapper — UI hub strings via [NewAreaUiStrings].
class HuongDanTapCoBanStrings {
  final NewAreaLang lang;
  const HuongDanTapCoBanStrings(this.lang);

  NewAreaUiStrings get _ui => NewAreaUiStrings(lang);

  String get appBarTitle => _ui.basicPracticeGuide;

  String get guideTile => _ui.basicPracticeGuide;

  String demoTile(int n) => _ui.demoPractitioner(n);

  /// Demo WebView titles stay Vietnamese (user request).
  String exerciseTitle(int n, String chineseName) => 'Bài $n: $chineseName';

  String get tipMirror => _ui.tipMirror;

  String get tipSame => _ui.tipSame;

  String get tipExercise4 => _ui.tipExercise4;
}
