import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';

/// Chuỗi dialog tải offline — chỉ tab Book. Fallback: tiếng Anh.
class ZflOfflineDialogStrings {
  const ZflOfflineDialogStrings({
    required this.promptTitle,
    required this.promptBodyTemplate,
    required this.buttonNo,
    required this.buttonDownload,
    required this.downloadingTitle,
    required this.downloadingHint,
    required this.successMessage,
    required this.failureMessage,
  });

  final String promptTitle;
  final String promptBodyTemplate;
  final String buttonNo;
  final String buttonDownload;
  final String downloadingTitle;
  final String downloadingHint;
  final String successMessage;
  final String failureMessage;

  String promptBody(String bookName) =>
      promptBodyTemplate.replaceAll('{book}', bookName);

  static const ZflOfflineDialogStrings english = ZflOfflineDialogStrings(
    promptTitle: 'Download to read offline?',
    promptBodyTemplate:
        'Download the {book} book to your device to read without an internet connection.',
    buttonNo: 'No',
    buttonDownload: 'Download',
    downloadingTitle: 'Downloading…',
    downloadingHint: 'Please keep the screen open while downloading.',
    successMessage: 'Download complete. You can read offline.',
    failureMessage: 'Download failed. Check your connection and try again.',
  );

  static final Map<LanguageNameOfChuyenPhapLuan, ZflOfflineDialogStrings> _byLanguage =
      <LanguageNameOfChuyenPhapLuan, ZflOfflineDialogStrings>{
    LanguageNameOfChuyenPhapLuan.english: english,
    LanguageNameOfChuyenPhapLuan.chinese: const ZflOfflineDialogStrings(
      promptTitle: '下载以便离线阅读？',
      promptBodyTemplate: '将{book}下载到设备，以便在没有网络连接时阅读。',
      buttonNo: '暂不',
      buttonDownload: '下载',
      downloadingTitle: '正在下载…',
      downloadingHint: '下载期间请保持屏幕开启。',
      successMessage: '下载完成。可以离线阅读。',
      failureMessage: '下载失败。请检查网络后重试。',
    ),
    LanguageNameOfChuyenPhapLuan.chineseSimplified: const ZflOfflineDialogStrings(
      promptTitle: '下载以便离线阅读？',
      promptBodyTemplate: '将{book}下载到设备，以便在没有网络连接时阅读。',
      buttonNo: '暂不',
      buttonDownload: '下载',
      downloadingTitle: '正在下载…',
      downloadingHint: '下载期间请保持屏幕开启。',
      successMessage: '下载完成。可以离线阅读。',
      failureMessage: '下载失败。请检查网络后重试。',
    ),
    LanguageNameOfChuyenPhapLuan.ChineseTraditional: const ZflOfflineDialogStrings(
      promptTitle: '下載以便離線閱讀？',
      promptBodyTemplate: '將{book}下載到裝置，以便在沒有網路連線時閱讀。',
      buttonNo: '暫不',
      buttonDownload: '下載',
      downloadingTitle: '正在下載…',
      downloadingHint: '下載期間請保持螢幕開啟。',
      successMessage: '下載完成。可以離線閱讀。',
      failureMessage: '下載失敗。請檢查網路後重試。',
    ),
    LanguageNameOfChuyenPhapLuan.korean: const ZflOfflineDialogStrings(
      promptTitle: '오프라인으로 읽기 위해 다운로드하시겠습니까?',
      promptBodyTemplate:
          '인터넷 연결 없이 읽을 수 있도록 {book} 도서를 기기에 다운로드합니다.',
      buttonNo: '아니요',
      buttonDownload: '다운로드',
      downloadingTitle: '다운로드 중…',
      downloadingHint: '다운로드하는 동안 화면을 켜 두세요.',
      successMessage: '다운로드가 완료되었습니다. 오프라인으로 읽을 수 있습니다.',
      failureMessage: '다운로드에 실패했습니다. 네트워크를 확인하고 다시 시도하세요.',
    ),
    LanguageNameOfChuyenPhapLuan.japan: const ZflOfflineDialogStrings(
      promptTitle: 'オフラインで読むためにダウンロードしますか？',
      promptBodyTemplate:
          'インターネット接続なしで読めるよう、{book} を端末にダウンロードします。',
      buttonNo: 'いいえ',
      buttonDownload: 'ダウンロード',
      downloadingTitle: 'ダウンロード中…',
      downloadingHint: 'ダウンロード中は画面を開いたままにしてください。',
      successMessage: 'ダウンロードが完了しました。オフラインで読めます。',
      failureMessage: 'ダウンロードに失敗しました。接続を確認して再試行してください。',
    ),
    LanguageNameOfChuyenPhapLuan.thai: const ZflOfflineDialogStrings(
      promptTitle: 'ดาวน์โหลดเพื่ออ่านแบบออฟไลน์?',
      promptBodyTemplate:
          'ดาวน์โหลดหนังสือ {book} ลงอุปกรณ์เพื่ออ่านเมื่อไม่มีการเชื่อมต่ออินเทอร์เน็ต',
      buttonNo: 'ไม่',
      buttonDownload: 'ดาวน์โหลด',
      downloadingTitle: 'กำลังดาวน์โหลด…',
      downloadingHint: 'กรุณาเปิดหน้าจอค้างไว้ระหว่างดาวน์โหลด',
      successMessage: 'ดาวน์โหลดเสร็จแล้ว สามารถอ่านแบบออฟไลน์ได้',
      failureMessage: 'ดาวน์โหลดไม่สำเร็จ ตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง',
    ),
    LanguageNameOfChuyenPhapLuan.cesky: const ZflOfflineDialogStrings(
      promptTitle: 'Stáhnout pro čtení offline?',
      promptBodyTemplate:
          'Stáhněte knihu {book} do zařízení pro čtení bez připojení k internetu.',
      buttonNo: 'Ne',
      buttonDownload: 'Stáhnout',
      downloadingTitle: 'Stahování…',
      downloadingHint: 'Během stahování nechte obrazovku zapnutou.',
      successMessage: 'Stažení dokončeno. Můžete číst offline.',
      failureMessage: 'Stažení se nezdařilo. Zkontrolujte připojení a zkuste znovu.',
    ),
    LanguageNameOfChuyenPhapLuan.deutsch: const ZflOfflineDialogStrings(
      promptTitle: 'Herunterladen, um offline zu lesen?',
      promptBodyTemplate:
          'Laden Sie das Buch {book} auf Ihr Gerät herunter, um es ohne Internetverbindung zu lesen.',
      buttonNo: 'Nein',
      buttonDownload: 'Herunterladen',
      downloadingTitle: 'Wird heruntergeladen…',
      downloadingHint: 'Bitte lassen Sie den Bildschirm während des Downloads eingeschaltet.',
      successMessage: 'Download abgeschlossen. Sie können offline lesen.',
      failureMessage:
          'Download fehlgeschlagen. Überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.',
    ),
    LanguageNameOfChuyenPhapLuan.espanol: const ZflOfflineDialogStrings(
      promptTitle: '¿Descargar para leer sin conexión?',
      promptBodyTemplate:
          'Descargue el libro {book} en su dispositivo para leerlo sin conexión a internet.',
      buttonNo: 'No',
      buttonDownload: 'Descargar',
      downloadingTitle: 'Descargando…',
      downloadingHint: 'Mantenga la pantalla encendida mientras se descarga.',
      successMessage: 'Descarga completa. Puede leer sin conexión.',
      failureMessage: 'Error al descargar. Compruebe su conexión e inténtelo de nuevo.',
    ),
    LanguageNameOfChuyenPhapLuan.greek: const ZflOfflineDialogStrings(
      promptTitle: 'Λήψη για ανάγνωση χωρίς σύνδεση;',
      promptBodyTemplate:
          'Λάβετε το βιβλίο {book} στη συσκευή σας για ανάγνωση χωρίς σύνδεση στο διαδίκτυο.',
      buttonNo: 'Όχι',
      buttonDownload: 'Λήψη',
      downloadingTitle: 'Λήψη…',
      downloadingHint: 'Κρατήστε την οθόνη ανοιχτή κατά τη λήψη.',
      successMessage: 'Η λήψη ολοκληρώθηκε. Μπορείτε να διαβάσετε χωρίς σύνδεση.',
      failureMessage: 'Η λήψη απέτυχε. Ελέγξτε τη σύνδεσή σας και δοκιμάστε ξανά.',
    ),
    LanguageNameOfChuyenPhapLuan.italiano: const ZflOfflineDialogStrings(
      promptTitle: 'Scaricare per leggere offline?',
      promptBodyTemplate:
          'Scarica il libro {book} sul dispositivo per leggerlo senza connessione Internet.',
      buttonNo: 'No',
      buttonDownload: 'Scarica',
      downloadingTitle: 'Download in corso…',
      downloadingHint: 'Tieni lo schermo acceso durante il download.',
      successMessage: 'Download completato. Puoi leggere offline.',
      failureMessage: 'Download non riuscito. Controlla la connessione e riprova.',
    ),
    LanguageNameOfChuyenPhapLuan.latviski: const ZflOfflineDialogStrings(
      promptTitle: 'Lejupielādēt, lai lasītu bezsaistē?',
      promptBodyTemplate:
          'Lejupielādējiet grāmatu {book} ierīcē, lai to lasītu bez interneta savienojuma.',
      buttonNo: 'Nē',
      buttonDownload: 'Lejupielādēt',
      downloadingTitle: 'Lejupielāde…',
      downloadingHint: 'Lejupielādes laikā turiet ekrānu ieslēgtu.',
      successMessage: 'Lejupielāde pabeigta. Varat lasīt bezsaistē.',
      failureMessage: 'Lejupielāde neizdevās. Pārbaudiet savienojumu un mēģiniet vēlreiz.',
    ),
    LanguageNameOfChuyenPhapLuan.magyar: const ZflOfflineDialogStrings(
      promptTitle: 'Letölti offline olvasáshoz?',
      promptBodyTemplate:
          'Töltse le a(z) {book} könyvet az eszközére, hogy internetkapcsolat nélkül olvashassa.',
      buttonNo: 'Nem',
      buttonDownload: 'Letöltés',
      downloadingTitle: 'Letöltés…',
      downloadingHint: 'A letöltés alatt tartsa bekapcsolva a képernyőt.',
      successMessage: 'A letöltés kész. Offline is olvasható.',
      failureMessage: 'A letöltés sikertelen. Ellenőrizze a kapcsolatot, és próbálja újra.',
    ),
    LanguageNameOfChuyenPhapLuan.nederlands: const ZflOfflineDialogStrings(
      promptTitle: 'Downloaden om offline te lezen?',
      promptBodyTemplate:
          'Download het boek {book} naar uw apparaat om het zonder internetverbinding te lezen.',
      buttonNo: 'Nee',
      buttonDownload: 'Downloaden',
      downloadingTitle: 'Bezig met downloaden…',
      downloadingHint: 'Houd het scherm aan tijdens het downloaden.',
      successMessage: 'Download voltooid. U kunt offline lezen.',
      failureMessage: 'Download mislukt. Controleer uw verbinding en probeer opnieuw.',
    ),
    LanguageNameOfChuyenPhapLuan.portugues: const ZflOfflineDialogStrings(
      promptTitle: 'Transferir para ler offline?',
      promptBodyTemplate:
          'Transfira o livro {book} para o seu dispositivo para ler sem ligação à Internet.',
      buttonNo: 'Não',
      buttonDownload: 'Transferir',
      downloadingTitle: 'A transferir…',
      downloadingHint: 'Mantenha o ecrã ligado durante a transferência.',
      successMessage: 'Transferência concluída. Pode ler offline.',
      failureMessage: 'Falha na transferência. Verifique a ligação e tente novamente.',
    ),
    LanguageNameOfChuyenPhapLuan.rumani: const ZflOfflineDialogStrings(
      promptTitle: 'Descărcați pentru a citi offline?',
      promptBodyTemplate:
          'Descărcați cartea {book} pe dispozitiv pentru a o citi fără conexiune la internet.',
      buttonNo: 'Nu',
      buttonDownload: 'Descărcare',
      downloadingTitle: 'Se descarcă…',
      downloadingHint: 'Păstrați ecranul aprins în timpul descărcării.',
      successMessage: 'Descărcare finalizată. Puteți citi offline.',
      failureMessage: 'Descărcarea a eșuat. Verificați conexiunea și încercați din nou.',
    ),
    LanguageNameOfChuyenPhapLuan.russian: const ZflOfflineDialogStrings(
      promptTitle: 'Загрузить для чтения офлайн?',
      promptBodyTemplate:
          'Загрузите книгу {book} на устройство, чтобы читать без подключения к интернету.',
      buttonNo: 'Нет',
      buttonDownload: 'Загрузить',
      downloadingTitle: 'Загрузка…',
      downloadingHint: 'Не выключайте экран во время загрузки.',
      successMessage: 'Загрузка завершена. Можно читать офлайн.',
      failureMessage: 'Не удалось загрузить. Проверьте соединение и повторите попытку.',
    ),
    LanguageNameOfChuyenPhapLuan.slovencina: const ZflOfflineDialogStrings(
      promptTitle: 'Stiahnuť na čítanie offline?',
      promptBodyTemplate:
          'Stiahnite knihu {book} do zariadenia na čítanie bez pripojenia k internetu.',
      buttonNo: 'Nie',
      buttonDownload: 'Stiahnuť',
      downloadingTitle: 'Sťahuje sa…',
      downloadingHint: 'Počas sťahovania nechajte obrazovku zapnutú.',
      successMessage: 'Sťahovanie dokončené. Môžete čítať offline.',
      failureMessage: 'Sťahovanie zlyhalo. Skontrolujte pripojenie a skúste znova.',
    ),
    LanguageNameOfChuyenPhapLuan.suomi: const ZflOfflineDialogStrings(
      promptTitle: 'Ladataanko offline-lukemista varten?',
      promptBodyTemplate:
          'Lataa kirja {book} laitteellesi lukemista varten ilman internet-yhteyttä.',
      buttonNo: 'Ei',
      buttonDownload: 'Lataa',
      downloadingTitle: 'Ladataan…',
      downloadingHint: 'Pidä näyttö päällä latauksen aikana.',
      successMessage: 'Lataus valmis. Voit lukea offline-tilassa.',
      failureMessage: 'Lataus epäonnistui. Tarkista yhteys ja yritä uudelleen.',
    ),
    LanguageNameOfChuyenPhapLuan.svenska: const ZflOfflineDialogStrings(
      promptTitle: 'Ladda ner för att läsa offline?',
      promptBodyTemplate:
          'Ladda ner boken {book} till din enhet för att läsa utan internetanslutning.',
      buttonNo: 'Nej',
      buttonDownload: 'Ladda ner',
      downloadingTitle: 'Laddar ner…',
      downloadingHint: 'Håll skärmen på under nedladdningen.',
      successMessage: 'Nedladdning klar. Du kan läsa offline.',
      failureMessage: 'Nedladdningen misslyckades. Kontrollera anslutningen och försök igen.',
    ),
    LanguageNameOfChuyenPhapLuan.vietnamese: const ZflOfflineDialogStrings(
      promptTitle: 'Tải để đọc khi không có mạng?',
      promptBodyTemplate:
          'Tải sách {book} về máy để đọc khi không có kết nối internet.',
      buttonNo: 'Không',
      buttonDownload: 'Tải',
      downloadingTitle: 'Đang tải…',
      downloadingHint: 'Vui lòng giữ màn hình mở trong lúc tải.',
      successMessage: 'Đã tải xong. Có thể đọc khi không có mạng.',
      failureMessage: 'Tải thất bại. Kiểm tra mạng và thử lại.',
    ),
    LanguageNameOfChuyenPhapLuan.turkce: const ZflOfflineDialogStrings(
      promptTitle: 'Çevrimdışı okumak için indirilsin mi?',
      promptBodyTemplate:
          'İnternet bağlantısı olmadan okumak için {book} kitabını cihazınıza indirin.',
      buttonNo: 'Hayır',
      buttonDownload: 'İndir',
      downloadingTitle: 'İndiriliyor…',
      downloadingHint: 'İndirme sırasında lütfen ekranı açık tutun.',
      successMessage: 'İndirme tamamlandı. Çevrimdışı okuyabilirsiniz.',
      failureMessage: 'İndirme başarısız. Bağlantınızı kontrol edip tekrar deneyin.',
    ),
    LanguageNameOfChuyenPhapLuan.ukraina: const ZflOfflineDialogStrings(
      promptTitle: 'Завантажити для читання офлайн?',
      promptBodyTemplate:
          'Завантажте книгу {book} на пристрій, щоб читати без підключення до інтернету.',
      buttonNo: 'Ні',
      buttonDownload: 'Завантажити',
      downloadingTitle: 'Завантаження…',
      downloadingHint: 'Не вимикайте екран під час завантаження.',
      successMessage: 'Завантаження завершено. Можна читати офлайн.',
      failureMessage: 'Не вдалося завантажити. Перевірте з’єднання та спробуйте знову.',
    ),
  };

  static ZflOfflineDialogStrings forLanguage(LanguageNameOfChuyenPhapLuan language) {
    return _byLanguage[language] ?? english;
  }
}
