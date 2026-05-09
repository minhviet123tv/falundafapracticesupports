import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';

/// Chuẩn bị downloader một lần khi khởi động (timeout, resume khi vào lại foreground).
Future<void> initBackgroundDownloader() async {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

  final downloader = FileDownloader();
  await downloader.configure(
    globalConfig: [(Config.requestTimeout, const Duration(minutes: 8))],
    androidConfig: [(Config.useCacheDir, Config.whenAble)],
  );
  unawaited(downloader.resumeFromBackground());
}
