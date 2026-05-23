/// Chuẩn hóa ô địa chỉ: thêm https/http khi thiếu; chuỗi không phải URL → tìm kiếm Google.
class WebUrlResolver {
  static const String _searchBase = 'https://www.google.com/search?q=';

  static Uri resolve(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) {
      throw ArgumentError('empty input');
    }

    if (_shouldSearch(input)) {
      return Uri.parse('$_searchBase${Uri.encodeQueryComponent(input)}');
    }

    final withScheme = _ensureScheme(input);
    final uri = Uri.tryParse(withScheme);
    if (uri != null && uri.hasAuthority && uri.host.isNotEmpty) {
      return uri;
    }

    return Uri.parse('$_searchBase${Uri.encodeQueryComponent(input)}');
  }

  static bool _shouldSearch(String input) {
    if (input.contains(' ')) return true;

    final lower = input.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return false;
    }
    if (lower.startsWith('localhost') ||
        RegExp(r'^\d{1,3}(\.\d{1,3}){3}').hasMatch(input)) {
      return false;
    }

    final hostPart = input.split('/').first.split(':').first;
    if (hostPart.contains('.') &&
        !hostPart.startsWith('.') &&
        !hostPart.endsWith('.')) {
      return false;
    }

    return !input.contains('.');
  }

  static String _ensureScheme(String input) {
    final lower = input.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return input;
    }
    return 'https://$input';
  }

  /// Hiển thị gọn trong ô địa chỉ (bỏ https:// khi là cổng mặc định).
  static String displayForUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    final uri = Uri.tryParse(url);
    if (uri == null) return url;
    if (uri.scheme != 'http' && uri.scheme != 'https') return url;

    final defaultPort = uri.scheme == 'https' ? 443 : 80;
    final portSuffix =
        uri.hasPort && uri.port != defaultPort ? ':${uri.port}' : '';
    final path = uri.path == '/' ? '' : uri.path;
    final query = uri.hasQuery ? '?${uri.query}' : '';
    final fragment = uri.hasFragment ? '#${uri.fragment}' : '';
    return '${uri.host}$portSuffix$path$query$fragment';
  }
}
