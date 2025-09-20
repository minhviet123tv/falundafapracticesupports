
// Tạo model truyền thông tin source
class AudioSourceModelName{
  String name;
  String timeTotal;
  AudioSourceModelName(this.name, this.timeTotal);
}

// model đủ source internet
class AudioSourceModelInternet{
  String name;
  String linkUrl;
  String timeTotal;
  AudioSourceModelInternet(this.name, this.linkUrl, this.timeTotal);
}

//I. Danh sách ngôn ngữ | Dùng enum sẽ tạo độ chính xác chắc chắn cho mã code (không bị lỗi do đọc String không chính xác theo ký tự đặc biệt của nhiêu ngôn ngữ)
enum LanguageNameAndCode {
  english("English", "en"), // listInternetSourceEnglish
  chinese("中文简体","zh"), // listInternetSourceChinese
  korean("한국어", "ko"), // listInternetSourceKorean
  japan("日本語", "ja"), // listInternetSourceJapan
  thai("ไทย", "th"), // listInternetSourceThai
  bosanski("Bosanski", "bo"), // listInternetSourceBosanski
  belarus("Belarus", "be"), // listInternetSourceBelarus
  bulgarian("Български", "bu"), // listInternetSourceBulgarian
  cesky("Česky", "ce"), // listInternetSourceCesky
  deutsch("Deutsch", "de"), // listInternetSourceDeutsch
  espanol("Español", "es"), // listInternetSourceEspanol
  greek("Ελληνικά", "ge"), // listInternetSourceGreek
  persian("Farsi /فارسی", "fa"), // listInternetSourcePersian
  french("Français", "fr"), // listInternetSourceFrench
  hebrew("עברית", "he"), // listInternetSourceHebrew
  hrvatski("Hrvatski", "hr"), // listInternetSourceHrvatski
  italiano("Italiano", "it"), // listInternetSourceItaliano
  magyar("Magyar", "ma"), // listInternetSourceMagyar
  macedonia("Македонски", "cr"), // listInternetSourceCroatial
  polski("Polski", "po"), // listInternetSourcePolski
  portugues("Português", "por"), // listInternetSourcePortugues
  rumani("Română", "ru"), // listInternetSourceRumani
  suomi("Suomi", "su"), // listInternetSourceSuomi
  svenska("Svenska", "sv"), // listInternetSourceSvenska
  vietnamese("Tiếng Việt","vi"), // listInternetSourceVietnamese
  turkce("Türkçe", "tu"), // listInternetSourceTurkce
  ukraina("Українська", "uk"), // listInternetSourceUkrainian
  ;

  final String tengoc;
  final String code;
  const LanguageNameAndCode(this.tengoc, this.code);
}

//II. Danh sách list AudioSourceModelInternet của các ngôn ngữ (Theo thứ tự trong trang falundafa.org)

List<AudioSourceModelInternet> listInternetSourceChinese = [
  AudioSourceModelInternet("第一讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_1.mp3", ""),
  AudioSourceModelInternet("第二讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_2.mp3", ""),
  AudioSourceModelInternet("第三讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_3.mp3", ""),
  AudioSourceModelInternet("第四讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_4.mp3", ""),
  AudioSourceModelInternet("第五讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_5.mp3", ""),
  AudioSourceModelInternet("第六讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_6.mp3", ""),
  AudioSourceModelInternet("第七讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_7.mp3", ""),
  AudioSourceModelInternet("第八讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_8.mp3", ""),
  AudioSourceModelInternet("第九讲", "https://media.falundafa.org/media1/media/dafa/gzjf/Guangzhou40k_9.mp3", ""),
]; // Chinese | 中文简体


List<AudioSourceModelInternet> listInternetSourceEnglish = [
  AudioSourceModelInternet("Lesson 1", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-1-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 2", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-2-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 3", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-3-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 4", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-4-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 5", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-5-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 6", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-6-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 7", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-7-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 8", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-8-Lecture.mp3", ""),
  AudioSourceModelInternet("Lesson 9", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-9-Lecture.mp3", ""),
]; // English

// List<AudioSourceModelInternet> listInternetSourceAfrikaans = []; // Trùng với listInternetSourceEnglish
// List<AudioSourceModelInternet> listInternetSourceArabic = []; // Trùng với listInternetSourceEnglish
// List<AudioSourceModelInternet> listInternetSourceBangla = []; // Trùng với listInternetSourceEnglish

List<AudioSourceModelInternet> listInternetSourceBosanski = [
  AudioSourceModelInternet("Predavanje 1", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-1.mp3", ""),
  AudioSourceModelInternet("Predavanje 2", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-2.mp3", ""),
  AudioSourceModelInternet("Predavanje 3", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-3.mp3", ""),
  AudioSourceModelInternet("Predavanje 4", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-4.mp3", ""),
  AudioSourceModelInternet("Predavanje 5", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-5.mp3", ""),
  AudioSourceModelInternet("Predavanje 6", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-6.mp3", ""),
  AudioSourceModelInternet("Predavanje 7", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-7.mp3", ""),
  AudioSourceModelInternet("Predavanje 8", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-8.mp3", ""),
  AudioSourceModelInternet("Predavanje 9", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-9.mp3", ""),
]; // Bosanski | Croatia

List<AudioSourceModelInternet> listInternetSourceBelarus = [
  AudioSourceModelInternet("Yрок 1", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L1_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 2", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L2_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 3", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L3_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 4", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L4_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 5", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L5_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 6", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L6_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 7", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L7_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 8", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L8_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Yрок 9", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L9_2016-05-04.mp3", ""),
]; // Belarus


List<AudioSourceModelInternet> listInternetSourceBulgarian = [
  AudioSourceModelInternet(" Лекция 1", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L1_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 2", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L2_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 3", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L3_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 4", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L4_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 5", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L5_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 6", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L6_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 7", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L7_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 8", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L8_bg.mp3", ""),
  AudioSourceModelInternet(" Лекция 9", "https://media.falundafa.org/media1/media/dafa/bulgarian/mp3/L9_bg.mp3", ""),
]; // Български | Bungari

// List<AudioSourceModelInternet> listInternetSourceBurmese = []; // Miến Điện -> Trùng tiếng Anh

List<AudioSourceModelInternet> listInternetSourceCesky = [
  AudioSourceModelInternet("Přednáška 1", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L1Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 2", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L2Czech_20230517.mp3", ""),
  AudioSourceModelInternet("Přednáška 3", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L3Czech_20230517.mp3", ""),
  AudioSourceModelInternet("Přednáška 4", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L4Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 5", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L5Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 6", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L6Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 7", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L7Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 8", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L8Czech_20230307.mp3", ""),
  AudioSourceModelInternet("Přednáška 9", "https://media.falundafa.org/media1/media/dafa/czech/mp3/L9Czech_20230307.mp3", ""),
]; // Česky - Séc

// List<AudioSourceModelInternet> listInternetSourceChineseSimplified = []; // Chinese (simplified) | Trùng với listInternetSourceChinese
// List<AudioSourceModelInternet> listInternetSourceChineseTraditional = []; // Chinese (traditional) | Trùng với listInternetSourceTQ
// List<AudioSourceModelInternet> listInternetSourceDansk = []; // Đan Mạch | Trùng với listInternetSourceEN

List<AudioSourceModelInternet> listInternetSourceDeutsch = [
  AudioSourceModelInternet("Lektion 1", "https://media.falundafa.org/media1/media/dafa/german/mp3/L1German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 2", "https://media.falundafa.org/media1/media/dafa/german/mp3/L2German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 3", "https://media.falundafa.org/media1/media/dafa/german/mp3/L3German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 4", "https://media.falundafa.org/media1/media/dafa/german/mp3/L4German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 5", "https://media.falundafa.org/media1/media/dafa/german/mp3/L5German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 6", "https://media.falundafa.org/media1/media/dafa/german/mp3/L6German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 7", "https://media.falundafa.org/media1/media/dafa/german/mp3/L7German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 8", "https://media.falundafa.org/media1/media/dafa/german/mp3/L8German_20210515_Mix-Orig-12dB.mp3", ""),
  AudioSourceModelInternet("Lektion 9", "https://media.falundafa.org/media1/media/dafa/german/mp3/L9German_20210515_Mix-Orig-12dB.mp3", ""),
]; // Deutsch | Tiếng Đức


List<AudioSourceModelInternet> listInternetSourceEspanol = [
  AudioSourceModelInternet("Lección 1", "https://media2.falundafa.org/media1/stream/dafa/es/L1Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 2", "https://media2.falundafa.org/media1/stream/dafa/es/L2Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 3", "https://media2.falundafa.org/media1/stream/dafa/es/L3Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 4", "https://media2.falundafa.org/media1/stream/dafa/es/L4Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 5", "https://media2.falundafa.org/media1/stream/dafa/es/L5Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 6", "https://media2.falundafa.org/media1/stream/dafa/es/L6Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 7", "https://media2.falundafa.org/media1/stream/dafa/es/L7Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 8", "https://media2.falundafa.org/media1/stream/dafa/es/L8Spanish_2022-12-05.mp3", ""),
  AudioSourceModelInternet("Lección 9", "https://media2.falundafa.org/media1/stream/dafa/es/L9Spanish_2022-12-05.mp3", ""),
]; // Español | Tây Ban Nha

// List<AudioSourceModelInternet> listInternetSourceEesti = []; // Estonia | listInternetSourceEN

List<AudioSourceModelInternet> listInternetSourceGreek = [
  AudioSourceModelInternet("Διάλεξη 1", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L1Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 2", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L2Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 3", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L3Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 4", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L4Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 5", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L5Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 6", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L6Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 7", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L7Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 8", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L8Greek_20160131.mp3", ""),
  AudioSourceModelInternet("Διάλεξη 9", "https://media.falundafa.org/media1/media/dafa/greek/mp3/L9Greek_20160131.mp3", ""),
]; // Ελληνικά | Hy lạp

List<AudioSourceModelInternet> listInternetSourcePersian = [
  AudioSourceModelInternet("درس 1", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_1.MP3", ""),
  AudioSourceModelInternet("درس 2", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_2.MP3", ""),
  AudioSourceModelInternet("درس 3", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_3.MP3", ""),
  AudioSourceModelInternet("درس 4", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_4.MP3", ""),
  AudioSourceModelInternet("درس 5", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_5.MP3", ""),
  AudioSourceModelInternet("درس 6", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_6.MP3", ""),
  AudioSourceModelInternet("درس 7", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_7.MP3", ""),
  AudioSourceModelInternet("درس 8", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_8.MP3", ""),
  AudioSourceModelInternet("درس 9", "https://media.falundafa.org/media1/media/dafa/persian/mp3/Persian_Guangzhou_Lecture_9.MP3", ""),
]; // Farsi /فارسی  | Ba tư | Persian

List<AudioSourceModelInternet> listInternetSourceFrench = [
  AudioSourceModelInternet("Leçon 1", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_1.mp3", ""),
  AudioSourceModelInternet("Leçon 2", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_2.mp3", ""),
  AudioSourceModelInternet("Leçon 3", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_3.mp3", ""),
  AudioSourceModelInternet("Leçon 4", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_4.mp3", ""),
  AudioSourceModelInternet("Leçon 5", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_5.mp3", ""),
  AudioSourceModelInternet("Leçon 6", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_6.mp3", ""),
  AudioSourceModelInternet("Leçon 7", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_7.mp3", ""),
  AudioSourceModelInternet("Leçon 8", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_8.mp3", ""),
  AudioSourceModelInternet("Leçon 9", "https://media.falundafa.org/media1/media/dafa/fr/audio/guangzhou/2018_French_Lecture_9.mp3", ""),
]; // Français | French - Tiếng Pháp

List<AudioSourceModelInternet> listInternetSourceHebrew = [
  AudioSourceModelInternet("הרצאה 1", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L1_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 2", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L2_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 3", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L3_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 4", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L4_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 5", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L5_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 6", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L6_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 7", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L7_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 8", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L8_Hebrew.mp3", ""),
  AudioSourceModelInternet("הרצאה 9", "https://media.falundafa.org/media1/media/dafa/hebrew/mp3/L9_Hebrew.mp3", ""),
]; // עברית| tiếng Do Thái | Hebrew

// List<AudioSourceModelInternet> listInternetSourceHindi = []; // Hindi / हिन्दी | Trùng tiếng Anh

List<AudioSourceModelInternet> listInternetSourceHrvatski = [
  AudioSourceModelInternet("Lekcija 1", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-1.mp3", ""),
  AudioSourceModelInternet("Lekcija 2", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-2.mp3", ""),
  AudioSourceModelInternet("Lekcija 3", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-3.mp3", ""),
  AudioSourceModelInternet("Lekcija 4", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-4.mp3", ""),
  AudioSourceModelInternet("Lekcija 5", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-5.mp3", ""),
  AudioSourceModelInternet("Lekcija 6", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-6.mp3", ""),
  AudioSourceModelInternet("Lekcija 7", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-7.mp3", ""),
  AudioSourceModelInternet("Lekcija 8", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-8.mp3", ""),
  AudioSourceModelInternet("Lekcija 9", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-9.mp3", ""),
]; // Hrvatski | tiếng Croatia

// Indonesia | Trùng tiếng Anh

List<AudioSourceModelInternet> listInternetSourceItaliano = [
  AudioSourceModelInternet(" Lezione 1", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L1_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 2", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L2_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 3", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L3_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 4", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L4_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 5", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L5_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 6", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L6_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 7", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L7_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 8", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L8_Italian.mp3", ""),
  AudioSourceModelInternet(" Lezione 9", "https://media.falundafa.org/media1/media/dafa/italian/mp3/L9_Italian.mp3", ""),
]; // Italiano

// Kannada / ಕನ್ನಡ | Trùng tiếng Anh
// Latviski | Trùng tiếng Nga (Russian)
// Laotian / ລາວ | Trùng tiếng Anh

List<AudioSourceModelInternet> listInternetSourceMagyar = [
  AudioSourceModelInternet("Előadás 1", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL1_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 2", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL2_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 3", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL3_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 4", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL4_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 5", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL5_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 6", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL6_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 7", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL7_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 8", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL8_Hungarian_20160714.mp3", ""),
  AudioSourceModelInternet("Előadás 9", "https://media.falundafa.org/media1/media/dafa/hungarian/mp3/HCL9_Hungarian_20160714.mp3", ""),
]; // Magyar | tiếng Hungary

List<AudioSourceModelInternet> listInternetSourceMacedonia = [
  AudioSourceModelInternet("Предавање 1", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-1.mp3", ""),
  AudioSourceModelInternet("Предавање 2", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-2.mp3", ""),
  AudioSourceModelInternet("Предавање 3", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-3.mp3", ""),
  AudioSourceModelInternet("Предавање 4", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-4.mp3", ""),
  AudioSourceModelInternet("Предавање 5", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-5.mp3", ""),
  AudioSourceModelInternet("Предавање 6", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-6.mp3", ""),
  AudioSourceModelInternet("Предавање 7", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-7.mp3", ""),
  AudioSourceModelInternet("Предавање 8", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-8.mp3", ""),
  AudioSourceModelInternet("Предавање 9", "https://media.falundafa.org/media1/media/dafa/croatial/mp3/CroatiaLekcija-9.mp3", ""),
]; // Македонски |

// Монгол / ᠮᠣᠩᠭᠣᠯ | Mông cổ | Trùng tiếng Anh
// Nederlands | Hà Lan | Trùng tiếng Anh

List<AudioSourceModelInternet> listInternetSourceJapan = [
  AudioSourceModelInternet("第一講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture1_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第二講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture2_Japanese_v2_3.mp3", ""),
  AudioSourceModelInternet("第三講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture3_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第四講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture4_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第五講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture5_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第六講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture6_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第七講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture7_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第八講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture8_Japanese_v2_1.mp3", ""),
  AudioSourceModelInternet("第九講", "https://media.falundafa.org/media1/media/dafa/japanese/audio/Lecture9_Japanese_v2_1.mp3", ""),
]; // Japan / 日本語	| Nhật bản

//Khmer / ខ្មែរ	| file tiếng Anh
// Norsk / Bokmål | Na uy | file tiếng Anh


List<AudioSourceModelInternet> listInternetSourcePolski = [
  AudioSourceModelInternet("Wyklad 1", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_1.mp3", ""),
  AudioSourceModelInternet("Wyklad 2", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_2.mp3", ""),
  AudioSourceModelInternet("Wyklad 3", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_3.mp3", ""),
  AudioSourceModelInternet("Wyklad 4", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_4.mp3", ""),
  AudioSourceModelInternet("Wyklad 5", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_5.mp3", ""),
  AudioSourceModelInternet("Wyklad 6", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_6.mp3", ""),
  AudioSourceModelInternet("Wyklad 7", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_7.mp3", ""),
  AudioSourceModelInternet("Wyklad 8", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_8.mp3", ""),
  AudioSourceModelInternet("Wyklad 9", "https://media.falundafa.org/media1/media/dafa/polski/mp3/Guangzhou_wyklad_9.mp3", ""),
]; // Polski | Ba lan

List<AudioSourceModelInternet> listInternetSourcePortugues = [
  AudioSourceModelInternet("Lição 1", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L1Portuguese_20240427.mp3", ""),
  AudioSourceModelInternet("Lição 2", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L2Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 3", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L3Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 4", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L4Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 5", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L5Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 6", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L6Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 7", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L7Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 8", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L8Portuguese_20161219.mp3", ""),
  AudioSourceModelInternet("Lição 9", "https://media.falundafa.org/media1/media/dafa/portuguese/mp3/L9Portuguese_20190225.mp3", ""),
]; // Português ? Bồ Đào Nha


List<AudioSourceModelInternet> listInternetSourceRumani = [
  AudioSourceModelInternet("Lectia 1", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-1-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 2", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-2-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 3", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-3-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 4", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-4-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 5", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-5-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 6", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-6-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 7", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-7-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 8", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-8-Lectia_20160628.mp3", ""),
  AudioSourceModelInternet("Lectia 9", "https://media.falundafa.org/media1/media/dafa/romanian/mp3/Ro-9-Lectia_20160628.mp3", ""),
]; // Română | Rumani


// Русский	| Tiếng Nga | trùng file Belarus
// Sinhala / සිංහල | file English

// Slovenčina | file listInternetSourceCesky
//Slovenščina | file English
// Srpski / Српски | cùng listInternetSourceBosanski


List<AudioSourceModelInternet> listInternetSourceSuomi = [
  AudioSourceModelInternet("Oppitunti 1", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-1_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 2", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-2_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 3", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-3_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 4", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-4_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 5", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-5_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 6", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-6_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 7", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-7_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 8", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-8_Guangzhou_Finnish_128kbps.mp3", ""),
  AudioSourceModelInternet("Oppitunti 9", "https://media.falundafa.org/media1/media/dafa/fin/mp3/Luento-9_Guangzhou_Finnish_128kbps.mp3", ""),
]; // Suomi | Phần Lan


List<AudioSourceModelInternet> listInternetSourceSvenska = [
  AudioSourceModelInternet("Föreläsning 1", "https://media.falundafa.org/media1/stream/sv/mp3/L1Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 2", "https://media.falundafa.org/media1/stream/sv/mp3/L2Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 3", "https://media.falundafa.org/media1/stream/sv/mp3/L3Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 4", "https://media.falundafa.org/media1/stream/sv/mp3/L4Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 5", "https://media.falundafa.org/media1/stream/sv/mp3/L5Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 6", "https://media.falundafa.org/media1/stream/sv/mp3/L6Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 7", "https://media.falundafa.org/media1/stream/sv/mp3/L7Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 8", "https://media.falundafa.org/media1/stream/sv/mp3/L8Swedish_202401.mp3", ""),
  AudioSourceModelInternet("Föreläsning 9", "https://media.falundafa.org/media1/stream/sv/mp3/L9Swedish_202401.mp3", ""),
]; // Svenska | Thuỵ điển

//Shqip / Albanian | file English

List<AudioSourceModelInternet> listInternetSourceKorean = [
  AudioSourceModelInternet("제 1 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-1.mp3", ""),
  AudioSourceModelInternet("제 2 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-2.mp3", ""),
  AudioSourceModelInternet("제 3 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-3.mp3", ""),
  AudioSourceModelInternet("제 4 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-4.mp3", ""),
  AudioSourceModelInternet("제 5 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-5.mp3", ""),
  AudioSourceModelInternet("제 6 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-6.mp3", ""),
  AudioSourceModelInternet("제 7 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-7.mp3", ""),
  AudioSourceModelInternet("제 8 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-8.mp3", ""),
  AudioSourceModelInternet("제 9 강", "https://dafamedia.org/assets/falundafa/mp3/Lecture-9.mp3", ""),
]; // Korean / 한국어 | Hàn Quốc

List<AudioSourceModelInternet> listInternetSourceThai = [
  AudioSourceModelInternet("การบรรยายที่ 1", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L1Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 2", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L2Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 3", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L3Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 4", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L4Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 5", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L5Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 6", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L6Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 7", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L7Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 8", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L8Thai_20160814.mp3", ""),
  AudioSourceModelInternet("การบรรยายที่ 9", "https://media.falundafa.org/media1/media/dafa/thai/mp3/L9Thai_20160814.mp3", ""),
]; // Thai / ไทย | Thái Lan

List<AudioSourceModelInternet> listInternetSourceTurkce = [
  AudioSourceModelInternet("Ders 1", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L1Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 2", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L2Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 3", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L3Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 4", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L4Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 5", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L5Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 6", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L6Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 7", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L7Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 8", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L8Turkish_20160815.mp3", ""),
  AudioSourceModelInternet("Ders 9", "https://media.falundafa.org/media1/media/dafa/turkish/mp3/L9Turkish_20160815.mp3", ""),
]; //Türkçe | Thổ Nhĩ Kỳ

List<AudioSourceModelInternet> listInternetSourceUkrainian = [
  AudioSourceModelInternet("Лекція 1", "https://media.falundafa.org/media1/media/dafa/uk/mp3/Ukraine-L1_2023.mp3", ""),
  AudioSourceModelInternet("Лекція 2", "https://media.falundafa.org/media1/media/dafa/uk/mp3/Ukraine-L2_2023.mp3", ""),
  AudioSourceModelInternet("Лекція 3", "https://media.falundafa.org/media1/media/dafa/uk/mp3/Ukraine-L3_2023.mp3", ""),
  AudioSourceModelInternet("Лекція 4", "https://media.falundafa.org/media1/media/dafa/uk/mp3/Ukraine-L4_2023.mp3", ""),
  AudioSourceModelInternet("Лекція 5", "https://media.falundafa.org/media1/media/dafa/uk/mp3/Ukraine-L5_2023.mp3", ""),
  AudioSourceModelInternet("Лекція 6", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L6_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Лекція 7", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L7_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Лекція 8", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L8_2016-05-04.mp3", ""),
  AudioSourceModelInternet("Лекція 9", "https://media.falundafa.org/media1/media/dafa/russian/mp3/Russian-L9_2016-05-04.mp3", ""),
]; // Ukrainian / Українська | Ukraina


List<AudioSourceModelInternet> listInternetSourceVietnamese = [
  AudioSourceModelInternet("Bài giảng 1", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L1Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 2", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L2Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 3", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L3Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 4", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L4Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 5", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L5Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 6", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L6Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 7", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L7Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 8", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L8Vietnam_20161218L.mp3", ""),
  AudioSourceModelInternet("Bài giảng 9", "https://media.falundafa.org/media1/media/dafa/vietnamese/9-lectures/mp3/L9Vietnam_20161218L.mp3", ""),
];


