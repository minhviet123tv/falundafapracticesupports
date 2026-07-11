import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as audio_session;

/// Cấu hình session + thư mục/file audio offline (dùng chung các player).
class OfflineAudioHelper {
  OfflineAudioHelper._();

  static bool _sessionConfigured = false;
  static const String _offlineSubDir = 'offline_audio';

  static String normalizeLocalPath(String path) {
    var trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('file://')) {
      try {
        trimmed = Uri.parse(trimmed).toFilePath();
      } catch (_) {
        trimmed = trimmed.replaceFirst(RegExp(r'^file://'), '');
      }
    }
    if (Platform.isAndroid &&
        !trimmed.startsWith('/') &&
        (trimmed.startsWith('data/') || trimmed.startsWith('storage/'))) {
      return '/$trimmed';
    }
    return trimmed;
  }

  /// Tên file ổn định theo URL (tránh trùng / ký tự lạ).
  static String fileNameForUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    var base = 'audio.mp3';
    if (uri != null && uri.pathSegments.isNotEmpty) {
      final last = uri.pathSegments.last;
      if (last.isNotEmpty) base = last;
    }
    base = base.replaceAll(RegExp(r'[^\w.\-]+'), '_');
    if (!base.toLowerCase().endsWith('.mp3') &&
        !base.toLowerCase().endsWith('.m4a') &&
        !base.toLowerCase().endsWith('.aac') &&
        !base.toLowerCase().endsWith('.wav')) {
      base = '$base.mp3';
    }
    // Prefix ngắn theo URL để tránh trùng tên bài giữa các nguồn.
    final hash = url.trim().hashCode.toRadixString(16).replaceAll('-', 'n');
    return '${hash}_$base';
  }

  static Future<Directory> offlineDirectory() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/$_offlineSubDir');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<String> offlinePathForUrl(String url) async {
    final dir = await offlineDirectory();
    return '${dir.path}/${fileNameForUrl(url)}';
  }

  static Future<bool> localFileReady(String? path) async {
    if (path == null || path.isEmpty) return false;
    final normalized = normalizeLocalPath(path);
    try {
      final file = File(normalized);
      if (!await file.exists()) return false;
      final len = await file.length();
      return len > 0;
    } catch (_) {
      return false;
    }
  }

  /// Đưa file tải về về thư mục app (luôn đọc được, không cần quyền storage).
  /// Trả về đường dẫn tuyệt đối đã xác minh.
  static Future<String> ensurePlayableLocalFile({
    required String url,
    required String downloadedPath,
  }) async {
    final sourcePath = normalizeLocalPath(downloadedPath);
    final targetPath = await offlinePathForUrl(url);

    if (await localFileReady(targetPath)) {
      return targetPath;
    }

    final source = File(sourcePath);
    if (await localFileReady(sourcePath)) {
      if (sourcePath == targetPath) {
        return targetPath;
      }
      try {
        await source.copy(targetPath);
        if (await localFileReady(targetPath)) {
          debugPrint('Offline audio: copied to $targetPath');
          return targetPath;
        }
      } catch (e) {
        debugPrint('Offline audio copy failed ($sourcePath → $targetPath): $e');
        // Có thể phát trực tiếp từ source nếu cùng app storage.
        if (sourcePath.contains('files') ||
            sourcePath.contains('app_flutter') ||
            sourcePath.contains('offline_audio')) {
          return sourcePath;
        }
        rethrow;
      }
    }

    throw StateError(
      'Offline audio file missing or empty. source=$sourcePath target=$targetPath',
    );
  }

  static Future<void> ensureSessionConfigured(AudioPlayer player) async {
    try {
      final session = await audio_session.AudioSession.instance;
      if (!_sessionConfigured) {
        await session.configure(audio_session.AudioSessionConfiguration.music());
        await player.setAudioContext(
          AudioContext(
            android: AudioContextAndroid(
              isSpeakerphoneOn: false,
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.media,
              audioFocus: AndroidAudioFocus.gain,
            ),
            iOS: AudioContextIOS(
              category: AVAudioSessionCategory.playback,
              options: <AVAudioSessionOptions>{
                AVAudioSessionOptions.mixWithOthers,
              },
            ),
          ),
        );
        await player.setReleaseMode(ReleaseMode.stop);
        _sessionConfigured = true;
      }
      await session.setActive(true);
    } catch (e) {
      debugPrint('Offline audio session error: $e');
    }
  }

  static Future<void> playLocalFile(AudioPlayer player, String path) async {
    final devicePath = normalizeLocalPath(path);
    if (!await localFileReady(devicePath)) {
      throw StateError('Offline audio file not found: $devicePath');
    }

    Future<void> playDevice() async {
      await ensureSessionConfigured(player);
      await player.play(DeviceFileSource(devicePath));
    }

    Future<void> playBytes() async {
      await ensureSessionConfigured(player);
      final bytes = await File(devicePath).readAsBytes();
      if (bytes.isEmpty) {
        throw StateError('Offline audio file is empty: $devicePath');
      }
      await player.play(BytesSource(bytes));
    }

    await ensureSessionConfigured(player);
    await player.stop();
    await Future<void>.delayed(const Duration(milliseconds: 60));

    try {
      await playDevice();
    } catch (e) {
      debugPrint('Offline audio DeviceFileSource failed: $e → BytesSource');
      await playBytes();
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (player.state != PlayerState.playing) {
      debugPrint('Offline audio: retry play (${player.state})');
      try {
        await playDevice();
      } catch (_) {
        await playBytes();
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (player.state != PlayerState.playing) {
      debugPrint('Offline audio: final BytesSource fallback (${player.state})');
      await playBytes();
    }
  }
}
