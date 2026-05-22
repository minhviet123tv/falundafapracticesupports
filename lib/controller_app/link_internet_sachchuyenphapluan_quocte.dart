
//I. Danh sách trang tất cả các kinh văn, sách của tất cả các ngôn ngữ hiện có (Theo thứ tự trong trang falundafa.org)
// Cấu trúc: Tên ngôn ngữ gốc, tên tiếng Anh, link dẫn về trang chủ falundafa, link dấn đến trang tất cả các kinh sách
enum LanguageAllPageFalundafa {
  english("English", "english", "https://en.falundafa.org/?v=bks04", "https://en.falundafa.org/falun-dafa-books.html?v=bks04"),
  chinese("中文简体", "chinese", "https://gb.falundafa.org/?v=bks04", "https://gb.falundafa.org/falun-dafa-books.html"),
  afrikaans("Afrikaans", "afrikaans", "https://af.falundafa.org/?v=bks04", "https://af.falundafa.org/falun-dafa-books.html?v=bks04"),
  arabic("Arabic / العربية", "arabic", "https://ar.falundafa.org/?v=bks04", "https://ar.falundafa.org/falun-dafa-books.html?v=bks04"),
  bangla("Bangla", "bangla", "https://ba.falundafa.org/?v=bks04","https://ba.falundafa.org/falun-dafa-books.html?v=bks04"),
  bosanski("Bosanski", "bosanski", "https://bs.falundafa.org/?v=bks04", "https://bs.falundafa.org/falun-dafa-books.html?v=bks04"),
  belarus("Belarus", "belarus", "https://by.falundafa.org/?v=bks04", "https://by.falundafa.org/falun-dafa-books.html?v=bks04"),
  bungari("Български", "bungari", "https://bg.falundafa.org/?v=bks04", "https://bg.falundafa.org/falun-dafa-books.html?v=bks04"),
  burmese("Burmese", "burmese", "https://www.falundafa.org/eng/language/burmese.html?v=bks04", "https://www.falundafa.org/eng/language/burmese.html"),
  cesky("Česky", 'cesky', "https://cs.falundafa.org/?v=bks04", "https://cs.falundafa.org/falun-dafa-books.html?v=bks04"),
  chinese_simplified("Chinese (simplified)","chinese_simplified", "https://gb.falundafa.org/", "https://gb.falundafa.org/falun-dafa-books.html"),
  chinese_traditional("Chinese (traditional)", "chinese_traditional", "https://big5.falundafa.org/", "https://big5.falundafa.org/falun-dafa-books.html"),
  dansk("Dansk", 'dansk', "https://da.falundafa.org/", "https://da.falundafa.org/falun-dafa-books.html?v=bks04"),
  deutsch("Deutsch", "deutsch", "https://de.falundafa.org/?v=bks04", "https://de.falundafa.org/buecher.html?v=bks04"),
  espanol("Español", "espanol", "https://es.falundafa.org/?v=bks04", "https://es.falundafa.org/falun-dafa-books.html?v=bks04"),
  eesti("Eesti", 'eesti', "https://en.falundafa.org/language/estonian.html?v=bks04", "https://en.falundafa.org/language/estonian.html"),
  greek("Ελληνικά", 'greek', "https://el.falundafa.org/?v=bks04", "https://el.falundafa.org/falun-dafa-books.html?v=bks04"),
  farsi("Farsi / فارسی", 'farsi', "https://fa.falundafa.org/?v=bks04", "https://fa.falundafa.org/falun-dafa-books.html?v=bks04"),
  francais("Français", 'francais', "https://fr.falundafa.org/?v=bks04", "https://fr.falundafa.org/falun-dafa-books.html?v=bks04"),
  hebrew("עברית", 'hebrew', "https://he.falundafa.org/?v=bks04", "https://he.falundafa.org/falun-dafa-books.html?v=bks04"),
  hindi("Hindi / हिन्दी", 'hindi', "https://hi.falundafa.org/?v=bks04", "https://hi.falundafa.org/falun-dafa-books.html?v=bks04"),
  hrvatski("Hrvatski", 'hrvatski', "https://hr.falundafa.org/?v=bks04", "https://hr.falundafa.org/falun-dafa-books.html?v=bks04"),
  indonesia("Bahasa Indonesia", 'indonesia', "https://id.falundafa.org/?v=bks04", "https://id.falundafa.org/falun-dafa-books.html?v=bks04"),
  italiano("Italiano", 'italiano', "https://it.falundafa.org/?v=bks04", "https://it.falundafa.org/falun-dafa-books.html?v=bks04"),
  kannada("Kannada", 'kannada', "https://kn.falundafa.org/?v=bks04", "https://kn.falundafa.org/"),
  latviski("Latviski", 'latviski', "https://lv.falundafa.org/?v=bks04", "https://lv.falundafa.org/"),
  lietuviu("Lietuvių", 'lietuviu', "https://falundafa.org/eng/language/lithuanian.html?v=bks04", "https://falundafa.org/eng/language/lithuanian.html"),
  laotian("Laotian / ລາວ", 'laotian', "https://en.falundafa.org/language/laotian.html?v=bks04", "https://en.falundafa.org/language/laotian.html"),
  magyar("Magyar", 'magyar', "https://hu.falundafa.org/?v=bks04", "https://hu.falundafa.org/"),
  macedonia("Македонски", 'macedonia', "https://mk.falundafa.org/?v=bks04", "https://mk.falundafa.org/falun-dafa-books.html?v=bks04"),
  mongolia("Монгол / ᠮᠣᠩᠭᠣᠯ", 'mongolia', "https://mn.falundafa.org/?v=bks04", "https://mn.falundafa.org/falun-dafa-books.html?v=bks04"),
  nederlands("Nederlands", 'nederlands', "https://nl.falundafa.org/?v=bks04", "https://nl.falundafa.org/falun-dafa-books.html"),
  japan("Japan / 日本語", 'japan', "https://ja.falundafa.org/?v=bks04", "https://ja.falundafa.org/falun-dafa-books.html?v=bks04"),
  khmer("Khmer / ខ្មែរ", 'khmer', "https://kh.falundafa.org/falun-dafa-books.html?v=bks04", "https://kh.falundafa.org/falun-dafa-books.html"),
  norsk("Norsk / Bokmål", 'norsk', "https://no.falundafa.org/?v=bks04", "https://no.falundafa.org/falun-dafa-books.html?v=bks04"),
  polski("Polski", 'polski', "https://pl.falundafa.org/?v=bks04", "https://pl.falundafa.org/falun-dafa-books.html"),
  portugues("Português", 'portugues', "https://pt.falundafa.org/?v=bks04", "https://pt.falundafa.org/falun-dafa-livros.html?v=bks04"),
  romana("Română", 'romana', "https://ro.falundafa.org/?v=bks04", "https://ro.falundafa.org/falun-dafa-books.html?v=bks04"),
  russian("Русский", 'russian', "https://rus.falundafa.org/?v=bks04", "https://rus.falundafa.org/falun-dafa-books.html?v=bks04"),
  sinhala("Sinhala / සිංහල", 'sinhala', "https://lk.falundafa.org/?v=bks04", "https://lk.falundafa.org/falun-dafa-books.html?v=bks04"),
  slovencina("Slovenčina", 'slovencina', "https://sk.falundafa.org/?v=bks04", "https://sk.falundafa.org/knihy.html?v=bks04"),
  slovenscina("Slovenščina", 'slovenscina', "https://sl.falundafa.org/?v=bks04", "https://sl.falundafa.org/falun-dafa-books.html?v=bks04"),
  srpski("Srpski / Српски", 'srpski', "https://sr.falundafa.org/?v=bks04", "https://sr.falundafa.org/"),
  suomi("Suomi", 'suomi', "https://fi.falundafa.org/?v=bks04", "https://fi.falundafa.org/falun-dafa-books.html?v=bks04"),
  svenska("Svenska", 'svenska', "https://sv.falundafa.org/?v=bks04", "https://sv.falundafa.org/falun-dafa-books.html?v=bks04"),
  shqip("Shqip / Albanian", 'shqip', "https://sq.falundafa.org/?v=bks04", "https://sq.falundafa.org/falun-dafa-books.html?v=bks04"),
  korean("Korean / 한국어", 'korean', "https://ko.falundafa.org/?v=bks04", "https://ko.falundafa.org/falun-dafa-books.html"),
  thai("Thai / ไทย", 'thai', "https://th.falundafa.org/?v=bks04", "https://th.falundafa.org/falun-dafa-books.html?v=bks04"),
  tibetan("Tibetan / བོད་ཡིག", 'tibetan', "https://www.falundafa.org/eng/language/tibetan.html?v=bks04", "https://tr.falundafa.org/books.html?v=bks04"),
  vietnamese("Tiếng Việt", 'vietnamese', "https://vn.falundafa.org/index.html", "https://vn.falundafa.org/falun-dafa-books.html"),
  turkce("Türkçe", 'turkce', "https://tr.falundafa.org/?v=bks04", "https://tr.falundafa.org/books.html?v=bks04"),
  ukrainian("Ukrainian / Українська", 'ukrainian', "https://uk.falundafa.org/?v=bks04", "https://uk.falundafa.org/falun-dafa-books.html?v=bks05")
  ;

  final String languageName;
  final String languageCode;
  final String homePage;
  final String booksPage;
  const LanguageAllPageFalundafa(this.languageName, this.languageCode, this.homePage, this.booksPage);
}


//II. Danh sách ngôn ngữ có thể đọc sách Chuyển Pháp Luân online bằng html | Dùng enum sẽ tạo độ chính xác chắc chắn cho mã code (không bị lỗi do đọc String không chính xác theo ký tự đặc biệt của nhiêu ngôn ngữ)
enum LanguageNameOfChuyenPhapLuan {
  english("English", "https://en.falundafa.org/eng/zfl_2018.html?v=bks04"), //  https://en.falundafa.org/falun-dafa-books.html?v=bks04
  chinese("中文简体","https://gb.falundafa.org/chigb/zfl.htm"),
  korean("한국어", "https://www.dafamedia.or.kr/book/HTML/zfl"),
  japan("日本語", "https://ja.falundafa.org/book/html/ZFL_J_content.html"),
  thai("ไทย", "https://th.falundafa.org/books/ZHUAN_FALUN/ZHUAN_FALUN_THAI_2016-07-08.htm"),
  cesky("Česky", "https://cs.falundafa.org/literatura/zhuan_falun_2015.html?v=bks04"),
  chineseSimplified("Chinese \n(simplified)", "https://gb.falundafa.org/chigb/zfl.htm"),
  ChineseTraditional("Chinese \n(traditional)", "https://big5.falundafa.org/chibig5/zfl.htm"),
  deutsch("Deutsch", "https://de.falundafa.org/buecher_online/zhuanfalun_2019/zf_2019_index.html?v=bks04"),
  espanol("Español", "https://es.falundafa.org/docs/zfl-2017/zfl-es-00-2017.html?v=bks04"),
  greek("Ελληνικά", "https://www.falundafa.gr/fdgr/books/Zhuan_Falun/zfgr2007.html?v=bks04"),
  italiano("Italiano", "https://it.falundafa.org/imported/zfl/zfl.htm"),
  latviski("Latviski", "https://lv.falundafa.org/fa-lv/ZF/zfl_2014.html?v=bks04"),
  magyar("Magyar", "https://hu.falundafa.org/falundafa.hu/books/zf_hun_web.html"),
  nederlands("Nederlands", "https://nl.falundafa.org/books/zfl_dutch_2023/zfl_2023.html"),
  portugues("Português", "https://pt.falundafa.org/rec/liv/html/zfl_pt_2018.html"),
  rumani("Română", "https://ro.falundafa.org/books/Zhuan_Falun/ZhuanFalun-prima-traducere_index.html"),
  russian("Русский", "https://rus.falundafa.org/books/ZhuanFalun_20130707/ZhuanFalun/zfl_title.htm"),
  slovencina("Slovenčina", "https://sk.falundafa.org/knihy/ZFL2023_sk.html"),
  suomi("Suomi", "https://www.falundafa.fi/kirjat/0/zhuan-falun-2012/"),
  svenska("Svenska", "https://sv.falundafa.org/books/zhuan-falun-swedish_2022/zf_cont.html?v=bks04"),
  vietnamese("Tiếng Việt","https://vn.falundafa.org/book/zfl_2024_html/index.html"),
  turkce("Türkçe", "https://www.falundafatr.org/html/zflindex.html?v=bks04"),
  ukraina("Українська", "https://uk.falundafa.org/books/ZhuanFalun/zfl_cover.htm"),
  more("More ...", "https://falundafa.org/")
  ;

  final String tengoc;
  final String urlChuyenPhapLuan;
  const LanguageNameOfChuyenPhapLuan(this.tengoc, this.urlChuyenPhapLuan);

}




