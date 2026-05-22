import 'package:webview_flutter/webview_flutter.dart';

import 'zfl_offline_pack_store.dart';
import 'zfl_offline_prompt_policy.dart';

/// Chọn URL http hoặc file:// khi không có mạng nhưng đã tải gói offline.
class ZflOfflineUrlLoader {
  static Future<Uri> uriForReading({
    required String languageCode,
    required String remoteUrl,
  }) async {
    final online = await ZflOfflinePromptPolicy.hasInternet();
    if (online) {
      return Uri.parse(remoteUrl);
    }
    final local = await ZflOfflinePackStore.resolveLocalAbsolutePath(
      languageCode,
      remoteUrl,
    );
    if (local != null) {
      return Uri.file(local);
    }
    return Uri.parse(remoteUrl);
  }

  static Future<void> loadInController(
    WebViewController controller, {
    required String languageCode,
    required String remoteUrl,
  }) async {
    await controller.loadRequest(
      await uriForReading(languageCode: languageCode, remoteUrl: remoteUrl),
    );
  }
}
