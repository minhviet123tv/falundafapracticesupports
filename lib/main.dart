import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';

import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'player_widget.dart';
import 'player_widget_9baigiang.dart';

import 'menu/all_books_webview.dart';
import 'menu_huongdan_page.dart';

/*
audioplayers: ^6.0.0
Ứng dụng play audio: Khi mở thì sẽ tải play luôn
 */

//*I Main
void main() {
  runApp(RunAppFalunDafaExercise());
}

//*II.1 Run App
class RunAppFalunDafaExercise extends StatefulWidget {
  @override
  State<RunAppFalunDafaExercise> createState() => _RunAppFalunDafaExerciseState();
}

//*II.2 Run App State: Đếm số lần login để chọn widget khi mới vào app
class _RunAppFalunDafaExerciseState extends State<RunAppFalunDafaExercise> {

  //A. Dữ liệu
  late int? countLoginNumber = 10; // Đếm số lần login lưu, load trong shared (đặt sẵn số load trang home, tránh hiện intro nhiều lần về sau khi chưa load kịp)
  static const String countKeyName = "countLogin";


  //B. Khởi tạo
  @override
  void initState() {
    super.initState();
    _checkForUpdateAll(); // update app
    _countLogin(); //Đếm số lần login

  }

  //B.1 Hàm đếm số lần login lưu trong shared -> Mỗi lần gọi sẽ trả về số tăng 1 lần lưu trong shared -> Chỉ nên gọi 1 lần trong init và gán cho biến toàn cục để sử dụng
  Future<void> _countLogin() async {
    final shared = await SharedPreferences.getInstance();
    int count = shared.getInt(countKeyName) ?? 0; // Lấy số đã lưu | Giá trị mặc định là 10 (tránh hiện intro nhiều lần về sau khi chưa load kịp)
    count++; // Tăng một lần đếm
    countLoginNumber = count; // Gán cho biến toàn cục (nhanh nhất có thể để kịp load cho trang)
    shared.setInt(countKeyName, count); // Lưu vào shared
    // print(count.toString());
    setState(() { }); // Phải cập nhật lại (UI) theo biến toàn cục (vì khi mới mở chưa có giá trị)
  }

  //B.2 Tổng hợp update
  Future<void> _checkForUpdateAll() async {

    late AppUpdateInfo updateInfoHere; // Thông tin về update
    bool flexibleUpdateAvailableHere = false; // Được update linh hoạt

    //1. Kiểm tra xem có update được không
    await InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        updateInfoHere = info;
      });
    }).catchError((e) {
      print(e.toString());
    });

    //2. Thực hiện Cập nhật ngay lập tức
    if(updateInfoHere.updateAvailability == UpdateAvailability.updateAvailable){
      await InAppUpdate.performImmediateUpdate().catchError((e) {
        print(e.toString());
        return AppUpdateResult.inAppUpdateFailed;
      });
    }

    //3. Bắt đầu cập nhật linh hoạt
    if(updateInfoHere.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.startFlexibleUpdate().then((_) {
        setState(() {
          flexibleUpdateAvailableHere = true; // Có sẵn bản cập nhật linh hoạt
        });
      }).catchError((e) {
        print(e.toString());
      });
    }

    //4. Hoàn thành cập nhật linh hoạt
    if(flexibleUpdateAvailableHere) {
      await InAppUpdate.completeFlexibleUpdate().then((_) {
        print("Update success");
      }).catchError((e) {
        print(e.toString());
      });
    }

  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      home: SafeArea (
        child: _getHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  // Widget trang home page (hoặc intro nếu là lần đầu) | list các trang PageViewModel ở file intro_list_widget_body.dart
  Widget _getHomePage (){
    // return FalunDafaExerciseHomePage();
    if((countLoginNumber ?? 0)  < 2){
      return IntroductionScreenWidget(listPageViewModel: listPageViewModelGioiThieuApp, setPageIntro: SetPageIntro.molandau,);
    } else {
      return FalunDafaExerciseHomePage();
    }
  }
}

//*III. Home page (Trang main chính)
class FalunDafaExerciseHomePage extends StatefulWidget {
  const FalunDafaExerciseHomePage();

  @override
  _FalunDafaExerciseHomePageState createState() => _FalunDafaExerciseHomePageState();
}

class _FalunDafaExerciseHomePageState extends State<FalunDafaExerciseHomePage> {

  //A. Dữ liệu | List widget body của menu bottom
  late List<Widget> listWidgetBody = []; // Danh sách các trang widget
  late int indexMenu;
  late String title;
  var styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w700);

  //B. Khởi tạo khi mới vào app
  @override
  void initState() {
    super.initState();

    //B.1 List widget body của page
    listWidgetBody = [
      MenuHuongDanPage(),
      AllBooksWebview(),
      PlayerWidget9Baigiang(), // Không thể cùng lúc dùng 1 trang widget (Có khung Scaffold) 2 lần -> nên tạo 2 trang (Đồng thời tạo sẵn list link)
      PlayerWidget(),
    ];

    indexMenu = 0;
    _getIndexMenu(); // Load thứ tự menu
  }

  //B.1 Load index của menu bottom được lưu trong shared
  Future<void> _getIndexMenu() async {
    final shared = await SharedPreferences.getInstance();
    int indexSelectedHere = shared.getInt("index_menu_bottom") ?? 0;

    // Đề phòng trường hợp lưu index vượt quá số lượng của list widget
    if(indexSelectedHere > listWidgetBody.length -1){
      indexSelectedHere = listWidgetBody.length -1;
    }
    indexMenu = indexSelectedHere;
    setState(() { });
  }

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //I. Body: Load indexSelected để lấy widget trong list
      body: Center(child: listWidgetBody[indexMenu]),
      backgroundColor: Colors.white, // Màu nền chung cho trang

      //II. Bottom NavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexMenu, //Chỉ định index được chọn trong menu (Tương ứng với listWidgetBody)
        selectedItemColor: Colors.red,
        items: [

          //4. Menu lựa chọn
          const BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.black,),
              label: "Home"
          ),

          //3. Menu đọc sách
          const BottomNavigationBarItem(
              icon: Icon(Icons.menu_book, color: Colors.black),
              label: "Books"
          ),

          //2. Menu audio 09 bài giảng
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/icon_bottom_lotus.png", width: 30, height: 30,),
            label: "9 Lesson",
          ),

          //1. Menu nhạc luyện công
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/icon_bottom_meditation.png", width: 20, height: 20,), // Icon(Icons.accessibility) | Image.asset("assets/images/meditation_3.png", width: 20, height: 20,)
            label: "Practice",
          ),

        ],

        // Xử lý khi click vào từng menu bottom
        onTap: (index){
          indexMenu = index;
          saveMenuBottom(index); // Lưu index của menu bottom vào shared
          setState(() { }); // Cập nhật dữ liệu của trang
        },
      ),
    );
  }

  //D.1 Lưu menu bottom vào shared
  Future<void> saveMenuBottom(int indexMenuBottom) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt("index_menu_bottom", indexMenuBottom);
  }


}