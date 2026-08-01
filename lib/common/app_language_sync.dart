import 'dart:ui' show PlatformDispatcher;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/controller_app/link_all_page_and_api_enum.dart';
import 'package:falun_dafa_practice_supports/controller_app/link_internet_list_baigiang_quocte.dart';
import 'package:falun_dafa_practice_supports/controller_app/link_internet_sachchuyenphapluan_quocte.dart';

/// Đồng bộ ngôn ngữ toàn app trong phạm vi ngôn ngữ mà từng vùng hỗ trợ.
class AppLanguageSync {
  static const String preferredKey = 'app_preferred_language_v1';
  static const String initializedKey = 'app_language_initialized_v1';

  /// Chuẩn hoá alias giữa các enum khác nhau về một canonical code.
  static String canonicalize(String raw) {
    final c = raw.trim().toLowerCase().replaceAll('-', '_');
    switch (c) {
      case 'en':
      case 'eng':
        return 'english';
      case 'vi':
      case 'vn':
        return 'vietnamese';
      case 'fr':
      case 'french':
        return 'francais';
      case 'de':
      case 'german':
        return 'deutsch';
      case 'es':
      case 'spanish':
        return 'espanol';
      case 'it':
      case 'italian':
        return 'italiano';
      case 'pt':
      case 'portuguese':
        return 'portugues';
      case 'fa':
      case 'persian':
        return 'farsi';
      case 'ja':
      case 'japanese':
        return 'japan';
      case 'ko':
        return 'korean';
      case 'th':
        return 'thai';
      case 'ru':
        return 'russian';
      case 'uk':
      case 'ukraina':
        return 'ukrainian';
      case 'ro':
      case 'rumani':
      case 'romana':
        return 'romana';
      case 'bg':
      case 'bulgarian':
      case 'bungari':
        return 'bungari';
      case 'zh':
      case 'zh_cn':
      case 'zh_hans':
      case 'chinese':
      case 'chinese_simplified':
      case 'chinesesimplified':
      case 'chinese2':
        return 'chinese2';
      case 'zh_tw':
      case 'zh_hk':
      case 'zh_hant':
      case 'chinese_traditional':
      case 'chinesetraditional':
      case 'chinese1':
        return 'chinese1';
      case 'id':
      case 'indonesian':
        return 'indonesia';
      case 'tr':
        return 'turkce';
      case 'pl':
        return 'polski';
      case 'hr':
        return 'hrvatski';
      case 'bs':
        return 'bosanski';
      case 'sk':
        return 'slovencina';
      case 'sr':
        return 'srpski';
      case 'he':
      case 'iw':
        return 'hebrew';
      case 'cs':
      case 'cesky':
        return 'cesky';
      case 'el':
      case 'greek':
        return 'greek';
      case 'hu':
      case 'magyar':
        return 'magyar';
      case 'fi':
      case 'suomi':
        return 'suomi';
      case 'sv':
      case 'svenska':
        return 'svenska';
      case 'nl':
      case 'nederlands':
        return 'nederlands';
      case 'ar':
      case 'arabic':
        return 'arabic';
      default:
        return c;
    }
  }

  static String fromDeviceLocale() {
    final locale = PlatformDispatcher.instance.locale;
    final candidates = <String>[
      if (locale.scriptCode != null)
        '${locale.languageCode}_${locale.scriptCode}',
      if (locale.countryCode != null)
        '${locale.languageCode}_${locale.countryCode}',
      locale.languageCode,
    ];
    for (final raw in candidates) {
      final code = canonicalize(raw);
      if (_isKnownCanonical(code)) return code;
    }
    return 'english';
  }

  static bool _isKnownCanonical(String code) {
    if (NewAreaLang.values.any((e) => e.name == code)) return true;
    if (VisaoconhanloaiEnum.values.any((e) => e.languageCode == code)) {
      return true;
    }
    if (MinghuiEnum.values.any((e) => e.languageCode == code)) return true;
    if (FalundafaEnum.values.any((e) => e.languageCode == code)) return true;
    if (LanguageAllPageFalundafa.values.any((e) => e.name == code)) return true;
    if (LanguageNameOfChuyenPhapLuan.values.any((e) => e.name == code)) {
      return true;
    }
    if (LanguageNameAndCode.values.any((e) => e.name == code)) return true;
    // aliases already canonicalized above
    const aliases = {
      'francais',
      'deutsch',
      'espanol',
      'italiano',
      'portugues',
      'farsi',
      'japan',
      'korean',
      'thai',
      'russian',
      'ukrainian',
      'romana',
      'bungari',
      'chinese1',
      'chinese2',
      'english',
      'vietnamese',
    };
    return aliases.contains(code);
  }

  static Future<String?> preferredOrNull() async {
    final shared = await SharedPreferences.getInstance();
    final raw = shared.getString(preferredKey);
    if (raw == null || raw.isEmpty) return null;
    return canonicalize(raw);
  }

  static Future<String> preferredOrEnglish() async {
    return await preferredOrNull() ?? 'english';
  }

  /// Lần đầu mở app (sau khi có sync): chọn theo ngôn ngữ máy.
  /// Nếu user đã có prefs ngôn ngữ từ bản cũ — giữ và đồng bộ, không ghi đè bằng locale máy.
  static Future<void> bootstrapFromDeviceIfNeeded() async {
    final shared = await SharedPreferences.getInstance();
    if (shared.getBool(initializedKey) == true) return;

    final existingPreferred = shared.getString(preferredKey);
    final existingAny = shared.getString('languageEnum') ??
        shared.getString('LanguageNameOfChuyenPhapLuan') ??
        shared.getString(NewAreaLanguageKeys.aboutApp) ??
        shared.getString(NewAreaLanguageKeys.huongDanTapCoBan) ??
        shared.getString('languageCodeVisaoconhanloai') ??
        shared.getString('languageCodeMinghui') ??
        shared.getString('LanguageAllPageFalundafa');

    if (existingPreferred != null && existingPreferred.isNotEmpty) {
      await applyEverywhere(existingPreferred);
    } else if (existingAny != null && existingAny.isNotEmpty) {
      await applyEverywhere(existingAny);
    } else {
      await applyEverywhere(fromDeviceLocale());
    }
    await shared.setBool(initializedKey, true);
  }

  /// Khi user chọn ngôn ngữ ở bất kỳ vùng nào.
  static Future<void> onUserSelected(String rawCode) async {
    final code = canonicalize(rawCode);
    await applyEverywhere(code);
    final shared = await SharedPreferences.getInstance();
    await shared.setBool(initializedKey, true);
  }

  /// Ghi preferred + cập nhật mọi vùng CÓ hỗ trợ ngôn ngữ đó.
  static Future<void> applyEverywhere(String rawCode) async {
    final code = canonicalize(rawCode);
    final shared = await SharedPreferences.getInstance();
    await shared.setString(preferredKey, code);

    // Vùng ngôn ngữ mới
    final newArea = NewAreaLang.fromCanonical(code);
    if (newArea != null) {
      await shared.setString(NewAreaLanguageKeys.aboutApp, newArea.name);
      await shared.setString(NewAreaLanguageKeys.huongDanTapCoBan, newArea.name);
      await shared.setString(NewAreaLanguageKeys.privacyPolicy, newArea.name);
    }

    // Humankind
    final humankind = _matchVisao(code);
    if (humankind != null) {
      await shared.setString(
          'languageCodeVisaoconhanloai', humankind.languageCode);
    }

    // Minghui
    final minghui = _matchMinghui(code);
    if (minghui != null) {
      await shared.setString('languageCodeMinghui', minghui.languageCode);
    }

    // Falundafa OpenUrl
    final falun = _matchFalundafa(code);
    if (falun != null) {
      await shared.setString('languageCodeFalundafa', falun.languageCode);
    }

    // All Books
    final allBooks = _matchAllBooks(code);
    if (allBooks != null) {
      await shared.setString('LanguageAllPageFalundafa', allBooks.name);
    }

    // Book / CPL
    final cpl = _matchCpl(code);
    if (cpl != null) {
      await shared.setString('LanguageNameOfChuyenPhapLuan', cpl.name);
    }

    // 9 Lesson
    final lesson = _matchLesson(code);
    if (lesson != null) {
      await shared.setString('languageEnum', lesson.name);
    }
  }

  static VisaoconhanloaiEnum? _matchVisao(String code) {
    for (final e in VisaoconhanloaiEnum.values) {
      if (canonicalize(e.languageCode) == code || canonicalize(e.name) == code) {
        return e;
      }
    }
    return null;
  }

  static MinghuiEnum? _matchMinghui(String code) {
    for (final e in MinghuiEnum.values) {
      if (canonicalize(e.languageCode) == code || canonicalize(e.name) == code) {
        return e;
      }
    }
    return null;
  }

  static FalundafaEnum? _matchFalundafa(String code) {
    for (final e in FalundafaEnum.values) {
      if (canonicalize(e.languageCode) == code || canonicalize(e.name) == code) {
        return e;
      }
    }
    return null;
  }

  /// Link trang toàn bộ sách (`booksPage`) theo mã ngôn ngữ đang chọn.
  /// Không khớp → mặc định tiếng Anh.
  static String booksPageUrlForLanguage(String languageCode) {
    final matched = _matchAllBooks(canonicalize(languageCode));
    return matched?.booksPage ?? LanguageAllPageFalundafa.english.booksPage;
  }

  static LanguageAllPageFalundafa? _matchAllBooks(String code) {
    for (final e in LanguageAllPageFalundafa.values) {
      if (canonicalize(e.name) == code || canonicalize(e.languageCode) == code) {
        return e;
      }
    }
    // chinese aliases
    if (code == 'chinese2') {
      return LanguageAllPageFalundafa.chinese;
    }
    if (code == 'chinese1') {
      return LanguageAllPageFalundafa.chinese_traditional;
    }
    if (code == 'francais') {
      return LanguageAllPageFalundafa.francais;
    }
    if (code == 'farsi') return LanguageAllPageFalundafa.farsi;
    if (code == 'bungari') return LanguageAllPageFalundafa.bungari;
    if (code == 'romana') return LanguageAllPageFalundafa.romana;
    return null;
  }

  static LanguageNameOfChuyenPhapLuan? _matchCpl(String code) {
    for (final e in LanguageNameOfChuyenPhapLuan.values) {
      if (canonicalize(e.name) == code) return e;
    }
    if (code == 'chinese2' || code == 'chinese') {
      return LanguageNameOfChuyenPhapLuan.chinese;
    }
    if (code == 'chinese1') {
      return LanguageNameOfChuyenPhapLuan.ChineseTraditional;
    }
    if (code == 'francais') {
      // CPL may not have french — skip
      return null;
    }
    if (code == 'romana' || code == 'rumani') {
      try {
        return LanguageNameOfChuyenPhapLuan.values
            .firstWhere((e) => e.name == 'rumani');
      } catch (_) {
        return null;
      }
    }
    if (code == 'ukrainian') {
      try {
        return LanguageNameOfChuyenPhapLuan.values
            .firstWhere((e) => e.name == 'ukraina');
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static LanguageNameAndCode? _matchLesson(String code) {
    for (final e in LanguageNameAndCode.values) {
      if (canonicalize(e.name) == code) return e;
    }
    if (code == 'francais') return LanguageNameAndCode.french;
    if (code == 'farsi') return LanguageNameAndCode.persian;
    if (code == 'romana') return LanguageNameAndCode.rumani;
    if (code == 'ukrainian') return LanguageNameAndCode.ukraina;
    if (code == 'bungari') return LanguageNameAndCode.bulgarian;
    if (code == 'chinese2' || code == 'chinese') {
      return LanguageNameAndCode.chinese;
    }
    return null;
  }
}
