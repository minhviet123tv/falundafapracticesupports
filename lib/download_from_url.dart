import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

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
  DownloadFromUrl({required this.url, super.key,});
  @override
  State<DownloadFromUrl> createState() => _DownloadFromUrlState();
}

class _DownloadFromUrlState extends State<DownloadFromUrl> {

  //A. Dữ liệu
  double? _progress = 0.0;
  String? _fileName = "";
  bool downloadDone = false;
  late bool showLoading = false;

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
          if(downloadDone == true) Icon(Icons.check, color: Colors.green,),
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
      onDownloadCompleted: (path) {
        setState(() {
          _progress = 0.0; // Trả lại tiến trình (progress) về điểm bắt đầu
          downloadDone = true; // Xác nhận tình trạng download
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Files/downloads/$_fileName"))); // Hiện tên fileName, còn Files/downloads chỉ mang tính mô tả, nhưng đúng trên khá nhiều thiết bị kiểu chỗ quản lí file/downloads
        // print('path source:  $path '); // path: Đường dẫn chứa file tải về
      }
    );
  }
}
