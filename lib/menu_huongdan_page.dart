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
import 'menu/settings_page.dart';
import 'menu/webview_browser/falundafa_video_webview.dart';
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

  Future<void> _onLanguageChanged(NewAreaLang lang) async {
    await AppLanguageSync.onUserSelected(lang.name);
    if (!mounted) return;
    setState(() => _lang = lang);
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
          leadingWidth: 148,
          leading: Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: NewAreaLanguageMenu(
                current: _lang,
                available: NewAreaLang.values,
                textColor: Colors.white,
                onChanged: (lang) => unawaited(_onLanguageChanged(lang)),
              ),
            ),
          ),
          title: Text(
            'Home',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title(fontSize: 19),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            TextButton(
              onPressed: () {
                AppNavigator.pushFromTop(
                  context,
                  const FalundafaVideoWebview(
                    kind: FalundafaVideoKind.introduction,
                  ),
                ).then((_) => _loadLanguage(silent: true));
              },
              child: Text(
                _ui.introductionAppBarButton,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.title(fontSize: 13.5),
              ),
            ),
            const SizedBox(width: 4),
          ],
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
      _ui.masterExerciseGuideMenu,
      _ui.basicPracticeGuideMenu,
      'Falundafa.org',
      'Minghui.org',
      _ui.humankindMenuTitle,
      _ui.localClassesMenuTitle,
      _ui.aboutAppMenuTitle,
      _ui.privacyMenuTitle,
      _ui.settingsMenuTitle,
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
      // Vuông hơn (trước ~0.72), vẫn cao hơn rộng.
      childAspectRatio: 0.88,
      children: [
        // Hàng 1: Sư phụ hướng dẫn tập | Học viên hướng dẫn
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(context, const FalundafaVideoWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/su_phu_tap_bai_5_1_anh.png',
            titles[0],
            labelBarHeight: labelBarHeight,
            imageFit: BoxFit.contain,
            imageAlignment: const Alignment(0, -0.08),
            // To hơn một chút so với trước (padding hẹp hơn).
            imagePadding: const EdgeInsets.fromLTRB(4, 4, 4, 2),
            imageScale: 1.08,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, const HuongDanTapCoBanPage())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_2.jpg',
            titles[1],
            labelBarHeight: labelBarHeight,
            // Zoom vào phần giữa để thấy rõ học viên đang tập.
            imageFit: BoxFit.cover,
            imageAlignment: Alignment.center,
            imageScale: 1.45,
          ),
        ),
        // Hàng 2: Falundafa | Minghui
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
            // Hoa sen hơi cao trong ảnh — căn giữa vùng hiển thị.
            imageFit: BoxFit.cover,
            imageAlignment: const Alignment(0, -0.28),
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(context, MinghuiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_5.jpg',
            titles[3],
            labelBarHeight: labelBarHeight,
            imageFit: BoxFit.cover,
            imageAlignment: Alignment.center,
          ),
        ),
        // Hàng 3: Vì sao có nhân loại | Liên hệ lớp học địa phương
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(context, VisaoconhanloaiWebview())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_3.jpg',
            titles[4],
            labelBarHeight: labelBarHeight,
            imageFit: BoxFit.cover,
            imageAlignment: const Alignment(0, -0.12),
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.pushFromTop(
              context,
              const FalundafaVideoWebview(
                kind: FalundafaVideoKind.connectToClasses,
              ),
            ).then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_world_map.png',
            titles[5],
            labelBarHeight: labelBarHeight,
            // Ảnh có nhiều khoảng trống — cover + scale nhẹ để bản đồ đủ lớn, căn giữa.
            imageFit: BoxFit.cover,
            imageAlignment: Alignment.center,
            imageScale: 1.22,
          ),
        ),
        // Hàng 4: Giới thiệu app | Chính sách bảo mật
        InkWell(
          onTap: () {
            _openAboutAppIntro(context);
          },
          child: itemMenu(
            'assets/images/menu_item_1.jpg',
            titles[6],
            labelBarHeight: labelBarHeight,
            imageFit: BoxFit.cover,
            imageAlignment: Alignment.center,
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(context, const PrivacyPolicyPageHtml())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenu(
            'assets/images/menu_item_6.jpg',
            titles[7],
            labelBarHeight: labelBarHeight,
            imageFit: BoxFit.cover,
            imageAlignment: Alignment.center,
          ),
        ),
        // Hàng 5: Cài đặt
        InkWell(
          onTap: () {
            AppNavigator.push(context, const SettingsPage())
                .then((_) => _loadLanguage(silent: true));
          },
          child: itemMenuSettings(
            titles[8],
            labelBarHeight: labelBarHeight,
          ),
        ),
      ],
    );
  }

  Widget itemMenuSettings(String text, {required double labelBarHeight}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade50,
                    Colors.blue.shade100,
                    Colors.lightBlue.shade50,
                  ],
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    top: -12,
                    right: -10,
                    child: Icon(
                      Icons.settings_outlined,
                      size: 96,
                      color: Colors.blue.withValues(alpha: 0.08),
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    left: -16,
                    child: Icon(
                      Icons.tune_rounded,
                      size: 64,
                      color: Colors.blue.withValues(alpha: 0.07),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.92),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.22),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        size: 42,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _menuLabelBar(text, labelBarHeight),
        ],
      ),
    );
  }

  Widget itemMenu(
    String imagePath,
    String text, {
    required double labelBarHeight,
    AlignmentGeometry imageAlignment = Alignment.center,
    BoxFit imageFit = BoxFit.cover,
    EdgeInsetsGeometry? imagePadding,
    double imageScale = 1.0,
  }) {
    final alignment = imageAlignment is Alignment
        ? imageAlignment
        : Alignment.center;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: ClipRect(
                child: Padding(
                  padding: imagePadding ?? EdgeInsets.zero,
                  child: Transform.scale(
                    scale: imageScale,
                    alignment: alignment,
                    child: Image.asset(
                      imagePath,
                      fit: imageFit,
                      alignment: imageAlignment,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _menuLabelBar(text, labelBarHeight),
        ],
      ),
    );
  }

  /// Thanh tiêu đề xanh — vùng riêng, không chồng lên ảnh/icon phía trên.
  Widget _menuLabelBar(String text, double labelBarHeight) {
    return Container(
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
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
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
