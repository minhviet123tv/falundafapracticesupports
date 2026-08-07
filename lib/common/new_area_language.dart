import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'language_menu_order.dart';

/// Ngôn ngữ chính (Home / About / hướng dẫn tập / privacy…).
/// Tập lựa chọn khớp Video 9 Lesson; gộp 3 mục Chinese của video
/// thành [chinese1] (正體) + [chinese2] (简体).
enum NewAreaLang {
  english('English'),
  vietnamese('Tiếng Việt'),
  chinese1('正體中文'),
  chinese2('中文简体'),
  bosanski('Bosanski'),
  deutsch('Deutsch'),
  espanol('Español'),
  farsi('فارسی'),
  francais('Français'),
  hebrew('עברית'),
  hrvatski('Hrvatski'),
  indonesia('Bahasa Indonesia'),
  italiano('Italiano'),
  japan('日本語'),
  korean('한국어'),
  polski('Polski'),
  portugues('Português'),
  russian('Русский'),
  slovencina('Slovenčina'),
  srpski('Српски'),
  thai('ไทย'),
  turkce('Türkçe'),
  ukrainian('Українська'),

  afrikaans('Afrikaans'),
  arabic('Arabic / العربية'),
  bangla('Bangla'),
  belarus('Belarus'),
  bungari('Български'),
  burmese('Burmese'),
  cesky('Česky'),
  dansk('Dansk'),
  eesti('Eesti'),
  greek('Ελληνικά'),
  hindi('Hindi / हिन्दी'),
  kannada('Kannada'),
  khmer('Khmer / ខ្មែរ'),
  latviski('Latviski'),
  laotian('Laotian / ລາວ'),
  lietuviu('Lietuvių'),
  magyar('Magyar'),
  macedonia('Македонски'),
  mongolia('Монгол / ᠮᠣᠩᠭᠣᠯ'),
  nederlands('Nederlands'),
  norsk('Norsk / Bokmål'),
  romana('Română'),
  sinhala('Sinhala / සිංහල'),
  slovenscina('Slovenščina'),
  suomi('Suomi'),
  svenska('Svenska'),
  shqip('Shqip / Albanian'),
  tibetan('Tibetan / བོད་ཡིག');

  const NewAreaLang(this.label);
  final String label;

  /// Có bản dịch UI/nội dung riêng; ngôn ngữ còn lại dùng tiếng Anh.
  bool get hasDedicatedTranslation => switch (this) {
        NewAreaLang.afrikaans ||
        NewAreaLang.arabic ||
        NewAreaLang.bangla ||
        NewAreaLang.belarus ||
        NewAreaLang.bungari ||
        NewAreaLang.burmese ||
        NewAreaLang.cesky ||
        NewAreaLang.dansk ||
        NewAreaLang.eesti ||
        NewAreaLang.greek ||
        NewAreaLang.hindi ||
        NewAreaLang.kannada ||
        NewAreaLang.khmer ||
        NewAreaLang.latviski ||
        NewAreaLang.laotian ||
        NewAreaLang.lietuviu ||
        NewAreaLang.magyar ||
        NewAreaLang.macedonia ||
        NewAreaLang.mongolia ||
        NewAreaLang.nederlands ||
        NewAreaLang.norsk ||
        NewAreaLang.romana ||
        NewAreaLang.sinhala ||
        NewAreaLang.slovenscina ||
        NewAreaLang.suomi ||
        NewAreaLang.svenska ||
        NewAreaLang.shqip ||
        NewAreaLang.tibetan =>
          false,
        _ => true,
      };

  static NewAreaLang fromName(String? name) {
    if (name == null || name.isEmpty) return NewAreaLang.english;
    for (final value in NewAreaLang.values) {
      if (value.name == name) return value;
    }
    return fromCanonical(name) ?? NewAreaLang.english;
  }

  /// null nếu canonical không thuộc vùng ngôn ngữ mới.
  static NewAreaLang? fromCanonical(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final code = raw.trim().toLowerCase().replaceAll('-', '_');
    final mapped = switch (code) {
      'en' || 'eng' || 'english' => NewAreaLang.english,
      'vi' || 'vn' || 'vietnamese' => NewAreaLang.vietnamese,
      'zh_tw' || 'zh_hk' || 'zh_hant' || 'chinese1' || 'chinese_traditional' =>
        NewAreaLang.chinese1,
      'zh' ||
      'zh_cn' ||
      'zh_hans' ||
      'chinese' ||
      'chinese2' ||
      'chinese_simplified' =>
        NewAreaLang.chinese2,
      'fr' || 'french' || 'francais' => NewAreaLang.francais,
      'de' || 'german' || 'deutsch' => NewAreaLang.deutsch,
      'es' || 'spanish' || 'espanol' => NewAreaLang.espanol,
      'it' || 'italian' || 'italiano' => NewAreaLang.italiano,
      'pt' || 'portuguese' || 'portugues' => NewAreaLang.portugues,
      'fa' || 'persian' || 'farsi' => NewAreaLang.farsi,
      'ja' || 'japanese' || 'japan' => NewAreaLang.japan,
      'ko' || 'korean' => NewAreaLang.korean,
      'th' || 'thai' => NewAreaLang.thai,
      'ru' || 'russian' => NewAreaLang.russian,
      'uk' || 'ukraina' || 'ukrainian' => NewAreaLang.ukrainian,
      'id' || 'indonesian' || 'indonesia' => NewAreaLang.indonesia,
      'tr' || 'turkce' => NewAreaLang.turkce,
      'pl' || 'polski' => NewAreaLang.polski,
      'hr' || 'hrvatski' => NewAreaLang.hrvatski,
      'bs' || 'bosanski' => NewAreaLang.bosanski,
      'sk' || 'slovencina' => NewAreaLang.slovencina,
      'sr' || 'srpski' => NewAreaLang.srpski,
      'he' || 'iw' || 'hebrew' => NewAreaLang.hebrew,
      'af' || 'afrikaans' => NewAreaLang.afrikaans,
      'ar' || 'arabic' => NewAreaLang.arabic,
      'bn' || 'bangla' || 'bengali' => NewAreaLang.bangla,
      'be' || 'belarus' || 'belarusian' => NewAreaLang.belarus,
      'bg' || 'bungari' || 'bulgarian' => NewAreaLang.bungari,
      'my' || 'burmese' || 'myanmar' => NewAreaLang.burmese,
      'cs' || 'cesky' || 'czech' => NewAreaLang.cesky,
      'da' || 'dansk' || 'danish' => NewAreaLang.dansk,
      'et' || 'eesti' || 'estonian' => NewAreaLang.eesti,
      'el' || 'greek' => NewAreaLang.greek,
      'hi' || 'hindi' => NewAreaLang.hindi,
      'kn' || 'kannada' => NewAreaLang.kannada,
      'km' || 'khmer' || 'cambodian' => NewAreaLang.khmer,
      'lv' || 'latviski' || 'latvian' => NewAreaLang.latviski,
      'lo' || 'laotian' || 'lao' => NewAreaLang.laotian,
      'lt' || 'lietuviu' || 'lithuanian' => NewAreaLang.lietuviu,
      'hu' || 'magyar' || 'hungarian' => NewAreaLang.magyar,
      'mk' || 'macedonia' || 'macedonian' => NewAreaLang.macedonia,
      'mn' || 'mongolia' || 'mongolian' => NewAreaLang.mongolia,
      'nl' || 'nederlands' || 'dutch' => NewAreaLang.nederlands,
      'no' || 'nb' || 'nn' || 'norsk' || 'norwegian' => NewAreaLang.norsk,
      'ro' || 'romana' || 'rumani' || 'romanian' => NewAreaLang.romana,
      'si' || 'sinhala' || 'sinhalese' => NewAreaLang.sinhala,
      'sl' || 'slovenscina' || 'slovenian' => NewAreaLang.slovenscina,
      'fi' || 'suomi' || 'finnish' => NewAreaLang.suomi,
      'sv' || 'svenska' || 'swedish' => NewAreaLang.svenska,
      'sq' || 'shqip' || 'albanian' => NewAreaLang.shqip,
      'bo' || 'tibetan' => NewAreaLang.tibetan,
      _ => null,
    };
    if (mapped != null) return mapped;
    for (final value in NewAreaLang.values) {
      if (value.name == code) return value;
    }
    return null;
  }
}

class NewAreaLanguageKeys {
  static const String aboutApp = 'new_area_lang_about_app';
  static const String huongDanTapCoBan = 'new_area_lang_huong_dan_tap_co_ban';
  static const String privacyPolicy = 'new_area_lang_privacy_policy';
}

class NewAreaLanguageStore {
  static Future<NewAreaLang> load(String prefsKey) async {
    final shared = await SharedPreferences.getInstance();
    final saved = shared.getString(prefsKey);
    if (saved != null && saved.isNotEmpty) {
      return NewAreaLang.fromName(saved);
    }
    final preferred = shared.getString('app_preferred_language_v1');
    return NewAreaLang.fromCanonical(preferred) ?? NewAreaLang.english;
  }

  /// Chỉ lưu key vùng này (đồng bộ toàn cục gọi [AppLanguageSync.onUserSelected]).
  static Future<void> saveLocal(String prefsKey, NewAreaLang lang) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(prefsKey, lang.name);
  }
}

/// Menu chọn ngôn ngữ dùng chung cho Vùng ngôn ngữ mới.
class NewAreaLanguageMenu extends StatelessWidget {
  final NewAreaLang current;
  final List<NewAreaLang> available;
  final ValueChanged<NewAreaLang> onChanged;
  final Color? textColor;

  const NewAreaLanguageMenu({
    required this.current,
    required this.onChanged,
    this.available = NewAreaLang.values,
    this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Colors.black87;
    return PopupMenuButton<NewAreaLang>(
      tooltip: 'Language',
      position: PopupMenuPosition.under,
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 420),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: onChanged,
      itemBuilder: (context) {
        final ordered = LanguageMenuOrder.sort(
          available,
          name: (e) => e.name,
          label: (e) => e.label,
        );
        return ordered
            .map(
              (value) => PopupMenuItem<NewAreaLang>(
                value: value,
                height: 40,
                child: Text(
                  value.label,
                  style: TextStyle(
                    fontWeight:
                        value == current ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            )
            .toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: Text(
                current.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}
