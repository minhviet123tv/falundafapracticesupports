import 'package:flutter/foundation.dart';

/// Tab Book: ẩn menu bottom app khi chế độ đọc mở rộng (immersive).
class BookTabChrome {
  BookTabChrome._();

  static final ValueNotifier<bool> immersive = ValueNotifier<bool>(false);
}
