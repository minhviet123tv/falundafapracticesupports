import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserHelper {
  /// User-Agent giống Chrome — Google thường từ chối / trả trang trắng với UA mặc định WebView (`; wv`).
  static const String webViewChromeUserAgent =
      'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) '
      'Chrome/121.0.0.0 Mobile Safari/537.36';

  static Uri _googleSearch(String query) {
    return Uri.https('www.google.com', '/search', {
      'q': query,
      'ie': 'UTF-8',
      'hl': 'vi',
    });
  }

  /// Chuyển ô địa chỉ thành URI hợp lệ:
  /// - Đã có `http(s)://` hoặc `file://` → dùng trực tiếp nếu parse được.
  /// - Có **khoảng trắng** → câu tìm kiếm (Google).
  /// - **Không có dấu `.`** trong toàn chuỗi → từ khóa / một từ: **Google** (không dùng `https://một_từ` vì Dart coi đó là host).
  /// - Có `.` → thử `https://...` như tên miền (vd. `example.com`).
  static Uri? resolveNavigationUri(String input) {
    final t = input.trim();
    if (t.isEmpty) return null;

    final parsed = Uri.tryParse(t);
    if (parsed != null && parsed.hasScheme) {
      if (parsed.scheme == 'file') return parsed;
      if (parsed.scheme == 'http' || parsed.scheme == 'https') return parsed;
    }

    // Câu có khoảng trắng → gần như luôn là tìm kiếm.
    if (RegExp(r'\s').hasMatch(t)) {
      return _googleSearch(t);
    }

    // Không có dấu chấm → không thể là domain kiểu example.com; tránh https://google hay https://news.
    if (!t.contains('.')) {
      return _googleSearch(t);
    }

    if (!t.contains('://')) {
      final withHttps = Uri.tryParse(
        t.startsWith('//') ? 'https:$t' : 'https://$t',
      );
      if (withHttps != null &&
          withHttps.hasScheme &&
          withHttps.host.isNotEmpty) {
        return withHttps;
      }
    }

    final u = Uri.tryParse('https://$t');
    if (u != null && u.host.isNotEmpty) return u;

    return _googleSearch(t);
  }

  static Future<void> launchInApp(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<void> launchExternal(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static Future<String?> getCurrentUrl(WebViewController controller) {
    return controller.currentUrl();
  }
}
