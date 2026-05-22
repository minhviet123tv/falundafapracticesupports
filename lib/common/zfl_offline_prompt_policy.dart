import 'package:connectivity_plus/connectivity_plus.dart';

import '../controller_app/link_internet_sachchuyenphapluan_quocte.dart';
import 'zfl_offline_pack_store.dart';

enum ZflOfflinePromptTrigger {
  firstOpenLanguage,
  languageChanged,
  bookTabVisit,
}

/// Khi nào hiện hộp thoại “Tải để đọc khi không có mạng?”.
class ZflOfflinePromptPolicy {
  static Future<bool> hasInternet() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  static bool isDownloadable(LanguageNameOfChuyenPhapLuan language) {
    return language != LanguageNameOfChuyenPhapLuan.more;
  }

  static Future<bool> shouldOfferDownload({
    required String languageCode,
    required LanguageNameOfChuyenPhapLuan language,
    required ZflOfflinePromptTrigger trigger,
  }) async {
    if (!isDownloadable(language)) return false;
    if (!await hasInternet()) return false;
    // Đã tải bản này rồi → không hỏi lại (mọi trigger: mở app, đổi ngôn ngữ, tab Book).
    if (await ZflOfflinePackStore.isInstalled(languageCode)) return false;

    if (trigger == ZflOfflinePromptTrigger.languageChanged) {
      return true;
    }

    if (await ZflOfflinePackStore.wasDeclined(languageCode)) {
      return false;
    }

    if (trigger == ZflOfflinePromptTrigger.bookTabVisit) {
      final visits = await ZflOfflinePackStore.getBookTabVisitCount();
      return visits <= 2;
    }

    return true;
  }
}
