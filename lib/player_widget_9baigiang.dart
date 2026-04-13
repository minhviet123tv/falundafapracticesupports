import 'package:flutter/material.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'link_and_api/link_internet_list_baigiang_quocte.dart';
import 'menu/play_audio_webview.dart';
import 'download_from_url.dart';

//* PlayerWidget9Baigiang
class PlayerWidget9Baigiang extends StatefulWidget {

  const PlayerWidget9Baigiang({super.key,});  // Hàm khởi tạo

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget9Baigiang> {

  //A.1 Dữ liệu
  late int indexCurrent = 0; // Vị trí đang được lựa chọn để play
  TextStyle textStyle18 = TextStyle(fontSize: 18, color: Colors.black);
  TextStyle textStyle16 = TextStyle(fontSize: 16, color: Colors.black);
  var styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20);
  double border10 = 10.0;
  late LanguageNameAndCode languageNameAndCode; // Xác định ngôn ngữ theo enum tự tạo

  //A.2 list ban đầu (chứa source trong assets hoặc source internet)
  List<AudioSourceModelInternet> listInternetSource = [
    AudioSourceModelInternet("Lesson 1", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-1-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 2", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-2-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 3", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-3-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 4", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-4-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 5", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-5-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 6", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-6-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 7", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-7-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 8", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-8-Lecture.mp3", ""),
    AudioSourceModelInternet("Lesson 9", "https://media.falundafa.org/media1/media/dafa/eng/mp3/En-9-Lecture.mp3", "")
  ]; // Để sẵn nhằm phục vụ khi chưa load xong

  //B. Khởi tạo
  @override
  void initState() {
    super.initState();

    //1. Cài đặt cơ bản ban đầu cho player
    _getIndexCurrent(); // Lấy indexCurrent lưu shared

    //2. Khởi tạo ngôn ngữ được chọn
    languageNameAndCode = LanguageNameAndCode.english; // Tạo sẵn phục vụ load khi chưa lấy xong từ shared
    _getLanguageEnum(); // cập nhật ngôn ngữ theo như lưu trong shared
  }

  //B.1.1 Lấy indexCurrent (bài xem cuối trong trang) lưu shared
  _getIndexCurrent() async {
    final shared = await SharedPreferences.getInstance();
    int index = shared.getInt("indexCurrent_baigiang") ?? 0;
    if(index >= listInternetSource.length){
      index = listInternetSource.length - 1;
    } else if(index < 0){
      index = 0;
    }
    setState((){
      indexCurrent = index; // Cập nhật cho indexCurrent
    });
  }

  //B.1.2 Lưu indexCurrent vào shared
  _setIndexCurrentShared(int index) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt("indexCurrent_baigiang", index);
  }

  //B.2.1 Hàm lấy ngôn ngữ được chọn lưu Shared -> gán cho biến toàn cục (Dùng phục vụ khi mới mở tab trang)
  Future<void> _getLanguageEnum() async {
    final shared = await SharedPreferences.getInstance();
    String languageEnum = await shared.getString("languageEnum") ?? "vietnamese";
    languageNameAndCode = LanguageNameAndCode.values.byName(languageEnum); // Đổi String lưu shared sang enum
    await _getListInternetSource (); // lấy listInternetSource theo languageNameAndCode (Sau khi đã lấy được ngôn ngữ lưu trong shared)
    setState((){}); // Cập nhật ngôn ngữ
  }

  //B.2.2 Hàm lưu ngôn ngữ trong Shared
  Future<void> _setLanguageEnum(LanguageNameAndCode languageNameAndCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString("languageEnum", languageNameAndCode.name); // Lưu tên đơn
  }

  //B.3 Chọn list link source theo enum ngôn ngữ
  Future<void> _getListInternetSource () async {
    if(languageNameAndCode == LanguageNameAndCode.chinese){
      listInternetSource = listInternetSourceChinese.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal); // Dùng .map để chuyển về đối tượng cho listInternetSource
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.english){
      listInternetSource = listInternetSourceEnglish.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.bosanski){
      listInternetSource = listInternetSourceBosanski.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.belarus){
      listInternetSource = listInternetSourceBelarus.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.bulgarian){
      listInternetSource = listInternetSourceBulgarian.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.cesky){
      listInternetSource = listInternetSourceCesky.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.deutsch){
      listInternetSource = listInternetSourceDeutsch.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.espanol){
      listInternetSource = listInternetSourceEspanol.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.greek){
      listInternetSource = listInternetSourceGreek.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.persian){
      listInternetSource = listInternetSourcePersian.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.french){
      listInternetSource = listInternetSourceFrench.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.hebrew){
      listInternetSource = listInternetSourceHebrew.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.hrvatski){
      listInternetSource = listInternetSourceHrvatski.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.italiano){
      listInternetSource = listInternetSourceItaliano.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.magyar){
      listInternetSource = listInternetSourceMagyar.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.macedonia){
      listInternetSource = listInternetSourceMacedonia.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.japan){
      listInternetSource = listInternetSourceJapan.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.polski){
      listInternetSource = listInternetSourcePolski.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.portugues){
      listInternetSource = listInternetSourcePortugues.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    } else if (languageNameAndCode == LanguageNameAndCode.rumani){
      listInternetSource = listInternetSourceRumani.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.suomi){
      listInternetSource = listInternetSourceSuomi.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.svenska){
      listInternetSource = listInternetSourceSvenska.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.korean){
      listInternetSource = listInternetSourceKorean.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.thai){
      listInternetSource = listInternetSourceThai.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.turkce){
      listInternetSource = listInternetSourceTurkce.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.ukraina){
      listInternetSource = listInternetSourceUkrainian.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    else if (languageNameAndCode == LanguageNameAndCode.vietnamese){
      listInternetSource = listInternetSourceVietnamese.map((element){
        return AudioSourceModelInternet(element.name, element.linkUrl, element.timeTotal);
      }).toList();
    }
    setState((){}); // Cập nhật list theo ngôn ngữ
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(listInternetSource[indexCurrent].name, style: styleTextTitle,)),
        toolbarHeight: 60, // Chiều cao của AppBar
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(border10)), // Bo viền container
              color: Colors.transparent,
            ),

            // DropdownMenu chọn ngôn ngữ
            child: DropdownMenu<LanguageNameAndCode>(
              initialSelection: languageNameAndCode, // Mới mở thì đặt theo ngôn ngữ đã khởi tạo trong init hoặc đã lấy từ shared
              textStyle: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w500), // Kiểu dáng, màu, cỡ chữ hiển thị của giá trị đã được chọn
              // menuHeight: 300, // Chiều dài tối đa của bảng menu được mở ra
              // width: 120, // Chiều rộng của nút chọn menu
              // helperText: "Select language", // Gợi ý dưới nút chọn
              inputDecorationTheme: InputDecorationTheme(
                // constraints: BoxConstraints(), // Giới hạn kích thước nếu cần thiết
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(border10),
                ),
                enabledBorder: OutlineInputBorder( // Viền ngoài của cả DropdownMenu
                  borderRadius: BorderRadius.circular(border10),
                  borderSide: BorderSide(color: Colors.white70), // Màu viền ngoài
                ),
              ),

              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white), // Màu nền của item được chọn
                surfaceTintColor: WidgetStatePropertyAll(Colors.white), // màu ánh nền
                shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)), // Góc bo viền của viền bên ngoài
                ),
              ),

              // Thực hiện khi bấm chọn (Sử dụng giá trị của đối tượng)
              onSelected: (LanguageNameAndCode? value) {
                setState(() {
                  languageNameAndCode = value!; // Cập nhật enum ngôn ngữ
                  _getListInternetSource(); // Cập nhật list link theo ngôn ngữ toàn cục | Không _getLanguageEnum() nữa vì biến toàn cục đã được cập nhật
                  _setLanguageEnum(languageNameAndCode); // Lưu luôn vào trong shared
                });
              },

              // Gán nhãn giá trị trong list ngôn ngữ vào list lựa chọn của button
              dropdownMenuEntries: LanguageNameAndCode.values.map<DropdownMenuEntry<LanguageNameAndCode>>((LanguageNameAndCode value) {
                return DropdownMenuEntry<LanguageNameAndCode>(
                  value: value,
                  label: value.tengoc,
                  style: MenuItemButton.styleFrom(
                    foregroundColor: Colors.black, //text color
                    backgroundColor: Colors.white, //unselected background color,
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),

      body: listViewItem(),
      // floatingActionButton: ElevatedButton(onPressed: () {  }, child: Text("Language"),),
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
            indexCurrent = index; // Cập nhật index
            _setIndexCurrentShared(index); // Lưu shared
            setState(() { }); // Cập nhật index được chọn trên UI
            _playInWebview(index); // Mở trình duyệt play theo link source

          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            height: 50,
            color: index == indexCurrent ? Colors.deepPurple[200] : Colors.grey[200], // Phải cập nhật ở Provider để lấy đúng indexCurrent khi có thay đổi
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                //I. Tên item
                Text("${listInternetSource[index].name}", style: textStyle16,),

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

                    //2. Widget download về máy (Đã tạo sẵn) -> Chọn kích thước phù hợp để hiển thị
                    Container(
                      alignment: Alignment.center,
                      width: 60, height: 50,
                      child: InkWell(
                        onTap: (){
                          indexCurrent = index; // Cập nhật index cho Provider
                          _setIndexCurrentShared(index); // Lưu index vào shared
                          setState(() {}); // Cập nhật cho giao diện
                        },
                        child: DownloadFromUrl(url: listInternetSource[index].linkUrl,)
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

// Tạo model truyền thông tin source
class AudioSourceModelInternet{
  String name;
  String linkUrl;
  String timeTotal;

  AudioSourceModelInternet(this.name, this.linkUrl, this.timeTotal);
}