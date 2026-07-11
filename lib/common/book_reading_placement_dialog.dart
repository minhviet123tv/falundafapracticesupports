import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Dialog hướng dẫn đặt điện thoại khi đọc sách (tab Book).
class BookReadingPlacementDialog {
  static const String _prefsKey = 'book_reading_phone_placement_hint_v1';

  static Future<bool> shouldShow() async {
    final shared = await SharedPreferences.getInstance();
    return !(shared.getBool(_prefsKey) ?? false);
  }

  static Future<void> markNeverShowAgain() async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool(_prefsKey, true);
  }

  static Future<void> showIfNeeded(BuildContext context) async {
    if (!await shouldShow()) return;
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _BookReadingPlacementDialogContent(),
    );
  }
}

class _BookReadingPlacementDialogContent extends StatelessWidget {
  const _BookReadingPlacementDialogContent();

  static const String _goodImage = 'assets/images/dienthoai_nen_1.jpeg';
  static const String _badImage1 = 'assets/images/dienthoai_khongnen_1.jpg';
  static const String _badImage2 = 'assets/images/dienthoai_khongnen_2.png';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final dialogWidth = (screenWidth * 0.92).clamp(300.0, 420.0);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: dialogWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lưu ý khi đọc sách',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 20),
              _section(
                title: 'Nên đặt điện thoại trên giá đỡ và ở trên cao',
                isPositive: true,
                images: const [_goodImage],
                imageWidth: dialogWidth * 0.55,
              ),
              const SizedBox(height: 18),
              _section(
                title: 'Không nên đặt điện thoại dưới thấp khi đọc',
                isPositive: false,
                images: const [_badImage1, _badImage2],
                imageWidth: (dialogWidth - 56) / 2,
              ),
              const SizedBox(height: 22),
              _actionButtons(context),
            ],
          ),
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
            top: -6,
            right: -6,
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
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton(
          onPressed: () async {
            await BookReadingPlacementDialog.markNeverShowAgain();
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Không nhắc lại'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Bỏ qua'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Đã hiểu'),
        ),
      ],
    );
  }
}
