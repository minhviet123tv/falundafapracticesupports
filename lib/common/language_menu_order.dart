/// Thứ tự menu chọn ngôn ngữ: English + Chinese lên đầu, còn lại theo ABC (label).
class LanguageMenuOrder {
  LanguageMenuOrder._();

  static bool _isEnglish(String name, String label) {
    final n = name.toLowerCase();
    final l = label.toLowerCase();
    return n == 'english' || l == 'english';
  }

  static bool _isChinese(String name, String label) {
    final n = name.toLowerCase();
    final l = label.toLowerCase();
    return n.contains('chinese') ||
        l.contains('chinese') ||
        l.contains('中文') ||
        l.contains('正體') ||
        l.contains('简体') ||
        l.contains('簡體');
  }

  /// 0 = traditional, 1 = simplified (và biến thể khác).
  static int _chineseSubOrder(String name, String label) {
    final n = name.toLowerCase();
    final l = label.toLowerCase();
    if (n.contains('traditional') ||
        n == 'chinese1' ||
        l.contains('正體') ||
        l.contains('繁') ||
        l.contains('traditional')) {
      return 0;
    }
    return 1;
  }

  /// [name]: enum `.name`; [label]: chữ hiện trên menu.
  static List<T> sort<T>(
    Iterable<T> items, {
    required String Function(T) name,
    required String Function(T) label,
  }) {
    final list = items.toList();
    list.sort((a, b) {
      final na = name(a);
      final nb = name(b);
      final la = label(a);
      final lb = label(b);

      final pa = _isEnglish(na, la)
          ? 0
          : (_isChinese(na, la) ? 1 : 2);
      final pb = _isEnglish(nb, lb)
          ? 0
          : (_isChinese(nb, lb) ? 1 : 2);
      if (pa != pb) return pa.compareTo(pb);

      if (pa == 1) {
        final ca = _chineseSubOrder(na, la);
        final cb = _chineseSubOrder(nb, lb);
        if (ca != cb) return ca.compareTo(cb);
        return la.toLowerCase().compareTo(lb.toLowerCase());
      }

      return la.toLowerCase().compareTo(lb.toLowerCase());
    });
    return list;
  }
}
