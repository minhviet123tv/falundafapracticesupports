import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Lưu trạng thái đọc sách ZFL theo từng ngôn ngữ: URL cuối, lịch sử trang, vị trí cuộn.
class BookWebViewStateStore {
  static const String _keyPrefix = 'zfl_book_reading_state_v2_';

  static String _keyForLanguage(String languageCode) => '$_keyPrefix$languageCode';

  static Future<BookReadingState> load(String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    final raw = shared.getString(_keyForLanguage(languageCode));
    if (raw == null || raw.isEmpty) {
      return BookReadingState.empty();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return BookReadingState.empty();
      }
      return BookReadingState.fromJson(decoded.cast<String, dynamic>());
    } catch (_) {
      return BookReadingState.empty();
    }
  }

  static Future<void> save(String languageCode, BookReadingState state) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(
      _keyForLanguage(languageCode),
      jsonEncode(state.toJson()),
    );
  }
}

/// Vị trí đọc: pixel (cùng thiết bị) + tỷ lệ 0..1 (ổn định hơn khi đổi kích thước màn hình).
class BookScrollPosition {
  final double scrollY;
  final double scrollRatio;

  const BookScrollPosition({
    required this.scrollY,
    required this.scrollRatio,
  });

  factory BookScrollPosition.fromJson(dynamic json) {
    if (json is num) {
      return BookScrollPosition(scrollY: json.toDouble(), scrollRatio: 0);
    }
    if (json is Map) {
      final y = json['y'];
      final ratio = json['ratio'];
      return BookScrollPosition(
        scrollY: y is num ? y.toDouble() : 0,
        scrollRatio: ratio is num ? ratio.clamp(0.0, 1.0).toDouble() : 0,
      );
    }
    return const BookScrollPosition(scrollY: 0, scrollRatio: 0);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'y': scrollY,
        'ratio': scrollRatio,
      };
}

class BookReadingState {
  final String? lastUrl;
  final List<String> history;
  final int historyIndex;
  final Map<String, BookScrollPosition> scrollByUrl;

  const BookReadingState({
    this.lastUrl,
    this.history = const <String>[],
    this.historyIndex = 0,
    this.scrollByUrl = const <String, BookScrollPosition>{},
  });

  factory BookReadingState.empty() => const BookReadingState();

  factory BookReadingState.fromJson(Map<String, dynamic> json) {
    final historyRaw = json['history'];
    final scrollRaw = json['scrollByUrl'];

    final history = <String>[];
    if (historyRaw is List) {
      for (final item in historyRaw) {
        if (item is String && item.isNotEmpty) {
          history.add(item);
        }
      }
    }

    final scrollByUrl = <String, BookScrollPosition>{};
    if (scrollRaw is Map) {
      scrollRaw.forEach((key, value) {
        if (key is String) {
          scrollByUrl[key] = BookScrollPosition.fromJson(value);
        }
      });
    }

    var historyIndex = json['historyIndex'];
    if (historyIndex is! int) {
      historyIndex = history.isEmpty ? 0 : history.length - 1;
    }
    if (history.isNotEmpty) {
      if (historyIndex < 0) historyIndex = 0;
      if (historyIndex >= history.length) historyIndex = history.length - 1;
    } else {
      historyIndex = 0;
    }

    return BookReadingState(
      lastUrl: json['lastUrl'] is String ? json['lastUrl'] as String : null,
      history: history,
      historyIndex: historyIndex,
      scrollByUrl: scrollByUrl,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lastUrl': lastUrl,
        'history': history,
        'historyIndex': historyIndex,
        'scrollByUrl': scrollByUrl.map(
          (key, value) => MapEntry(key, value.toJson()),
        ),
      };

  BookScrollPosition? scrollForUrl(String url) => scrollByUrl[url];

  BookReadingState withScroll(String url, BookScrollPosition position) {
    if (position.scrollY <= 0 && position.scrollRatio <= 0) {
      return this;
    }
    final nextScroll = Map<String, BookScrollPosition>.from(scrollByUrl);
    nextScroll[url] = position;
    return BookReadingState(
      lastUrl: lastUrl,
      history: history,
      historyIndex: historyIndex,
      scrollByUrl: nextScroll,
    );
  }

  /// Chỉ giữ vị trí cuộn của trang đang đọc (một URL).
  BookReadingState withOnlyCurrentScroll(
    String urlKey,
    BookScrollPosition position,
  ) {
    final map = <String, BookScrollPosition>{};
    if (position.scrollY > 0 || position.scrollRatio > 0) {
      map[urlKey] = position;
    }
    return BookReadingState(
      lastUrl: lastUrl,
      history: history,
      historyIndex: historyIndex,
      scrollByUrl: map,
    );
  }

  /// Xóa vị trí đã lưu — dùng khi người dùng mở lại link (xem từ đầu).
  BookReadingState withoutScrollForUrl(String urlKey) {
    if (!scrollByUrl.containsKey(urlKey)) return this;
    final nextScroll = Map<String, BookScrollPosition>.from(scrollByUrl);
    nextScroll.remove(urlKey);
    return BookReadingState(
      lastUrl: lastUrl,
      history: history,
      historyIndex: historyIndex,
      scrollByUrl: nextScroll,
    );
  }

  BookReadingState withNavigation({
    required String url,
    required List<String> history,
    required int historyIndex,
  }) {
    return BookReadingState(
      lastUrl: url,
      history: history,
      historyIndex: historyIndex,
      scrollByUrl: scrollByUrl,
    );
  }
}
