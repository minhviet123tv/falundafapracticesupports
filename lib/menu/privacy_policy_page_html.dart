import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/new_area_content_i18n.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';

/*
flutter_widget_from_html: ^0.15.0 #widget, code html
Chú ý cho code bên trong thẻ HtmlWidget và trong thẻ lại chứa code trong 2 lần dấu ''':
HtmlWidget( ''' <code> ''' )
 */

class PrivacyPolicyPageHtml extends StatefulWidget {
  const PrivacyPolicyPageHtml({super.key});

  @override
  State<PrivacyPolicyPageHtml> createState() => _PrivacyPolicyPageHtmlState();
}

class _PrivacyPolicyPageHtmlState extends State<PrivacyPolicyPageHtml> {
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
        await NewAreaLanguageStore.load(NewAreaLanguageKeys.privacyPolicy);
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
            _ui.privacyAppBarTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.green,
          actions: [
            NewAreaLanguageMenu(
              current: _lang,
              available: NewAreaLang.values,
              textColor: Colors.white,
              onChanged: (lang) => unawaited(_onLanguageChanged(lang)),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  HtmlWidget(NewAreaContentI18n.privacyHtml(_lang)),
                  if (NewAreaContentI18n.privacyIsTranslated(_lang))
                    googleTranslateFooterNote(_lang),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
