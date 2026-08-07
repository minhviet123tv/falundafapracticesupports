
//I. Danh sách trang tất cả các kinh văn, sách của tất cả các ngôn ngữ hiện có (Theo thứ tự trong trang falundafa.org)
// Cấu trúc: Tên ngôn ngữ gốc, tên tiếng Anh, link dẫn về trang chủ falundafa, link dấn đến trang tất cả các kinh sách
enum LanguageAllPageFalundafa {
  english("English", "english", "https://en.falundafa.org/?v=bks04", "https://en.falundafa.org/falun-dafa-books.html?v=bks04", "https://en.falundafa.org/falun-dafa-video-audio.html", "https://en.falundafa.org/falun-dafa-video-audio-9session.html"),
  chinese("中文简体", "chinese", "https://gb.falundafa.org/?v=bks04", "https://gb.falundafa.org/falun-dafa-books.html", "https://gb.falundafa.org/falun-dafa-video-audio.html", "https://gb.falundafa.org/falun-dafa-video-audio-9session.html"),
  afrikaans("Afrikaans", "afrikaans", "https://af.falundafa.org/?v=bks04", "https://af.falundafa.org/falun-dafa-books.html?v=bks04", "https://af.falundafa.org/falun-dafa-video-audio.html", "https://af.falundafa.org/falun-dafa-video-audio-9session.html"),
  arabic("Arabic / العربية", "arabic", "https://ar.falundafa.org/?v=bks04", "https://ar.falundafa.org/falun-dafa-books.html?v=bks04", "https://ar.falundafa.org/falun-dafa-video-audio.html", "https://ar.falundafa.org/falun-dafa-video-audio-9session.html"),
  bangla("Bangla", "bangla", "https://ba.falundafa.org/?v=bks04","https://ba.falundafa.org/falun-dafa-books.html?v=bks04", "https://ba.falundafa.org/falun-dafa-video-audio.html", "https://ba.falundafa.org/falun-dafa-video-audio-9session.html"),
  bosanski("Bosanski", "bosanski", "https://bs.falundafa.org/?v=bks04", "https://bs.falundafa.org/falun-dafa-books.html?v=bks04", "https://bs.falundafa.org/falun-dafa-video-audio.html", "https://bs.falundafa.org/falun-dafa-video-audio-9session.html"),
  belarus("Belarus", "belarus", "https://by.falundafa.org/?v=bks04", "https://by.falundafa.org/falun-dafa-books.html?v=bks04", "https://by.falundafa.org/falun-dafa-video-audio.html", "https://by.falundafa.org/falun-dafa-video-audio-9session.html"),
  bungari("Български", "bungari", "https://bg.falundafa.org/?v=bks04", "https://bg.falundafa.org/falun-dafa-books.html?v=bks04", "https://bg.falundafa.org/falun-dafa-video-audio.html", "https://bg.falundafa.org/falun-dafa-video-audio-9session.html"),
  burmese("Burmese", "burmese", "https://www.falundafa.org/eng/language/burmese.html?v=bks04", "https://www.falundafa.org/eng/language/burmese.html", "https://en.falundafa.org/falun-dafa-video-audio.html", "https://en.falundafa.org/falun-dafa-video-audio-9session.html"),
  cesky("Česky", 'cesky', "https://cs.falundafa.org/?v=bks04", "https://cs.falundafa.org/falun-dafa-books.html?v=bks04", "https://cs.falundafa.org/falun-dafa-video-audio.html", "https://cs.falundafa.org/falun-dafa-video-audio-9session.html"),
  chinese_simplified("Chinese (simplified)","chinese_simplified", "https://gb.falundafa.org/", "https://gb.falundafa.org/falun-dafa-books.html", "https://gb.falundafa.org/falun-dafa-video-audio.html", "https://gb.falundafa.org/falun-dafa-video-audio-9session.html"),
  chinese_traditional("Chinese (traditional)", "chinese_traditional", "https://big5.falundafa.org/", "https://big5.falundafa.org/falun-dafa-books.html", "https://big5.falundafa.org/falun-dafa-video-audio.html", "https://big5.falundafa.org/falun-dafa-video-audio-9session.html"),
  dansk("Dansk", 'dansk', "https://da.falundafa.org/", "https://da.falundafa.org/falun-dafa-books.html?v=bks04", "https://da.falundafa.org/falun-dafa-video-audio.html", "https://da.falundafa.org/falun-dafa-video-audio-9session.html"),
  deutsch("Deutsch", "deutsch", "https://de.falundafa.org/?v=bks04", "https://de.falundafa.org/buecher.html?v=bks04", "https://de.falundafa.org/audiovideo.html", "https://de.falundafa.org/falun-dafa-video-audio-9session.html"),
  espanol("Español", "espanol", "https://es.falundafa.org/?v=bks04", "https://es.falundafa.org/falun-dafa-books.html?v=bks04", "https://es.falundafa.org/falun-dafa-video-audio.html", "https://es.falundafa.org/falun-dafa-video-audio-9session.html"),
  eesti("Eesti", 'eesti', "https://en.falundafa.org/language/estonian.html?v=bks04", "https://en.falundafa.org/language/estonian.html", "https://ee.falundafa.org/falun-dafa-video-audio.html", "https://ee.falundafa.org/falun-dafa-video-audio-9session.html"),
  greek("Ελληνικά", 'greek', "https://el.falundafa.org/?v=bks04", "https://el.falundafa.org/falun-dafa-books.html?v=bks04", "https://el.falundafa.org/falun-dafa-video-audio.html", "https://el.falundafa.org/falun-dafa-video-audio-9session.html"),
  farsi("Farsi / فارسی", 'farsi', "https://fa.falundafa.org/?v=bks04", "https://fa.falundafa.org/falun-dafa-books.html?v=bks04", "https://fa.falundafa.org/falun-dafa-video-audio.html", "https://fa.falundafa.org/falun-dafa-video-audio-9session.html"),
  francais("Français", 'francais', "https://fr.falundafa.org/?v=bks04", "https://fr.falundafa.org/falun-dafa-books.html?v=bks04", "https://fr.falundafa.org/falun-dafa-video-audio.html", "https://fr.falundafa.org/falun-dafa-video-audio-9session.html"),
  hebrew("עברית", 'hebrew', "https://he.falundafa.org/?v=bks04", "https://he.falundafa.org/falun-dafa-books.html?v=bks04", "https://he.falundafa.org/falun-dafa-video-audio.html", "https://he.falundafa.org/falun-dafa-video-audio-9session.html"),
  hindi("Hindi / हिन्दी", 'hindi', "https://hi.falundafa.org/?v=bks04", "https://hi.falundafa.org/falun-dafa-books.html?v=bks04", "https://hi.falundafa.org/falun-dafa-video-audio.html", "https://hi.falundafa.org/falun-dafa-video-audio-9session.html"),
  hrvatski("Hrvatski", 'hrvatski', "https://hr.falundafa.org/?v=bks04", "https://hr.falundafa.org/falun-dafa-books.html?v=bks04", "https://hr.falundafa.org/falun-dafa-video-audio.html", "https://hr.falundafa.org/falun-dafa-video-audio-9session.html"),
  indonesia("Bahasa Indonesia", 'indonesia', "https://id.falundafa.org/?v=bks04", "https://id.falundafa.org/falun-dafa-books.html?v=bks04", "https://id.falundafa.org/falun-dafa-video-audio.html", "https://id.falundafa.org/falun-dafa-video-audio-9session.html"),
  italiano("Italiano", 'italiano', "https://it.falundafa.org/?v=bks04", "https://it.falundafa.org/falun-dafa-books.html?v=bks04", "https://it.falundafa.org/falun-dafa-video-audio.html", "https://it.falundafa.org/falun-dafa-video-audio-9session.html"),
  kannada("Kannada", 'kannada', "https://kn.falundafa.org/?v=bks04", "https://kn.falundafa.org/", "https://kn.falundafa.org/falun-dafa-video-audio.html", "https://kn.falundafa.org/falun-dafa-video-audio-9session.html"),
  latviski("Latviski", 'latviski', "https://lv.falundafa.org/?v=bks04", "https://lv.falundafa.org/", "https://lv.falundafa.org/falun-dafa-video-audio.html", "https://lv.falundafa.org/falun-dafa-video-audio-9session.html"),
  lietuviu("Lietuvių", 'lietuviu', "https://falundafa.org/eng/language/lithuanian.html?v=bks04", "https://falundafa.org/eng/language/lithuanian.html", "https://falundafa.org/eng/language/lithuanian.html", "https://en.falundafa.org/falun-dafa-video-audio-9session.html"), // Cho tiếng Anh thay thế
  laotian("Laotian / ລາວ", 'laotian', "https://en.falundafa.org/language/laotian.html?v=bks04", "https://en.falundafa.org/language/laotian.html", "https://en.falundafa.org/falun-dafa-video-audio.html", "https://en.falundafa.org/falun-dafa-video-audio-9session.html"),
  magyar("Magyar", 'magyar', "https://hu.falundafa.org/?v=bks04", "https://hu.falundafa.org/", "https://hu.falundafa.org/falun-dafa-video-audio.html", "https://hu.falundafa.org/falun-dafa-video-audio-9session.html"),
  macedonia("Македонски", 'macedonia', "https://mk.falundafa.org/?v=bks04", "https://mk.falundafa.org/falun-dafa-books.html?v=bks04", "https://mk.falundafa.org/falun-dafa-video-audio.html", "https://mk.falundafa.org/falun-dafa-video-audio-9session.html"),
  mongolia("Монгол / ᠮᠣᠩᠭᠣᠯ", 'mongolia', "https://mn.falundafa.org/?v=bks04", "https://mn.falundafa.org/falun-dafa-books.html?v=bks04", "https://mn.falundafa.org/falun-dafa-video-audio.html", "https://mn.falundafa.org/falun-dafa-video-audio-9session.html"),
  nederlands("Nederlands", 'nederlands', "https://nl.falundafa.org/?v=bks04", "https://nl.falundafa.org/falun-dafa-books.html", "https://nl.falundafa.org/falun-dafa-video-audio.html", "https://nl.falundafa.org/falun-dafa-video-audio-9session.html"),
  japan("Japan / 日本語", 'japan', "https://ja.falundafa.org/?v=bks04", "https://ja.falundafa.org/falun-dafa-books.html?v=bks04", "https://ja.falundafa.org/falun-dafa-video-audio.html", "https://ja.falundafa.org/falun-dafa-video-audio-9session.html"),
  khmer("Khmer / ខ្មែរ", 'khmer', "https://kh.falundafa.org/falun-dafa-books.html?v=bks04", "https://kh.falundafa.org/falun-dafa-books.html", "https://kh.falundafa.org/falun-dafa-video-audio.html", "https://kh.falundafa.org/falun-dafa-video-audio-9session.html"),
  norsk("Norsk / Bokmål", 'norsk', "https://no.falundafa.org/?v=bks04", "https://no.falundafa.org/falun-dafa-books.html?v=bks04", "https://no.falundafa.org/falun-dafa-video-audio.html", "https://no.falundafa.org/falun-dafa-video-audio-9session.html"),
  polski("Polski", 'polski', "https://pl.falundafa.org/?v=bks04", "https://pl.falundafa.org/falun-dafa-books.html", "https://pl.falundafa.org/falun-dafa-video-audio.html", "https://pl.falundafa.org/falun-dafa-video-audio-9session.html"),
  portugues("Português", 'portugues', "https://pt.falundafa.org/?v=bks04", "https://pt.falundafa.org/falun-dafa-livros.html?v=bks04", "https://pt.falundafa.org/falun-dafa-video-audio.html", "https://pt.falundafa.org/falun-dafa-video-audio-9session.html"),
  romana("Română", 'romana', "https://ro.falundafa.org/?v=bks04", "https://ro.falundafa.org/falun-dafa-books.html?v=bks04", "https://ro.falundafa.org/falun-dafa-video-audio.html", "https://ro.falundafa.org/falun-dafa-video-audio-9session.html"),
  russian("Русский", 'russian', "https://rus.falundafa.org/?v=bks04", "https://rus.falundafa.org/falun-dafa-books.html?v=bks04", "https://rus.falundafa.org/falun-dafa-video-audio.html", "https://rus.falundafa.org/falun-dafa-video-audio-9session.html"),
  sinhala("Sinhala / සිංහල", 'sinhala', "https://lk.falundafa.org/?v=bks04", "https://lk.falundafa.org/falun-dafa-books.html?v=bks04", "https://lk.falundafa.org/falun-dafa-video-audio.html", "https://lk.falundafa.org/falun-dafa-video-audio-9session.html"),
  slovencina("Slovenčina", 'slovencina', "https://sk.falundafa.org/?v=bks04", "https://sk.falundafa.org/knihy.html?v=bks04", "https://sk.falundafa.org/audiovideo.html", "https://sk.falundafa.org/falun-dafa-video-audio-9session.html"),
  slovenscina("Slovenščina", 'slovenscina', "https://sl.falundafa.org/?v=bks04", "https://sl.falundafa.org/falun-dafa-books.html?v=bks04", "https://sl.falundafa.org/falun-dafa-video-audio.html", "https://sl.falundafa.org/falun-dafa-video-audio-9session.html"),
  srpski("Srpski / Српски", 'srpski', "https://sr.falundafa.org/?v=bks04", "https://sr.falundafa.org/", "https://sr.falundafa.org/falun-dafa-video-audio.html", "https://sr.falundafa.org/falun-dafa-video-audio-9session.html"),
  suomi("Suomi", 'suomi', "https://fi.falundafa.org/?v=bks04", "https://fi.falundafa.org/falun-dafa-books.html?v=bks04", "https://fi.falundafa.org/falun-dafa-video-audio.html", "https://fi.falundafa.org/falun-dafa-video-audio-9session.html"),
  svenska("Svenska", 'svenska', "https://sv.falundafa.org/?v=bks04", "https://sv.falundafa.org/falun-dafa-books.html?v=bks04", "https://sv.falundafa.org/falun-dafa-video-audio.html", "https://sv.falundafa.org/falun-dafa-video-audio-9session.html"),
  shqip("Shqip / Albanian", 'shqip', "https://sq.falundafa.org/?v=bks04", "https://sq.falundafa.org/falun-dafa-books.html?v=bks04", "https://sq.falundafa.org/falun-dafa-video-audio.html", "https://sq.falundafa.org/falun-dafa-video-audio-9session.html"),
  korean("Korean / 한국어", 'korean', "https://ko.falundafa.org/?v=bks04", "https://ko.falundafa.org/falun-dafa-books.html", "https://ko.falundafa.org/falun-dafa-video-audio.html", "https://ko.falundafa.org/falun-dafa-video-audio-9session.html"),
  thai("Thai / ไทย", 'thai', "https://th.falundafa.org/?v=bks04", "https://th.falundafa.org/falun-dafa-books.html?v=bks04", "https://th.falundafa.org/falun-dafa-video-audio.html", "https://th.falundafa.org/falun-dafa-video-audio-9session.html"),
  tibetan("Tibetan / བོད་ཡིག", 'tibetan', "https://www.falundafa.org/eng/language/tibetan.html?v=bks04", "https://www.falundafa.org/eng/falun-dafa-books.html", "https://www.falundafa.org/eng/falun-dafa-video-audio.html", "https://www.falundafa.org/eng/falun-dafa-video-audio-9session.html"),
  vietnamese("Tiếng Việt", 'vietnamese', "https://vn.falundafa.org/index.html", "https://vn.falundafa.org/falun-dafa-books.html", "https://vn.falundafa.org/falun-dafa-video-audio.html", "https://vn.falundafa.org/falun-dafa-video-audio-9session.html"),
  turkce("Türkçe", 'turkce', "https://tr.falundafa.org/?v=bks04", "https://tr.falundafa.org/books.html?v=bks04", "https://tr.falundafa.org/audio_video_egzersiz.html", "https://tr.falundafa.org/audio_video_9ders.html"),
  ukrainian("Ukrainian / Українська", 'ukrainian', "https://uk.falundafa.org/?v=bks04", "https://uk.falundafa.org/falun-dafa-books.html?v=bks05", "https://uk.falundafa.org/falun-dafa-video-audio.html?v=bks05", "https://uk.falundafa.org/falun-dafa-video-audio-9session.html")
  ;

  final String languageName;
  final String languageCode;
  final String homePage;
  final String booksPage;
  final String videoPage;
  final String video9Lession;
  const LanguageAllPageFalundafa(this.languageName, this.languageCode, this.homePage, this.booksPage, this.videoPage, this.video9Lession);
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




