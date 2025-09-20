import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:falun_dafa_practice_supports/menu/simple_webview.dart';

import 'intro_list_widget_body.dart';
import 'introduction_screen.dart';

// Widget Page
class HuongDanTapCoBanPage extends StatelessWidget {

  //A. Dữ liệu
  static const String routeName = "Menu2HuongDanTapCoBanPage_routeName";
  final textStyle1 = const TextStyle(fontSize: 20, color: Colors.black);
  final styleTextTitle = TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20);

  HuongDanTapCoBanPage({super.key});

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          // leading: IconButton(
          //   onPressed: () { Navigator.pop(context); },
          //   icon: Icon(Icons.arrow_back, color: Colors.white,),
          // ),
          title: Text("Hướng dẫn tập cơ bản", style: styleTextTitle,),
          backgroundColor: Colors.white,
        ),

        body: Center(
          child: girdViewMenu(context),
        ),

        backgroundColor: Colors.white,
      ),
    );
  }

  //D.1 Thiết kế gridView
  Widget girdViewMenu(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        InkWell(
          onTap: (){_openIntro(context, listPageViewModelHuongDanTapCoBan);},
          child: itemMenu("assets/images/menu_item_2.jpg", "Hướng dẫn tập cơ bản"),
        ),
        InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (builder) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmph5i6al3ExcRdoWQUzS541l51c', title: "Bài 1: Phật Triển Thiên Thủ Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",)));
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmph5i6al3ExcRdoWQUzS541l51c', title: "Bài 1: Phật Triển Thiên Thủ Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)); // begin: Xác định điểm đầu (theo trục ngang x như (-1,1) (0.0,1.0) (180,1) ...) | end: điểm cuối (hay dùng zero) | curve: kiểu đường cong di chuyển
                return SlideTransition(position: animation.drive(tween), child: child,);
              },
            ),);
          },
          child: itemMenu("assets/images/anh_bai_1.jpg", "Học viên tập mẫu bài 1"),
        ),
        InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (builder) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmq7mob016ej27ndenbGNr21511c', title: "Bài 2: Pháp Luân Trang Pháp", textHuongDan: "Nam/nữ động tác như nhau.",)));
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmq7mob016ej27ndenbGNr21511c', title: "Bài 2: Pháp Luân Trang Pháp", textHuongDan: "Nam/nữ động tác như nhau.",),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)); // begin: Xác định điểm đầu (theo trục ngang x như (-1,1) (0.0,1.0) (180,1) ...) | end: điểm cuối (hay dùng zero) | curve: kiểu đường cong di chuyển
                return SlideTransition(position: animation.drive(tween), child: child,);
              },
            ),);
          },
          child: itemMenu("assets/images/anh_bai_2.jpg", "Học viên tập mẫu bài 2"),
        ),
        InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (builder) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmqjv549d5B8SAxJfBd7M5F11u1c', title: "Bài 3: Quán Thông Lưỡng Cực Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",)));
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmqjv549d5B8SAxJfBd7M5F11u1c', title: "Bài 3: Quán Thông Lưỡng Cực Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)); // begin: Xác định điểm đầu (theo trục ngang x như (-1,1) (0.0,1.0) (180,1) ...) | end: điểm cuối (hay dùng zero) | curve: kiểu đường cong di chuyển
                return SlideTransition(position: animation.drive(tween), child: child,);
              },
            ),);
          },
          child: itemMenu("assets/images/anh_bai_3.jpg", "Học viên tập mẫu bài 3"),
        ),
        InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (builder) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmtv3fpd19ENgfFOQCoXuu41fe1c', title: "Bài 4: Pháp Luân Chu Thiên Pháp", textHuongDan: "Nam/nữ tập theo nam hoặc nữ. Tay không chạm vào cơ thể.",)));
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdmtv3fpd19ENgfFOQCoXuu41fe1c', title: "Bài 4: Pháp Luân Chu Thiên Pháp", textHuongDan: "Nam/nữ tập theo nam hoặc nữ. Tay không chạm vào cơ thể.",),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)); // begin: Xác định điểm đầu (theo trục ngang x như (-1,1) (0.0,1.0) (180,1) ...) | end: điểm cuối (hay dùng zero) | curve: kiểu đường cong di chuyển
                return SlideTransition(position: animation.drive(tween), child: child,);
              },
            ),);
          },
          child: itemMenu("assets/images/anh_bai_4.jpg", "Học viên tập mẫu bài 4"),
        ),
        InkWell(
          onTap: (){
            // Navigator.push(context, MaterialPageRoute(builder: (builder) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdnvgqme2u2yk7Jy0s0VWcsL1ev1c', title: "Bài 5: Thần Thông Gia Trì Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",)));
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (_, __, ___) => WebViewBrowser(linkUrl: 'https://www.ganjingworld.com/embed/1fdnvgqme2u2yk7Jy0s0VWcsL1ev1c', title: "Bài 5: Thần Thông Gia Trì Pháp", textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease)); // begin: Xác định điểm đầu (theo trục ngang x như (-1,1) (0.0,1.0) (180,1) ...) | end: điểm cuối (hay dùng zero) | curve: kiểu đường cong di chuyển
                return SlideTransition(position: animation.drive(tween), child: child,);
              },
            ),);
          },
          child: itemMenu("assets/images/anh_bai_5.jpg", "Học viên tập mẫu bài 5"),
        ),
      ]
    );
  }

  //D.2 Widget item của từng sản phẩm trong grid
  Widget itemMenu(String imagePath, String text) {
    return Card(

      elevation: 8, // Độ cao (Tạo bóng)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Góc bo viền
      ),
      semanticContainer: true, // nơi chứa ngữ nghĩa
      clipBehavior: Clip.antiAliasWithSaveLayer, // Cho phép bo viền

      child: Column (
        children: [

          //1. Thành phần đầu tiên (lớp dưới cùng): Ảnh nền (cần tạo width và height bằng double.infinity để lấp đầy ô chứa nó)
          Container(
            child: Image.asset(
              imagePath, // path trong assets
              fit: BoxFit.cover,
              // height: 80,
              // width: double.infinity,
            ),
          ),

          //2. Text có nền: Dùng Expanded để chiếm hết phần còn dư, bên trong đặt container để tạo màu
          Expanded(
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(5),
              child: Center(child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500), textAlign: TextAlign.center,))
            ),
          ),

        ],
      ),
    );
  }

  //E.1 Hàm mở trang intro: Truyền list các trang nội dung
  void _openIntro(BuildContext context, List<PageViewModel> listPageViewModel) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => IntroductionScreenWidget(listPageViewModel: listPageViewModel, setPageIntro: SetPageIntro.tapcoban,)),);
  }
}
