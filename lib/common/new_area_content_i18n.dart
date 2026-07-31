import 'package:falun_dafa_practice_supports/common/new_area_language.dart';
import 'package:falun_dafa_practice_supports/common/new_area_ui_strings.dart';

/// Long-form New Area content (About, Practice Guide, Privacy).
///
/// About + Practice Guide: Vietnamese is the source (no Google footer).
/// All other languages are translated from Vietnamese and should show
/// [NewAreaUiStrings.googleTranslateFooter].
///
/// Privacy: English is the source (no Google footer).
/// All other languages are translated from English and should show the footer.
class NewAreaContentI18n {
  NewAreaContentI18n._();

  /// About app page 1 body (without the Home/News links section).

  static String aboutBody(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''Nowadays many people have learned about the goodness of Falun Gong (Falun Dafa) and have begun to practice.

To listen to the 9 lectures or read the books—the main book being "Zhuan Falun" (with the same content as the 9 lectures)—practitioners can visit www.falundafa.org, print the books, or download audio files for use.

This app was created by a Falun Gong practitioner to help other practitioners access online study materials on the official website www.falundafa.org

The app also includes a basic practice guide to help new practitioners get started, and a download button so audio can be used when there is no internet.

To learn more fully about Falun Gong (Falun Dafa), please visit:
''',
    NewAreaLang.vietnamese => '''Hiện nay có rất nhiều người đã biết đến sự tốt đẹp của Pháp Luân Công (Pháp Luân Đại Pháp) và bắt đầu tu luyện.

Để nghe 9 bài giảng hoặc đọc sách, trong đó sách chính là "Chuyển Pháp Luân" (có nội dung như 9 bài giảng), học viên có thể truy cập tại chủ www.falundafa.org hoặc in thành sách, tải file âm thanh về để sử dụng.

Ứng dụng này được tạo ra bởi học viên Pháp Luân Công nhằm hỗ trợ các học viên khác truy cập dữ liệu học tập trực tuyến trên trang chủ www.falundafa.org

Ngoài ra ứng dụng còn có phần hướng dẫn tập cơ bản nhằm giúp học viên mới tiếp cận môn học, có nút hỗ trợ tải audio về máy để sử dụng khi không dùng internet.

Để tìm hiểu đầy đủ về Pháp Luân Công (Pháp Luân Đại Pháp) vui lòng truy cập:
''',
    NewAreaLang.chinese1 => '''如今許多人已了解法輪功（法輪大法）的美好並開始修煉。

要聽九講或讀書——主要書籍是《轉法輪》（內容與九講相同）——學員可造訪 www.falundafa.org，印成書本，或下載音訊檔使用。

本應用由法輪功學員製作，旨在協助其他學員存取官網 www.falundafa.org 上的線上學習資料。

此外還有基本煉功指南，幫助新學員入門，並有下載按鈕以便在無網路時使用音訊。

若要更完整了解法輪功（法輪大法），請造訪：
''',
    NewAreaLang.chinese2 => '''如今许多人已了解法轮功（法轮大法）的美好并开始修炼。

要听九讲或读书——主要书籍是《转法轮》（内容与九讲相同）——学员可访问 www.falundafa.org，印成书本，或下载音频文件使用。

本应用由法轮功学员制作，旨在协助其他学员访问官网 www.falundafa.org 上的在线学习资料。

此外还有基本炼功指南，帮助新学员入门，并有下载按钮以便在无网络时使用音频。

若要更完整了解法轮功（法轮大法），请访问：
''',
    NewAreaLang.bosanski => '''Danas mnogi ljudi saznali su za dobrotu Falun Gonga (Falun Dafe) i počeli vježbati.

Da bi slušali 9 predavanja ili čitali knjige — glavna knjiga je « Zhuan Falun » (isti sadržaj kao 9 predavanja) — vježbači mogu posjetiti www.falundafa.org, štampati knjige ili preuzeti audio datoteke.

Ovu aplikaciju je napravio vježbač Falun Gonga kako bi pomogao drugim vježbačima da pristupe online materijalima na službenoj stranici www.falundafa.org

Aplikacija također uključuje osnovni vodič za vježbu za početnike i dugme za preuzimanje kako bi se audio koristio bez interneta.

Za potpunije učenje o Falun Gongu (Falun Dafi) posjetite:
''',
    NewAreaLang.deutsch => '''Heute haben viele Menschen das Gute des Falun Gong (Falun Dafa) kennengelernt und begonnen zu üben.

Um die 9 Vorträge zu hören oder die Bücher zu lesen — das Hauptbuch ist „Zhuan Falun“ (mit demselben Inhalt wie die 9 Vorträge) — können Übende www.falundafa.org besuchen, die Bücher drucken oder Audiodateien herunterladen.

Diese App wurde von einem Falun-Gong-Übenden erstellt, um anderen Übenden den Zugang zu Online-Studienmaterialien auf der offiziellen Website www.falundafa.org zu erleichtern.

Die App enthält auch einen grundlegenden Übungsleitfaden für neue Übende sowie eine Download-Taste, damit Audio ohne Internet genutzt werden kann.

Um mehr über Falun Gong (Falun Dafa) zu erfahren, besuchen Sie bitte:
''',
    NewAreaLang.espanol => '''Hoy en día muchas personas han conocido la bondad de Falun Gong (Falun Dafa) y han comenzado a practicar.

Para escuchar las 9 conferencias o leer los libros — el libro principal es « Zhuan Falun » (con el mismo contenido que las 9 conferencias) — los practicantes pueden visitar www.falundafa.org, imprimir los libros o descargar archivos de audio.

Esta aplicación fue creada por un practicante de Falun Gong para ayudar a otros practicantes a acceder a materiales de estudio en línea en el sitio oficial www.falundafa.org

La aplicación también incluye una guía de práctica básica para principiantes y un botón de descarga para usar el audio sin Internet.

Para conocer más plenamente Falun Gong (Falun Dafa), visite:
''',
    NewAreaLang.farsi => '''امروزه بسیاری از مردم از خوبی فالون گونگ (فالون دافا) آگاه شده‌اند و تمرین را آغاز کرده‌اند.

برای گوش دادن به ۹ سخنرانی یا خواندن کتاب‌ها — کتاب اصلی «ژوان فالون» است (با همان محتوای ۹ سخنرانی) — تمرین‌کنندگان می‌توانند به www.falundafa.org مراجعه کنند، کتاب‌ها را چاپ کنند یا فایل‌های صوتی را دانلود کنند.

این برنامه توسط یک تمرین‌کننده فالون گونگ ساخته شده تا به دیگر تمرین‌کنندگان در دسترسی به مطالب آموزشی آنلاین در وب‌سایت رسمی www.falundafa.org کمک کند.

برنامه همچنین شامل راهنمای تمرین پایه برای مبتدیان و دکمه دانلود است تا بتوان از صدا بدون اینترنت استفاده کرد.

برای آشنایی کامل‌تر با فالون گونگ (فالون دافا) لطفاً مراجعه کنید به:
''',
    NewAreaLang.francais => '''Aujourd'hui, de nombreuses personnes ont découvert la bonté du Falun Gong (Falun Dafa) et ont commencé à pratiquer.

Pour écouter les 9 conférences ou lire les livres — le livre principal étant « Zhuan Falun » (avec le même contenu que les 9 conférences) — les pratiquants peuvent consulter www.falundafa.org, imprimer les livres ou télécharger des fichiers audio.

Cette application a été créée par un pratiquant de Falun Gong pour aider d'autres pratiquants à accéder aux supports d'étude en ligne sur le site officiel www.falundafa.org

L'application comprend également un guide de pratique de base pour aider les nouveaux pratiquants, et un bouton de téléchargement afin d'utiliser l'audio sans Internet.

Pour en savoir plus sur le Falun Gong (Falun Dafa), veuillez consulter :
''',
    NewAreaLang.hebrew => '''כיום אנשים רבים למדו על הטוב שבפאלון גונג (פאלון דאפא) והחלו לתרגל.

כדי להאזין ל־9 ההרצאות או לקרוא את הספרים — הספר העיקרי הוא « ג'ואן פאלון » (עם אותו תוכן כמו 9 ההרצאות) — מתרגלים יכולים לבקר ב־www.falundafa.org, להדפיס את הספרים או להוריד קבצי אודיו.

אפליקציה זו נוצרה על ידי מתרגל פאלון גונג כדי לעזור למתרגלים אחרים לגשת לחומרי לימוד מקוונים באתר הרשמי www.falundafa.org

האפליקציה כוללת גם מדריך תרגול בסיסי למתחילים וכפתור הורדה כדי להשתמש באודיו ללא אינטרנט.

כדי ללמוד יותר על פאלון גונג (פאלון דאפא), אנא בקרו ב:
''',
    NewAreaLang.hrvatski => '''Danas mnogi ljudi saznali su za dobrotu Falun Gonga (Falun Dafe) i počeli vježbati.

Da bi slušali 9 predavanja ili čitali knjige — glavna knjiga je « Zhuan Falun » (isti sadržaj kao 9 predavanja) — vježbači mogu posjetiti www.falundafa.org, ispisati knjige ili preuzeti audio datoteke.

Ovu aplikaciju je napravio vježbač Falun Gonga kako bi pomogao drugim vježbačima da pristupe online materijalima na službenoj stranici www.falundafa.org

Aplikacija također uključuje osnovni vodič za vježbu za početnike i dugme za preuzimanje kako bi se audio koristio bez interneta.

Za potpunije učenje o Falun Gongu (Falun Dafi) posjetite:
''',
    NewAreaLang.indonesia => '''Saat ini banyak orang telah mengenal kebaikan Falun Gong (Falun Dafa) dan mulai berlatih.

Untuk mendengarkan 9 kuliah atau membaca buku — buku utamanya adalah « Zhuan Falun » (dengan isi yang sama seperti 9 kuliah) — praktisi dapat mengunjungi www.falundafa.org, mencetak buku, atau mengunduh file audio.

Aplikasi ini dibuat oleh seorang praktisi Falun Gong untuk membantu praktisi lain mengakses materi belajar daring di situs resmi www.falundafa.org

Aplikasi ini juga memiliki panduan latihan dasar untuk membantu praktisi baru, serta tombol unduh agar audio dapat digunakan tanpa internet.

Untuk mempelajari Falun Gong (Falun Dafa) lebih lengkap, silakan kunjungi:
''',
    NewAreaLang.italiano => '''Oggigiorno molte persone hanno conosciuto la bontà del Falun Gong (Falun Dafa) e hanno iniziato a praticare.

Per ascoltare le 9 lezioni o leggere i libri — il libro principale è « Zhuan Falun » (con lo stesso contenuto delle 9 lezioni) — i praticanti possono visitare www.falundafa.org, stampare i libri o scaricare file audio.

Questa app è stata creata da un praticante di Falun Gong per aiutare altri praticanti ad accedere ai materiali di studio online sul sito ufficiale www.falundafa.org

L'app include anche una guida alla pratica di base per i nuovi praticanti e un pulsante di download per usare l'audio senza Internet.

Per approfondire il Falun Gong (Falun Dafa), visitate:
''',
    NewAreaLang.japan => '''現在、多くの人が法輪功（法輪大法）の素晴らしさを知り、修煉を始めています。

9つの講義を聴いたり本を読んだりするには——主な本は「転法輪」（9つの講義と同じ内容）——学習者は www.falundafa.org を訪れ、本を印刷したり音声ファイルをダウンロードしたりできます。

このアプリは法輪功の学習者によって作成され、他の学習者が公式サイト www.falundafa.org のオンライン学習資料にアクセスできるよう支援します。

また、新しい学習者が始めやすいよう基本功法ガイドがあり、インターネットがないときでも使えるよう音声をダウンロードするボタンもあります。

法輪功（法輪大法）についてさらに詳しく知るには、次をご覧ください：
''',
    NewAreaLang.korean => '''오늘날 많은 사람들이 파룬궁(파룬따파)의 훌륭함을 알고 수련을 시작했습니다.

9개 강의를 듣거나 책을 읽으려면——주요 책은 「전법륜」(9개 강의와 같은 내용)——수련생은 www.falundafa.org 를 방문하거나 책을 인쇄하거나 음성 파일을 내려받을 수 있습니다.

이 앱은 파룬궁 수련생이 다른 수련생들이 공식 사이트 www.falundafa.org 의 온라인 학습 자료에 접근하도록 돕기 위해 만들었습니다.

또한 새 수련생을 위한 기본 연공 안내와 인터넷 없이도 음성을 쓸 수 있도록 다운로드 버튼이 있습니다.

파룬궁(파룬따파)에 대해 더 자세히 알아보려면 다음을 방문하세요:
''',
    NewAreaLang.polski => '''Obecnie wiele osób poznało dobroć Falun Gong (Falun Dafa) i rozpoczęło praktykę.

Aby słuchać 9 wykładów lub czytać książki — główną książką jest « Zhuan Falun » (z tą samą treścią co 9 wykładów) — praktykujący mogą odwiedzić www.falundafa.org, wydrukować książki lub pobrać pliki audio.

Ta aplikacja została stworzona przez praktykującego Falun Gong, aby pomóc innym praktykującym uzyskać dostęp do materiałów do nauki online na oficjalnej stronie www.falundafa.org

Aplikacja zawiera także podstawowy przewodnik ćwiczeń dla początkujących oraz przycisk pobierania, aby używać audio bez internetu.

Aby dowiedzieć się więcej o Falun Gong (Falun Dafa), odwiedź:
''',
    NewAreaLang.portugues => '''Hoje em dia muitas pessoas conheceram a bondade do Falun Gong (Falun Dafa) e começaram a praticar.

Para ouvir as 9 palestras ou ler os livros — o livro principal é « Zhuan Falun » (com o mesmo conteúdo das 9 palestras) — os praticantes podem visitar www.falundafa.org, imprimir os livros ou baixar arquivos de áudio.

Este aplicativo foi criado por um praticante de Falun Gong para ajudar outros praticantes a acessar materiais de estudo online no site oficial www.falundafa.org

O aplicativo também inclui um guia de prática básica para novos praticantes e um botão de download para usar o áudio sem Internet.

Para saber mais sobre o Falun Gong (Falun Dafa), visite:
''',
    NewAreaLang.russian => '''Сегодня многие люди узнали о благости Фалуньгун (Фалунь Дафа) и начали заниматься.

Чтобы слушать 9 лекций или читать книги — главная книга «Чжуань Фалунь» (с тем же содержанием, что и 9 лекций) — практикующие могут посетить www.falundafa.org, распечатать книги или скачать аудиофайлы.

Это приложение создано практикующим Фалуньгун, чтобы помочь другим практикующим получать учебные материалы на официальном сайте www.falundafa.org

В приложении также есть базовое руководство по упражнениям для начинающих и кнопка загрузки, чтобы использовать аудио без интернета.

Чтобы подробнее узнать о Фалуньгун (Фалунь Дафа), посетите:
''',
    NewAreaLang.slovencina => '''Dnes mnohí ľudia spoznali dobrotu Falun Gongu (Falun Dafa) a začali cvičiť.

Na vypočutie 9 prednášok alebo čítanie kníh — hlavná kniha je « Zhuan Falun » (s rovnakým obsahom ako 9 prednášok) — cvičiaci môžu navštíviť www.falundafa.org, vytlačiť knihy alebo stiahnuť audio súbory.

Túto aplikáciu vytvoril cvičiaci Falun Gongu, aby pomohol iným cvičiacim získať prístup k online študijným materiálom na oficiálnej stránke www.falundafa.org

Aplikácia obsahuje aj základného sprievodcu cvičením pre začiatočníkov a tlačidlo na stiahnutie, aby bolo možné používať audio bez internetu.

Ak sa chcete dozvedieť viac o Falun Gongu (Falun Dafa), navštívte:
''',
    NewAreaLang.srpski => '''Данас многи људи сазнали су за доброту Фалун Гонга (Фалун Дафе) и почели да вежбају.

Да би слушали 9 предавања или читали књиге — главна књига је « Жуан Фалун » (исти садржај као 9 предавања) — вежбачи могу посетити www.falundafa.org, одштампати књиге или преузети аудио датотеке.

Ову апликацију је направио вежбач Фалун Гонга како би помогао другим вежбачима да приступе онлајн материјалима на званичном сајту www.falundafa.org

Апликација такође укључује основни водич за вежбу за почетнике и дугме за преузимање како би се аудио користио без интернета.

За потпуније учење о Фалун Гонгу (Фалун Дафи) посетите:
''',
    NewAreaLang.thai => '''ปัจจุบันมีผู้คนจำนวนมากได้รู้จักความดีงามของฝ่าหลุนกง (ฝ่าหลุนต้าฝ่า) และเริ่มฝึกฝน

เพื่อฟังการบรรยาย 9 บท หรืออ่านหนังสือ — หนังสือหลักคือ 「จวนฝ่าหลุน」 (เนื้อหาเดียวกับการบรรยาย 9 บท) — ผู้ฝึกสามารถเข้าชม www.falundafa.org พิมพ์หนังสือ หรือดาวน์โหลดไฟล์เสียงมาใช้

แอปนี้สร้างโดยผู้ฝึกฝ่าหลุนกง เพื่อช่วยผู้ฝึกคนอื่นเข้าถึงสื่อการเรียนรู้ออนไลน์บนเว็บไซต์ทางการ www.falundafa.org

แอปยังมีคู่มือการฝึกพื้นฐานสำหรับผู้เริ่มต้น และปุ่มดาวน์โหลดเพื่อใช้ไฟล์เสียงเมื่อไม่มีอินเทอร์เน็ต

หากต้องการเรียนรู้เกี่ยวกับฝ่าหลุนกง (ฝ่าหลุนต้าฝ่า) อย่างครบถ้วน กรุณาเยี่ยมชม:
''',
    NewAreaLang.turkce => '''Günümüzde birçok kişi Falun Gong'un (Falun Dafa) iyiliğini öğrenmiş ve uygulamaya başlamıştır.

9 dersi dinlemek veya kitapları okumak için — ana kitap « Zhuan Falun »dur (9 dersle aynı içerik) — uygulayıcılar www.falundafa.org adresini ziyaret edebilir, kitapları yazdırabilir veya ses dosyalarını indirebilir.

Bu uygulama, diğer uygulayıcıların resmi site www.falundafa.org üzerindeki çevrimiçi çalışma materyallerine erişmesine yardımcı olmak için bir Falun Gong uygulayıcısı tarafından oluşturulmuştur.

Uygulama ayrıca yeni başlayanlar için temel bir uygulama rehberi ve internet yokken ses kullanmak için bir indirme düğmesi içerir.

Falun Gong (Falun Dafa) hakkında daha fazla bilgi için lütfen ziyaret edin:
''',
    NewAreaLang.ukrainian => '''Нині багато людей дізналися про доброту Фалуньгун (Фалунь Дафа) і почали практикувати.

Щоб слухати 9 лекцій або читати книги — головна книга «Чжуань Фалунь» (з тим самим змістом, що й 9 лекцій) — практикувальники можуть відвідати www.falundafa.org, надрукувати книги або завантажити аудіофайли.

Цей додаток створив практикувальник Фалуньгун, щоб допомогти іншим практикувальникам отримувати навчальні матеріали на офіційному сайті www.falundafa.org

У додатку також є базовий посібник з вправ для новачків і кнопка завантаження, щоб користуватися аудіо без інтернету.

Щоб докладніше дізнатися про Фалуньгун (Фалунь Дафа), відвідайте:
''',
  };

  /// False only for Vietnamese (source language for About / Practice Guide).
  static bool aboutPage1IsTranslated(NewAreaLang lang) =>
      lang != NewAreaLang.vietnamese;

  /// False only for Vietnamese (source language for Practice Guide).
  static bool practiceIsTranslated(NewAreaLang lang) =>
      lang != NewAreaLang.vietnamese;

  /// False only for English (source language for Privacy).
  static bool privacyIsTranslated(NewAreaLang lang) =>
      lang != NewAreaLang.english;

  /// Convenience: footer string when content is translated; empty otherwise.
  static String aboutGoogleFooter(NewAreaLang lang) =>
      aboutPage1IsTranslated(lang)
          ? NewAreaUiStrings(lang).googleTranslateFooter
          : '';

  static String practiceGoogleFooter(NewAreaLang lang) =>
      practiceIsTranslated(lang)
          ? NewAreaUiStrings(lang).googleTranslateFooter
          : '';

  static String privacyGoogleFooter(NewAreaLang lang) =>
      privacyIsTranslated(lang)
          ? NewAreaUiStrings(lang).googleTranslateFooter
          : '';


  static String overviewBody1(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''"Xiu" is a Sino-Vietnamese word meaning to correct or amend. "Lian" means to temper (tempering one's xinxing / character, and tempering the body...). In short, "cultivation practice" means correcting oneself according to a method and maintaining what has been corrected and tempered.

Falun Gong is a Buddha-school cultivation practice that allows people to cultivate in ordinary society—at home, at work, at school, and so on. It emphasizes correcting unhealthy mindsets such as jealousy, the desire to show off, the competitive mentality, and more.

Practicing the 5 exercises helps practitioners become healthier through positive changes in the body.
To cultivate xinxing, practitioners need to study the Fa by listening to Master's 9 lectures or by reading the books—the main book being Zhuan Falun (with the same content as the 9 lectures).
On the official website www.falundafa.org there are also other books and scriptures, such as The Great Consummation Way, which explains the principles of the movements; other supporting books such as Essentials for Further Advancement; and Master's lectures in various places (with answers to many practitioners' questions)...

Practitioners can also visit minghui.org for the latest news and important articles of the practice, such as the Three Things Dafa disciples should do, the article "How Humankind Came to Be", and more.

When reading books or scriptures, practitioners should place them in clean, elevated places such as on a desk or a stand. Do not place them low on the floor or in places that shake. Practitioners may also sit at a desk while reading.
''',
    NewAreaLang.vietnamese => '''"Tu" là từ Hán Việt, "tu" có nghĩa là sửa hay sửa đổi. Còn "luyện" là rèn luyện (rèn luyện tâm tính, rèn luyện thân thể...). Có thể nói rằng "tu luyện" là việc sửa lại bản thân theo một phương pháp và giữ gìn những gì đã sửa được, đã luyện được.

Pháp Luân Công là môn tu luyện của Phật Pháp giúp người học có thể tu luyện ngay trong cuộc sống như tại gia đình, nơi làm việc, trường học ... Trong đó chú trọng việc sửa đổi các tâm tính không tốt như tâm tật đố, tâm lý hiển thị, tâm tranh đấu ...

Việc tập luyện 5 bài công pháp giúp học viên trở nên khoẻ mạnh hơn nhờ những thay đổi tích cực của cơ thể.
Để tu luyện tâm tính, học viên cần học pháp bằng việc lắng nghe 9 bài giảng của sư phụ hoặc đọc sách, trong đó sách chính là Chuyển Pháp Luân (có chung nội dung với 9 bài giảng).
Tại trang chủ www.falundafa.org còn có các sách và kinh văn như: Sách Đại Viên Mãn Pháp giúp hiểu rõ cơ lý của động tác, sách hỗ trợ khác như Tinh Tấn Yếu Chỉ và giảng pháp tại các nơi của sư phụ (có giải đáp nhiều câu hỏi của học viên) ...

Học viên cũng có thể truy cập trang minghui.org để theo dõi các thông tin mới và bài viết quan trọng của môn học như: Ba việc nên làm của đệ tử Đại Pháp, bài viết "Vì sao có nhân loại"...

Khi đọc sách, kinh văn, học viên nên đặt sách, kinh văn ở những nơi như trên bàn, giá đỡ trên cao, tĩnh. Không nên đặt ở những nơi thấp như dưới đất, sàn nhà, hoặc nơi rung lắc ... Học viên có thể vừa ngồi song bàn vừa đọc.
''',
    NewAreaLang.chinese1 => '''「修」是漢語詞，意思是改正或修正。「煉」是鍛鍊（鍛鍊心性、鍛鍊身體……）。可以說「修煉」就是按照一種方法改正自己，並守住已經改正、已經煉成的東西。

法輪功是佛家修煉方法，使人能在日常生活中修煉——在家、工作、學校等。它注重改正不好的心性，如妒嫉心、顯示心、爭鬥心等。

練習五套功法，通過身體的積極變化，幫助學員變得更健康。
要修煉心性，學員需聽師父的九講或讀書來學法——主要書籍是《轉法輪》（與九講內容相同）。
官網 www.falundafa.org 還有其他書籍與經文，如幫助理解動作機理的《大圓滿法》、《精進要旨》等輔助書籍，以及師父各地講法（解答學員許多問題）……

學員也可訪問 minghui.org，了解最新消息與重要文章，如大法弟子應做的三件事、「為什麼有人類」等。

讀經書時，應放在乾淨、較高的地方，如桌上或支架上。不要放在地面等低處或晃動的地方。學員也可坐在桌前閱讀。
''',
    NewAreaLang.chinese2 => '''「修」是汉语词，意思是改正或修正。「炼」是锻炼（锻炼心性、锻炼身体……）。可以说「修炼」就是按照一种方法改正自己，并守住已经改正、已经炼成的东西。

法轮功是佛家修炼方法，使人能在日常生活中修炼——在家、工作、学校等。它注重改正不好的心性，如妒嫉心、显示心、争斗心等。

练习五套功法，通过身体的积极变化，帮助学员变得更健康。
要修炼心性，学员需听师父的九讲或读书来学法——主要书籍是《转法轮》（与九讲内容相同）。
官网 www.falundafa.org 还有其他书籍与经文，如帮助理解动作机理的《大圆满法》、《精进要旨》等辅助书籍，以及师父各地讲法（解答学员许多问题）……

学员也可访问 minghui.org，了解最新消息与重要文章，如大法弟子应做的三件事、「为什么有人类」等。

读经书时，应放在干净、较高的地方，如桌上或支架上。不要放在地面等低处或晃动的地方。学员也可坐在桌前阅读。
''',
    NewAreaLang.bosanski => '''« Xiu » znači ispraviti ili popraviti. « Lian » znači kaliti (kaliti xinxing / karakter i tijelo...). Ukratko, « praksa kultivacije » znači ispravljati sebe prema metodi i održavati ono što je ispravljeno i okaljeno.

Falun Gong je praksa kultivacije budističke škole koja omogućava kultivaciju u običnom društvu — kod kuće, na poslu, u školi itd. Naglašava ispravljanje nezdravih načina razmišljanja kao što su ljubomora, želja za pokazivanjem, takmičarski mentalitet i drugo.

Vježbanje 5 vježbi pomaže vježbačima da postanu zdraviji kroz pozitivne promjene u tijelu.
Da bi kultivirali xinxing, vježbači trebaju učiti Fa slušajući 9 predavanja Učitelja ili čitajući knjige — glavna knjiga je Zhuan Falun (isti sadržaj kao 9 predavanja).
Na službenoj stranici www.falundafa.org postoje i druge knjige i spisi, poput Velikog puta savršenstva, koji objašnjava principe pokreta; pomoćne knjige kao Essentials for Further Advancement; i Učiteljeva predavanja na raznim mjestima (s odgovorima na mnoga pitanja vježbača)...

Vježbači također mogu posjetiti minghui.org za najnovije vijesti i važne članke prakse, poput Tri stvari koje učenici Dafe trebaju raditi, članak « Kako je nastalo čovječanstvo » itd.

Pri čitanju knjiga ili spisa, vježbači ih trebaju staviti na čista, uzdignuta mjesta — na sto ili stalk. Ne stavljati nisko na pod ili na mjesta koja se trese. Mogu i sjediti za stolom dok čitaju.
''',
    NewAreaLang.deutsch => '''„Xiu“ bedeutet berichtigen oder verbessern. „Lian“ bedeutet läutern (Charakter/Xinxing und Körper läutern...). Kurz gesagt bedeutet „Kultivierungspraxis“, sich nach einer Methode zu berichtigen und das Berichtigte und Geläuterte zu bewahren.

Falun Gong ist eine Kultivierungspraxis der Buddha-Schule, die es Menschen ermöglicht, im gewöhnlichen Leben zu kultivieren — zu Hause, bei der Arbeit, in der Schule usw. Sie betont die Berichtigung ungesunder Denkweisen wie Eifersucht, Prahlsucht, Wettbewerbsdenken und mehr.

Das Üben der 5 Übungen hilft Übenden, durch positive Veränderungen im Körper gesünder zu werden.
Um Xinxing zu kultivieren, müssen Übende das Fa studieren, indem sie die 9 Vorträge des Meisters hören oder Bücher lesen — das Hauptbuch ist Zhuan Falun (mit demselben Inhalt wie die 9 Vorträge).
Auf der offiziellen Website www.falundafa.org gibt es auch andere Bücher und Schriften, etwa Der Große Vollendungsweg, der die Prinzipien der Bewegungen erklärt; unterstützende Bücher wie Essentials for Further Advancement; und Vorträge des Meisters an verschiedenen Orten (mit Antworten auf viele Fragen von Übenden)...

Übende können auch minghui.org besuchen für aktuelle Nachrichten und wichtige Artikel der Praxis, etwa die Drei Dinge, die Dafa-Schüler tun sollten, den Artikel „Wie die Menschheit entstand“ und mehr.

Beim Lesen von Büchern oder Schriften sollten Übende sie an sauberen, erhöhten Orten ablegen, etwa auf einem Schreibtisch oder Ständer. Nicht tief auf dem Boden oder an Orten, die wackeln. Übende können auch am Schreibtisch sitzen und lesen.
''',
    NewAreaLang.espanol => '''« Xiu » significa corregir o enmendar. « Lian » significa templar (templar el xinxing / carácter y templar el cuerpo...). En resumen, « práctica de cultivación » significa corregirse según un método y mantener lo corregido y templado.

Falun Gong es una práctica de cultivación de la escuela de Buda que permite cultivar en la sociedad ordinaria: en casa, en el trabajo, en la escuela, etc. Enfatiza corregir mentalidades poco saludables como los celos, el deseo de exhibirse, la mentalidad competitiva y más.

Practicar los 5 ejercicios ayuda a los practicantes a volverse más saludables mediante cambios positivos en el cuerpo.
Para cultivar el xinxing, los practicantes deben estudiar el Fa escuchando las 9 conferencias del Maestro o leyendo los libros — el principal es Zhuan Falun (mismo contenido que las 9 conferencias).
En el sitio oficial www.falundafa.org también hay otros libros y escrituras, como El Gran Camino de la Consumación, que explica los principios de los movimientos; otros libros de apoyo como Essentials for Further Advancement; y conferencias del Maestro en varios lugares (con respuestas a muchas preguntas de practicantes)...

Los practicantes también pueden visitar minghui.org para las últimas noticias y artículos importantes, como las Tres Cosas que los discípulos de Dafa deberían hacer, el artículo « Cómo surgió la humanidad », etc.

Al leer libros o escrituras, los practicantes deben colocarlos en lugares limpios y elevados, como un escritorio o un soporte. No colocarlos bajos en el suelo o en lugares que vibren. También pueden sentarse en un escritorio mientras leen.
''',
    NewAreaLang.farsi => '''«شیو» به معنای اصلاح کردن است. «لیَن» به معنای آبدیده کردن است (آبدیده کردن شین‌شینگ / شخصیت و بدن...). به‌طور خلاصه، «تمرین تزکیه» یعنی اصلاح خود بر اساس یک روش و نگه داشتن آنچه اصلاح و آبدیده شده است.

فالون گونگ تمرین تزکیه مکتب بودا است که به افراد امکان می‌دهد در جامعهٔ معمولی — در خانه، محل کار، مدرسه و غیره — تزکیه کنند. بر اصلاح ذهنیت‌های ناسالم مانند حسادت، میل به خودنمایی، روحیهٔ رقابت و بیشتر تأکید دارد.

انجام ۵ تمرین به تمرین‌کنندگان کمک می‌کند از طریق تغییرات مثبت در بدن سالم‌تر شوند.
برای تزکیهٔ شین‌شینگ، تمرین‌کنندگان باید با گوش دادن به ۹ سخنرانی استاد یا خواندن کتاب‌ها فا را بیاموزند — کتاب اصلی ژوان فالون است (همان محتوای ۹ سخنرانی).
در وب‌سایت رسمی www.falundafa.org کتاب‌ها و نوشته‌های دیگری نیز هست، مانند راه کمال عظیم که اصول حرکات را توضیح می‌دهد؛ کتاب‌های کمکی مانند Essentials for Further Advancement؛ و سخنرانی‌های استاد در جاهای مختلف (با پاسخ به بسیاری از پرسش‌های تمرین‌کنندگان)...

تمرین‌کنندگان همچنین می‌توانند برای آخرین اخبار و مقالات مهم به minghui.org مراجعه کنند، مانند سه کاری که شاگردان دافا باید انجام دهند، مقالهٔ «انسان چگونه پدید آمد» و بیشتر.

هنگام خواندن کتاب یا نوشته‌ها، آن‌ها را در جاهای تمیز و بلند مانند میز یا پایه بگذارید. پایین روی زمین یا در جاهای لرزان نگذارید. می‌توان پشت میز نشست و خواند.
''',
    NewAreaLang.francais => '''« Xiu » signifie corriger ou amender. « Lian » signifie temperer (temperer le xinxing / le caractère, et temperer le corps...). En bref, « la pratique de la cultivation » signifie se corriger selon une méthode et maintenir ce qui a été corrigé et tempéré.

Le Falun Gong est une pratique de cultivation de l'école du Bouddha qui permet de cultiver dans la société ordinaire — à la maison, au travail, à l'école, etc. Il met l'accent sur la correction d'états d'esprit malsains comme la jalousie, le désir de se montrer, la mentalité de compétition, et plus encore.

Pratiquer les 5 exercices aide les pratiquants à devenir plus sains grâce à des changements positifs dans le corps.
Pour cultiver le xinxing, les pratiquants doivent étudier le Fa en écoutant les 9 conférences du Maître ou en lisant les livres — le livre principal étant Zhuan Falun (même contenu que les 9 conférences).
Sur le site officiel www.falundafa.org se trouvent aussi d'autres livres et écritures, comme La Grande Voie de la Consommation, qui explique les principes des mouvements ; d'autres livres de soutien comme Essentials for Further Advancement ; et les conférences du Maître dans divers lieux (avec des réponses à de nombreuses questions des pratiquants)...

Les pratiquants peuvent aussi consulter minghui.org pour les dernières nouvelles et articles importants, comme les Trois Choses que les disciples de Dafa devraient faire, l'article « Comment l'humanité est apparue », etc.

En lisant livres ou écritures, les pratiquants devraient les placer dans des endroits propres et élevés, comme sur un bureau ou un support. Ne pas les placer bas sur le sol ou dans des endroits qui bougent. Les pratiquants peuvent aussi s'asseoir à un bureau pour lire.
''',
    NewAreaLang.hebrew => '''« Xiu » פירושו לתקן או לשפר. « Lian » פירושו לצרוף (לצרוף את הסינסינג / האופי ואת הגוף...). בקצרה, « תרגול הקולטיבציה » פירושו לתקן את עצמך לפי שיטה ולשמור על מה שתוקן ונצרף.

פאלון גונג הוא תרגול קולטיבציה של אסכולת הבודהה המאפשר לקולטיבציה בחברה הרגילה — בבית, בעבודה, בבית הספר וכו'. הוא מדגיש תיקון הלכי רוח לא בריאים כמו קנאה, רצון להתרברב, תחרותיות ועוד.

תרגול 5 התרגילים עוזר למתרגלים להיות בריאים יותר באמצעות שינויים חיוביים בגוף.
כדי לקולטיבציה של הסינסינג, מתרגלים צריכים ללמוד את הפא בהאזנה ל־9 ההרצאות של המורה או בקריאת הספרים — הספר העיקרי הוא ג'ואן פאלון (אותו תוכן כמו 9 ההרצאות).
באתר הרשמי www.falundafa.org יש גם ספרים וכתבים נוספים, כמו הדרך הגדולה של ההשלמה, המסבירה את עקרונות התנועות; ספרי תמיכה כמו Essentials for Further Advancement; והרצאות המורה במקומות שונים (עם תשובות לשאלות רבות של מתרגלים)...

מתרגלים יכולים גם לבקר ב־minghui.org לחדשות האחרונות ומאמרים חשובים של התרגול, כמו שלושת הדברים שתלמידי דאפא צריכים לעשות, המאמר « כיצד נוצרה האנושות » ועוד.

בקריאת ספרים או כתבים יש להניחם במקומות נקיים וגבוהים — על שולחן או מעמד. אל תניחו נמוך על הרצפה או במקומות רועדים. אפשר גם לשבת ליד שולחן בזמן הקריאה.
''',
    NewAreaLang.hrvatski => '''« Xiu » znači ispraviti ili popraviti. « Lian » znači kaliti (kaliti xinxing / karakter i tijelo...). Ukratko, « praksa kultivacije » znači ispravljati sebe prema metodi i održavati ono što je ispravljeno i okaljeno.

Falun Gong je praksa kultivacije budističke škole koja omogućava kultivaciju u običnom društvu — kod kuće, na poslu, u školi itd. Naglašava ispravljanje nezdravih načina razmišljanja kao što su ljubomora, želja za pokazivanjem, takmičarski mentalitet i drugo.

Vježbanje 5 vježbi pomaže vježbačima da postanu zdraviji kroz pozitivne promjene u tijelu.
Da bi kultivirali xinxing, vježbači trebaju učiti Fa slušajući 9 predavanja Učitelja ili čitajući knjige — glavna knjiga je Zhuan Falun (isti sadržaj kao 9 predavanja).
Na službenoj stranici www.falundafa.org postoje i druge knjige i spisi, poput Velikog puta savršenstva, koji objašnjava principe pokreta; pomoćne knjige kao Essentials for Further Advancement; i Učiteljeva predavanja na raznim mjestima (s odgovorima na mnoga pitanja vježbača)...

Vježbači također mogu posjetiti minghui.org za najnovije vijesti i važne članke prakse, poput Tri stvari koje učenici Dafe trebaju raditi, članak « Kako je nastalo čovječanstvo » itd.

Pri čitanju knjiga ili spisa, vježbači ih trebaju staviti na čista, uzdignuta mjesta — na sto ili stalk. Ne stavljati nisko na pod ili na mjesta koja se trese. Mogu i sjediti za stolom dok čitaju.
''',
    NewAreaLang.indonesia => '''« Xiu » berarti memperbaiki atau mengoreksi. « Lian » berarti menempa (menempa xinxing / karakter, dan menempa tubuh...). Singkatnya, « praktik kultivasi » berarti memperbaiki diri menurut suatu metode dan menjaga apa yang telah diperbaiki dan ditempa.

Falun Gong adalah praktik kultivasi aliran Buddha yang memungkinkan orang berkultivasi dalam masyarakat biasa—di rumah, di tempat kerja, di sekolah, dan sebagainya. Ia menekankan koreksi pola pikir yang tidak sehat seperti kecemburuan, keinginan pamer, mentalitas bersaing, dan lainnya.

Melatih 5 gerakan membantu praktisi menjadi lebih sehat melalui perubahan positif pada tubuh.
Untuk mengkultivasi xinxing, praktisi perlu mempelajari Fa dengan mendengarkan 9 kuliah Guru atau membaca buku—buku utamanya adalah Zhuan Falun (isi sama dengan 9 kuliah).
Di situs resmi www.falundafa.org ada juga buku dan kitab lain, seperti Jalan Kesempurnaan Agung yang menjelaskan prinsip gerakan; buku pendukung seperti Essentials for Further Advancement; dan kuliah Guru di berbagai tempat (dengan jawaban atas banyak pertanyaan praktisi)...

Praktisi juga dapat mengunjungi minghui.org untuk berita terbaru dan artikel penting praktik, seperti Tiga Hal yang harus dilakukan murid Dafa, artikel « Bagaimana umat manusia muncul », dll.

Saat membaca buku atau kitab, praktisi harus meletakkannya di tempat bersih dan tinggi, seperti di meja atau rak. Jangan meletakkannya rendah di lantai atau di tempat yang goyang. Praktisi juga boleh duduk di meja sambil membaca.
''',
    NewAreaLang.italiano => '''« Xiu » significa correggere o emendare. « Lian » significa temperare (temperare lo xinxing / il carattere e temperare il corpo...). In breve, « pratica di coltivazione » significa correggersi secondo un metodo e mantenere ciò che è stato corretto e temperato.

Il Falun Gong è una pratica di coltivazione della scuola del Buddha che permette di coltivare nella società ordinaria — a casa, al lavoro, a scuola, ecc. Enfatizza la correzione di mentalità malsane come gelosia, desiderio di mettersi in mostra, mentalità competitiva e altro.

Praticare i 5 esercizi aiuta i praticanti a diventare più sani attraverso cambiamenti positivi nel corpo.
Per coltivare lo xinxing, i praticanti devono studiare il Fa ascoltando le 9 lezioni del Maestro o leggendo i libri — il libro principale è Zhuan Falun (stesso contenuto delle 9 lezioni).
Sul sito ufficiale www.falundafa.org ci sono anche altri libri e scritture, come La Grande Via della Consumazione, che spiega i principi dei movimenti; altri libri di supporto come Essentials for Further Advancement; e lezioni del Maestro in vari luoghi (con risposte a molte domande dei praticanti)...

I praticanti possono anche visitare minghui.org per le ultime notizie e articoli importanti della pratica, come le Tre Cose che i discepoli di Dafa dovrebbero fare, l'articolo « Come è nata l'umanità » e altro.

Quando si leggono libri o scritture, i praticanti dovrebbero posizionarli in luoghi puliti ed elevati, come su una scrivania o un supporto. Non metterli in basso sul pavimento o in luoghi che vibrano. I praticanti possono anche sedersi a una scrivania mentre leggono.
''',
    NewAreaLang.japan => '''「修」は正す・改めるという意味です。「煉」は鍛えるという意味です（心性を鍛え、体を鍛えるなど）。つまり「修煉」とは、ある方法に従って自分を正し、正したもの・鍛えたものを保つことです。

法輪功は仏家の修煉法で、家庭・職場・学校など日常社会の中で修煉できます。嫉妬、見せびらかし、争いの心など、良くない心性を正すことを重視します。

5つの功法を練習すると、体の良い変化により健康になります。
心性を修煉するには、師の9つの講義を聴くか本を読んで法を学ぶ必要があります——主な本は転法輪です（9つの講義と同じ内容）。
公式サイト www.falundafa.org には他の書物・経文もあります。例えば動作の原理を説明する大円満法、精進要旨などの補助書、各地での師の講法（学習者の多くの質問への回答付き）などです...

また minghui.org で最新ニュースや重要な文章——大法弟子がすべき三つのこと、「なぜ人類がいるのか」など——を見ることができます。

本や経文を読むときは、机や高い台など清潔で高い場所に置いてください。床の低い場所や揺れる場所に置かないでください。机に座って読むこともできます。
''',
    NewAreaLang.korean => '''「수(修)」는 고치거나 바로잡는다는 뜻입니다. 「련(煉)」은 단련한다는 뜻입니다(심성 단련, 몸 단련 등). 즉 「수련」은 어떤 방법에 따라 자신을 바로잡고, 바로잡고 단련한 것을 지키는 것입니다.

파룬궁은 불가의 수련법으로, 가정·직장·학교 등 일상 사회에서 수련할 수 있습니다. 질투심, 과시심, 투쟁심 등 좋지 않은 심성을 바로잡는 것을 중시합니다.

5가지 공법을 연마하면 몸의 긍정적인 변화로 건강해집니다.
심성을 수련하려면 스승님의 9개 강의를 듣거나 책을 읽어 법을 배워야 합니다——주요 책은 전법륜입니다(9개 강의와 같은 내용).
공식 사이트 www.falundafa.org 에는 다른 책과 경문도 있습니다. 예를 들어 동작의 원리를 설명하는 대원만법, 정진요지 같은 보조 서적, 각지에서의 스승님 강법(수련생들의 많은 질문에 대한 답변 포함) 등입니다...

또한 minghui.org 에서 최신 소식과 중요한 글——대법제자가 해야 할 세 가지, 「인류가 왜 있는가」 등——을 볼 수 있습니다.

책이나 경문을 읽을 때는 책상이나 높은 받침대 등 깨끗하고 높은 곳에 두세요. 바닥처럼 낮은 곳이나 흔들리는 곳에 두지 마세요. 책상에 앉아 읽을 수도 있습니다.
''',
    NewAreaLang.polski => '''« Xiu » oznacza poprawiać lub korygować. « Lian » oznacza hartować (hartować xinxing / charakter i ciało...). Krótko mówiąc, « praktyka kultywacji » oznacza poprawianie siebie według metody i utrzymywanie tego, co zostało poprawione i zahartowane.

Falun Gong to praktyka kultywacji szkoły Buddy, która pozwala kultywować w zwykłym społeczeństwie — w domu, w pracy, w szkole itd. Podkreśla korygowanie niezdrowych nastawień, takich jak zazdrość, chęć popisania się, mentalność rywalizacji i inne.

Ćwiczenie 5 ćwiczeń pomaga praktykującym stać się zdrowszymi dzięki pozytywnym zmianom w ciele.
Aby kultywować xinxing, praktykujący muszą studiować Fa, słuchając 9 wykładów Mistrza lub czytając książki — główną jest Zhuan Falun (ta sama treść co 9 wykładów).
Na oficjalnej stronie www.falundafa.org są też inne książki i pisma, np. Wielka Droga Spełnienia, wyjaśniająca zasady ruchów; książki pomocnicze jak Essentials for Further Advancement; oraz wykłady Mistrza w różnych miejscach (z odpowiedziami na wiele pytań praktykujących)...

Praktykujący mogą też odwiedzać minghui.org po najnowsze wiadomości i ważne artykuły praktyki, np. Trzy Rzeczy, które powinni robić uczniowie Dafa, artykuł « Jak powstała ludzkość » itd.

Czytając książki lub pisma, należy kłaść je w czystych, wyniesionych miejscach — na biurku lub stojaku. Nie kłaść nisko na podłodze ani w miejscach, które się trzęsą. Można też siedzieć przy biurku podczas czytania.
''',
    NewAreaLang.portugues => '''« Xiu » significa corrigir ou emendar. « Lian » significa temperar (temperar o xinxing / caráter e temperar o corpo...). Em resumo, « prática de cultivo » significa corrigir-se segundo um método e manter o que foi corrigido e temperado.

O Falun Gong é uma prática de cultivo da escola de Buda que permite cultivar na sociedade comum — em casa, no trabalho, na escola, etc. Enfatiza corrigir mentalidades pouco saudáveis como ciúme, desejo de se exibir, mentalidade competitiva e mais.

Praticar os 5 exercícios ajuda os praticantes a ficarem mais saudáveis por meio de mudanças positivas no corpo.
Para cultivar o xinxing, os praticantes precisam estudar o Fa ouvindo as 9 palestras do Mestre ou lendo os livros — o principal é Zhuan Falun (mesmo conteúdo das 9 palestras).
No site oficial www.falundafa.org também há outros livros e escrituras, como O Grande Caminho da Consumação, que explica os princípios dos movimentos; outros livros de apoio como Essentials for Further Advancement; e palestras do Mestre em vários lugares (com respostas a muitas perguntas dos praticantes)...

Os praticantes também podem visitar minghui.org para as últimas notícias e artigos importantes, como as Três Coisas que os discípulos de Dafa devem fazer, o artigo « Como a humanidade veio a existir », etc.

Ao ler livros ou escrituras, os praticantes devem colocá-los em lugares limpos e elevados, como uma mesa ou suporte. Não os coloque baixos no chão ou em lugares que vibrem. Também podem sentar-se à mesa enquanto leem.
''',
    NewAreaLang.russian => '''«Сю» означает исправлять. «Лянь» означает закалять (закалять синьсин / характер и тело...). Короче, «практика совершенствования» — исправлять себя по методу и сохранять исправленное и закалённое.

Фалуньгун — практика совершенствования буддийской школы, позволяющая совершенствоваться в обычной жизни — дома, на работе, в школе и т.д. Она подчёркивает исправление нездоровых состояний ума: зависти, желания показать себя, соперничества и др.

Выполнение 5 упражнений помогает практикующим стать здоровее благодаря положительным изменениям в теле.
Чтобы совершенствовать синьсин, практикующим нужно изучать Фа, слушая 9 лекций Учителя или читая книги — главная книга «Чжуань Фалунь» (то же содержание, что и 9 лекций).
На официальном сайте www.falundafa.org также есть другие книги и писания, например «Великий путь совершенствования», объясняющий принципы движений; вспомогательные книги вроде Essentials for Further Advancement; и лекции Учителя в разных местах (с ответами на многие вопросы практикующих)...

Практикующие также могут посещать minghui.org за новостями и важными статьями практики, например «Три дела, которые должны делать ученики Дафа», статья «Как появилось человечество» и др.

Читая книги или писания, практикующие должны класть их в чистые, возвышенные места — на стол или подставку. Не класть низко на пол или в места, которые трясутся. Можно также сидеть за столом во время чтения.
''',
    NewAreaLang.slovencina => '''« Xiu » znamená opravovať alebo napraviť. « Lian » znamená kaliť (kaliť xinxing / charakter a telo...). Stručne, « prax kultivácie » znamená napravovať sa podľa metódy a udržiavať to, čo bolo napravené a okalené.

Falun Gong je prax kultivácie budhistickej školy, ktorá umožňuje kultivovať v bežnej spoločnosti — doma, v práci, v škole atď. Zdôrazňuje naprávanie nezdravých postojov, ako sú žiarlivosť, túžba predvádzať sa, súťaživá mentalita a ďalšie.

Cvičenie 5 cvičení pomáha cvičiacim stať sa zdravšími vďaka pozitívnym zmenám v tele.
Na kultiváciu xinxingu musia cvičiaci študovať Fa počúvaním 9 prednášok Majstra alebo čítaním kníh — hlavná kniha je Zhuan Falun (rovnaký obsah ako 9 prednášok).
Na oficiálnej stránke www.falundafa.org sú aj iné knihy a spisy, napr. Veľká cesta naplnenia, ktorá vysvetľuje princípy pohybov; podporné knihy ako Essentials for Further Advancement; a prednášky Majstra na rôznych miestach (s odpoveďami na mnohé otázky cvičiacich)...

Cvičiaci môžu navštíviť aj minghui.org pre najnovšie správy a dôležité články praxe, napr. Tri veci, ktoré by mali robiť žiaci Dafa, článok « Ako vzniklo ľudstvo » atď.

Pri čítaní kníh alebo spisov ich treba klásť na čisté, vyvýšené miesta — na stôl alebo stojan. Neklásť nízko na podlahu ani na miesta, ktoré sa trasú. Možno aj sedieť pri stole počas čítania.
''',
    NewAreaLang.srpski => '''«Сју» значи исправити или поправити. «Љен» значи калити (калити синсинг / карактер и тело...). Укратко, «пракса култивације» значи исправљати себе према методи и одржавати оно што је исправљено и окаљено.

Фалун Гонг је пракса култивације будистичке школе која омогућава култивацију у обичном друштву — код куће, на послу, у школи итд. Наглашава исправљање нездравих начинâ мишљења као што су љубомора, жеља за показивањем, такмичарски менталитет и друго.

Вежбање 5 вежби помаже вежбачима да постану здравији кроз позитивне промене у телу.
Да би култивирали синсинг, вежбачи треба да уче Фа слушајући 9 предавања Учитеља или читајући књиге — главна књига је Жуан Фалун (исти садржај као 9 предавања).
На званичном сајту www.falundafa.org постоје и друге књиге и списи, попут Великог пута савршенства, који објашњава принципе покрета; помоћне књиге као Essentials for Further Advancement; и Учитељева предавања на разним местима (са одговорима на многа питања вежбача)...

Вежбачи такође могу посетити minghui.org за најновије вести и важне чланке праксе, попут Три ствари које ученици Дафе треба да раде, чланак « Како је настало човечанство » итд.

При читању књига или списа, вежбачи их требају ставити на чиста, уздигнута места — на сто или сталак. Не стављати ниско на под или на места која се тресу. Могу и седети за столом док читају.
''',
    NewAreaLang.thai => '''「ซิว」หมายถึงแก้ไขหรือปรับปรุง 「เหลียน」หมายถึงฝึกฝน (ฝึกฝนจิตใจ/ซินซิง และฝึกฝนร่างกาย...) โดยสรุป 「การบำเพ็ญ」คือการแก้ไขตนเองตามวิธีหนึ่ง และรักษาสิ่งที่แก้ไขและฝึกฝนแล้วไว้

ฝ่าหลุนกงเป็นการบำเพ็ญของสำนักพุทธที่ให้คนบำเพ็ญได้ในสังคมปกติ—ที่บ้าน ที่ทำงาน ที่โรงเรียน ฯลฯ เน้นการแก้ไขจิตใจที่ไม่ดี เช่น ความอิจฉา ความอยากอวด ความคิดแข่งขัน และอื่นๆ

การฝึก 5 ท่างช่วยให้ผู้ฝึกแข็งแรงขึ้นผ่านการเปลี่ยนแปลงที่ดีของร่างกาย
เพื่อบำเพ็ญซินซิง ผู้ฝึกต้องเรียนฝ่าโดยฟังการบรรยาย 9 บทของอาจารย์หรืออ่านหนังสือ—หนังสือหลักคือจวนฝ่าหลุน (เนื้อหาเดียวกับ 9 บท)
บนเว็บไซต์ทางการ www.falundafa.org ยังมีหนังสือและคัมภีร์อื่นๆ เช่น ทางแห่งความบริบูรณ์อันยิ่งใหญ่ ที่อธิบายหลักการของท่าทาง หนังสือสนับสนุนอื่นๆ เช่น Essentials for Further Advancement และการบรรยายของอาจารย์ตามสถานที่ต่างๆ (พร้อมคำตอบคำถามมากมาย)...

ผู้ฝึกยังสามารถเข้า minghui.org เพื่อข่าวล่าสุดและบทความสำคัญ เช่น สามสิ่งที่ศิษย์ต้าฝ่าควรทำ บทความ 「มนุษย์เกิดมาได้อย่างไร」 ฯลฯ

เมื่ออ่านหนังสือหรือคัมภีร์ ควรวางไว้ในที่สะอาดและสูง เช่น บนโต๊ะหรือขาตั้ง อย่าวางต่ำบนพื้นหรือที่สั่น สามารถนั่งที่โต๊ะขณะอ่านได้
''',
    NewAreaLang.turkce => '''« Xiu » düzeltmek veya ıslah etmek demektir. « Lian » temperlemek demektir (xinxing / karakteri ve bedeni temperlemek...). Kısaca « yetiştirme uygulaması », bir yönteme göre kendini düzeltmek ve düzeltileni, temperleneni korumak demektir.

Falun Gong, sıradan toplumda — evde, işte, okulda vb. — yetiştirmeye olanak tanıyan Budist okul yetiştirme uygulamasıdır. Kıskançlık, gösteriş arzusu, rekabet zihniyeti gibi sağlıksız zihin hallerini düzeltmeyi vurgular.

5 egzersizi uygulamak, bedendeki olumlu değişimler sayesinde uygulayıcıların daha sağlıklı olmasına yardımcı olur.
Xinxing'i yetiştirmek için uygulayıcılar Usta'nın 9 dersini dinleyerek veya kitapları okuyarak Fa'yı çalışmalıdır — ana kitap Zhuan Falun'dur (9 dersle aynı içerik).
Resmi site www.falundafa.org adresinde hareketlerin ilkelerini açıklayan Büyük Tamamlanma Yolu gibi başka kitaplar ve yazılar; Essentials for Further Advancement gibi destek kitapları; ve çeşitli yerlerdeki Usta konuşmaları (birçok soruya yanıtlarla) da vardır...

Uygulayıcılar ayrıca en son haberler ve önemli makaleler için minghui.org adresini ziyaret edebilir — Dafa müritlerinin yapması gereken Üç Şey, « İnsanlık nasıl ortaya çıktı » makalesi vb.

Kitap veya yazı okurken bunları masa veya stand gibi temiz, yüksek yerlere koyun. Yere düşük yerlere veya sarsılan yerlere koymayın. Okurken masada oturulabilir.
''',
    NewAreaLang.ukrainian => '''«Сю» означає виправляти. «Лянь» означає гартувати (гартувати синьсін / характер і тіло...). Коротко, «практика вдосконалення» — виправляти себе за методом і зберігати виправлене й загартоване.

Фалуньгун — практика вдосконалення буддійської школи, що дозволяє вдосконалюватися в звичайному житті — вдома, на роботі, у школі тощо. Вона підкреслює виправлення нездорових станів розуму: заздрості, бажання показати себе, змагальності тощо.

Виконання 5 вправ допомагає практикувальникам стати здоровішими завдяки позитивним змінам у тілі.
Щоб вдосконалювати синьсін, потрібно вивчати Фа, слухаючи 9 лекцій Учителя або читаючи книги — головна книга «Чжуань Фалунь» (той самий зміст, що й 9 лекцій).
На офіційному сайті www.falundafa.org також є інші книги й писання, наприклад «Великий шлях удосконалення», що пояснює принципи рухів; допоміжні книги на кшталт Essentials for Further Advancement; і лекції Учителя в різних місцях (з відповідями на багато запитань)...

Практикувальники також можуть відвідувати minghui.org за новинами й важливими статтями, наприклад «Три справи, які мають робити учні Дафа», стаття «Як з'явилося людство» тощо.

Читаючи книги чи писання, кладіть їх у чисті, піднесені місця — на стіл чи підставку. Не кладіть низько на підлогу чи в місця, що трясуться. Можна сидіти за столом під час читання.
''',
  };

  static String overviewBody2(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''During study, practitioners can connect with one another to share experiences and gain broader perspectives. Cultivation is a long process, so beginners should be patient and do well in their study.''',
    NewAreaLang.vietnamese => '''Trong quá trình học tập, các học viên có thể kết nối với nhau để tham khảo, chia sẻ quá trình học tập, giúp bản thân có thêm góc nhìn. Tu luyện là một quá trình lâu dài nên khi mới tập các học viên nên kiên nhẫn và thực hiện tốt việc học tập của mình.''',
    NewAreaLang.chinese1 => '''在學習過程中，學員可以互相聯繫，交流分享，拓寬視野。修煉是長期過程，初學時應有耐心，認真做好學習。''',
    NewAreaLang.chinese2 => '''在学习过程中，学员可以互相联系，交流分享，拓宽视野。修炼是长期过程，初学时应有耐心，认真做好学习。''',
    NewAreaLang.bosanski => '''Tokom učenja vježbači se mogu povezati, dijeliti iskustva i steći šire perspektive. Kultivacija je dug proces, pa početnici trebaju biti strpljivi i dobro učiti.''',
    NewAreaLang.deutsch => '''Während des Studiums können Übende miteinander in Kontakt treten, Erfahrungen austauschen und weitere Perspektiven gewinnen. Kultivierung ist ein langer Prozess, daher sollten Anfänger geduldig sein und ihr Studium gut durchführen.''',
    NewAreaLang.espanol => '''Durante el estudio, los practicantes pueden conectarse para compartir experiencias y ganar perspectivas más amplias. La cultivación es un proceso largo, por lo que los principiantes deben ser pacientes y estudiar bien.''',
    NewAreaLang.farsi => '''در جریان مطالعه، تمرین‌کنندگان می‌توانند با هم ارتباط بگیرند، تجربه به اشتراک بگذارند و دیدگاه گسترده‌تری پیدا کنند. تزکیه فرآیندی طولانی است، بنابراین مبتدیان باید صبور باشند و خوب مطالعه کنند.''',
    NewAreaLang.francais => '''Pendant l'étude, les pratiquants peuvent se connecter pour partager leurs expériences et élargir leur perspective. La cultivation est un long processus ; les débutants doivent donc être patients et bien mener leur étude.''',
    NewAreaLang.hebrew => '''במהלך הלימוד מתרגלים יכולים להתחבר, לחלוק חוויות ולהרחיב פרספקטיבה. הקולטיבציה היא תהליך ארוך, ולכן מתחילים צריכים להיות סבלניים וללמוד היטב.''',
    NewAreaLang.hrvatski => '''Tokom učenja vježbači se mogu povezati, dijeliti iskustva i steći šire perspektive. Kultivacija je dug proces, pa početnici trebaju biti strpljivi i dobro učiti.''',
    NewAreaLang.indonesia => '''Selama belajar, praktisi dapat saling terhubung untuk berbagi pengalaman dan memperluas sudut pandang. Kultivasi adalah proses panjang, jadi pemula harus sabar dan belajar dengan baik.''',
    NewAreaLang.italiano => '''Durante lo studio, i praticanti possono collegarsi tra loro per condividere esperienze e ottenere prospettive più ampie. La coltivazione è un lungo processo, quindi i principianti dovrebbero essere pazienti e studiare bene.''',
    NewAreaLang.japan => '''学習の過程で、学習者どうしがつながり、経験を分かち合い、視野を広げることができます。修煉は長い過程なので、初心者は忍耐強く、学習をしっかり行うべきです。''',
    NewAreaLang.korean => '''학습 과정에서 수련생들은 서로 연결되어 경험을 나누고 시야를 넓힐 수 있습니다. 수련은 긴 과정이므로 초보자는 인내심을 갖고 학습을 잘 해야 합니다.''',
    NewAreaLang.polski => '''Podczas nauki praktykujący mogą łączyć się, dzielić doświadczeniami i poszerzać perspektywę. Kultywacja to długi proces, więc początkujący powinni być cierpliwi i dobrze studiować.''',
    NewAreaLang.portugues => '''Durante o estudo, os praticantes podem conectar-se para compartilhar experiências e obter perspectivas mais amplas. O cultivo é um processo longo, por isso os iniciantes devem ser pacientes e estudar bem.''',
    NewAreaLang.russian => '''Во время учёбы практикующие могут общаться, делиться опытом и расширять взгляд. Совершенствование — долгий процесс, поэтому начинающим следует быть терпеливыми и хорошо учиться.''',
    NewAreaLang.slovencina => '''Počas štúdia sa môžu cvičiaci spojiť, zdieľať skúsenosti a získať širšie pohľady. Kultivácia je dlhý proces, preto by začiatočníci mali byť trpezliví a dobre študovať.''',
    NewAreaLang.srpski => '''Током учења вежбачи могу да се повежу, деле искуства и стекну шире перспективе. Култивација је дуг процес, па почетници треба да буду стрпљиви и добро уче.''',
    NewAreaLang.thai => '''ระหว่างการเรียน ผู้ฝึกสามารถเชื่อมต่อกันเพื่อแบ่งปันประสบการณ์และขยายมุมมอง การบำเพ็ญเป็นกระบวนการยาว ดังนั้นผู้เริ่มต้นควรอดทนและเรียนให้ดี''',
    NewAreaLang.turkce => '''Çalışma sırasında uygulayıcılar birbirine bağlanıp deneyim paylaşabilir ve bakış açılarını genişletebilir. Yetiştirme uzun bir süreçtir; bu yüzden yeni başlayanlar sabırlı olmalı ve çalışmalarını iyi yapmalıdır.''',
    NewAreaLang.ukrainian => '''Під час навчання практикувальники можуть спілкуватися, ділитися досвідом і розширювати погляд. Вдосконалення — довгий процес, тож початківцям варто бути терплячими й добре вчитися.''',
  };

  static String exerciseIntro(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''When just starting, practitioners can simply follow the movements of practitioners who already know the exercises, or follow demo videos.
''',
    NewAreaLang.vietnamese => '''Khi mới tập, học viên có thể chỉ cần đơn giản là tập theo động tác của các học viên đã biết tập, hoặc theo video của học viên tập mẫu.
''',
    NewAreaLang.chinese1 => '''剛開始時，學員可以簡單地跟著已經會煉的學員動作，或跟著示範影片練習。
''',
    NewAreaLang.chinese2 => '''刚开始时，学员可以简单地跟着已经会炼的学员动作，或跟着示范视频练习。
''',
    NewAreaLang.bosanski => '''Na početku vježbači mogu jednostavno pratiti pokrete vježbača koji već znaju vježbe, ili pratiti demo videozapise.
''',
    NewAreaLang.deutsch => '''Am Anfang können Übende einfach den Bewegungen von Übenden folgen, die die Übungen bereits kennen, oder Demo-Videos folgen.
''',
    NewAreaLang.espanol => '''Al empezar, los practicantes pueden simplemente seguir los movimientos de practicantes que ya conocen los ejercicios, o seguir videos de demostración.
''',
    NewAreaLang.farsi => '''در آغاز، تمرین‌کنندگان می‌توانند صرفاً حرکات تمرین‌کنندگانی را که تمرین‌ها را می‌دانند دنبال کنند، یا از ویدیوهای نمونه پیروی کنند.
''',
    NewAreaLang.francais => '''Au début, les pratiquants peuvent simplement suivre les mouvements de pratiquants qui connaissent déjà les exercices, ou suivre des vidéos de démonstration.
''',
    NewAreaLang.hebrew => '''בהתחלה, מתרגלים יכולים פשוט לעקוב אחר תנועות של מתרגלים שכבר מכירים את התרגילים, או לעקוב אחר סרטוני הדגמה.
''',
    NewAreaLang.hrvatski => '''Na početku vježbači mogu jednostavno pratiti pokrete vježbača koji već znaju vježbe, ili pratiti demo videozapise.
''',
    NewAreaLang.indonesia => '''Saat baru mulai, praktisi cukup mengikuti gerakan praktisi yang sudah tahu latihan, atau mengikuti video demo.
''',
    NewAreaLang.italiano => '''All'inizio, i praticanti possono semplicemente seguire i movimenti di praticanti che già conoscono gli esercizi, o seguire video dimostrativi.
''',
    NewAreaLang.japan => '''始めたばかりのときは、すでに功法を知っている学習者の動作に従うか、模範動画に従うだけで構いません。
''',
    NewAreaLang.korean => '''처음에는 이미 공법을 아는 수련생의 동작을 따르거나 시범 영상을 따라 하면 됩니다.
''',
    NewAreaLang.polski => '''Na początku praktykujący mogą po prostu naśladować ruchy praktykujących, którzy już znają ćwiczenia, lub oglądać filmy demonstracyjne.
''',
    NewAreaLang.portugues => '''No início, os praticantes podem simplesmente seguir os movimentos de praticantes que já conhecem os exercícios, ou seguir vídeos de demonstração.
''',
    NewAreaLang.russian => '''В начале практикующие могут просто следовать движениям тех, кто уже знает упражнения, или смотреть демонстрационные видео.
''',
    NewAreaLang.slovencina => '''Na začiatku môžu cvičiaci jednoducho nasledovať pohyby cvičiacich, ktorí už cvičenia poznajú, alebo sledovať demo videá.
''',
    NewAreaLang.srpski => '''На почетку вежбачи могу једноставно пратити покрете вежбача који већ знају вежбе, или пратити демо видео записе.
''',
    NewAreaLang.thai => '''เมื่อเริ่มต้น ผู้ฝึกสามารถทำตามท่าของผู้ที่รู้แล้ว หรือตามวิดีโอสาธิตได้เลย
''',
    NewAreaLang.turkce => '''Yeni başlarken uygulayıcılar, egzersizleri bilen uygulayıcıların hareketlerini veya demo videolarını takip edebilir.
''',
    NewAreaLang.ukrainian => '''На початку практикувальники можуть просто повторювати рухи тих, хто вже знає вправи, або дивитися демонстраційні відео.
''',
  };

  static String exerciseBody(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''
After becoming reasonably familiar over about 1–2 months, practitioners should refine the movements by reading The Great Consummation Way to understand the principles of each movement, or by watching the exercise instruction videos on falundafa.org. They may also ask experienced practitioners for help adjusting the form.

Below is guidance in this app for beginners.

○ When watching and following a demo practitioner:
- Exercises 1, 3, 5: Male movements mirror female; female movements mirror male.
- Exercise 2: Male and female movements are the same.
- Exercise 4: Male/female follow either the male or female demo

○ Preparation posture for all 5 exercises:
- Feet shoulder-width apart for standing exercises. Knees slightly bent, not locked straight.
- Tongue against the upper palate; teeth slightly apart; lips closed.
- Keep the head upright, facing forward, with a calm mind.
- Close the eyes when practicing (once the movements and rhythm are familiar).
- For "Holding the Wheel in Front of the Lower Abdomen" (both hands in front of the abdomen): leave about one hand's thickness between the hands, and the same distance from the abdomen (do not touch the abdomen).

○ Notes for each exercise:
 - Exercise 1: Stretch into the movement, then tense, then suddenly relax.
 - Exercise 2: Hold each movement for as long as you can.
 - Exercise 3: Pay attention to the direction of the palms.
 - Exercise 4: Hands do not touch the body.
 - Exercise 5: Practice for as long as you can.''',
    NewAreaLang.vietnamese => '''
Sau khi đã tập tương đối quen khoảng 1~2 tháng, học viên cần điều chỉnh động tác cho chính xác bằng cách đọc sách Đại Viên Mãn Pháp để hiểu rõ cơ lý của từng động tác hoặc xem video hướng dẫn tập trong trang falundafa.org. Ngoài ra cũng có thể nhờ các học viên đã tập thành thạo điều chỉnh giúp. 

Sau đây là hướng dẫn của App cho học viên mới tiếp cận.

○ Khi nhìn và tập theo học viên tập mẫu:
- Bài 1,3,5: Động tác của nam đối xứng với nữ, nữ đối xứng với nam.
- Bài 2: Nam/nữ động tác như nhau.
- Bài 4: Nam/nữ tập theo nam hoặc nữ

○ Tư thế chuẩn bị cho cả 5 bài:
- Chân rộng bằng vai đối với những bài tập tư thế đứng. Đầu gối hơi trùng nhẹ, không thẳng cứng.
- Lưỡi đặt hàm trên, hàm răng tách hở ra, môi miệng ngậm lại.
- Đầu luôn ngay ngắn, hướng về phía trước, tâm tĩnh.
- Nhắm mắt khi tập (khi đã thuộc động tác, nhịp tập).
- Động tác "Điệp khấu tiểu phúc" (Hai tay đặt trước bụng) thì hai tay cách nhau khoảng một lần độ dày của bàn tay, đồng thời cách bụng cũng tầm đó (không chạm vào bụng).

○ Lưu ý trong từng bài tập:
 - Bài 1: Duỗi thành động tác, sau đó mới căng lên rồi đột nhiên buông lỏng.
 - Bài 2: Thời lượng tập của mỗi động tác có thể để lâu bao nhiêu thì để bấy lâu.
 - Bài 3: Lưu ý hướng của lòng bàn tay.
 - Bài 4: Tay không chạm vào cơ thể.
 - Bài 5: Có thể tập lâu bao nhiêu thì để bấy lâu.''',
    NewAreaLang.chinese1 => '''
大約1～2個月較熟悉後，學員應透過閱讀《大圓滿法》了解每個動作的機理，或觀看 falundafa.org 上的指導影片來調整動作。也可請熟練學員協助校正。

以下是本應用給初學者的指引。

○ 觀看並跟隨示範學員時：
- 第1、3、5套：男性動作與女性對稱；女性動作與男性對稱。
- 第2套：男女動作相同。
- 第4套：男女可跟隨男或女示範

○ 五套功法的準備姿勢：
- 站姿功法雙腳與肩同寬。膝蓋微彎，不要僵直。
- 舌抵上顎；牙齒微開；嘴唇閉合。
- 頭要正，面向前方，心要靜。
- 煉功時閉眼（動作與節奏熟悉後）。
- 「小腹前抱輪」（雙手在腹前）：兩手間約一手掌厚度，同時與腹部同距（不觸腹）。

○ 各套功法注意：
 - 第1套：伸展成動作後再繃緊，然後突然放鬆。
 - 第2套：每個動作能持續多久就持續多久。
 - 第3套：注意手心方向。
 - 第4套：手不觸及身體。
 - 第5套：能煉多久就煉多久。''',
    NewAreaLang.chinese2 => '''
大约1～2个月较熟悉后，学员应通过阅读《大圆满法》了解每个动作的机理，或观看 falundafa.org 上的指导视频来调整动作。也可请熟练学员协助校正。

以下是本应用给初学者的指引。

○ 观看并跟随示范学员时：
- 第1、3、5套：男性动作与女性对称；女性动作与男性对称。
- 第2套：男女动作相同。
- 第4套：男女可跟随男或女示范

○ 五套功法的准备姿势：
- 站姿功法双脚与肩同宽。膝盖微弯，不要僵直。
- 舌抵上颚；牙齿微开；嘴唇闭合。
- 头要正，面向前方，心要静。
- 炼功时闭眼（动作与节奏熟悉后）。
- 「小腹前抱轮」（双手在腹前）：两手间约一掌厚度，同时与腹部同距（不触腹）。

○ 各套功法注意：
 - 第1套：伸展成动作后再绷紧，然后突然放松。
 - 第2套：每个动作能持续多久就持续多久。
 - 第3套：注意手心方向。
 - 第4套：手不触及身体。
 - 第5套：能炼多久就炼多久。''',
    NewAreaLang.bosanski => '''
Nakon što u oko 1–2 mjeseca postanu razumno upoznati, vježbači trebaju usavršiti pokrete čitanjem Velikog puta savršenstva kako bi razumjeli principe svakog pokreta, ili gledanjem instruktivnih videa na falundafa.org. Mogu i pitati iskusne vježbače za pomoć pri korekciji forme.

Ispod je vodič ove aplikacije za početnike.

○ Kada gledate i pratite demo vježbača:
- Vježbe 1, 3, 5: Muški pokreti su zrcalni ženskim; ženski su zrcalni muškim.
- Vježba 2: Muški i ženski pokreti su isti.
- Vježba 4: Muškarci/žene prate muški ili ženski demo

○ Pripremni stav za svih 5 vježbi:
- Stopala u širini ramena za stojeće vježbe. Koljena blago savijena, ne zaključana.
- Jezik uz gornje nepce; zubi blago razmaknuti; usne zatvorene.
- Glava uspravna, gledati naprijed, miran um.
- Zatvoriti oči pri vježbanju (kad su pokreti i ritam poznati).
- Za « Držanje točka ispred donjeg abdomena » (obje ruke ispred abdomena): ostaviti oko debljine jedne šake između ruku, i istu udaljenost od abdomena (ne dirati abdomen).

○ Napomene za svaku vježbu:
 - Vježba 1: Isteći se u pokret, zatim napeti, zatim iznenada opustiti.
 - Vježba 2: Držati svaki pokret što duže možete.
 - Vježba 3: Obratiti pažnju na smjer dlanova.
 - Vježba 4: Ruke ne dodiruju tijelo.
 - Vježba 5: Vježbati što duže možete.''',
    NewAreaLang.deutsch => '''
Nach etwa 1–2 Monaten Übung sollten Übende die Bewegungen verfeinern, indem sie Der Große Vollendungsweg lesen, um die Prinzipien jeder Bewegung zu verstehen, oder die Übungsvideos auf falundafa.org ansehen. Sie können auch erfahrene Übende um Hilfe bei der Korrektur der Form bitten.

Nachfolgend die Anleitung in dieser App für Anfänger.

○ Beim Ansehen und Mitmachen nach einem Demo-Übenden:
- Übungen 1, 3, 5: Männliche Bewegungen spiegeln weibliche; weibliche spiegeln männliche.
- Übung 2: Männliche und weibliche Bewegungen sind gleich.
- Übung 4: Männer/Frauen folgen der männlichen oder weiblichen Demo

○ Vorbereitungshaltung für alle 5 Übungen:
- Füße schulterbreit bei stehenden Übungen. Knie leicht gebeugt, nicht durchgestreckt.
- Zunge am oberen Gaumen; Zähne leicht geöffnet; Lippen geschlossen.
- Kopf aufrecht, nach vorne gerichtet, ruhiger Geist.
- Augen schließen beim Üben (wenn Bewegungen und Rhythmus vertraut sind).
- Bei „Das Rad vor dem Unterbauch halten“ (beide Hände vor dem Bauch): etwa eine Handdicke zwischen den Händen und denselben Abstand zum Bauch (Bauch nicht berühren).

○ Hinweise zu jeder Übung:
 - Übung 1: In die Bewegung strecken, dann anspannen, dann plötzlich entspannen.
 - Übung 2: Jede Bewegung so lange halten, wie möglich.
 - Übung 3: Auf die Richtung der Handflächen achten.
 - Übung 4: Hände berühren den Körper nicht.
 - Übung 5: So lange üben, wie möglich.''',
    NewAreaLang.espanol => '''
Tras familiarizarse razonablemente en unos 1–2 meses, los practicantes deben refinar los movimientos leyendo El Gran Camino de la Consumación para entender los principios de cada movimiento, o viendo los videos de instrucción en falundafa.org. También pueden pedir ayuda a practicantes experimentados.

A continuación, la guía de esta aplicación para principiantes.

○ Al ver y seguir a un practicante de demostración:
- Ejercicios 1, 3, 5: Los movimientos masculinos reflejan los femeninos; los femeninos reflejan los masculinos.
- Ejercicio 2: Los movimientos masculinos y femeninos son iguales.
- Ejercicio 4: Hombres/mujeres siguen la demo masculina o femenina

○ Postura de preparación para los 5 ejercicios:
- Pies a la anchura de los hombros en ejercicios de pie. Rodillas ligeramente flexionadas, no bloqueadas.
- Lengua contra el paladar superior; dientes ligeramente separados; labios cerrados.
- Cabeza erguida, mirando al frente, mente calmada.
- Cerrar los ojos al practicar (una vez familiares movimientos y ritmo).
- Para « Sostener la rueda frente al bajo abdomen » (ambas manos frente al abdomen): dejar aproximadamente el grosor de una mano entre las manos, y la misma distancia del abdomen (no tocar el abdomen).

○ Notas para cada ejercicio:
 - Ejercicio 1: Estirarse en el movimiento, luego tensar, luego relajar de golpe.
 - Ejercicio 2: Mantener cada movimiento tanto como se pueda.
 - Ejercicio 3: Prestar atención a la dirección de las palmas.
 - Ejercicio 4: Las manos no tocan el cuerpo.
 - Ejercicio 5: Practicar tanto como se pueda.''',
    NewAreaLang.farsi => '''
پس از حدود ۱–۲ ماه که نسبتاً آشنا شدند، باید با خواندن راه کمال عظیم برای فهم اصول هر حرکت، یا تماشای ویدیوهای آموزشی در falundafa.org، حرکات را دقیق‌تر کنند. همچنین می‌توانند از تمرین‌کنندگان باتجربه کمک بخواهند.

در ادامه راهنمای این برنامه برای مبتدیان آمده است.

○ هنگام تماشا و پیروی از تمرین‌کننده نمونه:
- تمرین‌های ۱، ۳، ۵: حرکات مردانه آینهٔ زنانه است؛ حرکات زنانه آینهٔ مردانه.
- تمرین ۲: حرکات مردانه و زنانه یکسان است.
- تمرین ۴: مرد/زن از نمونه مرد یا زن پیروی کنند

○ وضعیت آماده‌سازی برای هر ۵ تمرین:
- برای تمرین‌های ایستاده پاها به‌اندازهٔ شانه. زانوها کمی خم، نه قفل‌شده.
- زبان به سقف دهان؛ دندان‌ها کمی باز؛ لب‌ها بسته.
- سر راست، رو به جلو، ذهن آرام.
- هنگام تمرین چشم‌ها را ببندید (وقتی حرکات و ریتم آشنا شدند).
- برای «نگه داشتن چرخ جلوی پایین شکم» (هر دو دست جلوی شکم): حدود ضخامت یک دست بین دست‌ها و همان فاصله از شکم (به شکم دست نزنید).

○ نکات هر تمرین:
 - تمرین ۱: در حرکت بکشید، سپس منقبض کنید، سپس ناگهان رها کنید.
 - تمرین ۲: هر حرکت را تا جایی که می‌توانید نگه دارید.
 - تمرین ۳: به جهت کف دست توجه کنید.
 - تمرین ۴: دست‌ها به بدن برخورد نکنند.
 - تمرین ۵: تا جایی که می‌توانید تمرین کنید.''',
    NewAreaLang.francais => '''
Après être devenu raisonnablement familier en environ 1–2 mois, les pratiquants devraient affiner les mouvements en lisant La Grande Voie de la Consommation pour comprendre les principes de chaque mouvement, ou en regardant les vidéos d'instruction sur falundafa.org. Ils peuvent aussi demander de l'aide à des pratiquants expérimentés.

Voici les conseils de cette application pour les débutants.

○ En regardant et en suivant un pratiquant de démonstration :
- Exercices 1, 3, 5 : Les mouvements masculins sont le miroir des féminins ; les féminins sont le miroir des masculins.
- Exercice 2 : Les mouvements masculins et féminins sont identiques.
- Exercice 4 : Hommes/femmes suivent la démo masculine ou féminine

○ Posture de préparation pour les 5 exercices :
- Pieds écartés de la largeur des épaules pour les exercices debout. Genoux légèrement fléchis, non verrouillés.
- Langue contre le palais supérieur ; dents légèrement écartées ; lèvres fermées.
- Tête droite, face à l'avant, esprit calme.
- Fermer les yeux en pratiquant (une fois mouvements et rythme familiers).
- Pour « Tenir la roue devant le bas-ventre » (les deux mains devant l'abdomen) : laisser environ l'épaisseur d'une main entre les mains, et la même distance de l'abdomen (ne pas toucher l'abdomen).

○ Notes pour chaque exercice :
 - Exercice 1 : S'étirer dans le mouvement, puis tendre, puis relâcher soudainement.
 - Exercice 2 : Maintenir chaque mouvement aussi longtemps que possible.
 - Exercice 3 : Faire attention à la direction des paumes.
 - Exercice 4 : Les mains ne touchent pas le corps.
 - Exercice 5 : Pratiquer aussi longtemps que possible.''',
    NewAreaLang.hebrew => '''
לאחר היכרות סבירה תוך כ־1–2 חודשים, יש לדייק את התנועות בקריאת הדרך הגדולה של ההשלמה כדי להבין את עקרונות כל תנועה, או בצפייה בסרטוני ההדרכה ב־falundafa.org. אפשר גם לבקש עזרה ממתרגלים מנוסים.

להלן ההנחיות באפליקציה זו למתחילים.

○ בעת צפייה ומעקב אחר מתרגל להדגמה:
- תרגילים 1, 3, 5: תנועות הגברים משקפות את הנשים; תנועות הנשים משקפות את הגברים.
- תרגיל 2: תנועות הגברים והנשים זהות.
- תרגיל 4: גברים/נשים עוקבים אחר הדגמה גברית או נשית

○ תנוחת הכנה לכל 5 התרגילים:
- רגליים ברוחב הכתפיים בתרגילים בעמידה. ברכיים כפופות מעט, לא נעולות.
- לשון מול החיך העליון; שיניים מעט פתוחות; שפתיים סגורות.
- ראש זקוף, פונה קדימה, מוח רגוע.
- לעצום עיניים בזמן התרגול (כשהתנועות והקצב מוכרים).
- עבור « החזקת הגלגל מול הבטן התחתונה » (שתי הידיים מול הבטן): להשאיר בערך עובי כף יד בין הידיים, ואותו מרחק מהבטן (לא לגעת בבטן).

○ הערות לכל תרגיל:
 - תרגיל 1: להימתח לתנועה, ואז למתוח, ואז להרפות פתאום.
 - תרגיל 2: להחזיק כל תנועה כמה שאפשר.
 - תרגיל 3: לשים לב לכיוון כפות הידיים.
 - תרגיל 4: הידיים אינן נוגעות בגוף.
 - תרגיל 5: לתרגל כמה שאפשר.''',
    NewAreaLang.hrvatski => '''
Nakon što u oko 1–2 mjeseca postanu razumno upoznati, vježbači trebaju usavršiti pokrete čitanjem Velikog puta savršenstva kako bi razumjeli principe svakog pokreta, ili gledanjem instruktivnih videa na falundafa.org. Mogu i pitati iskusne vježbače za pomoć pri korekciji forme.

Ispod je vodič ove aplikacije za početnike.

○ Kada gledate i pratite demo vježbača:
- Vježbe 1, 3, 5: Muški pokreti su zrcalni ženskim; ženski su zrcalni muškim.
- Vježba 2: Muški i ženski pokreti su isti.
- Vježba 4: Muškarci/žene prate muški ili ženski demo

○ Pripremni stav za svih 5 vježbi:
- Stopala u širini ramena za stojeće vježbe. Koljena blago savijena, ne zaključana.
- Jezik uz gornje nepce; zubi blago razmaknuti; usne zatvorene.
- Glava uspravna, gledati naprijed, miran um.
- Zatvoriti oči pri vježbanju (kad su pokreti i ritam poznati).
- Za « Držanje točka ispred donjeg abdomena » (obje ruke ispred abdomena): ostaviti oko debljine jedne šake između ruku, i istu udaljenost od abdomena (ne dirati abdomen).

○ Napomene za svaku vježbu:
 - Vježba 1: Isteći se u pokret, zatim napeti, zatim iznenada opustiti.
 - Vježba 2: Držati svaki pokret što duže možete.
 - Vježba 3: Obratiti pažnju na smjer dlanova.
 - Vježba 4: Ruke ne dodiruju tijelo.
 - Vježba 5: Vježbati što duže možete.''',
    NewAreaLang.indonesia => '''
Setelah cukup terbiasa dalam sekitar 1–2 bulan, praktisi sebaiknya memperbaiki gerakan dengan membaca Jalan Kesempurnaan Agung untuk memahami prinsip setiap gerakan, atau menonton video panduan di falundafa.org. Bisa juga minta bantuan praktisi berpengalaman untuk menyesuaikan bentuk.

Berikut panduan aplikasi ini untuk pemula.

○ Saat menonton dan mengikuti praktisi demo:
- Latihan 1, 3, 5: Gerakan pria cermin wanita; gerakan wanita cermin pria.
- Latihan 2: Gerakan pria dan wanita sama.
- Latihan 4: Pria/wanita mengikuti demo pria atau wanita

○ Postur persiapan untuk kelima latihan:
- Kaki selebar bahu untuk latihan berdiri. Lutut sedikit ditekuk, tidak terkunci lurus.
- Lidah menempel langit-langit atas; gigi sedikit terpisah; bibir tertutup.
- Kepala tegak, menghadap depan, pikiran tenang.
- Tutup mata saat berlatih (setelah gerakan dan irama familiar).
- Untuk « Memegang roda di depan perut bawah » (kedua tangan di depan perut): sisakan sekitar ketebalan satu tangan di antara tangan, dan jarak yang sama dari perut (jangan menyentuh perut).

○ Catatan untuk setiap latihan:
 - Latihan 1: Meregang ke gerakan, lalu menegangkan, lalu tiba-tiba melemaskan.
 - Latihan 2: Tahan setiap gerakan selama mungkin.
 - Latihan 3: Perhatikan arah telapak tangan.
 - Latihan 4: Tangan tidak menyentuh tubuh.
 - Latihan 5: Latihan selama mungkin.''',
    NewAreaLang.italiano => '''
Dopo aver acquisito una certa familiarità in circa 1–2 mesi, i praticanti dovrebbero raffinare i movimenti leggendo La Grande Via della Consumazione per comprendere i principi di ogni movimento, o guardando i video di istruzione su falundafa.org. Possono anche chiedere aiuto a praticanti esperti.

Di seguito la guida di questa app per principianti.

○ Quando si guarda e si segue un praticante dimostrativo:
- Esercizi 1, 3, 5: I movimenti maschili rispecchiano quelli femminili; quelli femminili rispecchiano quelli maschili.
- Esercizio 2: I movimenti maschili e femminili sono uguali.
- Esercizio 4: Uomini/donne seguono la demo maschile o femminile

○ Postura di preparazione per tutti e 5 gli esercizi:
- Piedi alla larghezza delle spalle per gli esercizi in piedi. Ginocchia leggermente piegate, non bloccate.
- Lingua contro il palato superiore; denti leggermente aperti; labbra chiuse.
- Testa eretta, rivolta in avanti, mente calma.
- Chiudere gli occhi durante la pratica (una volta che movimenti e ritmo sono familiari).
- Per « Tenere la ruota davanti al basso ventre » (entrambe le mani davanti all'addome): lasciare circa lo spessore di una mano tra le mani, e la stessa distanza dall'addome (non toccare l'addome).

○ Note per ogni esercizio:
 - Esercizio 1: Allungarsi nel movimento, poi tendere, poi rilassare improvvisamente.
 - Esercizio 2: Mantenere ogni movimento il più a lungo possibile.
 - Esercizio 3: Prestare attenzione alla direzione dei palmi.
 - Esercizio 4: Le mani non toccano il corpo.
 - Esercizio 5: Praticare il più a lungo possibile.''',
    NewAreaLang.japan => '''
約1〜2か月でかなり慣れたら、『大円満法』を読んで各動作の原理を理解するか、falundafa.org の指導動画を見て動作を正確にしてください。熟練した学習者に形の調整を頼むこともできます。

以下は、このアプリの初心者向けガイドです。

○ 模範学員を見て従うとき：
- 第1・3・5式：男性の動作は女性と対称、女性の動作は男性と対称。
- 第2式：男女の動作は同じ。
- 第4式：男女とも男性または女性の模範に従う

○ 5式すべての準備姿勢：
- 立位の功法では足を肩幅に。膝は軽く曲げ、真っすぐに固めない。
- 舌は上あごに、歯はわずかに開き、唇は閉じる。
- 頭はまっすぐ、正面を向き、心を静かに。
- 練習時は目を閉じる（動作とリズムが身についたら）。
- 「小腹の前で輪を抱く」（両手を腹の前）では、両手の間に手のひらの厚さほど、腹からも同じ距離を空ける（腹に触れない）。

○ 各式の注意：
 - 第1式：動作に伸ばし、その後緊張させ、突然ゆるめる。
 - 第2式：各動作をできるだけ長く保つ。
 - 第3式：手のひらの向きに注意。
 - 第4式：手は体に触れない。
 - 第5式：できるだけ長く練習する。''',
    NewAreaLang.korean => '''
약 1~2개월 정도 익숙해진 뒤에는 『대원만법』을 읽어 각 동작의 원리를 이해하거나 falundafa.org 의 지도 영상을 보며 동작을 바로잡으세요. 숙련된 수련생에게 자세 교정을 부탁할 수도 있습니다.

아래는 이 앱의 초보자를 위한 안내입니다.

○ 시범 수련생을 보고 따라 할 때:
- 1, 3, 5번 공법: 남성 동작은 여성과 대칭, 여성 동작은 남성과 대칭.
- 2번 공법: 남녀 동작이 같습니다.
- 4번 공법: 남/여 모두 남성 또는 여성 시범을 따릅니다

○ 5개 공법 공통 준비 자세:
- 서서 하는 공법은 발을 어깨너비로. 무릎은 살짝 굽히고 곧게 잠그지 않음.
- 혀는 윗잇몸에, 이는 살짝 벌리고, 입은 다물기.
- 머리는 바르게, 앞을 보고, 마음은 고요하게.
- 연공 시 눈을 감음(동작과 리듬이 익숙해지면).
- 「하복부 앞에서 륜을 안기」(양손을 배 앞에)는 양손 사이와 배와의 거리를 손바닥 두께 정도로(배에 닿지 않음).

○ 각 공법 참고:
 - 1번: 동작으로 뻗은 뒤 긴장했다가 갑자기 이완.
 - 2번: 각 동작을 가능한 한 오래 유지.
 - 3번: 손바닥 방향에 주의.
 - 4번: 손이 몸에 닿지 않음.
 - 5번: 가능한 한 오래 연공.''',
    NewAreaLang.polski => '''
Po około 1–2 miesiącach, gdy ruchy staną się dość znajome, należy je dopracować, czytając Wielką Drogę Spełnienia, aby zrozumieć zasady każdego ruchu, lub oglądając filmy instruktażowe na falundafa.org. Można też poprosić doświadczonych praktykujących o pomoc w korekcie formy.

Poniżej wskazówki tej aplikacji dla początkujących.

○ Gdy oglądasz i naśladujesz praktyka demonstracyjnego:
- Ćwiczenia 1, 3, 5: Ruchy męskie są lustrzanym odbiciem żeńskich; żeńskie — męskich.
- Ćwiczenie 2: Ruchy męskie i żeńskie są takie same.
- Ćwiczenie 4: Mężczyźni/kobiety idą za demo męskim lub żeńskim

○ Pozycja przygotowawcza dla wszystkich 5 ćwiczeń:
- Stopy na szerokość barków w ćwiczeniach stojących. Kolana lekko ugięte, nie zablokowane.
- Język przy podniebieniu górnym; zęby lekko rozchylone; usta zamknięte.
- Głowa prosto, twarz do przodu, spokojny umysł.
- Zamykać oczy podczas ćwiczeń (gdy ruchy i rytm są znane).
- Przy « Trzymaniu koła przed dolnym brzuchem » (obie ręce przed brzuchem): zostawić około grubości dłoni między rękami i taką samą odległość od brzucha (nie dotykać brzucha).

○ Uwagi do każdego ćwiczenia:
 - Ćwiczenie 1: Rozciągnąć się w ruch, potem napiąć, potem nagle rozluźnić.
 - Ćwiczenie 2: Utrzymywać każdy ruch tak długo, jak można.
 - Ćwiczenie 3: Zwracać uwagę na kierunek dłoni.
 - Ćwiczenie 4: Ręce nie dotykają ciała.
 - Ćwiczenie 5: Ćwiczyć tak długo, jak można.''',
    NewAreaLang.portugues => '''
Após familiarizar-se razoavelmente em cerca de 1–2 meses, os praticantes devem refinar os movimentos lendo O Grande Caminho da Consumação para entender os princípios de cada movimento, ou assistindo aos vídeos de instrução em falundafa.org. Também podem pedir ajuda a praticantes experientes.

A seguir, a orientação deste aplicativo para iniciantes.

○ Ao assistir e seguir um praticante de demonstração:
- Exercícios 1, 3, 5: Movimentos masculinos espelham os femininos; femininos espelham os masculinos.
- Exercício 2: Movimentos masculinos e femininos são iguais.
- Exercício 4: Homens/mulheres seguem a demo masculina ou feminina

○ Postura de preparação para os 5 exercícios:
- Pés na largura dos ombros nos exercícios em pé. Joelhos ligeiramente flexionados, não travados.
- Língua no palato superior; dentes ligeiramente apartados; lábios fechados.
- Cabeça ereta, olhando para frente, mente calma.
- Fechar os olhos ao praticar (quando movimentos e ritmo forem familiares).
- Para « Segurar a roda na frente do baixo abdômen » (ambas as mãos na frente do abdômen): deixar cerca da espessura de uma mão entre as mãos, e a mesma distância do abdômen (não tocar o abdômen).

○ Notas para cada exercício:
 - Exercício 1: Esticar no movimento, depois tensionar, depois relaxar de repente.
 - Exercício 2: Manter cada movimento o máximo possível.
 - Exercício 3: Prestar atenção à direção das palmas.
 - Exercício 4: As mãos não tocam o corpo.
 - Exercício 5: Praticar o máximo possível.''',
    NewAreaLang.russian => '''
После того как за примерно 1–2 месяца движения станут относительно привычными, практикующим следует уточнять форму, читая «Великий путь совершенствования», чтобы понять принципы каждого движения, или смотря обучающие видео на falundafa.org. Можно также попросить опытных практикующих помочь скорректировать форму.

Ниже — руководство этого приложения для начинающих.

○ Когда смотрите и следуете демонстрации:
- Упражнения 1, 3, 5: Мужские движения зеркальны женским; женские — мужским.
- Упражнение 2: Мужские и женские движения одинаковы.
- Упражнение 4: Мужчины/женщины следуют мужской или женской демонстрации

○ Подготовительная поза для всех 5 упражнений:
- Ноги на ширине плеч для стоячих упражнений. Колени слегка согнуты, не зафиксированы прямо.
- Язык к нёбу; зубы слегка разомкнуты; губы сомкнуты.
- Голова прямо, взгляд вперёд, ум спокоен.
- Закрывать глаза при выполнении (когда движения и ритм знакомы).
- Для «Держания колеса перед нижней частью живота» (обе руки перед животом): между руками — примерно толщина одной ладони, и такое же расстояние от живота (не касаться живота).

○ Примечания к каждому упражнению:
 - Упражнение 1: Вытянуться в движение, затем напрячь, затем внезапно расслабить.
 - Упражнение 2: Держать каждое движение столько, сколько можете.
 - Упражнение 3: Обращать внимание на направление ладоней.
 - Упражнение 4: Руки не касаются тела.
 - Упражнение 5: Выполнять столько, сколько можете.''',
    NewAreaLang.slovencina => '''
Po približne 1–2 mesiacoch, keď sú pohyby primerane známe, by mali cvičiaci spresniť pohyby čítaním Veľkej cesty naplnenia, aby pochopili princípy každého pohybu, alebo sledovaním inštruktážnych videí na falundafa.org. Môžu aj požiadať skúsených cvičiacich o pomoc pri korekcii formy.

Nižšie je sprievodca tejto aplikácie pre začiatočníkov.

○ Pri sledovaní a nasledovaní ukážkového cvičiaceho:
- Cvičenia 1, 3, 5: Mužské pohyby sú zrkadlové k ženským; ženské k mužským.
- Cvičenie 2: Mužské a ženské pohyby sú rovnaké.
- Cvičenie 4: Muži/ženy nasledujú mužské alebo ženské demo

○ Prípravný postoj pre všetkých 5 cvičení:
- Nohy na šírku ramien pri stojacich cvičeniach. Kolená mierne pokrčené, nie zablokované.
- Jazyk na hornom podnebí; zuby mierne od seba; pery zatvorené.
- Hlava vzpriamená, smerujúca dopredu, pokojná myseľ.
- Pri cvičení zatvoriť oči (keď sú pohyby a rytmus známe).
- Pri « Držaní kolesa pred dolným bruchom » (obe ruky pred bruchom): nechať približne hrúbku jednej ruky medzi rukami a rovnakú vzdialenosť od brucha (nedotýkať sa brucha).

○ Poznámky ku každému cvičeniu:
 - Cvičenie 1: Natiahnuť sa do pohybu, potom napnúť, potom náhle uvoľniť.
 - Cvičenie 2: Držať každý pohyb čo najdlhšie.
 - Cvičenie 3: Venovať pozornosť smeru dlani.
 - Cvičenie 4: Ruky sa nedotýkajú tela.
 - Cvičenie 5: Cvičiť čo najdlhšie.''',
    NewAreaLang.srpski => '''
Након што за око 1–2 месеца постану разумно упознати, вежбачи треба да усаврше покрете читањем Великог пута савршенства како би разумели принципе сваког покрета, или гледањем инструктивних видеа на falundafa.org. Могу и питати искусне вежбаче за помоћ при корекцији форме.

Испод је водич ове апликације за почетнике.

○ Када гледате и пратите демо вежбача:
- Вежбе 1, 3, 5: Мушки покрети су огледални женским; женски мушким.
- Вежба 2: Мушки и женски покрети су исти.
- Вежба 4: Мушкарци/жене прате мушки или женски демо

○ Припремни став за свих 5 вежби:
- Стопала у ширини рамена за стојеће вежбе. Колена благо савијена, не закључана.
- Језик уз горње непце; зуби благо размакнути; усне затворене.
- Глава усправна, гледати напред, миран ум.
- Затворити очи при вежбању (кад су покрети и ритам познати).
- За « Држање точка испред доњег абдомена » (обе руке испред абдомена): оставити око дебљине једне шаке између руку, и исто растојање од абдомена (не додиривати абдомен).

○ Напомене за сваку вежбу:
 - Вежба 1: Истегнути се у покрет, затим напети, затим изненада опустити.
 - Вежба 2: Држати сваки покрет што дуже можете.
 - Вежба 3: Обратити пажњу на смер дланова.
 - Вежба 4: Руке не додирују тело.
 - Вежба 5: Вежбати што дуже можете.''',
    NewAreaLang.thai => '''
หลังจากคุ้นเคยพอสมควรในราว 1–2 เดือน ควรปรับท่าให้ถูกต้องโดยอ่าน 「ทางแห่งความบริบูรณ์อันยิ่งใหญ่」 เพื่อเข้าใจหลักการของแต่ละท่า หรือดูวิดีโอสอนบน falundafa.org และอาจขอให้ผู้ฝึกที่มีประสบการณ์ช่วยปรับท่า

ด้านล่างคือคำแนะนำในแอปนี้สำหรับผู้เริ่มต้น

○ เมื่อดูและทำตามผู้ฝึกสาธิต:
- ท่า 1, 3, 5: ท่าผู้ชายสมมาตรกับผู้หญิง; ท่าผู้หญิงสมมาตรกับผู้ชาย
- ท่า 2: ท่าชาย/หญิงเหมือนกัน
- ท่า 4: ชาย/หญิงตามแบบชายหรือหญิงได้

○ ท่าเตรียมสำหรับทั้ง 5 ท่า:
- ยืนห่างเท่าไหล่สำหรับท่าที่ยืน เข่างอเล็กน้อย ไม่ตึงตรง
- ลิ้นแตะเพดานปาก ฟันแยกเล็กน้อย ริมฝีปากปิด
- ศีรษะตั้งตรง มองข้างหน้า จิตสงบ
- หลับตาเมื่อฝึก (เมื่อคุ้นท่าและจังหวะแล้ว)
- สำหรับ 「ประคองล้อหน้าท้องส่วนล่าง」 (มือทั้งสองหน้าท้อง): เว้นระยะระหว่างมือประมาณความหนาของฝ่ามือ และระยะจากท้องเท่ากัน (อย่าแตะท้อง)

○ หมายเหตุแต่ละท่า:
 - ท่า 1: ยืดเป็นท่า แล้วเกร็ง แล้วผ่อนคลายทันที
 - ท่า 2: ค้างแต่ละท่าให้นานเท่าที่ทำได้
 - ท่า 3: ระวังทิศทางฝ่ามือ
 - ท่า 4: มือไม่สัมผัสร่างกาย
 - ท่า 5: ฝึกให้นานเท่าที่ทำได้''',
    NewAreaLang.turkce => '''
Yaklaşık 1–2 ayda makul ölçüde alıştıktan sonra, her hareketin ilkelerini anlamak için Büyük Tamamlanma Yolu'nu okuyarak veya falundafa.org üzerindeki öğretim videolarını izleyerek hareketleri düzeltmelidir. Deneyimli uygulayıcılardan yardım da istenebilir.

Aşağıda bu uygulamanın yeni başlayanlar için rehberi vardır.

○ Demo uygulayıcıyı izleyip takip ederken:
- Egzersiz 1, 3, 5: Erkek hareketleri kadın hareketlerinin aynasıdır; kadın hareketleri erkek hareketlerinin aynasıdır.
- Egzersiz 2: Erkek ve kadın hareketleri aynıdır.
- Egzersiz 4: Erkek/kadın erkek veya kadın demoyu takip eder

○ 5 egzersizin hepsi için hazırlık duruşu:
- Ayakta egzersizlerde ayaklar omuz genişliğinde. Dizler hafif bükük, kilitli düz değil.
- Dil üst damağa; dişler hafif açık; dudaklar kapalı.
- Baş dik, öne bakarak, zihin sakin.
- Uygularken gözleri kapatın (hareketler ve ritim alışıldıktan sonra).
- « Alt karın önünde tekerleği tutma » (iki el karın önünde) için: eller arasında yaklaşık bir el kalınlığı ve karından aynı mesafe (karna değmeyin).

○ Her egzersiz için notlar:
 - Egzersiz 1: Harekete uzanın, sonra gerin, sonra aniden gevşetin.
 - Egzersiz 2: Her hareketi mümkün olduğunca uzun tutun.
 - Egzersiz 3: Avuç yönüne dikkat edin.
 - Egzersiz 4: Eller bedene değmez.
 - Egzersiz 5: Mümkün olduğunca uzun uygulayın.''',
    NewAreaLang.ukrainian => '''
Після того як за приблизно 1–2 місяці рухи стануть відносно звичними, варто уточнювати форму, читаючи «Великий шлях удосконалення», щоб зрозуміти принципи кожного руху, або дивлячись навчальні відео на falundafa.org. Можна також попросити досвідчених практикувальників допомогти з коригуванням форми.

Нижче — посібник цього додатку для початківців.

○ Коли дивитеся й повторюєте демонстрацію:
- Вправи 1, 3, 5: Чоловічі рухи дзеркальні до жіночих; жіночі — до чоловічих.
- Вправа 2: Чоловічі та жіночі рухи однакові.
- Вправа 4: Чоловіки/жінки йдуть за чоловічою або жіночою демонстрацією

○ Підготовча поза для всіх 5 вправ:
- Ноги на ширині плечей для вправ стоячи. Коліна злегка зігнуті, не зафіксовані прямо.
- Язик до піднебіння; зуби злегка розімкнені; губи зімкнені.
- Голова прямо, погляд уперед, розум спокійний.
- Закривати очі під час виконання (коли рухи й ритм знайомі).
- Для «Тримання колеса перед нижньою частиною живота» (обидві руки перед животом): між руками — приблизно товщина однієї долоні, і така сама відстань від живота (не торкатися живота).

○ Примітки до кожної вправи:
 - Вправа 1: Витягнутися в рух, потім напружити, потім раптово розслабити.
 - Вправа 2: Тримати кожен рух стільки, скільки можете.
 - Вправа 3: Звертати увагу на напрямок долонь.
 - Вправа 4: Руки не торкаються тіла.
 - Вправа 5: Виконувати стільки, скільки можете.''',
  };

  static String privacyHtml(NewAreaLang lang) => switch (lang) {
    NewAreaLang.english => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Privacy Policy Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports built the app as (free / ad-supported / buy in the application) app. This SERVICE is provided by Falun Dafa Practice Supports and is intended for use as is.
</p> <p>
  This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.
</p> <p>
  If you choose to use our Service, then you agree to the collection and use of information in relation to this policy.
  </p>
 <p><strong>Information Collection and Use</strong></p> <p>
    We do not collect personal data (full name, address, contact information, email, phone number, image, ... Personal documents any other)
  <p>
  The information that we request will be retained on your device and is not collected by us in any way.</p>
  <p>Applications can collect data used such as: Login time, usage status ...</p>
</p> <div><p>
    The app does use third-party services that may collect information used to identify you.
  </p> <p>
    Link to the privacy policy of third-party service providers used by the app
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Log Data</strong></p> <p>
  We want to inform you that whenever you use our Service, in a case of an error in the app We collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing our Service, the time and date of your use of the Service, and other statistics.
</p>

<p><strong>Service Providers</strong></p> <p>
  We may employ third-party companies and individuals due to the following reasons:
</p> <ul><li>To facilitate our Service;</li> <li>To provide the Service on our behalf;</li> <li>To perform Service-related services; or</li> <li>To assist us in analyzing how our Service is used.</li></ul> <p>
  We want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.
</p> <p><strong>Security</strong></p> <p>
  We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and We cannot guarantee its absolute security.
</p> <p><strong>Links to Other Sites</strong></p> <p>
  This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, We strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.
</p> <p><strong>Children’s Privacy</strong></p> <div><p>
    These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case We discover that a child under 13 has provided us with personal information, We immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that We will be able to do the necessary actions.
  </p></div> <p><strong>Changes to This Privacy Policy</strong></p> <p>
    We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page.
</p>
<p>This policy is effective as of 2024-06-01</p>
<p><strong>Contact Us</strong></p>
<p> If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact me at</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>This privacy policy page was created at <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>and modified/generated by <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>

</body>
</html>''',
    NewAreaLang.vietnamese => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Chính sách bảo mật Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports đã xây dựng ứng dụng dưới dạng ứng dụng (miễn phí / có quảng cáo / mua trong ứng dụng). DỊCH VỤ này được cung cấp bởi Falun Dafa Practice Supports và được dùng nguyên trạng.
</p> <p>
  Trang này dùng để thông báo cho khách truy cập về các chính sách của chúng tôi liên quan đến việc thu thập, sử dụng và tiết lộ Thông tin Cá nhân nếu ai đó quyết định sử dụng Dịch vụ của chúng tôi.
</p> <p>
  Nếu bạn chọn sử dụng Dịch vụ của chúng tôi, bạn đồng ý với việc thu thập và sử dụng thông tin liên quan đến chính sách này.
  </p>
 <p><strong>Thu thập và sử dụng thông tin</strong></p> <p>
    Chúng tôi không thu thập dữ liệu cá nhân (họ tên đầy đủ, địa chỉ, thông tin liên hệ, email, số điện thoại, hình ảnh, ... và bất kỳ giấy tờ cá nhân nào khác)
  <p>
  Thông tin mà chúng tôi yêu cầu sẽ được lưu trên thiết bị của bạn và không được chúng tôi thu thập dưới bất kỳ hình thức nào.</p>
  <p>Ứng dụng có thể thu thập dữ liệu sử dụng như: Thời gian đăng nhập, trạng thái sử dụng ...</p>
</p> <div><p>
    Ứng dụng có sử dụng các dịch vụ của bên thứ ba có thể thu thập thông tin dùng để nhận dạng bạn.
  </p> <p>
    Liên kết đến chính sách bảo mật của các nhà cung cấp dịch vụ bên thứ ba được ứng dụng sử dụng
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Dữ liệu nhật ký</strong></p> <p>
  Chúng tôi muốn thông báo rằng mỗi khi bạn sử dụng Dịch vụ của chúng tôi, trong trường hợp có lỗi trong ứng dụng, Chúng tôi thu thập dữ liệu và thông tin (qua các sản phẩm bên thứ ba) trên điện thoại của bạn gọi là Dữ liệu Nhật ký. Dữ liệu Nhật ký này có thể bao gồm thông tin như địa chỉ Giao thức Internet (“IP”) của thiết bị, tên thiết bị, phiên bản hệ điều hành, cấu hình của ứng dụng khi sử dụng Dịch vụ của chúng tôi, thời gian và ngày bạn sử dụng Dịch vụ, và các thống kê khác.
</p>

<p><strong>Nhà cung cấp dịch vụ</strong></p> <p>
  Chúng tôi có thể thuê các công ty và cá nhân bên thứ ba vì các lý do sau:
</p> <ul><li>Để hỗ trợ Dịch vụ của chúng tôi;</li> <li>Để cung cấp Dịch vụ thay mặt chúng tôi;</li> <li>Để thực hiện các dịch vụ liên quan đến Dịch vụ; hoặc</li> <li>Để hỗ trợ chúng tôi phân tích cách Dịch vụ được sử dụng.</li></ul> <p>
  Chúng tôi muốn thông báo cho người dùng Dịch vụ này rằng các bên thứ ba này có quyền truy cập Thông tin Cá nhân của họ. Lý do là để thực hiện các nhiệm vụ được giao thay mặt chúng tôi. Tuy nhiên, họ có nghĩa vụ không tiết lộ hoặc sử dụng thông tin cho bất kỳ mục đích nào khác.
</p> <p><strong>Bảo mật</strong></p> <p>
  Chúng tôi trân trọng sự tin tưởng của bạn khi cung cấp Thông tin Cá nhân cho chúng tôi, vì vậy chúng tôi đang nỗ lực sử dụng các biện pháp bảo vệ được chấp nhận về mặt thương mại. Nhưng hãy nhớ rằng không có phương thức truyền qua internet hoặc lưu trữ điện tử nào an toàn và đáng tin cậy 100%, và Chúng tôi không thể đảm bảo bảo mật tuyệt đối.
</p> <p><strong>Liên kết đến trang khác</strong></p> <p>
  Dịch vụ này có thể chứa liên kết đến các trang khác. Nếu bạn nhấp vào liên kết bên thứ ba, bạn sẽ được chuyển đến trang đó. Lưu ý rằng các trang bên ngoài này không do chúng tôi vận hành. Do đó, Chúng tôi đặc biệt khuyên bạn nên xem Chính sách bảo mật của các trang web đó. Chúng tôi không kiểm soát và không chịu trách nhiệm về nội dung, chính sách bảo mật hoặc thực tiễn của bất kỳ trang hoặc dịch vụ bên thứ ba nào.
</p> <p><strong>Quyền riêng tư của trẻ em</strong></p> <div><p>
    Các Dịch vụ này không hướng đến bất kỳ ai dưới 13 tuổi. Chúng tôi không cố ý thu thập thông tin nhận dạng cá nhân từ trẻ em dưới 13 tuổi. Trong trường hợp Chúng tôi phát hiện một trẻ dưới 13 tuổi đã cung cấp thông tin cá nhân cho chúng tôi, Chúng tôi sẽ ngay lập tức xóa thông tin đó khỏi máy chủ. Nếu bạn là phụ huynh hoặc người giám hộ và biết rằng con bạn đã cung cấp thông tin cá nhân cho chúng tôi, vui lòng liên hệ với tôi để Chúng tôi có thể thực hiện các hành động cần thiết.
  </p></div> <p><strong>Thay đổi Chính sách bảo mật này</strong></p> <p>
    Chúng tôi có thể cập nhật Chính sách bảo mật theo thời gian. Vì vậy, bạn nên xem lại trang này định kỳ để biết mọi thay đổi. Chúng tôi sẽ thông báo mọi thay đổi bằng cách đăng Chính sách bảo mật mới trên trang này.
</p>
<p>Chính sách này có hiệu lực kể từ 2024-06-01</p>
<p><strong>Liên hệ</strong></p>
<p> Nếu bạn có bất kỳ câu hỏi hoặc đề xuất nào về Chính sách bảo mật của chúng tôi, đừng ngần ngại liên hệ với tôi tại</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Trang chính sách bảo mật này được tạo tại <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>và được chỉnh sửa/tạo bởi <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Dịch bởi Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.chinese1 => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>隱私權政策 Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports 將本應用建為（免費／廣告支援／應用內購買）應用。本服務由 Falun Dafa Practice Supports 提供，並按現況使用。
</p> <p>
  本頁用於告知訪客，若有人決定使用我們的服務，我們關於個人資訊之收集、使用與揭露的政策。
</p> <p>
  若您選擇使用我們的服務，即表示您同意依本政策收集與使用資訊。
  </p>
 <p><strong>資訊收集與使用</strong></p> <p>
    我們不收集個人資料（全名、地址、聯絡資訊、電子郵件、電話號碼、影像……及其他個人文件）
  <p>
  我們要求的資訊會保留在您的裝置上，我們不以任何方式收集。</p>
  <p>應用可收集使用資料，例如：登入時間、使用狀態……</p>
</p> <div><p>
    本應用使用可能收集用於識別您之資訊的第三方服務。
  </p> <p>
    本應用所使用之第三方服務提供者隱私權政策連結
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>日誌資料</strong></p> <p>
  我們想告知您：每當您使用本服務，若應用發生錯誤，我們會透過第三方產品在您的手機上收集稱為日誌資料的資料與資訊。日誌資料可能包括裝置 IP 位址、裝置名稱、作業系統版本、使用本服務時的應用設定、使用日期與時間，以及其他統計資料。
</p>

<p><strong>服務提供者</strong></p> <p>
  我們可能因下列原因僱用第三方公司與個人：
</p> <ul><li>為便利我們的服務；</li> <li>代表我們提供服務；</li> <li>執行與服務相關的服務；或</li> <li>協助我們分析服務的使用方式。</li></ul> <p>
  我們想告知本服務使用者，這些第三方可存取其個人資訊。原因是代表我們執行所指派的任務。但他們有義務不得為任何其他目的揭露或使用該資訊。
</p> <p><strong>安全性</strong></p> <p>
  我們重視您提供個人資訊的信任，因此努力使用商業上可接受的方式加以保護。但請記住，透過網際網路傳輸或電子儲存的方法都不是 100% 安全可靠，我們無法保證絕對安全。
</p> <p><strong>其他網站連結</strong></p> <p>
  本服務可能包含其他網站的連結。若您點擊第三方連結，將被導向該網站。請注意，這些外部網站並非由我們營運。因此我們強烈建議您查閱這些網站的隱私權政策。我們對任何第三方網站或服務的內容、隱私權政策或做法無權控制也不承擔責任。
</p> <p><strong>兒童隱私</strong></p> <div><p>
    本服務不針對未滿 13 歲者。我們不會故意向未滿 13 歲兒童收集可識別個人身分的資訊。若發現未滿 13 歲兒童向我們提供個人資訊，我們會立即從伺服器刪除。若您是家長或監護人，並知悉您的孩子向我們提供了個人資訊，請與我聯絡，以便我們採取必要措施。
  </p></div> <p><strong>本隱私權政策之變更</strong></p> <p>
    我們可能不時更新隱私權政策。因此建議您定期查閱本頁以了解任何變更。我們會透過在本頁張貼新的隱私權政策來通知您任何變更。
</p>
<p>本政策自 2024-06-01 起生效</p>
<p><strong>聯絡我們</strong></p>
<p> 若您對我們的隱私權政策有任何問題或建議，請隨時透過以下方式與我聯絡</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>本隱私權政策頁面建立於 <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>並由以下修改／產生 <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>由 Google 翻譯提供翻譯</em></p>
</body>
</html>''',
    NewAreaLang.chinese2 => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>隐私政策 Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports 将本应用建为（免费／广告支持／应用内购买）应用。本服务由 Falun Dafa Practice Supports 提供，并按现状使用。
</p> <p>
  本页用于告知访客，若有人决定使用我们的服务，我们关于个人信息之收集、使用与披露的政策。
</p> <p>
  若您选择使用我们的服务，即表示您同意依本政策收集与使用信息。
  </p>
 <p><strong>信息收集与使用</strong></p> <p>
    我们不收集个人数据（全名、地址、联系信息、电子邮件、电话号码、影像……及其他个人文件）
  <p>
  我们要求的信息会保留在您的设备上，我们不以任何方式收集。</p>
  <p>应用可收集使用数据，例如：登录时间、使用状态……</p>
</p> <div><p>
    本应用使用可能收集用于识别您之信息的第三方服务。
  </p> <p>
    本应用所使用之第三方服务提供者隐私政策链接
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>日志数据</strong></p> <p>
  我们想告知您：每当您使用本服务，若应用发生错误，我们会通过第三方产品在您的手机上收集称为日志数据的数据与信息。日志数据可能包括设备 IP 地址、设备名称、操作系统版本、使用本服务时的应用配置、使用日期与时间，以及其他统计数据。
</p>

<p><strong>服务提供者</strong></p> <p>
  我们可能因下列原因雇佣第三方公司与个人：
</p> <ul><li>为便利我们的服务；</li> <li>代表我们提供服务；</li> <li>执行与服务相关的服务；或</li> <li>协助我们分析服务的使用方式。</li></ul> <p>
  我们想告知本服务用户，这些第三方可访问其个人信息。原因是代表我们执行所指派的任务。但他们有义务不得为任何其他目的披露或使用该信息。
</p> <p><strong>安全性</strong></p> <p>
  我们重视您提供个人信息的信任，因此努力使用商业上可接受的方式加以保护。但请记住，通过互联网传输或电子存储的方法都不是 100% 安全可靠，我们无法保证绝对安全。
</p> <p><strong>其他网站链接</strong></p> <p>
  本服务可能包含其他网站的链接。若您点击第三方链接，将被导向该网站。请注意，这些外部网站并非由我们运营。因此我们强烈建议您查阅这些网站的隐私政策。我们对任何第三方网站或服务的内容、隐私政策或做法无权控制也不承担责任。
</p> <p><strong>儿童隐私</strong></p> <div><p>
    本服务不针对未满 13 岁者。我们不会故意向未满 13 岁儿童收集可识别个人身份的信息。若发现未满 13 岁儿童向我们提供个人信息，我们会立即从服务器删除。若您是家长或监护人，并知悉您的孩子向我们提供了个人信息，请与我联络，以便我们采取必要措施。
  </p></div> <p><strong>本隐私政策之变更</strong></p> <p>
    我们可能不时更新隐私政策。因此建议您定期查阅本页以了解任何变更。我们会通过在本页张贴新的隐私政策来通知您任何变更。
</p>
<p>本政策自 2024-06-01 起生效</p>
<p><strong>联系我们</strong></p>
<p> 若您对我们的隐私政策有任何问题或建议，请随时通过以下方式与我联络</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>本隐私政策页面建立于 <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>并由以下修改／生成 <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>由 Google 翻译提供翻译</em></p>
</body>
</html>''',
    NewAreaLang.bosanski => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Politika privatnosti Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports je napravio aplikaciju kao (besplatnu / s oglasima / kupovine u aplikaciji) aplikaciju. Ova USLUGA se pruža od strane Falun Dafa Practice Supports i namijenjena je korištenju kakva jeste.
</p> <p>
  Ova stranica služi da obavijesti posjetioce o našim politikama prikupljanja, korištenja i otkrivanja Ličnih informacija ako neko odluči koristiti našu Uslugu.
</p> <p>
  Ako odaberete koristiti našu Uslugu, slažete se s prikupljanjem i korištenjem informacija u skladu s ovom politikom.
  </p>
 <p><strong>Prikupljanje i korištenje informacija</strong></p> <p>
    Ne prikupljamo lične podatke (puno ime, adresa, kontakt, email, broj telefona, slika, ... niti druge lične dokumente)
  <p>
  Informacije koje tražimo ostaju na vašem uređaju i mi ih ne prikupljamo ni na koji način.</p>
  <p>Aplikacije mogu prikupljati podatke o korištenju kao što su: vrijeme prijave, status korištenja ...</p>
</p> <div><p>
    Aplikacija koristi usluge trećih strana koje mogu prikupljati informacije za vašu identifikaciju.
  </p> <p>
    Link na politiku privatnosti pružatelja usluga trećih strana koje aplikacija koristi
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Podaci dnevnika</strong></p> <p>
  Želimo vas obavijestiti da kad god koristite našu Uslugu, u slučaju greške u aplikaciji prikupljamo podatke i informacije (putem proizvoda trećih strana) na vašem telefonu zvane Podaci dnevnika. Oni mogu uključivati IP adresu uređaja, ime uređaja, verziju OS-a, konfiguraciju aplikacije pri korištenju Usluge, vrijeme i datum korištenja te druge statistike.
</p>

<p><strong>Pružatelji usluga</strong></p> <p>
  Možemo angažirati treće kompanije i pojedince zbog sljedećih razloga:
</p> <ul><li>Da olakšamo našu Uslugu;</li> <li>Da pružimo Uslugu u naše ime;</li> <li>Da obavimo usluge povezane s Uslugom; ili</li> <li>Da nam pomognu analizirati kako se naša Usluga koristi.</li></ul> <p>
  Želimo obavijestiti korisnike ove Usluge da te treće strane imaju pristup njihovim Ličnim informacijama. Razlog je obavljanje zadataka dodijeljenih u naše ime. Međutim, obavezne su da ne otkrivaju niti koriste informacije u druge svrhe.
</p> <p><strong>Sigurnost</strong></p> <p>
  Cijenimo vaše povjerenje pri pružanju Ličnih informacija i nastojimo koristiti komercijalno prihvatljiva sredstva zaštite. Ali zapamtite da nijedan način prijenosa preko interneta ili elektronskog skladištenja nije 100% siguran i pouzdan, i ne možemo garantirati apsolutnu sigurnost.
</p> <p><strong>Linkovi na druge stranice</strong></p> <p>
  Ova Usluga može sadržavati linkove na druge stranice. Ako kliknete na link treće strane, bit ćete usmjereni na tu stranicu. Napomena: te vanjske stranice ne upravljamo mi. Stoga vas snažno savjetujemo da pregledate Politiku privatnosti tih web stranica. Nemamo kontrolu i ne preuzimamo odgovornost za sadržaj, politike privatnosti ili prakse bilo kojih stranica ili usluga trećih strana.
</p> <p><strong>Privatnost djece</strong></p> <div><p>
    Ove Usluge nisu namijenjene nikome mlađem od 13 godina. Svjesno ne prikupljamo lične podatke od djece mlađe od 13 godina. Ako otkrijemo da je dijete mlađe od 13 dalo lične informacije, odmah ih brišemo s naših servera. Ako ste roditelj ili staratelj i znate da je vaše dijete dalo lične informacije, kontaktirajte me kako bismo mogli poduzeti potrebne mjere.
  </p></div> <p><strong>Izmjene ove Politike privatnosti</strong></p> <p>
    Možemo s vremena na vrijeme ažurirati našu Politiku privatnosti. Stoga ste savjetovani da povremeno pregledate ovu stranicu zbog promjena. Obavijestit ćemo vas o promjenama objavljivanjem nove Politike privatnosti na ovoj stranici.
</p>
<p>Ova politika važi od 2024-06-01</p>
<p><strong>Kontaktirajte nas</strong></p>
<p> Ako imate pitanja ili prijedloge o našoj Politici privatnosti, ne ustručavajte se kontaktirati me na</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Ova stranica politike privatnosti kreirana je na <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>i izmijenjena/generisana od <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Preveo Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.deutsch => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Datenschutzrichtlinie Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports hat die App als (kostenlose / werbefinanzierte / In-App-Kauf-) App erstellt. Dieser DIENST wird von Falun Dafa Practice Supports bereitgestellt und ist zur Nutzung wie besehen bestimmt.
</p> <p>
  Diese Seite dient dazu, Besucher über unsere Richtlinien zur Erhebung, Nutzung und Offenlegung personenbezogener Daten zu informieren, falls jemand unseren Dienst nutzen möchte.
</p> <p>
  Wenn Sie unseren Dienst nutzen, stimmen Sie der Erhebung und Nutzung von Informationen gemäß dieser Richtlinie zu.
  </p>
 <p><strong>Erhebung und Nutzung von Informationen</strong></p> <p>
    Wir erheben keine personenbezogenen Daten (vollständiger Name, Adresse, Kontaktdaten, E-Mail, Telefonnummer, Bild, ... und keine anderen persönlichen Dokumente)
  <p>
  Die von uns angeforderten Informationen bleiben auf Ihrem Gerät und werden von uns in keiner Weise erhoben.</p>
  <p>Anwendungen können Nutzungsdaten erheben wie: Anmeldezeit, Nutzungsstatus ...</p>
</p> <div><p>
    Die App nutzt Dienste Dritter, die Informationen zur Identifizierung erheben können.
  </p> <p>
    Link zu den Datenschutzrichtlinien der von der App genutzten Drittanbieter
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Protokolldaten</strong></p> <p>
  Wir möchten Sie darüber informieren, dass wir bei Nutzung unseres Dienstes im Fehlerfall Daten und Informationen (über Drittanbieterprodukte) auf Ihrem Telefon erheben, sogenannte Protokolldaten. Diese können u. a. die IP-Adresse Ihres Geräts, Gerätename, Betriebssystemversion, die App-Konfiguration bei Nutzung unseres Dienstes, Zeitpunkt der Nutzung und andere Statistiken umfassen.
</p>

<p><strong>Dienstanbieter</strong></p> <p>
  Wir können Drittunternehmen und Einzelpersonen aus folgenden Gründen beschäftigen:
</p> <ul><li>Um unseren Dienst zu erleichtern;</li> <li>Um den Dienst in unserem Namen bereitzustellen;</li> <li>Um dienstbezogene Leistungen zu erbringen; oder</li> <li>Um uns bei der Analyse der Nutzung unseres Dienstes zu unterstützen.</li></ul> <p>
  Wir möchten Nutzer dieses Dienstes darüber informieren, dass diese Dritten Zugang zu ihren personenbezogenen Daten haben. Der Grund ist die Erfüllung der ihnen in unserem Namen übertragenen Aufgaben. Sie sind jedoch verpflichtet, die Informationen nicht für andere Zwecke offenzulegen oder zu nutzen.
</p> <p><strong>Sicherheit</strong></p> <p>
  Wir schätzen Ihr Vertrauen bei der Bereitstellung personenbezogener Daten und bemühen uns um wirtschaftlich vertretbare Schutzmaßnahmen. Denken Sie jedoch daran, dass keine Übertragung im Internet und keine elektronische Speicherung zu 100 % sicher und zuverlässig ist, und wir absolute Sicherheit nicht garantieren können.
</p> <p><strong>Links zu anderen Seiten</strong></p> <p>
  Dieser Dienst kann Links zu anderen Seiten enthalten. Wenn Sie auf einen Drittanbieter-Link klicken, werden Sie zu dieser Seite weitergeleitet. Beachten Sie, dass diese externen Seiten nicht von uns betrieben werden. Daher raten wir dringend, die Datenschutzrichtlinie dieser Websites zu prüfen. Wir haben keine Kontrolle über und übernehmen keine Verantwortung für Inhalte, Datenschutzrichtlinien oder Praktiken von Drittanbieter-Seiten oder -Diensten.
</p> <p><strong>Datenschutz von Kindern</strong></p> <div><p>
    Diese Dienste richten sich nicht an Personen unter 13 Jahren. Wir erheben wissentlich keine personenbezogenen Daten von Kindern unter 13 Jahren. Entdecken wir, dass ein Kind unter 13 Jahren uns personenbezogene Daten übermittelt hat, löschen wir diese sofort von unseren Servern. Wenn Sie Elternteil oder Erziehungsberechtigter sind und wissen, dass Ihr Kind uns personenbezogene Daten übermittelt hat, kontaktieren Sie mich bitte, damit wir die erforderlichen Maßnahmen ergreifen können.
  </p></div> <p><strong>Änderungen dieser Datenschutzrichtlinie</strong></p> <p>
    Wir können unsere Datenschutzrichtlinie von Zeit zu Zeit aktualisieren. Daher sollten Sie diese Seite regelmäßig auf Änderungen prüfen. Wir benachrichtigen Sie über Änderungen, indem wir die neue Datenschutzrichtlinie auf dieser Seite veröffentlichen.
</p>
<p>Diese Richtlinie gilt ab dem 2024-06-01</p>
<p><strong>Kontakt</strong></p>
<p> Wenn Sie Fragen oder Anregungen zu unserer Datenschutzrichtlinie haben, zögern Sie nicht, mich zu kontaktieren unter</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Diese Datenschutzseite wurde erstellt unter <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>und geändert/erstellt von <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Übersetzt von Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.espanol => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Política de privacidad Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports creó la aplicación como una app (gratuita / con anuncios / compras en la aplicación). Este SERVICIO es proporcionado por Falun Dafa Practice Supports y está destinado a usarse tal cual.
</p> <p>
  Esta página informa a los visitantes sobre nuestras políticas respecto a la recopilación, el uso y la divulgación de Información personal si alguien decide usar nuestro Servicio.
</p> <p>
  Si elige usar nuestro Servicio, acepta la recopilación y el uso de información en relación con esta política.
  </p>
 <p><strong>Recopilación y uso de información</strong></p> <p>
    No recopilamos datos personales (nombre completo, dirección, datos de contacto, correo, teléfono, imagen, ... ni otros documentos personales)
  <p>
  La información que solicitamos se conserva en su dispositivo y no es recopilada por nosotros de ninguna manera.</p>
  <p>Las aplicaciones pueden recopilar datos de uso como: hora de inicio de sesión, estado de uso ...</p>
</p> <div><p>
    La aplicación usa servicios de terceros que pueden recopilar información usada para identificarle.
  </p> <p>
    Enlace a la política de privacidad de los proveedores de servicios de terceros usados por la aplicación
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Datos de registro</strong></p> <p>
  Queremos informarle de que cada vez que usa nuestro Servicio, en caso de error en la aplicación, recopilamos datos e información (mediante productos de terceros) en su teléfono llamados Datos de registro. Pueden incluir la dirección IP del dispositivo, nombre del dispositivo, versión del sistema operativo, la configuración de la aplicación al usar nuestro Servicio, la fecha y hora de uso, y otras estadísticas.
</p>

<p><strong>Proveedores de servicios</strong></p> <p>
  Podemos emplear empresas e individuos terceros por las siguientes razones:
</p> <ul><li>Para facilitar nuestro Servicio;</li> <li>Para proporcionar el Servicio en nuestro nombre;</li> <li>Para realizar servicios relacionados con el Servicio; o</li> <li>Para ayudarnos a analizar cómo se usa nuestro Servicio.</li></ul> <p>
  Queremos informar a los usuarios de este Servicio de que estos terceros tienen acceso a su Información personal. El motivo es realizar las tareas asignadas en nuestro nombre. Sin embargo, están obligados a no divulgar ni usar la información para ningún otro fin.
</p> <p><strong>Seguridad</strong></p> <p>
  Valoramos su confianza al proporcionarnos su Información personal y nos esforzamos por usar medios comercialmente aceptables para protegerla. Pero recuerde que ningún método de transmisión por Internet ni de almacenamiento electrónico es 100% seguro y fiable, y no podemos garantizar su seguridad absoluta.
</p> <p><strong>Enlaces a otros sitios</strong></p> <p>
  Este Servicio puede contener enlaces a otros sitios. Si hace clic en un enlace de terceros, será dirigido a ese sitio. Tenga en cuenta que esos sitios externos no son operados por nosotros. Por ello, le aconsejamos firmemente revisar la Política de privacidad de esos sitios. No tenemos control ni asumimos responsabilidad por el contenido, las políticas de privacidad o las prácticas de sitios o servicios de terceros.
</p> <p><strong>Privacidad de los niños</strong></p> <div><p>
    Estos Servicios no se dirigen a nadie menor de 13 años. No recopilamos a sabiendas información personal identificable de niños menores de 13 años. Si descubrimos que un niño menor de 13 nos ha proporcionado información personal, la eliminamos de inmediato de nuestros servidores. Si es padre, madre o tutor y sabe que su hijo nos ha proporcionado información personal, contácteme para que podamos tomar las medidas necesarias.
  </p></div> <p><strong>Cambios a esta Política de privacidad</strong></p> <p>
    Podemos actualizar nuestra Política de privacidad de vez en cuando. Por ello, se le aconseja revisar esta página periódicamente para cualquier cambio. Le notificaremos cualquier cambio publicando la nueva Política de privacidad en esta página.
</p>
<p>Esta política entra en vigor a partir del 2024-06-01</p>
<p><strong>Contáctenos</strong></p>
<p> Si tiene preguntas o sugerencias sobre nuestra Política de privacidad, no dude en contactarme en</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Esta página de política de privacidad se creó en <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>y fue modificada/generada por <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Traducido por Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.farsi => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>سیاست حفظ حریم خصوصی Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports این برنامه را به‌صورت برنامه (رایگان / با تبلیغات / خرید درون‌برنامه‌ای) ساخته است. این خدمت توسط Falun Dafa Practice Supports ارائه می‌شود و برای استفاده به‌صورت «همان‌گونه که هست» در نظر گرفته شده است.
</p> <p>
  این صفحه برای اطلاع‌رسانی به بازدیدکنندگان درباره سیاست‌های ما در جمع‌آوری، استفاده و افشای اطلاعات شخصی است، اگر کسی تصمیم بگیرد از خدمت ما استفاده کند.
</p> <p>
  اگر استفاده از خدمت ما را انتخاب کنید، با جمع‌آوری و استفاده از اطلاعات مطابق این سیاست موافقت می‌کنید.
  </p>
 <p><strong>جمع‌آوری و استفاده از اطلاعات</strong></p> <p>
    ما داده‌های شخصی جمع‌آوری نمی‌کنیم (نام کامل، آدرس، اطلاعات تماس، ایمیل، شماره تلفن، تصویر و سایر اسناد شخصی)
  <p>
  اطلاعاتی که درخواست می‌کنیم روی دستگاه شما نگه داشته می‌شود و به هیچ وجه توسط ما جمع‌آوری نمی‌شود.</p>
  <p>برنامه‌ها ممکن است داده‌های استفاده مانند زمان ورود، وضعیت استفاده و ... را جمع‌آوری کنند.</p>
</p> <div><p>
    برنامه از خدمات شخص ثالثی استفاده می‌کند که ممکن است اطلاعاتی برای شناسایی شما جمع‌آوری کنند.
  </p> <p>
    پیوند به سیاست حفظ حریم خصوصی ارائه‌دهندگان خدمات شخص ثالث مورد استفاده برنامه
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>داده‌های گزارش</strong></p> <p>
  می‌خواهیم به شما اطلاع دهیم که هرگاه از خدمت ما استفاده می‌کنید، در صورت خطا در برنامه، داده‌ها و اطلاعاتی (از طریق محصولات شخص ثالث) روی تلفن شما به نام داده‌های گزارش جمع‌آوری می‌کنیم. این داده‌ها ممکن است شامل آدرس IP دستگاه، نام دستگاه، نسخه سیستم‌عامل، پیکربندی برنامه هنگام استفاده از خدمت، زمان و تاریخ استفاده و آمار دیگر باشد.
</p>

<p><strong>ارائه‌دهندگان خدمت</strong></p> <p>
  ممکن است به دلایل زیر شرکت‌ها و افراد شخص ثالث را به کار بگیریم:
</p> <ul><li>برای تسهیل خدمت ما؛</li> <li>برای ارائه خدمت از جانب ما؛</li> <li>برای انجام خدمات مرتبط با خدمت؛ یا</li> <li>برای کمک به ما در تحلیل نحوه استفاده از خدمت.</li></ul> <p>
  می‌خواهیم به کاربران این خدمت اطلاع دهیم که این اشخاص ثالث به اطلاعات شخصی آن‌ها دسترسی دارند. دلیل، انجام وظایف محول‌شده از جانب ماست. با این حال، موظف‌اند اطلاعات را برای هیچ هدف دیگری افشا یا استفاده نکنند.
</p> <p><strong>امنیت</strong></p> <p>
  به اعتماد شما در ارائه اطلاعات شخصی ارزش می‌نهیم و در تلاشیم از ابزارهای قابل قبول تجاری برای محافظت از آن استفاده کنیم. اما به یاد داشته باشید که هیچ روش انتقال از طریق اینترنت یا ذخیره الکترونیکی ۱۰۰٪ امن و قابل اعتماد نیست و ما نمی‌توانیم امنیت مطلق را تضمین کنیم.
</p> <p><strong>پیوند به سایت‌های دیگر</strong></p> <p>
  این خدمت ممکن است حاوی پیوند به سایت‌های دیگر باشد. اگر روی پیوند شخص ثالث کلیک کنید، به آن سایت هدایت می‌شوید. توجه کنید که این سایت‌های خارجی توسط ما اداره نمی‌شوند. بنابراین اکیداً توصیه می‌کنیم سیاست حفظ حریم خصوصی آن وب‌سایت‌ها را بررسی کنید. ما هیچ کنترلی نداریم و مسئولیتی در قبال محتوا، سیاست‌های حریم خصوصی یا شیوه‌های هیچ سایت یا خدمت شخص ثالثی نمی‌پذیریم.
</p> <p><strong>حریم خصوصی کودکان</strong></p> <div><p>
    این خدمات خطاب به افراد زیر ۱۳ سال نیست. ما آگاهانه اطلاعات قابل شناسایی شخصی از کودکان زیر ۱۳ سال جمع‌آوری نمی‌کنیم. اگر کشف کنیم کودکی زیر ۱۳ سال اطلاعات شخصی به ما داده است، فوراً آن را از سرورهایمان حذف می‌کنیم. اگر والدین یا قیم هستید و می‌دانید فرزندتان اطلاعات شخصی به ما داده است، لطفاً با من تماس بگیرید تا اقدامات لازم را انجام دهیم.
  </p></div> <p><strong>تغییرات این سیاست حفظ حریم خصوصی</strong></p> <p>
    ممکن است گاه‌به‌گاه سیاست حفظ حریم خصوصی را به‌روز کنیم. بنابراین توصیه می‌شود این صفحه را به‌طور دوره‌ای برای هرگونه تغییر بررسی کنید. با انتشار سیاست جدید در این صفحه شما را مطلع می‌کنیم.
</p>
<p>این سیاست از تاریخ ۲۰۲۴-۰۶-۰۱ معتبر است</p>
<p><strong>تماس با ما</strong></p>
<p> اگر سؤال یا پیشنهادی درباره سیاست حفظ حریم خصوصی ما دارید، در تماس با من درنگ نکنید</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>این صفحه سیاست حفظ حریم خصوصی در اینجا ایجاد شده است <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>و توسط این مورد اصلاح/تولید شده است <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>ترجمه شده توسط Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.francais => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Politique de confidentialité Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports a créé l'application en tant qu'application (gratuite / financée par la publicité / achats intégrés). Ce SERVICE est fourni par Falun Dafa Practice Supports et est destiné à être utilisé tel quel.
</p> <p>
  Cette page sert à informer les visiteurs de nos politiques concernant la collecte, l'utilisation et la divulgation des Informations personnelles si quelqu'un décide d'utiliser notre Service.
</p> <p>
  Si vous choisissez d'utiliser notre Service, vous acceptez la collecte et l'utilisation d'informations conformément à cette politique.
  </p>
 <p><strong>Collecte et utilisation des informations</strong></p> <p>
    Nous ne collectons pas de données personnelles (nom complet, adresse, coordonnées, e-mail, numéro de téléphone, image, ... ni aucun autre document personnel)
  <p>
  Les informations que nous demandons sont conservées sur votre appareil et ne sont collectées par nous d'aucune manière.</p>
  <p>Les applications peuvent collecter des données d'utilisation telles que : heure de connexion, état d'utilisation ...</p>
</p> <div><p>
    L'application utilise des services tiers qui peuvent collecter des informations servant à vous identifier.
  </p> <p>
    Lien vers la politique de confidentialité des fournisseurs de services tiers utilisés par l'application
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Données de journal</strong></p> <p>
  Nous souhaitons vous informer qu'à chaque utilisation de notre Service, en cas d'erreur dans l'application, Nous collectons des données et informations (via des produits tiers) sur votre téléphone, appelées Données de journal. Celles-ci peuvent inclure l'adresse IP de votre appareil, le nom de l'appareil, la version du système d'exploitation, la configuration de l'application lors de l'utilisation de notre Service, la date et l'heure d'utilisation, et d'autres statistiques.
</p>

<p><strong>Fournisseurs de services</strong></p> <p>
  Nous pouvons employer des sociétés et des personnes tierces pour les raisons suivantes :
</p> <ul><li>Pour faciliter notre Service ;</li> <li>Pour fournir le Service en notre nom ;</li> <li>Pour exécuter des services liés au Service ; ou</li> <li>Pour nous aider à analyser comment notre Service est utilisé.</li></ul> <p>
  Nous souhaitons informer les utilisateurs de ce Service que ces tiers ont accès à leurs Informations personnelles. La raison est d'accomplir les tâches qui leur sont assignées en notre nom. Cependant, ils sont tenus de ne pas divulguer ni utiliser les informations à d'autres fins.
</p> <p><strong>Sécurité</strong></p> <p>
  Nous apprécions votre confiance lorsque vous nous fournissez vos Informations personnelles, et nous nous efforçons d'utiliser des moyens commercialement acceptables pour les protéger. Mais rappelez-vous qu'aucune méthode de transmission sur Internet ni de stockage électronique n'est sûre et fiable à 100 %, et Nous ne pouvons garantir une sécurité absolue.
</p> <p><strong>Liens vers d'autres sites</strong></p> <p>
  Ce Service peut contenir des liens vers d'autres sites. Si vous cliquez sur un lien tiers, vous serez dirigé vers ce site. Notez que ces sites externes ne sont pas exploités par nous. Nous vous conseillons donc vivement de consulter la Politique de confidentialité de ces sites. Nous n'avons aucun contrôle et n'assumons aucune responsabilité quant au contenu, aux politiques de confidentialité ou aux pratiques de tout site ou service tiers.
</p> <p><strong>Confidentialité des enfants</strong></p> <div><p>
    Ces Services ne s'adressent à personne de moins de 13 ans. Nous ne collectons pas sciemment d'informations personnelles identifiables auprès d'enfants de moins de 13 ans. Si Nous découvrons qu'un enfant de moins de 13 ans nous a fourni des informations personnelles, Nous les supprimons immédiatement de nos serveurs. Si vous êtes parent ou tuteur et que vous savez que votre enfant nous a fourni des informations personnelles, veuillez me contacter afin que Nous puissions prendre les mesures nécessaires.
  </p></div> <p><strong>Modifications de cette Politique de confidentialité</strong></p> <p>
    Nous pouvons mettre à jour notre Politique de confidentialité de temps à autre. Vous êtes donc invité à consulter cette page périodiquement pour tout changement. Nous vous informerons de tout changement en publiant la nouvelle Politique de confidentialité sur cette page.
</p>
<p>Cette politique est en vigueur à compter du 2024-06-01</p>
<p><strong>Nous contacter</strong></p>
<p> Si vous avez des questions ou suggestions concernant notre Politique de confidentialité, n'hésitez pas à me contacter à</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Cette page de politique de confidentialité a été créée sur <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>et modifiée/générée par <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Traduit par Google Traduction</em></p>
</body>
</html>''',
    NewAreaLang.hebrew => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>מדיניות פרטיות Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports בנתה את האפליקציה כאפליקציה (חינמית / נתמכת פרסומות / רכישות באפליקציה). שירות זה מסופק על ידי Falun Dafa Practice Supports ומיועד לשימוש כפי שהוא.
</p> <p>
  דף זה משמש ליידע מבקרים לגבי המדיניות שלנו בנוגע לאיסוף, שימוש וחשיפה של מידע אישי אם מישהו מחליט להשתמש בשירות שלנו.
</p> <p>
  אם תבחרו להשתמש בשירות שלנו, אתם מסכימים לאיסוף ולשימוש במידע בהתאם למדיניות זו.
  </p>
 <p><strong>איסוף ושימוש במידע</strong></p> <p>
    איננו אוספים נתונים אישיים (שם מלא, כתובת, פרטי קשר, אימייל, מספר טלפון, תמונה ומסמכים אישיים אחרים)
  <p>
  המידע שאנו מבקשים נשמר במכשיר שלכם ואינו נאסף על ידינו בשום אופן.</p>
  <p>אפליקציות יכולות לאסוף נתוני שימוש כגון: זמן התחברות, מצב שימוש ...</p>
</p> <div><p>
    האפליקציה משתמשת בשירותי צד שלישי שעשויים לאסוף מידע המשמש לזיהויכם.
  </p> <p>
    קישור למדיניות הפרטיות של ספקי שירות צד שלישי שבהם משתמשת האפליקציה
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>נתוני יומן</strong></p> <p>
  ברצוננו ליידע אתכם שבכל פעם שאתם משתמשים בשירות שלנו, במקרה של שגיאה באפליקציה, אנו אוספים נתונים ומידע (באמצעות מוצרי צד שלישי) בטלפון שלכם הנקראים נתוני יומן. אלה עשויים לכלול כתובת IP של המכשיר, שם המכשיר, גרסת מערכת ההפעלה, תצורת האפליקציה בעת השימוש בשירות, תאריך ושעת השימוש וסטטיסטיקות אחרות.
</p>

<p><strong>ספקי שירות</strong></p> <p>
  אנו עשויים להעסיק חברות ויחידים צד שלישי מהסיבות הבאות:
</p> <ul><li>כדי להקל על השירות שלנו;</li> <li>כדי לספק את השירות בשמנו;</li> <li>כדי לבצע שירותים הקשורים לשירות; או</li> <li>כדי לסייע לנו בניתוח אופן השימוש בשירות.</li></ul> <p>
  ברצוננו ליידע את משתמשי השירות שצדדים שלישיים אלה יכולים לגשת למידע האישי שלהם. הסיבה היא לבצע את המשימות שהוקצו להם בשמנו. עם זאת, הם מחויבים שלא לחשוף או להשתמש במידע לכל מטרה אחרת.
</p> <p><strong>אבטחה</strong></p> <p>
  אנו מעריכים את אמונכם במסירת מידע אישי ומנסים להשתמש באמצעים מקובלים מסחרית להגנתו. אך זכרו שאין שיטת העברה באינטרנט או אחסון אלקטרוני שהיא בטוחה ואמינה ב־100%, ואיננו יכולים להבטיח אבטחה מוחלטת.
</p> <p><strong>קישורים לאתרים אחרים</strong></p> <p>
  שירות זה עשוי להכיל קישורים לאתרים אחרים. אם תלחצו על קישור צד שלישי, תופנו לאתר זה. שימו לב שאתרים חיצוניים אלה אינם מופעלים על ידינו. לכן אנו ממליצים בחום לעיין במדיניות הפרטיות של אתרים אלה. אין לנו שליטה ואיננו נושאים באחריות לתוכן, למדיניות פרטיות או לנהגים של אתרים או שירותי צד שלישי כלשהם.
</p> <p><strong>פרטיות ילדים</strong></p> <div><p>
    שירותים אלה אינם מיועדים למי שמתחת לגיל 13. איננו אוספים ביודעין מידע מזהה אישי מילדים מתחת לגיל 13. אם נגלה שילד מתחת לגיל 13 מסר לנו מידע אישי, נמחק אותו מיד מהשרתים שלנו. אם אתם הורה או אפוטרופוס ואתם מודעים לכך שילדכם מסר לנו מידע אישי, אנא צרו איתי קשר כדי שנוכל לנקוט בפעולות הנדרשות.
  </p></div> <p><strong>שינויים במדיניות פרטיות זו</strong></p> <p>
    אנו עשויים לעדכן את מדיניות הפרטיות מעת לעת. לכן מומלץ לעיין בדף זה מעת לעת לשינויים. נודיע לכם על שינויים על ידי פרסום מדיניות הפרטיות החדשה בדף זה.
</p>
<p>מדיניות זו בתוקף החל מ־2024-06-01</p>
<p><strong>צרו קשר</strong></p>
<p> אם יש לכם שאלות או הצעות לגבי מדיניות הפרטיות שלנו, אל תהססו ליצור איתי קשר ב</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>דף מדיניות פרטיות זה נוצר ב <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>ושונה/נוצר על ידי <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>תורגם על ידי Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.hrvatski => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Politika privatnosti Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports je napravio aplikaciju kao (besplatnu / s oglasima / kupovine u aplikaciji) aplikaciju. Ova USLUGA se pruža od strane Falun Dafa Practice Supports i namijenjena je korištenju kakva jeste.
</p> <p>
  Ova stranica služi da obavijesti posjetioce o našim politikama prikupljanja, korištenja i otkrivanja Osobnih informacija ako neko odluči koristiti našu Uslugu.
</p> <p>
  Ako odaberete koristiti našu Uslugu, slažete se s prikupljanjem i korištenjem informacija u skladu s ovom politikom.
  </p>
 <p><strong>Prikupljanje i korištenje informacija</strong></p> <p>
    Ne prikupljamo osobne podatke (puno ime, adresa, kontakt, email, broj telefona, slika, ... niti druge osobne dokumente)
  <p>
  Informacije koje tražimo ostaju na vašem uređaju i mi ih ne prikupljamo ni na koji način.</p>
  <p>Aplikacije mogu prikupljati podatke o korištenju kao što su: vrijeme prijave, status korištenja ...</p>
</p> <div><p>
    Aplikacija koristi usluge trećih strana koje mogu prikupljati informacije za vašu identifikaciju.
  </p> <p>
    Link na politiku privatnosti pružatelja usluga trećih strana koje aplikacija koristi
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Podaci dnevnika</strong></p> <p>
  Želimo vas obavijestiti da kad god koristite našu Uslugu, u slučaju greške u aplikaciji prikupljamo podatke i informacije (putem proizvoda trećih strana) na vašem telefonu zvane Podaci dnevnika. Oni mogu uključivati IP adresu uređaja, ime uređaja, verziju OS-a, konfiguraciju aplikacije pri korištenju Usluge, vrijeme i datum korištenja te druge statistike.
</p>

<p><strong>Pružatelji usluga</strong></p> <p>
  Možemo angažirati treće kompanije i pojedince zbog sljedećih razloga:
</p> <ul><li>Da olakšamo našu Uslugu;</li> <li>Da pružimo Uslugu u naše ime;</li> <li>Da obavimo usluge povezane s Uslugom; ili</li> <li>Da nam pomognu analizirati kako se naša Usluga koristi.</li></ul> <p>
  Želimo obavijestiti korisnike ove Usluge da te treće strane imaju pristup njihovim Ličnim informacijama. Razlog je obavljanje zadataka dodijeljenih u naše ime. Međutim, obavezne su da ne otkrivaju niti koriste informacije u druge svrhe.
</p> <p><strong>Sigurnost</strong></p> <p>
  Cijenimo vaše povjerenje pri pružanju Osobnih informacija i nastojimo koristiti komercijalno prihvatljiva sredstva zaštite. Ali zapamtite da nijedan način prijenosa preko interneta ili elektronskog skladištenja nije 100% siguran i pouzdan, i ne možemo garantirati apsolutnu sigurnost.
</p> <p><strong>Linkovi na druge stranice</strong></p> <p>
  Ova Usluga može sadržavati linkove na druge stranice. Ako kliknete na link treće strane, bit ćete usmjereni na tu stranicu. Napomena: te vanjske stranice ne upravljamo mi. Stoga vas snažno savjetujemo da pregledate Politiku privatnosti tih web stranica. Nemamo kontrolu i ne preuzimamo odgovornost za sadržaj, politike privatnosti ili prakse bilo kojih stranica ili usluga trećih strana.
</p> <p><strong>Privatnost djece</strong></p> <div><p>
    Ove Usluge nisu namijenjene nikome mlađem od 13 godina. Svjesno ne prikupljamo osobne podatke od djece mlađe od 13 godina. Ako otkrijemo da je dijete mlađe od 13 dalo osobne informacije, odmah ih brišemo s naših servera. Ako ste roditelj ili staratelj i znate da je vaše dijete dalo osobne informacije, kontaktirajte me kako bismo mogli poduzeti potrebne mjere.
  </p></div> <p><strong>Izmjene ove Politike privatnosti</strong></p> <p>
    Možemo s vremena na vrijeme ažurirati našu Politiku privatnosti. Stoga ste savjetovani da povremeno pregledate ovu stranicu zbog promjena. Obavijestit ćemo vas o promjenama objavljivanjem nove Politike privatnosti na ovoj stranici.
</p>
<p>Ova politika važi od 2024-06-01</p>
<p><strong>Kontaktirajte nas</strong></p>
<p> Ako imate pitanja ili prijedloge o našoj Politici privatnosti, ne ustručavajte se kontaktirati me na</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Ova stranica politike privatnosti kreirana je na <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>i izmijenjena/generisana od <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Preveo Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.indonesia => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Kebijakan Privasi Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports membangun aplikasi sebagai aplikasi (gratis / didukung iklan / pembelian dalam aplikasi). LAYANAN ini disediakan oleh Falun Dafa Practice Supports dan dimaksudkan untuk digunakan apa adanya.
</p> <p>
  Halaman ini digunakan untuk memberi tahu pengunjung mengenai kebijakan kami terkait pengumpulan, penggunaan, dan pengungkapan Informasi Pribadi jika seseorang memutuskan untuk menggunakan Layanan kami.
</p> <p>
  Jika Anda memilih untuk menggunakan Layanan kami, Anda setuju dengan pengumpulan dan penggunaan informasi terkait kebijakan ini.
  </p>
 <p><strong>Pengumpulan dan Penggunaan Informasi</strong></p> <p>
    Kami tidak mengumpulkan data pribadi (nama lengkap, alamat, informasi kontak, email, nomor telepon, gambar, ... dokumen pribadi lainnya)
  <p>
  Informasi yang kami minta akan disimpan di perangkat Anda dan tidak dikumpulkan oleh kami dengan cara apa pun.</p>
  <p>Aplikasi dapat mengumpulkan data penggunaan seperti: Waktu masuk, status penggunaan ...</p>
</p> <div><p>
    Aplikasi menggunakan layanan pihak ketiga yang mungkin mengumpulkan informasi yang digunakan untuk mengidentifikasi Anda.
  </p> <p>
    Tautan ke kebijakan privasi penyedia layanan pihak ketiga yang digunakan oleh aplikasi
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Data Log</strong></p> <p>
  Kami ingin memberi tahu Anda bahwa setiap kali Anda menggunakan Layanan kami, jika terjadi kesalahan di aplikasi, Kami mengumpulkan data dan informasi (melalui produk pihak ketiga) di ponsel Anda yang disebut Data Log. Data Log ini dapat mencakup alamat IP perangkat, nama perangkat, versi sistem operasi, konfigurasi aplikasi saat menggunakan Layanan kami, waktu dan tanggal penggunaan, serta statistik lainnya.
</p>

<p><strong>Penyedia Layanan</strong></p> <p>
  Kami dapat mempekerjakan perusahaan dan individu pihak ketiga karena alasan berikut:
</p> <ul><li>Untuk memfasilitasi Layanan kami;</li> <li>Untuk menyediakan Layanan atas nama kami;</li> <li>Untuk melakukan layanan terkait Layanan; atau</li> <li>Untuk membantu kami menganalisis bagaimana Layanan kami digunakan.</li></ul> <p>
  Kami ingin memberi tahu pengguna Layanan ini bahwa pihak ketiga tersebut memiliki akses ke Informasi Pribadi mereka. Alasannya adalah untuk melaksanakan tugas yang diberikan atas nama kami. Namun, mereka berkewajiban untuk tidak mengungkapkan atau menggunakan informasi untuk tujuan lain.
</p> <p><strong>Keamanan</strong></p> <p>
  Kami menghargai kepercayaan Anda dalam memberikan Informasi Pribadi kepada kami, sehingga kami berupaya menggunakan cara yang dapat diterima secara komersial untuk melindunginya. Namun ingat bahwa tidak ada metode transmisi melalui internet atau penyimpanan elektronik yang 100% aman dan andal, dan Kami tidak dapat menjamin keamanan mutlaknya.
</p> <p><strong>Tautan ke Situs Lain</strong></p> <p>
  Layanan ini mungkin berisi tautan ke situs lain. Jika Anda mengklik tautan pihak ketiga, Anda akan diarahkan ke situs tersebut. Perhatikan bahwa situs eksternal tersebut tidak dioperasikan oleh kami. Oleh karena itu, Kami sangat menyarankan Anda meninjau Kebijakan Privasi situs-situs tersebut. Kami tidak memiliki kendali dan tidak bertanggung jawab atas konten, kebijakan privasi, atau praktik situs atau layanan pihak ketiga mana pun.
</p> <p><strong>Privasi Anak</strong></p> <div><p>
    Layanan ini tidak ditujukan kepada siapa pun di bawah usia 13 tahun. Kami tidak dengan sengaja mengumpulkan informasi yang dapat mengidentifikasi pribadi dari anak di bawah 13 tahun. Jika Kami menemukan bahwa seorang anak di bawah 13 tahun telah memberikan informasi pribadi kepada kami, Kami segera menghapusnya dari server kami. Jika Anda adalah orang tua atau wali dan mengetahui bahwa anak Anda telah memberikan informasi pribadi kepada kami, silakan hubungi saya agar Kami dapat melakukan tindakan yang diperlukan.
  </p></div> <p><strong>Perubahan pada Kebijakan Privasi Ini</strong></p> <p>
    Kami dapat memperbarui Kebijakan Privasi kami dari waktu ke waktu. Oleh karena itu, Anda disarankan untuk meninjau halaman ini secara berkala untuk setiap perubahan. Kami akan memberi tahu Anda tentang perubahan apa pun dengan memposting Kebijakan Privasi baru di halaman ini.
</p>
<p>Kebijakan ini berlaku mulai 2024-06-01</p>
<p><strong>Hubungi Kami</strong></p>
<p> Jika Anda memiliki pertanyaan atau saran tentang Kebijakan Privasi kami, jangan ragu untuk menghubungi saya di</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Halaman kebijakan privasi ini dibuat di <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>dan dimodifikasi/dihasilkan oleh <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Diterjemahkan oleh Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.italiano => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Informativa sulla privacy Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports ha creato l'app come app (gratuita / supportata da annunci / acquisti in-app). Questo SERVIZIO è fornito da Falun Dafa Practice Supports ed è destinato all'uso così com'è.
</p> <p>
  Questa pagina informa i visitatori sulle nostre politiche relative alla raccolta, all'uso e alla divulgazione delle Informazioni personali se qualcuno decide di usare il nostro Servizio.
</p> <p>
  Se scegliete di usare il nostro Servizio, accettate la raccolta e l'uso delle informazioni in relazione a questa informativa.
  </p>
 <p><strong>Raccolta e uso delle informazioni</strong></p> <p>
    Non raccogliamo dati personali (nome completo, indirizzo, contatti, e-mail, numero di telefono, immagine, ... né altri documenti personali)
  <p>
  Le informazioni che richiediamo restano sul vostro dispositivo e non sono raccolte da noi in alcun modo.</p>
  <p>Le applicazioni possono raccogliere dati di utilizzo come: ora di accesso, stato di utilizzo ...</p>
</p> <div><p>
    L'app utilizza servizi di terze parti che possono raccogliere informazioni usate per identificarvi.
  </p> <p>
    Link all'informativa sulla privacy dei fornitori di servizi terzi usati dall'app
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Dati di registro</strong></p> <p>
  Vi informiamo che ogni volta che usate il nostro Servizio, in caso di errore nell'app raccogliamo dati e informazioni (tramite prodotti di terzi) sul vostro telefono, detti Dati di registro. Possono includere l'indirizzo IP del dispositivo, nome del dispositivo, versione del sistema operativo, configurazione dell'app durante l'uso del Servizio, data e ora di utilizzo e altre statistiche.
</p>

<p><strong>Fornitori di servizi</strong></p> <p>
  Possiamo impiegare aziende e individui terzi per i seguenti motivi:
</p> <ul><li>Per facilitare il nostro Servizio;</li> <li>Per fornire il Servizio per nostro conto;</li> <li>Per eseguire servizi correlati al Servizio; oppure</li> <li>Per aiutarci ad analizzare come viene usato il nostro Servizio.</li></ul> <p>
  Informiamo gli utenti di questo Servizio che queste terze parti hanno accesso alle loro Informazioni personali. Il motivo è svolgere i compiti assegnati per nostro conto. Tuttavia, sono obbligate a non divulgare né usare le informazioni per altri scopi.
</p> <p><strong>Sicurezza</strong></p> <p>
  Apprezziamo la vostra fiducia nel fornirci le Informazioni personali e ci sforziamo di usare mezzi commercialmente accettabili per proteggerle. Ricordate però che nessun metodo di trasmissione su Internet o di archiviazione elettronica è sicuro e affidabile al 100%, e non possiamo garantirne la sicurezza assoluta.
</p> <p><strong>Collegamenti ad altri siti</strong></p> <p>
  Questo Servizio può contenere collegamenti ad altri siti. Se cliccate su un collegamento di terzi, sarete indirizzati a quel sito. Notate che questi siti esterni non sono gestiti da noi. Vi consigliamo vivamente di consultare l'Informativa sulla privacy di tali siti. Non abbiamo alcun controllo e non ci assumiamo responsabilità per contenuti, informative sulla privacy o pratiche di siti o servizi di terzi.
</p> <p><strong>Privacy dei minori</strong></p> <div><p>
    Questi Servizi non si rivolgono a chiunque abbia meno di 13 anni. Non raccogliamo consapevolmente informazioni personali identificabili da minori di 13 anni. Se scopriamo che un minore di 13 anni ci ha fornito informazioni personali, le eliminiamo immediatamente dai nostri server. Se siete genitori o tutori e sapete che vostro figlio ci ha fornito informazioni personali, contattatemi affinché possiamo adottare le misure necessarie.
  </p></div> <p><strong>Modifiche a questa Informativa sulla privacy</strong></p> <p>
    Possiamo aggiornare la nostra Informativa sulla privacy di tanto in tanto. Vi consigliamo quindi di rivedere periodicamente questa pagina per eventuali modifiche. Vi informeremo di eventuali modifiche pubblicando la nuova Informativa sulla privacy su questa pagina.
</p>
<p>Questa informativa è efficace dal 2024-06-01</p>
<p><strong>Contattaci</strong></p>
<p> Se avete domande o suggerimenti sulla nostra Informativa sulla privacy, non esitate a contattarmi a</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Questa pagina dell'informativa sulla privacy è stata creata su <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>e modificata/generata da <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Tradotto da Google Traduttore</em></p>
</body>
</html>''',
    NewAreaLang.japan => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>プライバシーポリシー Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports は、本アプリを（無料／広告付き／アプリ内課金）アプリとして作成しました。本サービスは Falun Dafa Practice Supports により提供され、現状のまま利用されることを意図しています。
</p> <p>
  本ページは、当社のサービスを利用する場合の個人情報の収集・利用・開示に関する方針を訪問者にお知らせするためのものです。
</p> <p>
  本サービスを利用する場合、本ポリシーに関連する情報の収集および利用に同意したものとみなされます。
  </p>
 <p><strong>情報の収集と利用</strong></p> <p>
    当社は個人データ（氏名、住所、連絡先、メール、電話番号、画像、その他の個人書類など）を収集しません。
  <p>
  当社が求める情報はお客様の端末に保持され、当社が収集することはありません。</p>
  <p>アプリはログイン時刻、利用状況などの利用データを収集することがあります。</p>
</p> <div><p>
    本アプリは、お客様を識別するために情報を収集する可能性のある第三者サービスを使用します。
  </p> <p>
    本アプリが使用する第三者サービス提供者のプライバシーポリシーへのリンク
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>ログデータ</strong></p> <p>
  本サービスの利用時にアプリでエラーが発生した場合、当社は第三者製品を通じてお客様の端末上でログデータと呼ばれるデータと情報を収集します。ログデータには、端末のIPアドレス、端末名、OSバージョン、サービス利用時のアプリ設定、利用日時、その他の統計などが含まれる場合があります。
</p>

<p><strong>サービス提供者</strong></p> <p>
  当社は次の理由により第三者の企業・個人を雇用する場合があります：
</p> <ul><li>本サービスの円滑化のため；</li> <li>当社に代わってサービスを提供するため；</li> <li>サービス関連業務を行うため；または</li> <li>本サービスの利用状況分析を支援するため。</li></ul> <p>
  これらの第三者は個人情報にアクセスできます。理由は当社に代わって割り当てられた業務を遂行するためです。ただし、他の目的で情報を開示・利用しない義務があります。
</p> <p><strong>セキュリティ</strong></p> <p>
  個人情報を提供してくださる信頼を大切にし、商業上妥当な保護手段の使用に努めています。しかし、インターネット上の伝送や電子保存の方法が100％安全・確実であるとは限らず、絶対的な安全を保証することはできません。
</p> <p><strong>他サイトへのリンク</strong></p> <p>
  本サービスには他サイトへのリンクが含まれる場合があります。第三者リンクをクリックするとそのサイトへ移動します。これらの外部サイトは当社が運営するものではありません。そのため、各サイトのプライバシーポリシーを確認することを強く推奨します。第三者サイトやサービスの内容・プライバシー方針・慣行について、当社は管理せず責任を負いません。
</p> <p><strong>子どものプライバシー</strong></p> <div><p>
    本サービスは13歳未満の方を対象としていません。13歳未満の子どもから故意に個人を特定できる情報を収集しません。13歳未満の子どもが個人情報を提供したと判明した場合、直ちにサーバーから削除します。保護者の方で、お子様が個人情報を提供したとご存知の場合はご連絡ください。必要な対応を行います。
  </p></div> <p><strong>本プライバシーポリシーの変更</strong></p> <p>
    当社は随時プライバシーポリシーを更新することがあります。変更がないか定期的に本ページをご確認ください。新しいプライバシーポリシーを本ページに掲載することで変更をお知らせします。
</p>
<p>本ポリシーは 2024-06-01 から有効です</p>
<p><strong>お問い合わせ</strong></p>
<p> プライバシーポリシーについてご質問・ご提案がある場合は、遠慮なく次までご連絡ください</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>本プライバシーポリシーページの作成元： <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>／改変・生成： <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Google 翻訳による翻訳</em></p>
</body>
</html>''',
    NewAreaLang.korean => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>개인정보 처리방침 Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports는 본 앱을 (무료 / 광고 지원 / 인앱 구매) 앱으로 만들었습니다. 본 서비스는 Falun Dafa Practice Supports가 제공하며 있는 그대로 사용하도록 되어 있습니다.
</p> <p>
  이 페이지는 서비스 이용 시 개인정보의 수집·이용·공개에 관한 정책을 방문자에게 알리기 위한 것입니다.
</p> <p>
  서비스를 이용하기로 선택하면 본 정책과 관련된 정보 수집 및 이용에 동의한 것으로 간주됩니다.
  </p>
 <p><strong>정보 수집 및 이용</strong></p> <p>
    저희는 개인 데이터(성명, 주소, 연락처, 이메일, 전화번호, 이미지 및 기타 개인 서류)를 수집하지 않습니다.
  <p>
  요청하는 정보는 기기에 보관되며 저희가 어떤 방식으로도 수집하지 않습니다.</p>
  <p>앱은 로그인 시간, 사용 상태 등의 사용 데이터를 수집할 수 있습니다.</p>
</p> <div><p>
    앱은 사용자를 식별하는 데 쓰일 수 있는 정보를 수집할 수 있는 제3자 서비스를 사용합니다.
  </p> <p>
    앱이 사용하는 제3자 서비스 제공자의 개인정보 처리방침 링크
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>로그 데이터</strong></p> <p>
  서비스 이용 중 앱에 오류가 발생한 경우, 제3자 제품을 통해 휴대전화에서 로그 데이터라는 데이터와 정보를 수집합니다. 로그 데이터에는 기기 IP 주소, 기기 이름, OS 버전, 서비스 이용 시 앱 구성, 이용 일시 및 기타 통계가 포함될 수 있습니다.
</p>

<p><strong>서비스 제공자</strong></p> <p>
  다음과 같은 이유로 제3자 회사 및 개인을 고용할 수 있습니다:
</p> <ul><li>서비스 원활화를 위해;</li> <li>저희를 대신해 서비스를 제공하기 위해;</li> <li>서비스 관련 업무를 수행하기 위해; 또는</li> <li>서비스 이용 방식 분석을 돕기 위해.</li></ul> <p>
  이러한 제3자는 개인정보에 접근할 수 있습니다. 이유는 저희를 대신해 할당된 업무를 수행하기 위해서입니다. 그러나 다른 목적으로 정보를 공개하거나 사용하지 않을 의무가 있습니다.
</p> <p><strong>보안</strong></p> <p>
  개인정보를 제공해 주시는 신뢰를 소중히 여기며, 상업적으로 허용되는 보호 수단을 사용하기 위해 노력합니다. 다만 인터넷 전송이나 전자 저장 방식이 100% 안전하고 신뢰할 수 있는 것은 아니며, 절대적 보안을 보장할 수 없습니다.
</p> <p><strong>다른 사이트로의 링크</strong></p> <p>
  본 서비스에는 다른 사이트로의 링크가 포함될 수 있습니다. 제3자 링크를 클릭하면 해당 사이트로 이동합니다. 이러한 외부 사이트는 저희가 운영하지 않습니다. 따라서 해당 웹사이트의 개인정보 처리방침을 검토할 것을 강력히 권고합니다. 제3자 사이트나 서비스의 내용, 개인정보 정책 또는 관행에 대해 저희가 통제하지 않으며 책임을 지지 않습니다.
</p> <p><strong>아동의 개인정보</strong></p> <div><p>
    본 서비스는 13세 미만을 대상으로 하지 않습니다. 13세 미만 아동으로부터 고의로 개인 식별 정보를 수집하지 않습니다. 13세 미만 아동이 개인정보를 제공한 것을 발견하면 즉시 서버에서 삭제합니다. 부모 또는 보호자로서 자녀가 개인정보를 제공한 것을 아시면 연락해 주세요. 필요한 조치를 취하겠습니다.
  </p></div> <p><strong>본 개인정보 처리방침의 변경</strong></p> <p>
    개인정보 처리방침을 수시로 업데이트할 수 있습니다. 따라서 변경 사항을 위해 이 페이지를 주기적으로 검토하시기 바랍니다. 새 개인정보 처리방침을 이 페이지에 게시하여 변경 사항을 알려 드립니다.
</p>
<p>본 정책은 2024-06-01부터 유효합니다</p>
<p><strong>문의</strong></p>
<p> 개인정보 처리방침에 대한 질문이나 제안이 있으시면 다음으로 연락해 주세요</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>이 개인정보 처리방침 페이지는 다음에 생성되었습니다: <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>그리고 다음에 의해 수정/생성됨: <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Google 번역으로 번역됨</em></p>
</body>
</html>''',
    NewAreaLang.polski => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Polityka prywatności Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports stworzyło aplikację jako aplikację (bezpłatną / z reklamami / z zakupami w aplikacji). Ta USŁUGA jest świadczona przez Falun Dafa Practice Supports i jest przeznaczona do użytku w stanie, w jakim jest.
</p> <p>
  Ta strona informuje odwiedzających o naszych zasadach dotyczących zbierania, używania i ujawniania Danych osobowych, jeśli ktoś zdecyduje się korzystać z naszej Usługi.
</p> <p>
  Jeśli zdecydujesz się korzystać z naszej Usługi, zgadzasz się na zbieranie i używanie informacji zgodnie z tą polityką.
  </p>
 <p><strong>Zbieranie i używanie informacji</strong></p> <p>
    Nie zbieramy danych osobowych (pełne imię i nazwisko, adres, dane kontaktowe, e-mail, numer telefonu, obraz ani innych dokumentów osobistych)
  <p>
  Informacje, o które prosimy, są przechowywane na Twoim urządzeniu i nie są przez nas zbierane w żaden sposób.</p>
  <p>Aplikacje mogą zbierać dane o użyciu, takie jak: czas logowania, status użycia ...</p>
</p> <div><p>
    Aplikacja korzysta z usług stron trzecich, które mogą zbierać informacje służące do identyfikacji.
  </p> <p>
    Link do polityki prywatności dostawców usług stron trzecich używanych przez aplikację
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Dane dziennika</strong></p> <p>
  Chcemy poinformować, że za każdym razem, gdy korzystasz z naszej Usługi, w przypadku błędu w aplikacji zbieramy dane i informacje (poprzez produkty stron trzecich) na Twoim telefonie, zwane Danymi dziennika. Mogą one obejmować adres IP urządzenia, nazwę urządzenia, wersję systemu operacyjnego, konfigurację aplikacji podczas korzystania z Usługi, datę i godzinę użycia oraz inne statystyki.
</p>

<p><strong>Dostawcy usług</strong></p> <p>
  Możemy zatrudniać firmy i osoby trzecie z następujących powodów:
</p> <ul><li>Aby ułatwić naszą Usługę;</li> <li>Aby świadczyć Usługę w naszym imieniu;</li> <li>Aby wykonywać usługi związane z Usługą; lub</li> <li>Aby pomóc nam analizować, jak nasza Usługa jest używana.</li></ul> <p>
  Chcemy poinformować użytkowników tej Usługi, że te strony trzecie mają dostęp do ich Danych osobowych. Powodem jest wykonywanie zadań powierzonych w naszym imieniu. Są jednak zobowiązane nie ujawniać ani nie używać informacji do innych celów.
</p> <p><strong>Bezpieczeństwo</strong></p> <p>
  Cenimy Twoje zaufanie przy przekazywaniu nam Danych osobowych i staramy się używać komercyjnie akceptowalnych środków ochrony. Pamiętaj jednak, że żadna metoda transmisji przez internet ani przechowywania elektronicznego nie jest w 100% bezpieczna i niezawodna, i nie możemy zagwarantować absolutnego bezpieczeństwa.
</p> <p><strong>Linki do innych stron</strong></p> <p>
  Ta Usługa może zawierać linki do innych stron. Jeśli klikniesz link strony trzeciej, zostaniesz przekierowany na tę stronę. Zwróć uwagę, że te zewnętrzne strony nie są przez nas obsługiwane. Dlatego zdecydowanie zalecamy zapoznanie się z Polityką prywatności tych witryn. Nie mamy kontroli i nie ponosimy odpowiedzialności za treść, polityki prywatności ani praktyki żadnych stron lub usług stron trzecich.
</p> <p><strong>Prywatność dzieci</strong></p> <div><p>
    Te Usługi nie są skierowane do osób poniżej 13. roku życia. Świadomie nie zbieramy danych osobowych od dzieci poniżej 13. roku życia. Jeśli odkryjemy, że dziecko poniżej 13 lat przekazało nam dane osobowe, natychmiast usuniemy je z naszych serwerów. Jeśli jesteś rodzicem lub opiekunem i wiesz, że Twoje dziecko przekazało nam dane osobowe, skontaktuj się ze mną, abyśmy mogli podjąć niezbędne działania.
  </p></div> <p><strong>Zmiany w tej Polityce prywatności</strong></p> <p>
    Możemy od czasu do czasu aktualizować naszą Politykę prywatności. Dlatego zaleca się okresowe przeglądanie tej strony pod kątem zmian. Powiadomimy Cię o wszelkich zmianach, publikując nową Politykę prywatności na tej stronie.
</p>
<p>Ta polityka obowiązuje od 2024-06-01</p>
<p><strong>Kontakt</strong></p>
<p> Jeśli masz pytania lub sugestie dotyczące naszej Polityki prywatności, nie wahaj się skontaktować ze mną pod adresem</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Ta strona polityki prywatności została utworzona na <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>i zmodyfikowana/wygenerowana przez <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Przetłumaczone przez Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.portugues => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Política de privacidade Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports criou o aplicativo como um app (gratuito / com anúncios / compras no aplicativo). Este SERVIÇO é fornecido por Falun Dafa Practice Supports e destina-se ao uso como está.
</p> <p>
  Esta página informa os visitantes sobre nossas políticas quanto à coleta, uso e divulgação de Informações pessoais se alguém decidir usar nosso Serviço.
</p> <p>
  Se você escolher usar nosso Serviço, concorda com a coleta e o uso de informações em relação a esta política.
  </p>
 <p><strong>Coleta e uso de informações</strong></p> <p>
    Não coletamos dados pessoais (nome completo, endereço, contato, e-mail, telefone, imagem, ... nem quaisquer outros documentos pessoais)
  <p>
  As informações que solicitamos ficam no seu dispositivo e não são coletadas por nós de forma alguma.</p>
  <p>Os aplicativos podem coletar dados de uso como: horário de login, status de uso ...</p>
</p> <div><p>
    O aplicativo usa serviços de terceiros que podem coletar informações usadas para identificá-lo.
  </p> <p>
    Link para a política de privacidade dos provedores de serviços terceiros usados pelo aplicativo
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Dados de registro</strong></p> <p>
  Queremos informar que sempre que você usa nosso Serviço, em caso de erro no aplicativo, coletamos dados e informações (por meio de produtos de terceiros) no seu telefone, chamados Dados de registro. Podem incluir o endereço IP do dispositivo, nome do dispositivo, versão do sistema operacional, configuração do aplicativo ao usar nosso Serviço, data e hora de uso, e outras estatísticas.
</p>

<p><strong>Provedores de serviços</strong></p> <p>
  Podemos empregar empresas e indivíduos terceiros pelos seguintes motivos:
</p> <ul><li>Para facilitar nosso Serviço;</li> <li>Para fornecer o Serviço em nosso nome;</li> <li>Para realizar serviços relacionados ao Serviço; ou</li> <li>Para nos ajudar a analisar como nosso Serviço é usado.</li></ul> <p>
  Queremos informar os usuários deste Serviço de que esses terceiros têm acesso às suas Informações pessoais. O motivo é executar as tarefas atribuídas em nosso nome. No entanto, eles são obrigados a não divulgar nem usar as informações para qualquer outro fim.
</p> <p><strong>Segurança</strong></p> <p>
  Valorizamos sua confiança ao nos fornecer Informações pessoais e nos esforçamos para usar meios comercialmente aceitáveis de proteção. Mas lembre-se de que nenhum método de transmissão pela internet ou de armazenamento eletrônico é 100% seguro e confiável, e não podemos garantir segurança absoluta.
</p> <p><strong>Links para outros sites</strong></p> <p>
  Este Serviço pode conter links para outros sites. Se você clicar em um link de terceiros, será direcionado a esse site. Observe que esses sites externos não são operados por nós. Portanto, aconselhamos fortemente que revise a Política de privacidade desses sites. Não temos controle e não assumimos responsabilidade pelo conteúdo, políticas de privacidade ou práticas de quaisquer sites ou serviços de terceiros.
</p> <p><strong>Privacidade de crianças</strong></p> <div><p>
    Estes Serviços não se destinam a ninguém com menos de 13 anos. Não coletamos intencionalmente informações pessoalmente identificáveis de crianças com menos de 13 anos. Se descobrirmos que uma criança com menos de 13 nos forneceu informações pessoais, as excluiremos imediatamente de nossos servidores. Se você é pai, mãe ou responsável e sabe que seu filho nos forneceu informações pessoais, entre em contato comigo para que possamos tomar as medidas necessárias.
  </p></div> <p><strong>Alterações a esta Política de privacidade</strong></p> <p>
    Podemos atualizar nossa Política de privacidade de tempos em tempos. Assim, aconselha-se revisar esta página periodicamente para quaisquer alterações. Notificaremos você de quaisquer alterações publicando a nova Política de privacidade nesta página.
</p>
<p>Esta política entra em vigor a partir de 2024-06-01</p>
<p><strong>Contate-nos</strong></p>
<p> Se você tiver dúvidas ou sugestões sobre nossa Política de privacidade, não hesite em me contatar em</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Esta página de política de privacidade foi criada em <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>e modificada/gerada por <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Traduzido pelo Google Tradutor</em></p>
</body>
</html>''',
    NewAreaLang.russian => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Политика конфиденциальности Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports создало приложение как (бесплатное / с рекламой / с покупками в приложении). Эта УСЛУГА предоставляется Falun Dafa Practice Supports и предназначена для использования «как есть».
</p> <p>
  Эта страница информирует посетителей о наших правилах сбора, использования и раскрытия Персональной информации, если кто-либо решит использовать наш Сервис.
</p> <p>
  Выбирая наш Сервис, вы соглашаетесь на сбор и использование информации в соответствии с этой политикой.
  </p>
 <p><strong>Сбор и использование информации</strong></p> <p>
    Мы не собираем персональные данные (полное имя, адрес, контакты, электронная почта, телефон, изображение и любые другие личные документы)
  <p>
  Запрашиваемая нами информация хранится на вашем устройстве и никак нами не собирается.</p>
  <p>Приложения могут собирать данные об использовании, например: время входа, статус использования ...</p>
</p> <div><p>
    Приложение использует сторонние сервисы, которые могут собирать информацию для вашей идентификации.
  </p> <p>
    Ссылки на политику конфиденциальности сторонних поставщиков, используемых приложением
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Данные журнала</strong></p> <p>
  Мы хотим сообщить, что при использовании нашего Сервиса в случае ошибки в приложении Мы собираем данные и информацию (через сторонние продукты) на вашем телефоне, называемые Данными журнала. Они могут включать IP-адрес устройства, имя устройства, версию ОС, конфигурацию приложения при использовании Сервиса, дату и время использования и другую статистику.
</p>

<p><strong>Поставщики услуг</strong></p> <p>
  Мы можем привлекать сторонние компании и лиц по следующим причинам:
</p> <ul><li>Чтобы облегчить наш Сервис;</li> <li>Чтобы предоставлять Сервис от нашего имени;</li> <li>Чтобы выполнять услуги, связанные с Сервисом; или</li> <li>Чтобы помочь нам анализировать, как используется наш Сервис.</li></ul> <p>
  Мы хотим сообщить пользователям этого Сервиса, что у этих третьих лиц есть доступ к их Персональной информации. Причина — выполнение порученных им задач от нашего имени. Однако они обязаны не раскрывать и не использовать информацию для иных целей.
</p> <p><strong>Безопасность</strong></p> <p>
  Мы ценим ваше доверие при предоставлении Персональной информации и стремимся использовать коммерчески приемлемые средства её защиты. Но помните: ни один способ передачи через интернет и электронного хранения не является на 100% безопасным и надёжным, и Мы не можем гарантировать абсолютную безопасность.
</p> <p><strong>Ссылки на другие сайты</strong></p> <p>
  Этот Сервис может содержать ссылки на другие сайты. При нажатии на стороннюю ссылку вы будете направлены на этот сайт. Обратите внимание: этими внешними сайтами Мы не управляем. Поэтому Мы настоятельно советуем ознакомиться с Политикой конфиденциальности этих сайтов. Мы не контролируем и не несём ответственности за содержание, политики конфиденциальности или практики любых сторонних сайтов или сервисов.
</p> <p><strong>Конфиденциальность детей</strong></p> <div><p>
    Эти Сервисы не предназначены для лиц младше 13 лет. Мы сознательно не собираем персональные данные детей младше 13 лет. Если Мы обнаружим, что ребёнок младше 13 предоставил нам персональную информацию, Мы немедленно удалим её с наших серверов. Если вы родитель или опекун и знаете, что ваш ребёнок предоставил нам персональную информацию, свяжитесь со мной, чтобы Мы могли принять необходимые меры.
  </p></div> <p><strong>Изменения этой Политики конфиденциальности</strong></p> <p>
    Мы можем время от времени обновлять нашу Политику конфиденциальности. Поэтому рекомендуется периодически просматривать эту страницу на предмет изменений. Мы уведомим вас об изменениях, разместив новую Политику конфиденциальности на этой странице.
</p>
<p>Эта политика действует с 2024-06-01</p>
<p><strong>Связаться с нами</strong></p>
<p> Если у вас есть вопросы или предложения по нашей Политике конфиденциальности, не стесняйтесь связаться со мной по адресу</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Эта страница политики конфиденциальности создана на <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>и изменена/сгенерирована <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Переведено Google Переводчиком</em></p>
</body>
</html>''',
    NewAreaLang.slovencina => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Zásady ochrany súkromia Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports vytvorilo aplikáciu ako (bezplatnú / s reklamami / nákupy v aplikácii) aplikáciu. Táto SLUŽBA je poskytovaná Falun Dafa Practice Supports a je určená na použitie tak, ako je.
</p> <p>
  Táto stránka informuje návštevníkov o našich zásadách týkajúcich sa zhromažďovania, používania a zverejňovania Osobných informácií, ak sa niekto rozhodne používať našu Službu.
</p> <p>
  Ak sa rozhodnete používať našu Službu, súhlasíte so zhromažďovaním a používaním informácií v súlade s týmito zásadami.
  </p>
 <p><strong>Zhromažďovanie a používanie informácií</strong></p> <p>
    Nezhromažďujeme osobné údaje (celé meno, adresa, kontakt, e-mail, telefónne číslo, obrázok ani iné osobné dokumenty)
  <p>
  Informácie, ktoré požadujeme, zostávajú vo vašom zariadení a my ich nijako nezhromažďujeme.</p>
  <p>Aplikácie môžu zbierať údaje o používaní, napríklad: čas prihlásenia, stav používania ...</p>
</p> <div><p>
    Aplikácia používa služby tretích strán, ktoré môžu zbierať informácie na vašu identifikáciu.
  </p> <p>
    Odkaz na zásady ochrany súkromia poskytovateľov služieb tretích strán používaných aplikáciou
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Údaje denníka</strong></p> <p>
  Chceme vás informovať, že vždy, keď používate našu Službu, v prípade chyby v aplikácii zbierame údaje a informácie (prostredníctvom produktov tretích strán) na vašom telefóne nazývané Údaje denníka. Môžu zahŕňať IP adresu zariadenia, názov zariadenia, verziu OS, konfiguráciu aplikácie pri používaní Služby, dátum a čas používania a ďalšie štatistiky.
</p>

<p><strong>Poskytovatelia služieb</strong></p> <p>
  Môžeme zamestnávať tretie spoločnosti a jednotlivcov z týchto dôvodov:
</p> <ul><li>Aby sme uľahčili našu Službu;</li> <li>Aby sme poskytovali Službu v našom mene;</li> <li>Aby sme vykonávali služby súvisiace so Službou; alebo</li> <li>Aby sme nám pomohli analyzovať, ako sa naša Služba používa.</li></ul> <p>
  Chceme informovať používateľov tejto Služby, že tieto tretie strany majú prístup k ich Osobným informáciám. Dôvodom je plnenie úloh pridelených v našom mene. Sú však povinné informácie nezverejňovať ani nepoužívať na iné účely.
</p> <p><strong>Bezpečnosť</strong></p> <p>
  Ceníme si vašu dôveru pri poskytovaní Osobných informácií a snažíme sa používať komerčne prijateľné prostriedky ochrany. Pamätajte však, že žiadna metóda prenosu cez internet ani elektronického ukladania nie je 100% bezpečná a spoľahlivá a nemôžeme zaručiť absolútnu bezpečnosť.
</p> <p><strong>Odkazy na iné stránky</strong></p> <p>
  Táto Služba môže obsahovať odkazy na iné stránky. Ak kliknete na odkaz tretej strany, budete presmerovaní na danú stránku. Upozorňujeme, že tieto externé stránky neprevádzkujeme my. Preto dôrazne odporúčame skontrolovať Zásady ochrany súkromia týchto webov. Nemáme kontrolu a nepreberáme zodpovednosť za obsah, zásady ochrany súkromia ani praktiky žiadnych stránok alebo služieb tretích strán.
</p> <p><strong>Ochrana súkromia detí</strong></p> <div><p>
    Tieto Služby nie sú určené nikomu mladšiemu ako 13 rokov. Vedome nezbierame osobné údaje od detí mladších ako 13 rokov. Ak zistíme, že dieťa mladšie ako 13 poskytlo osobné informácie, okamžite ich odstránime z našich serverov. Ak ste rodič alebo opatrovník a viete, že vaše dieťa nám poskytlo osobné informácie, kontaktujte ma, aby sme mohli vykonať potrebné kroky.
  </p></div> <p><strong>Zmeny týchto Zásad ochrany súkromia</strong></p> <p>
    Môžeme našej Zásady ochrany súkromia čas od času aktualizovať. Preto vám odporúčame pravidelne kontrolovať túto stránku kvôli zmenám. O zmenách vás budeme informovať zverejnením nových Zásad ochrany súkromia na tejto stránke.
</p>
<p>Tieto zásady sú účinné od 2024-06-01</p>
<p><strong>Kontaktujte nás</strong></p>
<p> Ak máte otázky alebo návrhy k našim Zásadám ochrany súkromia, neváhajte ma kontaktovať na</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Táto stránka zásad ochrany súkromia bola vytvorená na <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>a upravená/vygenerovaná <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Preložené službou Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.srpski => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Политика приватности Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports је направио апликацију као (бесплатну / са огласима / куповине у апликацији) апликацију. Ова УСЛУГА се пружа од стране Falun Dafa Practice Supports и намењена је коришћењу каква јесте.
</p> <p>
  Ова страница служи да обавести посетиоце о нашим политикама прикупљања, коришћења и откривања Личних информација ако неко одлучи да користи нашу Услугу.
</p> <p>
  Ако изаберете да користите нашу Услугу, слажете се са прикупљањем и коришћењем информација у складу са овом политиком.
  </p>
 <p><strong>Прикупљање и коришћење информација</strong></p> <p>
    Не прикупљамо личне податке (пуно име, адреса, контакт, имејл, број телефона, слика, ... нити друге личне документе)
  <p>
  Информације које тражимо остају на вашем уређају и ми их не прикупљамо ни на који начин.</p>
  <p>Апликације могу прикупљати податке о коришћењу као што су: време пријаве, статус коришћења ...</p>
</p> <div><p>
    Апликација користи услуге трећих страна које могу прикупљати информације за вашу идентификацију.
  </p> <p>
    Линк на политику приватности пружалаца услуга трећих страна које апликација користи
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Подаци дневника</strong></p> <p>
  Желимо да вас обавестимо да кад год користите нашу Услугу, у случају грешке у апликацији прикупљамо податке и информације (путем производа трећих страна) на вашем телефону зване Подаци дневника. Они могу укључивати IP адресу уређаја, име уређаја, верзију ОС-а, конфигурацију апликације при коришћењу Услуге, време и датум коришћења и друге статистике.
</p>

<p><strong>Пружаоци услуга</strong></p> <p>
  Можемо ангажовати треће компаније и појединце из следећих разлога:
</p> <ul><li>Да олакшамо нашу Услугу;</li> <li>Да пружимо Услугу у наше име;</li> <li>Да обавимо услуге повезане са Услугом; или</li> <li>Да нам помогну да анализирамо како се наша Услуга користи.</li></ul> <p>
  Желимо да обавестимо кориснике ове Услуге да те треће стране имају приступ њиховим Личним информацијама. Разлог је обављање задатака додељених у наше име. Међутим, обавезне су да не откривају нити користе информације у друге сврхе.
</p> <p><strong>Безбедност</strong></p> <p>
  Ценимо ваше поверење при пружању Личних информација и настојимо да користимо комерцијално прихватљива средства заштите. Али запамтите да ниједан начин преноса преко интернета или електронског складиштења није 100% безбедан и поуздан, и не можемо гарантовати апсолутну безбедност.
</p> <p><strong>Линкови на друге странице</strong></p> <p>
  Ова Услуга може садржати линкове на друге странице. Ако кликнете на линк треће стране, бићете усмерени на ту страницу. Напомена: тим спољним страницама не управљамо ми. Стога вас снажно саветујемо да прегледате Политику приватности тих веб страница. Немамо контролу и не преузимамо одговорност за садржај, политике приватности или праксе било којих страница или услуга трећих страна.
</p> <p><strong>Приватност деце</strong></p> <div><p>
    Ове Услуге нису намењене никоме млађем од 13 година. Свесно не прикупљамо личне податке од деце млађе од 13 година. Ако откријемо да је дете млађе од 13 дало личне информације, одмах их бришемо са наших сервера. Ако сте родитељ или старатељ и знате да је ваше дете дало личне информације, контактирајте ме како бисмо могли предузети потребне мере.
  </p></div> <p><strong>Измене ове Политике приватности</strong></p> <p>
    Можемо с времена на време ажурирати нашу Политику приватности. Стога сте саветовани да повремено прегледате ову страницу због промена. Обавијестићемо вас о променама објављивањем нове Политике приватности на овој страници.
</p>
<p>Ова политика важи од 2024-06-01</p>
<p><strong>Контактирајте нас</strong></p>
<p> Ако имате питања или предлоге о нашој Политици приватности, не устручавајте се да ме контактирате на</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Ова страница политике приватности креирана је на <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>и измењена/генерисана од <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Превео Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.thai => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>นโยบายความเป็นส่วนตัว Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports สร้างแอปในรูปแบบแอป (ฟรี / มีโฆษณา / ซื้อในแอป) บริการนี้จัดให้โดย Falun Dafa Practice Supports และมีไว้ให้ใช้ตามสภาพ
</p> <p>
  หน้านี้ใช้แจ้งผู้เยี่ยมชมเกี่ยวกับนโยบายของเราในการเก็บรวบรวม ใช้ และเปิดเผยข้อมูลส่วนบุคคล หากมีผู้ตัดสินใจใช้บริการของเรา
</p> <p>
  หากคุณเลือกใช้บริการของเรา คุณตกลงให้มีการเก็บรวบรวมและใช้ข้อมูลตามนโยบายนี้
  </p>
 <p><strong>การเก็บรวบรวมและการใช้ข้อมูล</strong></p> <p>
    เราไม่เก็บข้อมูลส่วนบุคคล (ชื่อเต็ม ที่อยู่ ข้อมูลติดต่อ อีเมล หมายเลขโทรศัพท์ ภาพ และเอกสารส่วนบุคคลอื่นๆ)
  <p>
  ข้อมูลที่เราขอจะถูกเก็บไว้บนอุปกรณ์ของคุณ และเราไม่เก็บรวบรวมไม่ว่าด้วยวิธีใด</p>
  <p>แอปพลิเคชันอาจเก็บข้อมูลการใช้งาน เช่น เวลาเข้าสู่ระบบ สถานะการใช้งาน ...</p>
</p> <div><p>
    แอปใช้บริการของบุคคลที่สามซึ่งอาจเก็บข้อมูลที่ใช้ระบุตัวตนของคุณ
  </p> <p>
    ลิงก์ไปยังนโยบายความเป็นส่วนตัวของผู้ให้บริการบุคคลที่สามที่แอปใช้
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>ข้อมูลบันทึก</strong></p> <p>
  เราต้องการแจ้งว่าเมื่อใดก็ตามที่คุณใช้บริการของเรา ในกรณีที่เกิดข้อผิดพลาดในแอป เราจะเก็บข้อมูลและสารสนเทศ (ผ่านผลิตภัณฑ์ของบุคคลที่สาม) บนโทรศัพท์ของคุณที่เรียกว่าข้อมูลบันทึก ซึ่งอาจรวมถึงที่อยู่ IP ของอุปกรณ์ ชื่ออุปกรณ์ เวอร์ชันระบบปฏิบัติการ การตั้งค่าแอปเมื่อใช้บริการ วันและเวลาที่ใช้บริการ และสถิติอื่นๆ
</p>

<p><strong>ผู้ให้บริการ</strong></p> <p>
  เราอาจจ้างบริษัทและบุคคลภายนอกด้วยเหตุผลต่อไปนี้:
</p> <ul><li>เพื่ออำนวยความสะดวกแก่บริการของเรา;</li> <li>เพื่อให้บริการในนามของเรา;</li> <li>เพื่อดำเนินการบริการที่เกี่ยวข้องกับบริการ; หรือ</li> <li>เพื่อช่วยเราวิเคราะห์ว่าบริการถูกใช้อย่างไร</li></ul> <p>
  เราต้องการแจ้งผู้ใช้บริการนี้ว่าบุคคลที่สามเหล่านี้สามารถเข้าถึงข้อมูลส่วนบุคคลของตนได้ เหตุผลคือเพื่อปฏิบัติงานที่มอบหมายในนามของเรา อย่างไรก็ตาม พวกเขามีหน้าที่ไม่เปิดเผยหรือใช้ข้อมูลเพื่อวัตถุประสงค์อื่น
</p> <p><strong>ความปลอดภัย</strong></p> <p>
  เราให้ความสำคัญกับความไว้วางใจของคุณในการให้ข้อมูลส่วนบุคคล จึงพยายามใช้วิธีปกป้องที่ยอมรับได้ในเชิงพาณิชย์ แต่โปรดจำไว้ว่าไม่มีวิธีการส่งผ่านอินเทอร์เน็ตหรือการจัดเก็บทางอิเล็กทรอนิกส์ใดที่ปลอดภัยและเชื่อถือได้ 100% และเราไม่สามารถรับประกันความปลอดภัยอย่างสมบูรณ์
</p> <p><strong>ลิงก์ไปยังเว็บไซต์อื่น</strong></p> <p>
  บริการนี้อาจมีลิงก์ไปยังเว็บไซต์อื่น หากคุณคลิกลิงก์ของบุคคลที่สาม คุณจะถูกนำไปยังเว็บไซต์นั้น โปรดทราบว่าเว็บไซต์ภายนอกเหล่านี้ไม่ได้ดำเนินการโดยเรา ดังนั้นเราขอแนะนำอย่างยิ่งให้ตรวจสอบนโยบายความเป็นส่วนตัวของเว็บไซต์เหล่านั้น เราไม่ควบคุมและไม่รับผิดชอบต่อเนื้อหา นโยบายความเป็นส่วนตัว หรือแนวปฏิบัติของเว็บไซต์หรือบริการของบุคคลที่สามใดๆ
</p> <p><strong>ความเป็นส่วนตัวของเด็ก</strong></p> <div><p>
    บริการเหล่านี้ไม่ได้มุ่งไปที่ผู้ใดที่อายุต่ำกว่า 13 ปี เราไม่เก็บข้อมูลที่ระบุตัวตนได้จากเด็กอายุต่ำกว่า 13 ปีโดยเจตนา หากพบว่าเด็กอายุต่ำกว่า 13 ปีได้ให้ข้อมูลส่วนบุคคลแก่เรา เราจะลบออกจากเซิร์ฟเวอร์ทันที หากคุณเป็นผู้ปกครองและทราบว่าบุตรได้ให้ข้อมูลส่วนบุคคลแก่เรา กรุณาติดต่อฉันเพื่อให้เราดำเนินการที่จำเป็น
  </p></div> <p><strong>การเปลี่ยนแปลงนโยบายความเป็นส่วนตัวนี้</strong></p> <p>
    เราอาจอัปเดตนโยบายความเป็นส่วนตัวเป็นครั้งคราว ดังนั้นแนะนำให้ตรวจสอบหน้านี้เป็นระยะสำหรับความเปลี่ยนแปลงใดๆ เราจะแจ้งการเปลี่ยนแปลงโดยโพสต์นโยบายความเป็นส่วนตัวใหม่บนหน้านี้
</p>
<p>นโยบายนี้มีผลตั้งแต่วันที่ 2024-06-01</p>
<p><strong>ติดต่อเรา</strong></p>
<p> หากคุณมีคำถามหรือข้อเสนอแนะเกี่ยวกับนโยบายความเป็นส่วนตัวของเรา โปรดติดต่อฉันที่</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>หน้านี้สร้างที่ <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>และแก้ไข/สร้างโดย <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>แปลโดย Google Translate</em></p>
</body>
</html>''',
    NewAreaLang.turkce => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Gizlilik Politikası Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports uygulamayı (ücretsiz / reklam destekli / uygulama içi satın alma) uygulama olarak oluşturmuştur. Bu HİZMET Falun Dafa Practice Supports tarafından sağlanır ve olduğu gibi kullanılmak üzere tasarlanmıştır.
</p> <p>
  Bu sayfa, Hizmetimizi kullanmaya karar veren ziyaretçileri Kişisel Bilgilerin toplanması, kullanılması ve ifşa edilmesiyle ilgili politikalarımız hakkında bilgilendirmek için kullanılır.
</p> <p>
  Hizmetimizi kullanmayı seçerseniz, bu politikayla ilgili bilgilerin toplanmasını ve kullanılmasını kabul etmiş olursunuz.
  </p>
 <p><strong>Bilgi Toplama ve Kullanımı</strong></p> <p>
    Kişisel veri toplamıyoruz (tam ad, adres, iletişim bilgileri, e-posta, telefon numarası, görüntü ve diğer kişisel belgeler)
  <p>
  Talep ettiğimiz bilgiler cihazınızda tutulur ve hiçbir şekilde tarafımızca toplanmaz.</p>
  <p>Uygulamalar şu kullanım verilerini toplayabilir: Giriş zamanı, kullanım durumu ...</p>
</p> <div><p>
    Uygulama, sizi tanımlamak için kullanılan bilgileri toplayabilecek üçüncü taraf hizmetleri kullanır.
  </p> <p>
    Uygulama tarafından kullanılan üçüncü taraf hizmet sağlayıcılarının gizlilik politikasına bağlantı
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Günlük Verileri</strong></p> <p>
  Hizmetimizi her kullandığınızda, uygulamada bir hata olması durumunda telefonunuzda üçüncü taraf ürünler aracılığıyla Günlük Verileri adı verilen veri ve bilgileri topladığımızı bilmenizi isteriz. Bunlar cihaz IP adresi, cihaz adı, işletim sistemi sürümü, Hizmetimizi kullanırken uygulama yapılandırması, kullanım tarihi ve saati ve diğer istatistikleri içerebilir.
</p>

<p><strong>Hizmet Sağlayıcılar</strong></p> <p>
  Aşağıdaki nedenlerle üçüncü taraf şirketler ve kişiler istihdam edebiliriz:
</p> <ul><li>Hizmetimizi kolaylaştırmak için;</li> <li>Hizmeti bizim adımıza sağlamak için;</li> <li>Hizmetle ilgili hizmetleri gerçekleştirmek için; veya</li> <li>Hizmetimizin nasıl kullanıldığını analiz etmemize yardımcı olmak için.</li></ul> <p>
  Bu Hizmetin kullanıcılarına, bu üçüncü tarafların Kişisel Bilgilerine erişimi olduğunu bildirmek isteriz. Neden, bizim adımıza verilen görevleri yerine getirmektir. Ancak bilgileri başka bir amaçla ifşa etmeme veya kullanmama yükümlülükleri vardır.
</p> <p><strong>Güvenlik</strong></p> <p>
  Kişisel Bilgilerinizi sağlama konusundaki güveninize değer veriyoruz ve bunları korumak için ticari olarak kabul edilebilir yollar kullanmaya çalışıyoruz. Ancak internet üzerinden iletim veya elektronik depolama yöntemlerinin %100 güvenli ve güvenilir olmadığını ve mutlak güvenliği garanti edemeyeceğimizi unutmayın.
</p> <p><strong>Diğer Sitelerere Bağlantılar</strong></p> <p>
  Bu Hizmet diğer sitelere bağlantılar içerebilir. Üçüncü taraf bir bağlantıya tıklarsanız o siteye yönlendirilirsiniz. Bu harici sitelerin bizim tarafımızdan işletilmediğini unutmayın. Bu nedenle bu web sitelerinin Gizlilik Politikasını incelemenizi şiddetle tavsiye ederiz. Üçüncü taraf sitelerin veya hizmetlerin içeriği, gizlilik politikaları veya uygulamaları üzerinde kontrolümüz yoktur ve sorumluluk kabul etmeyiz.
</p> <p><strong>Çocukların Gizliliği</strong></p> <div><p>
    Bu Hizmetler 13 yaşın altındaki kimseyi hedef almaz. 13 yaşın altındaki çocuklardan bilerek kişisel olarak tanımlanabilir bilgi toplamayız. 13 yaşın altındaki bir çocuğun bize kişisel bilgi verdiğini tespit edersek, bunu sunucularımızdan derhal sileriz. Ebeveyn veya vasi iseniz ve çocuğunuzun bize kişisel bilgi verdiğini biliyorsanız, gerekli işlemleri yapabilmemiz için lütfen benimle iletişime geçin.
  </p></div> <p><strong>Bu Gizlilik Politikasındaki Değişiklikler</strong></p> <p>
    Gizlilik Politikamızı zaman zaman güncelleyebiliriz. Bu nedenle değişiklikler için bu sayfayı periyodik olarak incelemeniz önerilir. Yeni Gizlilik Politikasını bu sayfada yayınlayarak sizi bilgilendiririz.
</p>
<p>Bu politika 2024-06-01 tarihinden itibaren geçerlidir</p>
<p><strong>Bize Ulaşın</strong></p>
<p> Gizlilik Politikamız hakkında soru veya önerileriniz varsa, benimle şu adresten iletişime geçmekten çekinmeyin</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Bu gizlilik politikası sayfası şu adreste oluşturulmuştur <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>ve şu şekilde değiştirilmiş/üretilmiştir <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Google Çeviri tarafından çevrilmiştir</em></p>
</body>
</html>''',
    NewAreaLang.ukrainian => '''<!DOCTYPE html>
<html>
<head>
  <meta charset='utf-8'>
  <meta name='viewport' content='width=device-width'>
  <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } </style>
</head>
<body>
<strong>Політика конфіденційності Falun Dafa Practice Supports</strong> <p>
  Falun Dafa Practice Supports створило додаток як (безкоштовний / з рекламою / з покупками в додатку). Ця ПОСЛУГА надається Falun Dafa Practice Supports і призначена для використання «як є».
</p> <p>
  Ця сторінка інформує відвідувачів про наші правила збору, використання та розкриття Персональної інформації, якщо хтось вирішить користуватися нашим Сервісом.
</p> <p>
  Обираючи наш Сервіс, ви погоджуєтеся на збір і використання інформації відповідно до цієї політики.
  </p>
 <p><strong>Збір і використання інформації</strong></p> <p>
    Ми не збираємо персональні дані (повне ім’я, адреса, контакти, електронна пошта, телефон, зображення та будь-які інші особисті документи)
  <p>
  Запитувана нами інформація зберігається на вашому пристрої і жодним чином нами не збирається.</p>
  <p>Додатки можуть збирати дані про використання, наприклад: час входу, статус використання ...</p>
</p> <div><p>
    Додаток використовує сторонні сервіси, які можуть збирати інформацію для вашої ідентифікації.
  </p> <p>
    Посилання на політику конфіденційності сторонніх постачальників, що використовуються додатком
  </p> <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li></ul></div> <p><strong>Дані журналу</strong></p> <p>
  Ми хочемо повідомити, що під час використання нашого Сервісу у разі помилки в додатку Ми збираємо дані та інформацію (через сторонні продукти) на вашому телефоні, що називаються Даними журналу. Вони можуть включати IP-адресу пристрою, назву пристрою, версію ОС, конфігурацію додатка під час використання Сервісу, дату й час використання та іншу статистику.
</p>

<p><strong>Постачальники послуг</strong></p> <p>
  Ми можемо залучати сторонні компанії та осіб з таких причин:
</p> <ul><li>Щоб полегшити наш Сервіс;</li> <li>Щоб надавати Сервіс від нашого імені;</li> <li>Щоб виконувати послуги, пов’язані із Сервісом; або</li> <li>Щоб допомогти нам аналізувати, як використовується наш Сервіс.</li></ul> <p>
  Ми хочемо повідомити користувачів цього Сервісу, що ці треті сторони мають доступ до їхньої Персональної інформації. Причина — виконання доручених їм завдань від нашого імені. Однак вони зобов’язані не розкривати і не використовувати інформацію для інших цілей.
</p> <p><strong>Безпека</strong></p> <p>
  Ми цінуємо вашу довіру при наданні Персональної інформації і прагнемо використовувати комерційно прийнятні засоби її захисту. Але пам’ятайте: жоден спосіб передачі через інтернет і електронного зберігання не є на 100% безпечним і надійним, і Ми не можемо гарантувати абсолютну безпеку.
</p> <p><strong>Посилання на інші сайти</strong></p> <p>
  Цей Сервіс може містити посилання на інші сайти. Натиснувши стороннє посилання, ви будете спрямовані на цей сайт. Зверніть увагу: цими зовнішніми сайтами Ми не керуємо. Тому Ми настійно радимо ознайомитися з Політикою конфіденційності цих сайтів. Ми не контролюємо і не несемо відповідальності за зміст, політики конфіденційності чи практики будь-яких сторонніх сайтів або сервісів.
</p> <p><strong>Конфіденційність дітей</strong></p> <div><p>
    Ці Сервіси не призначені для осіб молодше 13 років. Ми свідомо не збираємо персональні дані дітей молодше 13 років. Якщо Ми виявимо, що дитина молодше 13 надала нам персональну інформацію, Ми негайно видалимо її з наших серверів. Якщо ви батько/мати або опікун і знаєте, що ваша дитина надала нам персональну інформацію, зв’яжіться зі мною, щоб Ми могли вжити необхідних заходів.
  </p></div> <p><strong>Зміни цієї Політики конфіденційності</strong></p> <p>
    Ми можемо час від часу оновлювати нашу Політику конфіденційності. Тому рекомендується періодично переглядати цю сторінку на предмет змін. Ми повідомимо вас про зміни, розмістивши нову Політику конфіденційності на цій сторінці.
</p>
<p>Ця політика чинна з 2024-06-01</p>
<p><strong>Зв’язатися з нами</strong></p>
<p> Якщо у вас є запитання чи пропозиції щодо нашої Політики конфіденційності, не соромтеся зв’язатися зі мною за адресою</p>
<p>Email: minhviet.dragon@gmail.com</p>
<p>Ця сторінка політики конфіденційності створена на <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>і змінена/згенерована <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
<p><em>Перекладено Google Перекладачем</em></p>
</body>
</html>''',
  };
}
