import 'dart:async';

import 'package:flutter/material.dart';

import 'package:falun_dafa_practice_supports/common/app_font_size_scale.dart';
import 'package:falun_dafa_practice_supports/common/app_font_size_scale_slider.dart';
import 'package:falun_dafa_practice_supports/common/app_font_size_settings.dart';
import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/app_text_theme.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';

/// Trang Cài đặt — hiện có « Kích thước chữ ».
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  NewAreaLang _lang = NewAreaLang.english;
  late final VoidCallback _fontListener;

  NewAreaUiStrings get _ui => NewAreaUiStrings(_lang);

  @override
  void initState() {
    super.initState();
    _fontListener = () {
      if (mounted) setState(() {});
    };
    AppFontSizeSettings.instance.addListener(_fontListener);
    unawaited(_loadLang());
  }

  @override
  void dispose() {
    AppFontSizeSettings.instance.removeListener(_fontListener);
    super.dispose();
  }

  Future<void> _loadLang() async {
    final preferred = await AppLanguageSync.preferredOrEnglish();
    final lang =
        NewAreaLang.fromCanonical(preferred) ?? NewAreaLang.english;
    if (!mounted) return;
    setState(() => _lang = lang);
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppFontSizeSettings.instance.scale;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _ui.settingsPageTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title(fontSize: 19),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.format_size_rounded,
                        color: Colors.blue.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _ui.fontSizeSettingLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title(
                            color: Colors.black87,
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: _ui.fontSizeResetTooltip,
                        onPressed: () => unawaited(
                          AppFontSizeSettings.instance.resetToDefault(),
                        ),
                        icon: Icon(
                          Icons.restart_alt_rounded,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _ui.fontSizeSettingHelp,
                    style: AppTextStyles.body(
                      color: Colors.black54,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppFontSizeScaleSlider(
                    selected: scale,
                    onSelected: (v) =>
                        unawaited(AppFontSizeSettings.instance.save(v)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _ui.fontSizePreviewSample,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      color: Colors.black87,
                      fontSize: 15.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _scaleName(scale),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(
                      color: Colors.blue.shade800,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _scaleName(AppFontSizeScale scale) {
    return switch (scale) {
      AppFontSizeScale.ultraSmall => _ui.fontSizeUltraSmall,
      AppFontSizeScale.extraSmall => _ui.fontSizeExtraSmall,
      AppFontSizeScale.small => _ui.fontSizeSmall,
      AppFontSizeScale.normal => _ui.fontSizeNormal,
      AppFontSizeScale.large => _ui.fontSizeLarge,
      AppFontSizeScale.extraLarge => _ui.fontSizeExtraLarge,
      AppFontSizeScale.ultraLarge => _ui.fontSizeUltraLarge,
      AppFontSizeScale.superLarge => _ui.fontSizeSuperLarge,
      AppFontSizeScale.maximum => _ui.fontSizeMaximum,
    };
  }
}
