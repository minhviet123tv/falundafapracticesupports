import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';
import 'package:falun_dafa_practice_supports/common/offline_audio_helper.dart';

/*
Tạo Widget hiện nút tải -> loading chờ tải -> hiện % download -> Báo download xong
Chỉ việc điền url vào là dùng được

Cài: flutter_file_downloader: ^1.1.0+1 #download any file
Chú ý: Cần cấp quyền truy cập file (Có thể phải khai báo cả trên google play)
 */

// void main(){
//   runApp(MaterialApp(home: SafeArea(child: SingleDownloadFromUrl(url: "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_01.mp3",),),));
// }

class DownloadFromUrl extends StatefulWidget {
  final String url;
  final ValueChanged<String>? onDownloadCompleted;
  final ValueChanged<bool>? onDownloadStateChanged;
  DownloadFromUrl({
    required this.url,
    this.onDownloadCompleted,
    this.onDownloadStateChanged,
    super.key,
  });
  @override
  State<DownloadFromUrl> createState() => _DownloadFromUrlState();
}

class _DownloadFromUrlState extends State<DownloadFromUrl> {

  //A. Dữ liệu
  double? _progress = 0.0;
  String? _fileName = "";
  bool downloadDone = false;
  late bool showLoading = false;
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _syncDownloadStatus();
  }

  //D. Widget
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Ẩn hiện các widget theo tình trạng loading của _progress
          //1. Nút bấm download dữ liệu từ url
          if(_progress == 0 && downloadDone == false && showLoading == false)
          IconButton(
            onPressed: (){
              downloadDone = false; // Cập nhật tình trạng là chưa download
              _download(widget.url.trim()); // Thực hiện download dữ liệu của url
              showLoading = true; // Hiện icon loading
              setState(() {});
            },
            icon: Icon(Icons.download, color: Colors.deepPurple,),
          ),

          if(showLoading == true) Container(width: 20, height: 20, child: Center(child: CircularProgressIndicator(),),),

          //2. Hiện cập nhật % download
          if(_progress != 0) Text("$_progress %"),

          //3. Hiện thông báo sau khi download xong
          if(downloadDone == true)
            IconButton(
              onPressed: () => unawaited(_confirmResetDownload()),
              tooltip: 'Reset bản tải về',
              icon: const Icon(Icons.check, color: Colors.green),
            ),
        ],
      ),
    );
  }

  //D.1 Thực hiện download dữ liệu của url
  _download(String url){

    FileDownloader.downloadFile(
      url: url, // Đường link url

      // Sự kiện khi thay đổi progress (load được từng %)
      onProgress: (name, progress) {
        setState(() {
          _progress = progress;
          _fileName = name;
          Future.delayed(Duration(milliseconds: 200), (){
            showLoading = false; // Ẩn icon loading progress sau thời gian đã chọn | Chờ để tránh đổi tín hiệu quá nhanh | Có thể sẽ cập nhật giao diện theo showLoading vào lần progress sau (Dù sao cũng sẽ có khoảng 2 lần progress trở lên, rất hiếm khi có 1, mà có 1 cũng không ảnh hưởng vì sẽ downloadDone)
          });
        });
        // print('name of download file: $name'); // Tên file
      },

      // Sự kiện sau khi hoàn thành (tải xong)
      onDownloadCompleted: (path) async {
        _localPath = OfflineAudioHelper.normalizeLocalPath(path);
        await DownloadedAudioStore.save(widget.url.trim(), _localPath!);
        if (!mounted) return;
        setState(() {
          _progress = 0.0;
          downloadDone = true;
        });
        widget.onDownloadStateChanged?.call(true);
        widget.onDownloadCompleted?.call(_localPath!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tải xong — có thể phát offline.')),
        );
      },
      onDownloadError: (message) {
        if (!mounted) return;
        setState(() {
          showLoading = false;
          _progress = 0.0;
          downloadDone = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Tải xuống thất bại: $message")));
      },
    );
  }

  Future<void> _syncDownloadStatus() async {
    final localPath =
        await DownloadedAudioStore.resolveExistingLocalPath(widget.url.trim());
    if (!mounted) return;
    setState(() {
      _localPath = localPath;
      downloadDone = localPath != null;
    });
    widget.onDownloadStateChanged?.call(downloadDone);
    if (localPath != null) {
      widget.onDownloadCompleted?.call(localPath);
    }
  }

  Future<void> _confirmResetDownload() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          actionsPadding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
          actionsAlignment: MainAxisAlignment.center,
          title: Row(
            children: const [
              Icon(Icons.restart_alt, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                "Reset track",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: const Text(
            "Do you want to reset this track?",
            style: TextStyle(fontSize: 15, height: 1.3),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(110, 42),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(110, 42),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;
    await _resetDownloadedFile();
  }

  Future<void> _resetDownloadedFile() async {
    final targetPath = _localPath ??
        await DownloadedAudioStore.resolveExistingLocalPath(widget.url.trim());
    if (targetPath != null && targetPath.isNotEmpty) {
      final file = File(OfflineAudioHelper.normalizeLocalPath(targetPath));
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('Reset audio delete failed: $e');
        }
      }
    }

    await DownloadedAudioStore.remove(widget.url.trim());

    if (!mounted) return;
    setState(() {
      _localPath = null;
      _progress = 0.0;
      downloadDone = false;
      showLoading = false;
      _fileName = "";
    });
    widget.onDownloadStateChanged?.call(false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã reset bản tải về.')),
    );
  }
}
