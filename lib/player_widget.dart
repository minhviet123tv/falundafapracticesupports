import 'package:flutter/material.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'menu/play_audio_webview.dart';
import 'download_from_url.dart';

//* Trang play nhạc luyện công
class PlayerWidget extends StatefulWidget {

  const PlayerWidget({super.key,}); // Hàm khởi tạo

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {

  //A. Dữ liệu
  late int indexCurrent = 0; // Vị trí đang được lựa chọn để play | Vị trí được chọn mặc định -> đầu list
  TextStyle textStyle18 = TextStyle(fontSize: 18, color: Colors.black);
  TextStyle textStyle16 = TextStyle(fontSize: 16, color: Colors.black);
  TextStyle styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20);

  // list chứa source trong assets | Vì dùng AssetsSource nên không cần ghi assets/ ở đầu
  List<AudioSourceModelInternet> listInternetSource = [
    AudioSourceModelInternet("Exercise 1", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_01.mp3"),
    AudioSourceModelInternet("Exercise 2", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_02.mp3"),
    AudioSourceModelInternet("Exercise 3", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_03.mp3"),
    AudioSourceModelInternet("Exercise 4", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_04.mp3"),
    AudioSourceModelInternet("Exercise 5", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_05.mp3"),
    AudioSourceModelInternet("发正念", "https://media.falundafa.org/media1/media/dafa/music/48k/fzn15.mp3"),
  ];

  //B. Khởi tạo
  @override
  void initState() {
    super.initState();
    _getIndexCurrent(); // Lấy indexCurrent (Thứ tự bài nhạc đã play gần nhất) lưu shared
  }

  //B.1 Lấy indexCurrent lưu shared
  _getIndexCurrent() async {
    final shared = await SharedPreferences.getInstance();
    int index = shared.getInt("indexCurrent_nhacluyencong") ?? 0;
    if(index >= listInternetSource.length){
      index = listInternetSource.length - 1;
    } else if(index < 0){
      index = 0;
    }
    indexCurrent = index;
    setState(() { }); // Cập nhật cho indexCurrent
  }

  //B.2 Lưu indexCurrent vào shared
  _setIndexCurrentShared(int index) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt("indexCurrent_nhacluyencong", index);
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(listInternetSource[indexCurrent].name, style: styleTextTitle,)),
        backgroundColor: Colors.blue,
      ),

      body: listViewItem(),
    );
  }

  //D.1 ListView danh sách bài hát, audio
  Widget listViewItem() {
    return ListView.builder(
      itemCount: listInternetSource.length, // list lấy từ Provider
      itemBuilder: (BuildContext context, int index) {

        // Container Item
        return GestureDetector(
          onTap: (){
            indexCurrent = index; // Cập nhật index cho Provider
            _setIndexCurrentShared(index); // Lưu index vào shared
            _playInWebview(index); // Mở trang play
            setState(() {}); //set state để cập nhật và tránh việc bị lag
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            // height: 50,
            // Phải cập nhật ở Provider để lấy đúng indexCurrent khi có thay đổi
            color: index == indexCurrent ? Colors.deepPurple[200] : Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //I. Tên item
                Text("${listInternetSource[index].name}", style: textStyle16, overflow: TextOverflow.ellipsis,),

                //II. Nhóm icon download và open in browser
                Row(
                  children: [

                    //1. Icon play (Chức năng giống như click vào item, nhưng để hiện nút cho dễ hiểu)
                    IconButton(
                      onPressed: (){
                        indexCurrent = index; // Cập nhật index cho Provider
                        _setIndexCurrentShared(index); // Lưu index vào shared
                        _playInWebview(index); // Mở trang play
                        setState(() {}); //set state để cập nhật và tránh việc bị lag
                      },
                      icon: Icon(Icons.play_circle_fill, color: Colors.orangeAccent,),
                    ),

                    //2. Widget download về máy (Đã tạo sẵn) -> Chọn kích thước phù hợp để hiển thị. Tạo lưu khi click
                    Container(
                      alignment: Alignment.center,
                      width: 60, height: 50,
                      child: InkWell(
                        onTap: (){
                          indexCurrent = index; // Cập nhật index cho Provider
                          _setIndexCurrentShared(index); // Lưu index vào shared
                          setState(() {}); // Cập nhật cho giao diện
                        },
                        child: DownloadFromUrl(url: listInternetSource[index].linkUrl,),
                      ),
                    ),

                    //3. Icon mở bên ngoài app bằng trình duyệt
                    IconButton(
                      onPressed: (){
                        _openInBrowser(Uri.parse(listInternetSource[index].linkUrl));
                        indexCurrent = index; // Cập nhật index cho Provider
                        _setIndexCurrentShared(index); // Lưu index vào shared
                        setState(() {}); // Cập nhật cho giao diện
                      },
                      icon: Icon(Icons.open_in_new),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  //E.1 Trang play audio bằng Webview
  _playInWebview(int index){
    Navigator.push(context, MaterialPageRoute(builder: (builder){
      return WebViewBrowserAudio(linkUrl: '${listInternetSource[index].linkUrl}', title: '${listInternetSource[index].name}',);
    }));
  }

  //E.2 Mở url ở trình duyệt website
  Future<void> _openInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $url');
    }
  }

}

// Tạo model truyền thông tin internet source
class AudioSourceModelInternet{
  String name;
  String linkUrl;

  AudioSourceModelInternet(this.name, this.linkUrl);
}
