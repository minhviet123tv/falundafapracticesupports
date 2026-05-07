import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class DownloadedAudioStore {
  static const String _key = 'downloaded_audio_url_path_map_v1';

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
    map[url] = localPath;
    await shared.setString(_key, jsonEncode(map));
  }

  static Future<void> remove(String url) async {
    final shared = await SharedPreferences.getInstance();
    final map = await getAll();
    map.remove(url);
    await shared.setString(_key, jsonEncode(map));
  }

  static Future<String?> resolveExistingLocalPath(String url) async {
    final map = await getAll();
    final localPath = map[url];
    if (localPath == null || localPath.isEmpty) {
      return null;
    }

    final exists = await File(localPath).exists();
    if (exists) {
      return localPath;
    }

    await remove(url);
    return null;
  }
}
