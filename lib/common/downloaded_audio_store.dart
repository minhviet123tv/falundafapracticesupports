import 'dart:convert';

import 'package:flutter/foundation.dart';
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
        result[normalizeUrl(key)] =
            OfflineAudioHelper.normalizeLocalPath(value);
      }
    });
    return result;
  }

  static Future<void> save(String url, String localPath) async {
    final shared = await SharedPreferences.getInstance();
    final map = await getAll();
    final normalizedUrl = normalizeUrl(url);
    final normalizedPath = OfflineAudioHelper.normalizeLocalPath(localPath);
    map[normalizedUrl] = normalizedPath;
    await shared.setString(_key, jsonEncode(map));
    debugPrint('DownloadedAudioStore.save: $normalizedUrl → $normalizedPath');
  }

  static Future<void> remove(String url) async {
    final shared = await SharedPreferences.getInstance();
    final map = await getAll();
    map.remove(normalizeUrl(url));
    await shared.setString(_key, jsonEncode(map));
  }

  static Future<String?> resolveExistingLocalPath(String url) async {
    return resolvePlayablePath(url);
  }

  static String? pathForUrl(Map<String, String> map, String url) {
    return map[normalizeUrl(url)];
  }

  /// Tìm file offline còn tồn tại (map RAM → SharedPreferences → thư mục app).
  static Future<String?> resolvePlayablePath(
    String url, {
    Map<String, String>? memoryMap,
  }) async {
    final normalizedUrl = normalizeUrl(url);
    final candidates = <String>{};

    void addCandidate(String? path) {
      if (path == null || path.isEmpty) return;
      candidates.add(OfflineAudioHelper.normalizeLocalPath(path));
    }

    addCandidate(memoryMap?[normalizedUrl]);
    addCandidate(memoryMap?[url]);
    if (memoryMap != null) {
      addCandidate(pathForUrl(memoryMap, normalizedUrl));
    }

    final diskMap = await getAll();
    addCandidate(diskMap[normalizedUrl]);

    // Đường dẫn chuẩn trong thư mục app (kể cả khi map cũ trỏ Download công khai).
    addCandidate(await OfflineAudioHelper.offlinePathForUrl(normalizedUrl));

    for (final devicePath in candidates) {
      if (await OfflineAudioHelper.localFileReady(devicePath)) {
        // Đồng bộ lại map nếu tìm thấy file app nhưng map chưa đúng.
        final mapped = diskMap[normalizedUrl];
        if (mapped != devicePath) {
          await save(normalizedUrl, devicePath);
        }
        return devicePath;
      }
    }

    // Map trỏ file chết → xóa entry hỏng.
    if (diskMap.containsKey(normalizedUrl)) {
      await remove(normalizedUrl);
      debugPrint(
        'DownloadedAudioStore: removed stale path for $normalizedUrl',
      );
    }
    return null;
  }
}
