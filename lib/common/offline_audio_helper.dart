import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as audio_session;
import 'package:flutter/foundation.dart';

/// Cấu hình session và phát file audio đã tải về (dùng chung cho các player).
class OfflineAudioHelper {
  static bool _sessionConfigured = false;

  static String normalizeLocalPath(String path) {
    var trimmed = path.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('file://')) {
      trimmed = Uri.parse(trimmed).toFilePath();
    }
    if (Platform.isAndroid &&
        !trimmed.startsWith('/') &&
        (trimmed.startsWith('data/') || trimmed.startsWith('storage/'))) {
      return '/$trimmed';
    }
    return trimmed;
  }

  static Future<bool> localFileReady(String? path) async {
    if (path == null || path.isEmpty) return false;
    final normalized = normalizeLocalPath(path);
    return File(normalized).exists();
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
    if (!await File(devicePath).exists()) {
      throw StateError('Offline audio file not found: $devicePath');
    }

    Future<void> playOnce() async {
      await ensureSessionConfigured(player);
      await player.play(DeviceFileSource(devicePath));
    }

    await ensureSessionConfigured(player);
    await player.stop();
    await Future<void>.delayed(const Duration(milliseconds: 60));
    await playOnce();

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (player.state != PlayerState.playing) {
      debugPrint('Offline audio: retry play (${player.state})');
      await playOnce();
    }
  }
}
