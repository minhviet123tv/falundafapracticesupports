import 'package:falun_dafa_practice_supports/common/new_area_language.dart';

/// Chuỗi ngắn cho dialog đặt điện thoại khi đọc sách (không cần footer Google).
class BookPlacementDialogStrings {
  final NewAreaLang lang;
  const BookPlacementDialogStrings(this.lang);

  String get title => switch (lang) {
        NewAreaLang.english => 'Notes when reading',
        NewAreaLang.vietnamese => 'Lưu ý khi đọc sách',
        NewAreaLang.chinese1 => '閱讀時的注意事項',
        NewAreaLang.chinese2 => '阅读时的注意事项',
        NewAreaLang.bosanski => 'Napomene pri čitanju',
        NewAreaLang.deutsch => 'Hinweise beim Lesen',
        NewAreaLang.espanol => 'Notas al leer',
        NewAreaLang.farsi => 'نکات هنگام مطالعه',
        NewAreaLang.francais => 'Notes pour la lecture',
        NewAreaLang.hebrew => 'הערות בעת הקריאה',
        NewAreaLang.hrvatski => 'Napomene pri čitanju',
        NewAreaLang.indonesia => 'Catatan saat membaca',
        NewAreaLang.italiano => 'Note durante la lettura',
        NewAreaLang.japan => '読書時の注意',
        NewAreaLang.korean => '독서 시 주의사항',
        NewAreaLang.polski => 'Uwagi podczas czytania',
        NewAreaLang.portugues => 'Notas ao ler',
        NewAreaLang.russian => 'Замечания при чтении',
        NewAreaLang.slovencina => 'Poznámky pri čítaní',
        NewAreaLang.srpski => 'Напомене при читању',
        NewAreaLang.thai => 'ข้อควรระวังเมื่ออ่าน',
        NewAreaLang.turkce => 'Okurken dikkat edilecekler',
        NewAreaLang.ukrainian => 'Поради під час читання',
        _ => 'Notes when reading',
};

  String get goodPlacement => switch (lang) {
        NewAreaLang.english =>
          'Place the phone on a stand and keep it elevated',
        NewAreaLang.vietnamese =>
          'Nên đặt điện thoại trên giá đỡ và ở trên cao',
        NewAreaLang.chinese1 => '請將手機放在支架上並置於較高位置',
        NewAreaLang.chinese2 => '请将手机放在支架上并置于较高位置',
        NewAreaLang.bosanski =>
          'Stavite telefon na stalku i držite ga povišeno',
        NewAreaLang.deutsch =>
          'Legen Sie das Telefon auf einen Ständer und halten Sie es erhöht',
        NewAreaLang.espanol =>
          'Coloque el teléfono en un soporte y manténgalo elevado',
        NewAreaLang.farsi =>
          'گوشی را روی پایه بگذارید و در جای بلند نگه دارید',
        NewAreaLang.francais =>
          'Placez le téléphone sur un support et gardez-le en hauteur',
        NewAreaLang.hebrew => 'הניחו את הטלפון על מעמד והחזיקו אותו גבוה',
        NewAreaLang.hrvatski =>
          'Stavite telefon na stalku i držite ga povišeno',
        NewAreaLang.indonesia =>
          'Letakkan ponsel di dudukan dan jaga agar tetap tinggi',
        NewAreaLang.italiano =>
          'Metti il telefono su un supporto e tienilo in alto',
        NewAreaLang.japan => 'スマホをスタンドに置き、高めの位置に保ってください',
        NewAreaLang.korean => '휴대폰을 거치대에 올려 높은 위치에 두세요',
        NewAreaLang.polski =>
          'Umieść telefon na stojaku i trzymaj go wyżej',
        NewAreaLang.portugues =>
          'Coloque o telefone num suporte e mantenha-o elevado',
        NewAreaLang.russian =>
          'Поставьте телефон на подставку и держите его выше',
        NewAreaLang.slovencina =>
          'Položte telefón na stojan a držte ho vyššie',
        NewAreaLang.srpski =>
          'Ставите телефон на сталак и држите га повишено',
        NewAreaLang.thai => 'วางโทรศัพท์บนขาตั้งและให้อยู่ในตำแหน่งสูง',
        NewAreaLang.turkce =>
          'Telefonu bir standa koyun ve yüksekte tutun',
        NewAreaLang.ukrainian =>
          'Поставте телефон на підставку й тримайте вище',
        _ => 'Place the phone on a stand and keep it elevated',
};

  String get badPlacement => switch (lang) {
        NewAreaLang.english =>
          'Do not place the phone low when reading',
        NewAreaLang.vietnamese =>
          'Không nên đặt điện thoại dưới thấp khi đọc',
        NewAreaLang.chinese1 => '閱讀時請勿將手機放得過低',
        NewAreaLang.chinese2 => '阅读时请勿将手机放得过低',
        NewAreaLang.bosanski =>
          'Ne stavljajte telefon nisko dok čitate',
        NewAreaLang.deutsch =>
          'Legen Sie das Telefon beim Lesen nicht zu niedrig',
        NewAreaLang.espanol =>
          'No coloque el teléfono bajo al leer',
        NewAreaLang.farsi => 'هنگام مطالعه گوشی را پایین نگذارید',
        NewAreaLang.francais =>
          'Ne placez pas le téléphone trop bas en lisant',
        NewAreaLang.hebrew => 'אל תניחו את הטלפון נמוך בעת הקריאה',
        NewAreaLang.hrvatski =>
          'Ne stavljajte telefon nisko dok čitate',
        NewAreaLang.indonesia =>
          'Jangan letakkan ponsel terlalu rendah saat membaca',
        NewAreaLang.italiano =>
          'Non mettere il telefono troppo in basso durante la lettura',
        NewAreaLang.japan => '読書中にスマホを低い位置に置かないでください',
        NewAreaLang.korean => '독서할 때 휴대폰을 낮은 곳에 두지 마세요',
        NewAreaLang.polski =>
          'Nie kładź telefonu nisko podczas czytania',
        NewAreaLang.portugues =>
          'Não coloque o telefone baixo ao ler',
        NewAreaLang.russian =>
          'Не кладите телефон низко во время чтения',
        NewAreaLang.slovencina =>
          'Pri čítaní nedávajte telefón príliš nízko',
        NewAreaLang.srpski =>
          'Не стављајте телефон ниско док читате',
        NewAreaLang.thai => 'อย่าวางโทรศัพท์ในตำแหน่งต่ำเมื่ออ่าน',
        NewAreaLang.turkce =>
          'Okurken telefonu alçak bir yere koymayın',
        NewAreaLang.ukrainian =>
          'Не кладіть телефон низько під час читання',
        _ => 'Do not place the phone low when reading',
};

  String get neverShowAgain => switch (lang) {
        NewAreaLang.english => "Don't show again",
        NewAreaLang.vietnamese => 'Không nhắc lại',
        NewAreaLang.chinese1 => '不再提醒',
        NewAreaLang.chinese2 => '不再提醒',
        NewAreaLang.bosanski => 'Ne prikazuj više',
        NewAreaLang.deutsch => 'Nicht mehr anzeigen',
        NewAreaLang.espanol => 'No volver a mostrar',
        NewAreaLang.farsi => 'دیگر نشان نده',
        NewAreaLang.francais => 'Ne plus afficher',
        NewAreaLang.hebrew => 'אל תציג שוב',
        NewAreaLang.hrvatski => 'Ne prikazuj više',
        NewAreaLang.indonesia => 'Jangan tampilkan lagi',
        NewAreaLang.italiano => 'Non mostrare più',
        NewAreaLang.japan => '今後表示しない',
        NewAreaLang.korean => '다시 보지 않기',
        NewAreaLang.polski => 'Nie pokazuj ponownie',
        NewAreaLang.portugues => 'Não mostrar novamente',
        NewAreaLang.russian => 'Больше не показывать',
        NewAreaLang.slovencina => 'Už nezobrazovať',
        NewAreaLang.srpski => 'Не приказуј поново',
        NewAreaLang.thai => 'ไม่ต้องแสดงอีก',
        NewAreaLang.turkce => 'Bir daha gösterme',
        NewAreaLang.ukrainian => 'Більше не показувати',
        _ => "Don't show again",
};

  String get skip => switch (lang) {
        NewAreaLang.english => 'Skip',
        NewAreaLang.vietnamese => 'Bỏ qua',
        NewAreaLang.chinese1 => '略過',
        NewAreaLang.chinese2 => '跳过',
        NewAreaLang.bosanski => 'Preskoči',
        NewAreaLang.deutsch => 'Überspringen',
        NewAreaLang.espanol => 'Omitir',
        NewAreaLang.farsi => 'رد کردن',
        NewAreaLang.francais => 'Ignorer',
        NewAreaLang.hebrew => 'דלג',
        NewAreaLang.hrvatski => 'Preskoči',
        NewAreaLang.indonesia => 'Lewati',
        NewAreaLang.italiano => 'Salta',
        NewAreaLang.japan => 'スキップ',
        NewAreaLang.korean => '건너뛰기',
        NewAreaLang.polski => 'Pomiń',
        NewAreaLang.portugues => 'Ignorar',
        NewAreaLang.russian => 'Пропустить',
        NewAreaLang.slovencina => 'Preskočiť',
        NewAreaLang.srpski => 'Прескочи',
        NewAreaLang.thai => 'ข้าม',
        NewAreaLang.turkce => 'Atla',
        NewAreaLang.ukrainian => 'Пропустити',
        _ => 'Skip',
};

  String get understood => switch (lang) {
        NewAreaLang.english => 'Got it',
        NewAreaLang.vietnamese => 'Đã hiểu',
        NewAreaLang.chinese1 => '知道了',
        NewAreaLang.chinese2 => '知道了',
        NewAreaLang.bosanski => 'Razumijem',
        NewAreaLang.deutsch => 'Verstanden',
        NewAreaLang.espanol => 'Entendido',
        NewAreaLang.farsi => 'متوجه شدم',
        NewAreaLang.francais => 'Compris',
        NewAreaLang.hebrew => 'הבנתי',
        NewAreaLang.hrvatski => 'Razumijem',
        NewAreaLang.indonesia => 'Mengerti',
        NewAreaLang.italiano => 'Ho capito',
        NewAreaLang.japan => 'わかりました',
        NewAreaLang.korean => '알겠습니다',
        NewAreaLang.polski => 'Rozumiem',
        NewAreaLang.portugues => 'Entendi',
        NewAreaLang.russian => 'Понятно',
        NewAreaLang.slovencina => 'Rozumiem',
        NewAreaLang.srpski => 'Разумем',
        NewAreaLang.thai => 'เข้าใจแล้ว',
        NewAreaLang.turkce => 'Anladım',
        NewAreaLang.ukrainian => 'Зрозуміло',
        _ => 'Got it',
};
}
