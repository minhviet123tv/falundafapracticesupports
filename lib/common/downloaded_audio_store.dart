import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'offline_audio_helper.dart';

class DownloadedAudioStore {
  static const String _key = 'downloaded_audio_url_path_map_v1';

  static String normalizeUrl(String url) => url.trim();

  static Future<Map<String, String>> getAll() async {
    final shared = await SharedPreferences.getInstance();
    final raw = shared.getString(_key);
    if (raw == null || raw.isEmpty) {
      return <String, String>{};
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      return <String, String>{};
    }

    final result = <String, String>{};
    decoded.forEach((key, value) {
      if (key is String && value is String) {
        result[key] = value;
      }
    });
    return result;
  }

  static Future<void> save(String url, String localPath) async {
    final shared = await SharedPreferences.getInstance();
    final map = await getAll();
    final normalizedUrl = normalizeUrl(url);
    map[normalizedUrl] = OfflineAudioHelper.normalizeLocalPath(localPath);
    await shared.setString(_key, jsonEncode(map));
  }

  static Future<void> remove(String url) async {
    final shared = await SharedPreferences.getInstance();
    final map = await getAll();
    map.remove(normalizeUrl(url));
    await shared.setString(_key, jsonEncode(map));
  }

  static Future<String?> resolveExistingLocalPath(String url) async {
    final map = await getAll();
    final normalizedUrl = normalizeUrl(url);
    final localPath = map[normalizedUrl];
    if (localPath == null || localPath.isEmpty) {
      return null;
    }

    final devicePath = OfflineAudioHelper.normalizeLocalPath(localPath);
    final exists = await File(devicePath).exists();
    if (exists) {
      return devicePath;
    }

    await remove(normalizedUrl);
    return null;
  }

  static String? pathForUrl(Map<String, String> map, String url) {
    return map[normalizeUrl(url)];
  }

  /// Tìm file offline còn tồn tại trên máy (map trong RAM + SharedPreferences).
  static Future<String?> resolvePlayablePath(
    String url, {
    Map<String, String>? memoryMap,
  }) async {
    final normalizedUrl = normalizeUrl(url);
    final candidates = <String?>[
      memoryMap?[normalizedUrl],
      memoryMap?[url],
      pathForUrl(memoryMap ?? const <String, String>{}, normalizedUrl),
    ];

    for (final candidate in candidates) {
      if (candidate == null || candidate.isEmpty) continue;
      final devicePath = OfflineAudioHelper.normalizeLocalPath(candidate);
      if (await File(devicePath).exists()) {
        return devicePath;
      }
    }

    return resolveExistingLocalPath(url);
  }
}
