
//I. Model lưu liên kết để sử dụng
class ModelOpenUrl {
  String link;
  String languageName;
  String languageCode;
  ModelOpenUrl(this.link, this.languageName, this.languageCode);
}

enum FalundafaEnum {
  english("https://en.falundafa.org/?v=bks04", "English", "english"),
  chinese("https://gb.falundafa.org/?v=bks04", "中文简体", "chinese"),
  afrikaans("https://af.falundafa.org/?v=bks04", "Afrikaans", "afrikaans"),
  arabic("https://ar.falundafa.org/?v=bks04", "Arabic / العربية", "arabic"),
  bangla("https://ba.falundafa.org/?v=bks04", "Bangla", "bangla"),
  bosanski("https://bs.falundafa.org/?v=bks04", "Bosanski", "bosanski"),
  belarus("https://by.falundafa.org/?v=bks04", "Belarus", "belarus"),
  bungari("https://bg.falundafa.org/?v=bks04", "Български", "bungari"),
  burmese("https://www.falundafa.org/eng/language/burmese.html?v=bks04", "Burmese", "burmese"),
  cesky("https://cs.falundafa.org/?v=bks04", "Česky", 'cesky'),
  dansk("https://da.falundafa.org/?v=bks04", "Dansk", 'dansk'),
  deutsch("https://de.falundafa.org/?v=bks04", "Deutsch", "deutsch"),
  espanol("https://es.falundafa.org/?v=bks04", "Español", "espanol"),
  eesti("https://en.falundafa.org/language/estonian.html?v=bks04", "Eesti", 'eesti'),
  greek("https://el.falundafa.org/?v=bks04", "Ελληνικά", 'greek'),
  farsi("https://fa.falundafa.org/?v=bks04", "Farsi / فارسی", 'farsi'),
  francais("https://fr.falundafa.org/?v=bks04", "Français", 'francais'),
  hebrew("https://he.falundafa.org/?v=bks04", "עברית", 'hebrew'),
  hindi("https://hi.falundafa.org/?v=bks04", "Hindi / हिन्दी", 'hindi'),
  hrvatski("https://hr.falundafa.org/?v=bks04", "Hrvatski", 'hrvatski'),
  indonesia("https://id.falundafa.org/?v=bks04", "Bahasa Indonesia", 'indonesia'),
  italiano("https://it.falundafa.org/?v=bks04", "Italiano", 'italiano'),
  kannada("https://kn.falundafa.org/?v=bks04", "Kannada", 'kannada'),
  latviski("https://lv.falundafa.org/?v=bks04", "Latviski", 'latviski'),
  lietuviu( "https://falundafa.org/eng/language/lithuanian.html?v=bks04", "Lietuvių", 'lietuviu'),
  laotian("https://en.falundafa.org/language/laotian.html?v=bks04", "Laotian / ລາວ", 'laotian'),
  magyar("https://hu.falundafa.org/?v=bks04", "Magyar", 'magyar'),
  macedonia("https://mk.falundafa.org/?v=bks04", "Македонски", 'macedonia'),
  mongolia("https://mn.falundafa.org/?v=bks04", "Монгол / ᠮᠣᠩᠭᠣᠯ", 'mongolia'),
  nederlands("https://nl.falundafa.org/?v=bks04", "Nederlands", 'nederlands'),
  japan("https://ja.falundafa.org/?v=bks04", "Japan / 日本語", 'japan'),
  khmer("https://kh.falundafa.org/falun-dafa-books.html?v=bks04", "Khmer / ខ្មែរ", 'khmer'),
  norsk("https://no.falundafa.org/?v=bks04", "Norsk / Bokmål", 'norsk'),
  polski("https://pl.falundafa.org/?v=bks04", "Polski", 'polski'),
  portugues("https://pt.falundafa.org/?v=bks04", "Português", 'portugues'),
  romana("https://ro.falundafa.org/?v=bks04", "Română", 'romana'),
  russian("https://rus.falundafa.org/?v=bks04", "Русский", 'russian'),
  sinhala("https://lk.falundafa.org/?v=bks04", "Sinhala / සිංහල", 'sinhala'),
  slovencina("https://sk.falundafa.org/?v=bks04", "Slovenčina", 'slovencina'),
  slovenscina("https://sl.falundafa.org/?v=bks04", "Slovenščina", 'slovenscina'),
  srpski("https://sr.falundafa.org/?v=bks04", "Srpski / Српски", 'srpski'),
  suomi("https://fi.falundafa.org/?v=bks04", "Suomi", 'suomi'),
  svenska("https://sv.falundafa.org/?v=bks04", "Svenska", 'svenska'),
  shqip("https://sq.falundafa.org/?v=bks04", "Shqip / Albanian", 'shqip'),
  korean("https://ko.falundafa.org/?v=bks04", "Korean / 한국어", 'korean'),
  thai("https://th.falundafa.org/?v=bks04", "Thai / ไทย", 'thai'),
  tibetan("https://www.falundafa.org/eng/language/tibetan.html?v=bks04", "Tibetan / བོད་ཡིག", 'tibetan'),
  vietnamese("https://vn.falundafa.org/", "Tiếng Việt", 'vietnamese'), // https://vi.falundafa.org/?v=bks04
  turkce("https://tr.falundafa.org/?v=bks04", "Türkçe", 'turkce'),
  ukrainian("https://uk.falundafa.org/?v=bks04", "Ukrainian / Українська", 'ukrainian')
  ;

  final String url;
  final String languageName;
  final String languageCode;
  const FalundafaEnum (this.url, this.languageName, this.languageCode);

  // Hàm hỗ trợ tìm enum từ languageCode
  static FalundafaEnum fromCode(String code) {
    return FalundafaEnum.values.firstWhere(
          (e) => e.languageCode == code,
      orElse: () => FalundafaEnum.english, // Giá trị mặc định nếu không tìm thấy
    );
  }
}

//II. Các danh sách liên kết
enum MinghuiEnum {
  english("https://en.minghui.org/", "English", "english"),
  chinese1("https://big5.minghui.org/", "正體中文", "chinese1"), // phồn thể
  chinese2("https://www.minghui.org/", "简体中文", 'chinese2'), // giản thể
  arabic("https://ar.minghui.org/", "العربية", "arabic"),
  bosanski("https://bs.minghui.org/", "Bosanski", "bosanski"),
  cesky("https://cs.minghui.org/", "Česky", 'cesky'),
  deutsch("https://de.minghui.org/", "Deutsch", "deutsch"),
  espanol("https://es.minghui.org/", "Español", 'espanol'),
  farsi("https://fa.minghui.org/", "فارسی", 'farsi'),
  francais("https://fr.minghui.org/", "Francais", 'francais'),
  hebrew("https://he.minghui.org/", "עברית", 'hebrew'),
  hrvatski("https://hr.minghui.org/", "Hrvatski", 'hrvatski'),
  indonesia("https://id.minghui.org/", "Indonesian", 'indonesia'),
  italiano("https://it.minghui.org/", "Italiano", 'italiano'),
  japan("https://jp.minghui.org/", "日本語", 'japan'),
  korean("https://www.minghui.or.kr/", "한국어", 'korean'),
  polski("https://pl.minghui.org/", "Polski", 'polski'),
  portugues("https://pt.minghui.org/", "Português", 'portugues'),
  russian("https://ru.minghui.org/", "Русский", 'russian'),
  slovencina("https://sk.minghui.org/", "Slovenčina", 'slovencina'),
  srpski("https://sr.minghui.org/", "Српски", 'srpski'),
  thai("https://th.minghui.org/", "ไทย", 'thai'),
  vietnamese("https://daiphap.org/vn.minghui.org%2Fnews", "Tiếng Việt", 'vietnamese'), // https://vi.minghui.org/news
  turkce("https://tr.minghui.org/", "Türkçe", 'turkce'),
  ukrainian("https://uk.minghui.org/", "Українська", 'ukrainian')
  ;

  final String url;
  final String languageName;
  final String languageCode;
  const MinghuiEnum (this.url, this.languageName, this.languageCode);

  // Hàm hỗ trợ tìm enum từ languageCode
  static MinghuiEnum fromCode(String code) {
    return MinghuiEnum.values.firstWhere(
          (e) => e.languageCode == code,
      orElse: () => MinghuiEnum.english, // Giá trị mặc định nếu không tìm thấy
    );
  }
}

//II. Danh sách liên kết ngôn ngữ bài viết "Vì sao có nhân loại" (Không trùng số lượng ngôn ngữ với trang minghui.org)
enum VisaoconhanloaiEnum {
  english("https://en.falundafa.org/eng/articles/20230120A.html", "English", "english"),
  chinese1("https://big5.minghui.org/mh/articles/2023/1/20/%E7%82%BA%E7%94%9A%E9%BA%BC%E6%9C%83%E6%9C%89%E4%BA%BA%E9%A1%9E-455562.html", "正體中文", "chinese1"), // giản thể
  chinese2("https://www.minghui.org/mh/articles/2023/1/20/%E4%B8%BA%E4%BB%80%E4%B9%88%E4%BC%9A%E6%9C%89%E4%BA%BA%E7%B1%BB-455562.html", "中文简体", "chinese2"), // phồn thể
  bosanski("https://bs.minghui.org/articles/6858", "Bosanski", "bosanski"),
  deutsch("https://de.minghui.org/html/articles/2023/1/23/165840.html", "Deutsch", "deutsch"),
  espanol("https://es.minghui.org/html/articles/2023/1/21/126075.html", "Español", 'espanol'),
  farsi("https://fa.minghui.org/html/articles/2023/1/21/133405.html", "فارسی", 'farsi'),
  francais("https://fr.minghui.org/html/articles/2023/1/21/103887.html", "Français", 'francais'),
  hebrew("https://he.minghui.org/html/articles/2023/1/23/41878.html", "עברית", 'hebrew'),
  hrvatski("https://hr.minghui.org/articles/6858", "Hrvatski", 'hrvatski'),
  indonesia("https://id.minghui.org/html/articles/2023/1/25/130727.html", "Bahasa Indonesia", 'indonesia'),
  italiano("https://it.minghui.org/html/articles/2023/1/25/21201.html", "Italiano", 'italiano'),
  japan("https://jp.minghui.org/2023/01/23/89043.html", "日本語", 'japan'),
  korean("https://www.minghui.or.kr/archives/masters-recent-articles/118601", "한국어", 'korean'),
  polski("https://pl.minghui.org/html/articles/2023/1/23/911.html", "Polski", 'polski'),
  portugues("https://pt.minghui.org/html/articles/2023/1/21/8438.html", "Português", 'portugues'),
  russian("https://ru.minghui.org/html/articles/2023/1/21/1172085.html", "Русский", 'russian'),
  slovencina("https://sk.minghui.org/2023/01/21/preco-existuje-ludstvo", "Slovenčina", 'slovencina'),
  srpski("https://sr.minghui.org/articles/6858", "Српски", 'srpski'),
  thai("https://th.minghui.org/html/articles/2023/1/31/3010.html", "ไทย", 'thai'),
  vietnamese("https://daiphap.org/vn.minghui.org/news/241240-vi-sao-co-nhan-loai.html", "Tiếng Việt", 'vietnamese'),
  turkce("https://tr.minghui.org/html/articles/2023/1/24/11239.html", "Türkçe", 'turkce'),
  ukrainian("https://uk.minghui.org/html/articles/2023/1/20/1155.html", "Українська", 'ukrainian')
  ;

  // Các tham số và hàm khởi tạo
  final String url;
  final String languageName;
  final String languageCode;
  const VisaoconhanloaiEnum(this.url, this.languageName, this.languageCode);

  static VisaoconhanloaiEnum fromCode(String code) {
    return VisaoconhanloaiEnum.values.firstWhere(
          (e) => e.languageCode == code,
      orElse: () => VisaoconhanloaiEnum.english, // Giá trị mặc định nếu không tìm thấy
    );
  }

}
