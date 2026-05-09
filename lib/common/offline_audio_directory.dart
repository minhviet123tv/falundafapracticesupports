/// Thư mục lưu file âm thanh tải về — nằm dưới Documents của app.
///
/// Trên iOS, với `UIFileSharingEnabled`, người dùng thấy trong **Files → Trên iPhone của tôi → [tên app]**
/// các thư mục con tương ứng; có thể xoá / đổi tên trong Files hoặc qua app như đường dẫn file thông thường.
class OfflineAudioDirectory {
  OfflineAudioDirectory._();

  /// Dùng tên dễ nhận (trùng branding app). Chỉ dùng ký tự hợp lệ trong tên đường dẫn.
  static const String appFolderName = 'Falun_Dafa_Practice_Supports';
  static const String audioSubfolder = 'Audio';

  /// Đường dẫn tương đối so với `BaseDirectory.applicationDocuments`
  /// (không có / đầu; dùng / giữa các phần).
  static String get relativePath =>
      '${appFolderName.replaceAll(RegExp(r'[/\\]+'), '_')}/$audioSubfolder';
}
