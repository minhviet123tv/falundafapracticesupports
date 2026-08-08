import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/book_placement_dialog_strings.dart';
import 'package:falun_dafa_practice_supports/common/new_area_language.dart';

/// Dialog hướng dẫn đặt điện thoại khi đọc sách / xem video.
class BookReadingPlacementDialog {
  static const String prefsKeyBook = 'book_reading_phone_placement_hint_v1';
  static const String prefsKeyVideoLesson =
      'video_lesson_phone_placement_hint_v1';

  static Future<bool> shouldShow({String prefsKey = prefsKeyBook}) async {
    final shared = await SharedPreferences.getInstance();
    return !(shared.getBool(prefsKey) ?? false);
  }

  static Future<void> markNeverShowAgain({
    String prefsKey = prefsKeyBook,
  }) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool(prefsKey, true);
  }

  static Future<void> showIfNeeded(
    BuildContext context, {
    String? languageCode,
    String prefsKey = prefsKeyBook,
  }) async {
    if (!await shouldShow(prefsKey: prefsKey)) return;
    if (!context.mounted) return;

    final code = languageCode ?? await AppLanguageSync.preferredOrEnglish();
    final lang =
        NewAreaLang.fromCanonical(code) ?? NewAreaLang.english;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _BookReadingPlacementDialogContent(
        lang: lang,
        prefsKey: prefsKey,
      ),
    );
  }
}

class _BookReadingPlacementDialogContent extends StatelessWidget {
  final NewAreaLang lang;
  final String prefsKey;

  const _BookReadingPlacementDialogContent({
    required this.lang,
    this.prefsKey = BookReadingPlacementDialog.prefsKeyBook,
  });

  static const String _goodImage = 'assets/images/dienthoai_nen_1.jpeg';
  static const String _badImage1 = 'assets/images/dienthoai_khongnen_1.jpg';
  static const String _badImage2 = 'assets/images/dienthoai_khongnen_2.png';

  @override
  Widget build(BuildContext context) {
    final s = BookPlacementDialogStrings(lang);
    final isVideo =
        prefsKey == BookReadingPlacementDialog.prefsKeyVideoLesson;
    final title = isVideo ? s.videoTitle : s.title;
    final goodPlacement = isVideo ? s.videoGoodPlacement : s.goodPlacement;
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final dialogWidth = (screenWidth * 0.92).clamp(300.0, 420.0);
    final maxDialogHeight = (screenHeight - media.viewPadding.vertical - 48)
        .clamp(280.0, screenHeight * 0.88);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _section(
                      title: goodPlacement,
                      isPositive: true,
                      images: const [_goodImage],
                      imageWidth: dialogWidth * 0.55,
                    ),
                    const SizedBox(height: 18),
                    _section(
                      title: s.badPlacement,
                      isPositive: false,
                      images: const [_badImage1, _badImage2],
                      imageWidth: (dialogWidth - 56) / 2,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
              child: _actionButtons(context, s),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required bool isPositive,
    required List<String> images,
    required double imageWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.35,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: images
              .map(
                (asset) => _imageWithBadge(
                  asset: asset,
                  isPositive: isPositive,
                  width: imageWidth,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _imageWithBadge({
    required String asset,
    required bool isPositive,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              asset,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                isPositive ? Icons.check_circle : Icons.cancel,
                color: isPositive ? Colors.green : Colors.red,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context, BookPlacementDialogStrings s) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton(
          onPressed: () async {
            await BookReadingPlacementDialog.markNeverShowAgain(
              prefsKey: prefsKey,
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Text(s.neverShowAgain),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.skip),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.understood),
        ),
      ],
    );
  }
}
