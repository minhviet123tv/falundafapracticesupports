import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'book_webview_scroll_helper.dart';
import 'zfl_offline_pack_store.dart';

typedef ZflOfflineDownloadProgress = void Function(int done, int total, String label);

/// Tải mirror HTML ZFL trong cùng thư mục site (không crawl toàn falundafa.org).
class ZflOfflineDownloader {
  static const int maxPages = 180;
  static const Duration _timeout = Duration(seconds: 25);

  static final RegExp _linkAttrPattern = RegExp(
    r'''(?:href|src)\s*=\s*["']([^"'#]+)''',
    caseSensitive: false,
  );

  static Future<bool> downloadPack({
    required String languageCode,
    required String startUrl,
    ZflOfflineDownloadProgress? onProgress,
  }) async {
    final startUri = Uri.parse(startUrl);
    if (!startUri.hasScheme || !startUri.hasAuthority) {
      return false;
    }

    final pathPrefix = _bookPathPrefix(startUri);
    final packDir = await ZflOfflinePackStore.packDirForLanguage(languageCode);
    if (await packDir.exists()) {
      await packDir.delete(recursive: true);
      await packDir.create(recursive: true);
    }

    final pending = <String>[startUrl];
    final visited = <String>{};
    final urlToRelative = <String, String>{};
    var done = 0;

    while (pending.isNotEmpty && visited.length < maxPages) {
      final url = pending.removeAt(0);
      final normalized = BookWebViewScrollHelper.normalizeUrlKey(url);
      if (visited.contains(normalized)) continue;
      visited.add(normalized);

      final uri = Uri.parse(url);
      if (!_isInScope(uri, startUri.host, pathPrefix)) continue;

      onProgress?.call(done, visited.length + pending.length, uri.path);

      final relativePath = _relativePathForUri(uri, pathPrefix);
      final localFile = File(p.join(packDir.path, relativePath));
      await localFile.parent.create(recursive: true);

      try {
        final response = await http.get(uri).timeout(_timeout);
        if (response.statusCode < 200 || response.statusCode >= 400) {
          continue;
        }

        final bytes = response.bodyBytes;
        await localFile.writeAsBytes(bytes);
        urlToRelative[normalized] = relativePath;
        done++;

        final contentType = response.headers['content-type'] ?? '';
        if (_looksLikeHtml(contentType, localFile.path)) {
          final html = utf8.decode(bytes, allowMalformed: true);
          final rewritten = _rewriteHtmlLinks(
            html,
            pageUri: uri,
            startHost: startUri.host,
            pathPrefix: pathPrefix,
            urlToRelative: urlToRelative,
          );
          await localFile.writeAsString(rewritten);

          for (final link in _extractLinks(rewritten, uri)) {
            if (!visited.contains(BookWebViewScrollHelper.normalizeUrlKey(link)) &&
                _isInScope(Uri.parse(link), startUri.host, pathPrefix)) {
              pending.add(link);
            }
          }
        }
      } catch (_) {
        continue;
      }
    }

    final startKey = BookWebViewScrollHelper.normalizeUrlKey(startUrl);
    if (!urlToRelative.containsKey(startKey)) {
      return false;
    }

    final entryRelative = urlToRelative[startKey]!;

    await ZflOfflinePackStore.writeManifest(
      languageCode,
      <String, dynamic>{
        'sourceUrl': startUrl,
        'entryRelativePath': entryRelative,
        'urlToRelativePath': urlToRelative,
        'pageCount': urlToRelative.length,
        'downloadedAt': DateTime.now().toIso8601String(),
      },
    );
    await ZflOfflinePackStore.markInstalled(languageCode);

    onProgress?.call(urlToRelative.length, urlToRelative.length, 'Hoàn tất');
    return true;
  }

  static String _bookPathPrefix(Uri startUri) {
    final dir = p.posix.dirname(startUri.path);
    if (dir == '.' || dir.isEmpty) {
      return startUri.path;
    }
    return dir.endsWith('/') ? dir : '$dir/';
  }

  static bool _isInScope(Uri uri, String host, String pathPrefix) {
    if (uri.scheme != 'http' && uri.scheme != 'https') return false;
    if (uri.host != host) return false;
    return uri.path.startsWith(pathPrefix);
  }

  static String _relativePathForUri(Uri uri, String pathPrefix) {
    var path = uri.path;
    if (path.startsWith('/')) path = path.substring(1);
    if (path.isEmpty || path.endsWith('/')) {
      path = '${path}index.html';
    }
    if (uri.query.isNotEmpty) {
      final safeQuery = uri.query.replaceAll(RegExp(r'[^\w=&-]'), '_');
      path = '$path.__q__$safeQuery.html';
    }
    return path;
  }

  static bool _looksLikeHtml(String contentType, String path) {
    if (contentType.contains('text/html')) return true;
    final lower = path.toLowerCase();
    return lower.endsWith('.html') ||
        lower.endsWith('.htm') ||
        lower.endsWith('.php') ||
        !lower.contains('.');
  }

  static List<String> _extractLinks(String html, Uri base) {
    final links = <String>[];
    for (final match in _linkAttrPattern.allMatches(html)) {
      final raw = match.group(1);
      if (raw == null || raw.isEmpty) continue;
      if (raw.startsWith('mailto:') ||
          raw.startsWith('javascript:') ||
          raw.startsWith('data:')) {
        continue;
      }
      try {
        links.add(base.resolve(raw).toString());
      } catch (_) {}
    }
    return links;
  }

  static String _rewriteHtmlLinks(
    String html, {
    required Uri pageUri,
    required String startHost,
    required String pathPrefix,
    required Map<String, String> urlToRelative,
  }) {
    return html.replaceAllMapped(_linkAttrPattern, (match) {
      final attr = match.group(0)!;
      final raw = match.group(1)!;
      if (raw.startsWith('mailto:') ||
          raw.startsWith('javascript:') ||
          raw.startsWith('data:')) {
        return attr;
      }
      try {
        final resolved = pageUri.resolve(raw);
        if (!_isInScope(resolved, startHost, pathPrefix)) {
          return attr;
        }
        final key = BookWebViewScrollHelper.normalizeUrlKey(resolved.toString());
        final relative = urlToRelative[key] ?? _relativePathForUri(resolved, pathPrefix);
        urlToRelative[key] = relative;
        final localRef = _relativeRefFromPage(pageUri, resolved, pathPrefix);
        return attr.replaceFirst(raw, localRef);
      } catch (_) {
        return attr;
      }
    });
  }

  static String _relativeRefFromPage(Uri pageUri, Uri targetUri, String pathPrefix) {
    final targetRel = _relativePathForUri(targetUri, pathPrefix);
    final pageDir = p.posix.dirname(_relativePathForUri(pageUri, pathPrefix));
    if (pageDir == '.' || pageDir.isEmpty) {
      return targetRel;
    }
    return p.posix.relative(targetRel, from: pageDir);
  }
}
