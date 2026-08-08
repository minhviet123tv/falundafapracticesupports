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

  /// Tiêu đề dialog khi mở Video 9 Lesson.
  String get videoTitle => switch (lang) {
        NewAreaLang.english => 'Notes when watching video',
        NewAreaLang.vietnamese => 'Lưu ý khi xem video',
        NewAreaLang.chinese1 => '觀看影片時的注意事項',
        NewAreaLang.chinese2 => '观看视频时的注意事项',
        NewAreaLang.bosanski => 'Napomene pri gledanju videa',
        NewAreaLang.deutsch => 'Hinweise beim Videoanschauen',
        NewAreaLang.espanol => 'Notas al ver el vídeo',
        NewAreaLang.farsi => 'نکات هنگام تماشای ویدیو',
        NewAreaLang.francais => 'Notes pour regarder la vidéo',
        NewAreaLang.hebrew => 'הערות בעת צפייה בווידאו',
        NewAreaLang.hrvatski => 'Napomene pri gledanju videa',
        NewAreaLang.indonesia => 'Catatan saat menonton video',
        NewAreaLang.italiano => 'Note durante la visione del video',
        NewAreaLang.japan => '動画視聴時の注意',
        NewAreaLang.korean => '영상 시청 시 주의사항',
        NewAreaLang.polski => 'Uwagi podczas oglądania wideo',
        NewAreaLang.portugues => 'Notas ao assistir ao vídeo',
        NewAreaLang.russian => 'Замечания при просмотре видео',
        NewAreaLang.slovencina => 'Poznámky pri sledovaní videa',
        NewAreaLang.srpski => 'Напомене при гледању видеа',
        NewAreaLang.thai => 'ข้อควรระวังเมื่อดูวิดีโอ',
        NewAreaLang.turkce => 'Video izlerken dikkat edilecekler',
        NewAreaLang.ukrainian => 'Поради під час перегляду відео',
        _ => 'Notes when watching video',
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

  /// Mô tả đặt máy khi xem Video 9 Lesson.
  String get videoGoodPlacement => switch (lang) {
        NewAreaLang.english =>
          'Place the phone on a stand and keep it elevated; set aside enough time to watch and listen to the entire video with focus',
        NewAreaLang.vietnamese =>
          'Nên đặt điện thoại trên giá đỡ và ở trên cao, dành đủ thời gian để tập trung xem và nghe hết video',
        NewAreaLang.chinese1 => '請將手機放在支架上並置於較高位置，預留足夠時間專心觀看並聽完整部影片',
        NewAreaLang.chinese2 => '请将手机放在支架上并置于较高位置，预留足够时间专心观看并听完整部视频',
        NewAreaLang.bosanski =>
          'Stavite telefon na stalku i držite ga povišeno; odvojite dovoljno vremena da usredotočeno pogledate i odslušate cijeli video',
        NewAreaLang.deutsch =>
          'Legen Sie das Telefon auf einen Ständer und halten Sie es erhöht; nehmen Sie sich genug Zeit, um das gesamte Video konzentriert anzusehen und anzuhören',
        NewAreaLang.espanol =>
          'Coloque el teléfono en un soporte y manténgalo elevado; reserve tiempo suficiente para ver y escuchar todo el vídeo con atención',
        NewAreaLang.farsi =>
          'گوشی را روی پایه بگذارید و در جای بلند نگه دارید؛ زمان کافی بگذارید تا با تمرکز تمام ویدیو را ببینید و بشنوید',
        NewAreaLang.francais =>
          'Placez le téléphone sur un support et gardez-le en hauteur ; prévoyez assez de temps pour regarder et écouter toute la vidéo avec attention',
        NewAreaLang.hebrew =>
          'הניחו את הטלפון על מעמד והחזיקו אותו גבוה; הקצו מספיק זמן כדי לצפות ולהאזין לכל הסרטון בריכוז',
        NewAreaLang.hrvatski =>
          'Stavite telefon na stalku i držite ga povišeno; odvojite dovoljno vremena da usredotočeno pogledate i odslušate cijeli video',
        NewAreaLang.indonesia =>
          'Letakkan ponsel di dudukan dan jaga agar tetap tinggi; sediakan waktu cukup untuk menonton dan mendengarkan seluruh video dengan fokus',
        NewAreaLang.italiano =>
          'Metti il telefono su un supporto e tienilo in alto; dedica abbastanza tempo per guardare e ascoltare tutto il video con attenzione',
        NewAreaLang.japan => 'スマホをスタンドに置き、高めの位置に保ってください。十分な時間をとり、集中して動画を最後まで視聴・聴取してください',
        NewAreaLang.korean => '휴대폰을 거치대에 올려 높은 위치에 두세요. 충분한 시간을 내어 집중해서 영상 전체를 시청하고 들으세요',
        NewAreaLang.polski =>
          'Umieść telefon na stojaku i trzymaj go wyżej; przeznacz wystarczająco czasu, aby skupić się na obejrzeniu i wysłuchaniu całego wideo',
        NewAreaLang.portugues =>
          'Coloque o telefone num suporte e mantenha-o elevado; reserve tempo suficiente para assistir e ouvir todo o vídeo com atenção',
        NewAreaLang.russian =>
          'Поставьте телефон на подставку и держите его выше; выделите достаточно времени, чтобы сосредоточенно посмотреть и прослушать всё видео',
        NewAreaLang.slovencina =>
          'Položte telefón na stojan a držte ho vyššie; vyhraďte si dosť času na sústredené pozretie a vypočutie celého videa',
        NewAreaLang.srpski =>
          'Ставите телефон на сталак и држите га повишено; издвојите довољно времена да усредсређено погледате и одслушате цео видео',
        NewAreaLang.thai =>
          'วางโทรศัพท์บนขาตั้งและให้อยู่ในตำแหน่งสูง สำรองเวลาให้เพียงพอเพื่อตั้งใจดูและฟังวิดีโอจนจบ',
        NewAreaLang.turkce =>
          'Telefonu bir standa koyun ve yüksekte tutun; tüm videoyu dikkatle izleyip dinlemek için yeterli zaman ayırın',
        NewAreaLang.ukrainian =>
          'Поставте телефон на підставку й тримайте вище; виділіть достатньо часу, щоб зосереджено переглянути й прослухати все відео',
        _ =>
          'Place the phone on a stand and keep it elevated; set aside enough time to watch and listen to the entire video with focus',
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

  String get videoBadPlacement => switch (lang) {
        NewAreaLang.english =>
          'Do not place the phone low when watching video',
        NewAreaLang.vietnamese =>
          'Không nên đặt điện thoại dưới thấp khi xem video',
        NewAreaLang.chinese1 => '觀看影片時請勿將手機放得過低',
        NewAreaLang.chinese2 => '观看视频时请勿将手机放得过低',
        NewAreaLang.bosanski =>
          'Ne stavljajte telefon nisko dok gledate video',
        NewAreaLang.deutsch =>
          'Legen Sie das Telefon beim Videoanschauen nicht zu niedrig',
        NewAreaLang.espanol =>
          'No coloque el teléfono bajo al ver el vídeo',
        NewAreaLang.farsi => 'هنگام تماشای ویدیو گوشی را پایین نگذارید',
        NewAreaLang.francais =>
          'Ne placez pas le téléphone trop bas en regardant la vidéo',
        NewAreaLang.hebrew => 'אל תניחו את הטלפון נמוך בעת צפייה בווידאו',
        NewAreaLang.hrvatski =>
          'Ne stavljajte telefon nisko dok gledate video',
        NewAreaLang.indonesia =>
          'Jangan letakkan ponsel terlalu rendah saat menonton video',
        NewAreaLang.italiano =>
          'Non mettere il telefono troppo in basso durante la visione del video',
        NewAreaLang.japan => '動画視聴中にスマホを低い位置に置かないでください',
        NewAreaLang.korean => '영상을 볼 때 휴대폰을 낮은 곳에 두지 마세요',
        NewAreaLang.polski =>
          'Nie kładź telefonu nisko podczas oglądania wideo',
        NewAreaLang.portugues =>
          'Não coloque o telefone baixo ao assistir ao vídeo',
        NewAreaLang.russian =>
          'Не кладите телефон низко во время просмотра видео',
        NewAreaLang.slovencina =>
          'Pri sledovaní videa nedávajte telefón príliš nízko',
        NewAreaLang.srpski =>
          'Не стављајте телефон ниско док гледате видео',
        NewAreaLang.thai => 'อย่าวางโทรศัพท์ในตำแหน่งต่ำเมื่อดูวิดีโอ',
        NewAreaLang.turkce =>
          'Video izlerken telefonu alçak bir yere koymayın',
        NewAreaLang.ukrainian =>
          'Не кладіть телефон низько під час перегляду відео',
        _ => 'Do not place the phone low when watching video',
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
