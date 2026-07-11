import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:falun_dafa_practice_supports/main.dart';
import 'package:falun_dafa_practice_supports/menu/intro_list_widget_body.dart';
import 'package:falun_dafa_practice_supports/common/swipe_to_back.dart';

/*
introduction_screen: ^3.1.14
link: https://pub.dev/packages/introduction_screen/install
 */

// Class tạo widget chứa intro screen
class IntroductionScreenWidget extends StatefulWidget {

  final List<PageViewModel> listPageViewModel; // danh sách các trang của intro PageViewModel
  final SetPageIntro setPageIntro; // enum tạo key xác định trang sẽ trả về sau khi dùng intro
  IntroductionScreenWidget({required this.listPageViewModel, required this.setPageIntro, super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<IntroductionScreenWidget> {

  //A. Dữ liệu
  final introKey = GlobalKey<IntroductionScreenState>(); // key thứ tự trang
  var styleTextBody2 = TextStyle(fontSize: 16.0, color: Colors.black);
  var styleTextNumberPage = TextStyle(fontSize: 16.0, color: Colors.grey);

  // Nhận danh sách các trang của intro (PageViewModel) từ trang khởi tạo
  List<PageViewModel> get listPageViewModel => widget.listPageViewModel; // list widget PageViewModel ở file intro_list_widget_body.dart

  //D. Widget build (Xây dựng widget)
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    // Keep controls slightly above system buttons without shifting layout too far.
    final bottomLift = bottomInset > 0 ? 6.0 : 0.0;

    //* Màn hình Introduction Screen
    return SwipeToBack(
      onBack: () => _onIntroEnd(context),
      child: SafeArea(
      bottom: true,
      child: IntroductionScreen(
        key: introKey, // key thứ tự page
        globalBackgroundColor: Colors.blue, // Màu nền dưới cùng của toàn bộ intro
        allowImplicitScrolling: false, // Cho phép cuộn ngầm trang
        // autoScrollDuration: 3000, // Thời lượng cuộn tự động (không đặt thì không cuộn)
        infiniteAutoScroll: false, // Cuộn tự động vô hạn

        //I. Danh sách các trang của intro (truyền vào khi khởi tạo)
        pages: listPageViewModel,

        //II. Các setup khác
        onDone: () => _onIntroEnd(context), // hàm thực hiện sau khi bấm done (xem xong)
        onSkip: () => _onIntroEnd(context), // hàm thực hiện sau khi skip
        showSkipButton: true, // Chọn show nút skip hoặc back (1 trong 2)
        showBackButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        //rtl: false, // hướng hiển thị right-to-left
        back: const Icon(Icons.arrow_back, color: Colors.white,),
        skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        next: const Icon(Icons.arrow_forward, color: Colors.white,),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomLift), // Tránh bị che bởi thanh điều hướng Android
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0 + bottomLift),

        dotsDecorator: const DotsDecorator( // Nút cuộn trang
          size: Size(10.0, 10.0),
          color: Colors.white,
          activeColor: Colors.blue,
          activeSize: Size(22.0, 10.0), // Kích thước khi được chọn
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)), // bo viền nút khi được chọn
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration( // Nền của thanh control
          color: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    ),
    );
  }

  //E.1 build image trong từng page
  // Widget _buildImage(String assetName, [double width = 250]) {
  //   return Image.asset('assets/$assetName', width: width, fit: BoxFit.cover,);
  // }

  //E.2 Trang image full screen page
  // Widget _buildFullscreenImage() {
  //   return Image.asset(
  //     'assets/images/menu_item_1.jpg',
  //     fit: BoxFit.cover,
  //     height: double.infinity,
  //     width: double.infinity,
  //     alignment: Alignment.center,
  //   );
  // }

  //F. Hàm thực hiện sau khi kết thúc intro -> Trả về trang home
  void _onIntroEnd(context) {
    if (widget.setPageIntro == SetPageIntro.molandau) {
      AppNavigator.pushReplacement(context, RunAppFalunDafaExercise());
    } else if (widget.setPageIntro == SetPageIntro.gioithieuapp) {
      Navigator.pop(context);
    } else if (widget.setPageIntro == SetPageIntro.tapcoban) {
      Navigator.pop(context);
    }
  }
}

