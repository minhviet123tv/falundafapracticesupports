import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';
import 'package:falun_dafa_practice_supports/main.dart';
import 'package:falun_dafa_practice_supports/menu/intro_list_widget_body.dart';

/*
introduction_screen: ^3.1.14
link: https://pub.dev/packages/introduction_screen/install
 */

class IntroductionScreenWidget extends StatefulWidget {
  /// Builder nội dung theo ngôn ngữ (Vùng ngôn ngữ mới).
  final List<PageViewModel> Function(NewAreaLang lang) pagesBuilder;
  final SetPageIntro setPageIntro;
  final String languagePrefsKey;
  final List<NewAreaLang> availableLanguages;

  const IntroductionScreenWidget({
    required this.pagesBuilder,
    required this.setPageIntro,
    required this.languagePrefsKey,
    this.availableLanguages = NewAreaLang.values,
    super.key,
  });

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<IntroductionScreenWidget> {
  final introKey = GlobalKey<IntroductionScreenState>();
  NewAreaLang _lang = NewAreaLang.english;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadLanguage());
  }

  Future<void> _loadLanguage() async {
    final loaded = await NewAreaLanguageStore.load(widget.languagePrefsKey);
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
        backgroundColor: Colors.blue,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final bottomLift = bottomInset > 0 ? 6.0 : 0.0;
    final pages = widget.pagesBuilder(_lang);
    final ui = NewAreaUiStrings(_lang);

    return SafeArea(
      bottom: true,
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.blue,
        allowImplicitScrolling: false,
        infiniteAutoScroll: false,
        globalHeader: SafeArea(
          bottom: false,
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(10),
                child: NewAreaLanguageMenu(
                  current: _lang,
                  available: widget.availableLanguages,
                  onChanged: (lang) => unawaited(_onLanguageChanged(lang)),
                ),
              ),
            ),
          ),
        ),
        pages: pages,
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        showSkipButton: true,
        showBackButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        back: const Icon(Icons.arrow_back, color: Colors.white),
        skip: Text(ui.skip,
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        next: const Icon(Icons.arrow_forward, color: Colors.white),
        done: Text(ui.done,
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomLift),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0 + bottomLift),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Colors.white,
          activeColor: Colors.blue,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  void _onIntroEnd(context) {
    if (widget.setPageIntro == SetPageIntro.molandau) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RunAppFalunDafaExercise()),
      );
    } else if (widget.setPageIntro == SetPageIntro.gioithieuapp) {
      Navigator.pop(context);
    } else if (widget.setPageIntro == SetPageIntro.tapcoban) {
      Navigator.pop(context);
    }
  }
}
