import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book_webview_scroll_helper.dart';

/// Lưu bản HTML Chuyển Pháp Luân đã tải theo ngôn ngữ (enum name).
class ZflOfflinePackStore {
  static const String _manifestFileName = 'manifest.json';
  static const String _prefsDeclinedPrefix = 'zfl_offline_declined_';
  static const String _prefsInstalledPrefix = 'zfl_offline_installed_';
  static const String _prefsBookTabVisits = 'zfl_offline_book_tab_visits';

  static Future<Directory> _packRoot() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'zfl_offline_packs'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> packDirForLanguage(String languageCode) async {
    final root = await _packRoot();
    final dir = Directory(p.join(root.path, languageCode));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<File> _manifestFile(String languageCode) async {
    final dir = await packDirForLanguage(languageCode);
    return File(p.join(dir.path, _manifestFileName));
  }

  static Future<Map<String, dynamic>?> readManifest(String languageCode) async {
    final file = await _manifestFile(languageCode);
    if (!await file.exists()) return null;
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map) {
        return decoded.cast<String, dynamic>();
      }
    } catch (_) {}
    return null;
  }

  static Future<void> writeManifest(
    String languageCode,
    Map<String, dynamic> manifest,
  ) async {
    final file = await _manifestFile(languageCode);
    await file.writeAsString(jsonEncode(manifest));
  }

  /// Đã tải gói offline hợp lệ cho ngôn ngữ này → không hỏi tải lại.
  static Future<bool> isInstalled(String languageCode) async {
    final onDisk = await _packExistsOnDisk(languageCode);
    if (!onDisk) {
      await _clearInstalledFlag(languageCode);
      return false;
    }

    final shared = await SharedPreferences.getInstance();
    if (shared.getBool('$_prefsInstalledPrefix$languageCode') != true) {
      await markInstalled(languageCode);
    }
    return true;
  }

  static Future<bool> _packExistsOnDisk(String languageCode) async {
    final manifest = await readManifest(languageCode);
    if (manifest == null) return false;
    final pageCount = manifest['pageCount'];
    if (pageCount is! int || pageCount < 1) return false;
    final entry = manifest['entryRelativePath'];
    if (entry is! String || entry.isEmpty) return false;
    final dir = await packDirForLanguage(languageCode);
    return await File(p.join(dir.path, entry)).exists();
  }

  static Future<void> markInstalled(String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('$_prefsInstalledPrefix$languageCode', true);
    await setDeclined(languageCode, false);
  }

  static Future<void> _clearInstalledFlag(String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.remove('$_prefsInstalledPrefix$languageCode');
  }

  static Future<String?> entryAbsolutePath(String languageCode) async {
    final manifest = await readManifest(languageCode);
    if (manifest == null) return null;
    final entry = manifest['entryRelativePath'];
    if (entry is! String || entry.isEmpty) return null;
    final dir = await packDirForLanguage(languageCode);
    final file = File(p.join(dir.path, entry));
    if (!await file.exists()) return null;
    return file.absolute.path;
  }

  static Future<String?> resolveLocalAbsolutePath(
    String languageCode,
    String remoteUrl,
  ) async {
    final manifest = await readManifest(languageCode);
    if (manifest == null) return null;
    final mapRaw = manifest['urlToRelativePath'];
    if (mapRaw is! Map) return null;
    final map = mapRaw.cast<String, dynamic>();
    final relative = map[remoteUrl] ??
        map[BookWebViewScrollHelper.normalizeUrlKey(remoteUrl)];
    if (relative is! String || relative.isEmpty) return null;
    final dir = await packDirForLanguage(languageCode);
    final file = File(p.join(dir.path, relative));
    if (!await file.exists()) return null;
    return file.absolute.path;
  }

  static Future<int> getBookTabVisitCount() async {
    final shared = await SharedPreferences.getInstance();
    return shared.getInt(_prefsBookTabVisits) ?? 0;
  }

  static Future<int> incrementBookTabVisitCount() async {
    final shared = await SharedPreferences.getInstance();
    final next = (shared.getInt(_prefsBookTabVisits) ?? 0) + 1;
    await shared.setInt(_prefsBookTabVisits, next);
    return next;
  }

  static Future<bool> wasDeclined(String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    return shared.getBool('$_prefsDeclinedPrefix$languageCode') ?? false;
  }

  static Future<void> setDeclined(String languageCode, bool declined) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('$_prefsDeclinedPrefix$languageCode', declined);
  }

  static Future<String?> remoteUrlForLocalFile(
    String languageCode,
    String localAbsolutePath,
  ) async {
    final manifest = await readManifest(languageCode);
    if (manifest == null) return null;
    final mapRaw = manifest['urlToRelativePath'];
    if (mapRaw is! Map) return null;
    final dir = await packDirForLanguage(languageCode);
    final normalizedLocal = File(localAbsolutePath).absolute.path;
    for (final entry in mapRaw.entries) {
      if (entry.value is! String) continue;
      final file = File(p.join(dir.path, entry.value as String));
      if (file.absolute.path == normalizedLocal) {
        return entry.key;
      }
    }
    return null;
  }

  static Future<void> deletePack(String languageCode) async {
    final dir = await packDirForLanguage(languageCode);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    final shared = await SharedPreferences.getInstance();
    await shared.remove('$_prefsDeclinedPrefix$languageCode');
    await _clearInstalledFlag(languageCode);
  }
}
