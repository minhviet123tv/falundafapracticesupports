import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';

import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'player_widget.dart';
import 'player_widget_9baigiang.dart';

import 'menu/chuyen_phap_luan_webview.dart';
import 'menu_huongdan_page.dart';
import 'common/memory_config.dart';
import 'common/memory_monitor.dart';

/*
audioplayers: ^6.0.0
Ứng dụng play audio: Khi mở thì sẽ tải play luôn
 */

//*I Main
void main() async {
  // Cấu hình để tối ưu hóa bộ nhớ và đảm bảo kích thước trang 16 KB
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo cấu hình bộ nhớ
  await MemoryConfig.initialize();
  
  runApp(RunAppFalunDafaExercise());
}

//*II.1 Run App
class RunAppFalunDafaExercise extends StatefulWidget {
  @override
  State<RunAppFalunDafaExercise> createState() => _RunAppFalunDafaExerciseState();
}

//*II.2 Run App State: Đếm số lần login để chọn widget khi mới vào app
class _RunAppFalunDafaExerciseState extends State<RunAppFalunDafaExercise> 
    with AutomaticKeepAliveClientMixin {

  //A. Dữ liệu - Tối ưu hóa bộ nhớ
  int? countLoginNumber = 10; // Đếm số lần login lưu, load trong shared (đặt sẵn số load trang home, tránh hiện intro nhiều lần về sau khi chưa load kịp)
  static const String countKeyName = "countLogin";
  
  // Cache SharedPreferences để tránh load lại nhiều lần
  SharedPreferences? _sharedPreferences;
  
  @override
  bool get wantKeepAlive => true; // Giữ state để tối ưu hóa bộ nhớ


  //B. Khởi tạo
  @override
  void initState() {
    super.initState();
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin
    
    // Khởi tạo SharedPreferences cache
    _initializeSharedPreferences();
    
    // Tránh tranh chấp main thread lúc khởi động (WebView / Play Core).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_checkForUpdateAll());
    });
    _countLogin(); //Đếm số lần login
  }
  
  // Khởi tạo SharedPreferences cache để tối ưu hóa bộ nhớ
  Future<void> _initializeSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  //B.1 Hàm đếm số lần login lưu trong shared -> Tối ưu hóa bộ nhớ với cache
  Future<void> _countLogin() async {
    // Sử dụng cache SharedPreferences để tránh load lại
    _sharedPreferences ??= await SharedPreferences.getInstance();
    
    int count = _sharedPreferences!.getInt(countKeyName) ?? 0; // Lấy số đã lưu | Giá trị mặc định là 10 (tránh hiện intro nhiều lần về sau khi chưa load kịp)
    count++; // Tăng một lần đếm
    countLoginNumber = count; // Gán cho biến toàn cục (nhanh nhất có thể để kịp load cho trang)
    
    // Lưu vào shared với tối ưu hóa bộ nhớ
    await _sharedPreferences!.setInt(countKeyName, count);
    
    // Chỉ cập nhật UI nếu widget vẫn mounted (gắn kết) để tránh memory leak
    if (mounted) {
      setState(() { }); // Phải cập nhật lại (UI) theo biến toàn cục (vì khi mới mở chưa có giá trị)
    }
  }

  //B.2 Tổng hợp update - Tối ưu hóa bộ nhớ
  Future<void> _checkForUpdateAll() async {
    try {
      late AppUpdateInfo updateInfoHere; // Thông tin về update
      bool flexibleUpdateAvailableHere = false; // Được update linh hoạt

      //1. Kiểm tra xem có update được không
      updateInfoHere = await InAppUpdate.checkForUpdate();
      
      // Chỉ cập nhật UI nếu widget vẫn mounted
      if (mounted) {
        setState(() {});
      }

      //2. Thực hiện Cập nhật ngay lập tức
      if(updateInfoHere.updateAvailability == UpdateAvailability.updateAvailable){
        await InAppUpdate.performImmediateUpdate();
      }

      //3. Bắt đầu cập nhật linh hoạt
      if(updateInfoHere.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
        
        if (mounted) {
          setState(() {
            flexibleUpdateAvailableHere = true; // Có sẵn bản cập nhật linh hoạt
          });
        }
      }

      //4. Hoàn thành cập nhật linh hoạt
      if(flexibleUpdateAvailableHere) {
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (e) {
      // Xử lý lỗi một cách an toàn để tránh crash
      debugPrint("Update error: $e");
    }
  }

  //D. Trang - Tối ưu hóa bộ nhớ
  @override
  Widget build(BuildContext context) {
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin
    
    return MaterialApp (
      home: MemoryMonitor(
        showMemoryInfo: false, // Có thể bật để debug
        child: SafeArea (
          child: _getHomePage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      // Tối ưu hóa bộ nhớ cho MaterialApp
      theme: ThemeData(
        useMaterial3: true,
        // Giảm thiểu việc tạo ra các object không cần thiết
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }

  // Widget trang home page (hoặc intro nếu là lần <2) | list các trang PageViewModel ở file intro_list_widget_body.dart
  Widget _getHomePage (){
    // return FalunDafaExerciseHomePage();
    if((countLoginNumber ?? 0) < 2){
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

class _FalunDafaExerciseHomePageState extends State<FalunDafaExerciseHomePage> 
    with AutomaticKeepAliveClientMixin {

  static const int _navItemCount = 4;

  // Chỉ tạo tab khi người dùng mở lần đầu — tránh khởi tạo WebView + AudioPlayer cùng lúc.
  final Map<int, Widget> _tabWidgets = <int, Widget>{};
  int indexMenu = 0;
  String title = '';
  final TextStyle styleTextTitle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w700);
  
  // Cache SharedPreferences để tối ưu hóa bộ nhớ
  SharedPreferences? _sharedPreferences;
  
  @override
  bool get wantKeepAlive => true; // Giữ state để tối ưu hóa bộ nhớ

  //B. Khởi tạo khi mới vào app - Tối ưu hóa bộ nhớ
  @override
  void initState() {
    super.initState();
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin
    
    // Khởi tạo SharedPreferences cache
    _initializeSharedPreferences();
    
    indexMenu = 0;
    _getIndexMenu(); // Load thứ tự menu
  }
  
  // Khởi tạo SharedPreferences cache để tối ưu hóa bộ nhớ
  Future<void> _initializeSharedPreferences() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }
  
  int _bodyIndexForNav(int navIndex) {
    switch (navIndex) {
      case 2:
        return 1;
      case 3:
        return 2;
      default:
        return 0;
    }
  }

  Widget _createTab(int bodyIndex) {
    switch (bodyIndex) {
      case 0:
        return MenuHome();
      case 1:
        return PlayerWidget9Baigiang();
      case 2:
        return PlayerWidget();
      default:
        return MenuHome();
    }
  }

  Widget _tabForNavIndex(int navIndex) {
    final bodyIndex = _bodyIndexForNav(navIndex);
    return _tabWidgets.putIfAbsent(bodyIndex, () => _createTab(bodyIndex));
  }

  void _openBookWebview() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ChuyenPhapLuanWebview(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  //B.1 Load index của menu bottom được lưu trong shared - Tối ưu hóa bộ nhớ
  Future<void> _getIndexMenu() async {
    // Sử dụng cache SharedPreferences để tránh load lại
    _sharedPreferences ??= await SharedPreferences.getInstance();
    
    var indexSelectedHere = _sharedPreferences!.getInt("index_menu_bottom") ?? 0;

    if (indexSelectedHere > _navItemCount - 1) {
      indexSelectedHere = _navItemCount - 1;
    }
    // Book mở trang riêng — không còn là tab body.
    if (indexSelectedHere == 1) {
      indexSelectedHere = 0;
    }
    indexMenu = indexSelectedHere;
    
    // Chỉ cập nhật UI nếu widget vẫn mounted để tránh memory leak
    if (mounted) {
      setState(() { });
    }
  }

  //D. Trang - Tối ưu hóa bộ nhớ
  @override
  Widget build(BuildContext context) {
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin

    return Scaffold(
      body: Center(child: _tabForNavIndex(indexMenu)),
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: indexMenu,
      selectedItemColor: Colors.blue,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color.fromARGB(255, 71, 71, 71)),
          label: 'Home',
          activeIcon: Icon(Icons.home, color: Color(0xFF2196f3)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book, color: Color.fromARGB(255, 71, 71, 71)),
          label: 'Book',
          activeIcon: Icon(Icons.menu_book, color: Colors.orange),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.audiotrack, color: Color.fromARGB(255, 71, 71, 71)),
          label: '9 Lesson',
          activeIcon: Icon(Icons.audiotrack, color: Colors.orange),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.self_improvement,
            color: Color.fromARGB(255, 71, 71, 71),
          ),
          label: '5 Practice',
          activeIcon: Icon(Icons.self_improvement, color: Colors.orange),
        ),
      ],
      onTap: (index) {
        if (index == 1) {
          _openBookWebview();
          return;
        }
        indexMenu = index;
        saveMenuBottom(index);
        setState(() {});
      },
    );
  }

  //D.1 Lưu menu bottom vào shared - Tối ưu hóa bộ nhớ
  Future<void> saveMenuBottom(int indexMenuBottom) async {
    // Sử dụng cache SharedPreferences để tránh load lại
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences!.setInt("index_menu_bottom", indexMenuBottom);
  }

  @override
  void dispose() {
    _sharedPreferences = null;
    _tabWidgets.clear();
    super.dispose();
  }
}