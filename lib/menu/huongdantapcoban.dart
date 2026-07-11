import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:falun_dafa_practice_supports/menu/simple_webview.dart';
import 'package:falun_dafa_practice_supports/common/swipe_to_back.dart';

import 'intro_list_widget_body.dart';
import 'introduction_screen.dart';

// Widget Page
class HuongDanTapCoBanPage extends StatelessWidget {
  static const String routeName = "Menu2HuongDanTapCoBanPage_routeName";
  final textStyle1 = const TextStyle(fontSize: 20, color: Colors.black);
  final styleTextTitle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20);

  HuongDanTapCoBanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Hướng dẫn tập cơ bản", style: styleTextTitle),
          backgroundColor: Colors.white,
        ),
        body: Center(child: girdViewMenu(context)),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget girdViewMenu(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        InkWell(
          onTap: () {
            _openIntro(context, listPageViewModelHuongDanTapCoBan);
          },
          child: itemMenu(
            "assets/images/menu_item_2.jpg",
            "Hướng dẫn tập cơ bản",
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              WebViewBrowser(
                linkUrl:
                    'https://www.ganjingworld.com/vi-VN/embed/1feprapkl1i77D9YXA1UBoCtd10s1c',
                title: "Bài 1: Phật Triển Thiên Thủ Pháp",
                textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",
              ),
            );
          },
          child: itemMenu(
            "assets/images/anh_bai_1.jpg",
            "Học viên tập mẫu bài 1",
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              WebViewBrowser(
                linkUrl:
                    'https://www.ganjingworld.com/embed/1fdmq7mob016ej27ndenbGNr21511c',
                title: "Bài 2: Pháp Luân Trang Pháp",
                textHuongDan: "Nam/nữ động tác như nhau.",
              ),
            );
          },
          child: itemMenu(
            "assets/images/anh_bai_2.jpg",
            "Học viên tập mẫu bài 2",
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              WebViewBrowser(
                linkUrl:
                    'https://www.ganjingworld.com/embed/1fdmqjv549d5B8SAxJfBd7M5F11u1c',
                title: "Bài 3: Quán Thông Lưỡng Cực Pháp",
                textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",
              ),
            );
          },
          child: itemMenu(
            "assets/images/anh_bai_3.jpg",
            "Học viên tập mẫu bài 3",
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              WebViewBrowser(
                linkUrl:
                    'https://www.ganjingworld.com/embed/1fdmtv3fpd19ENgfFOQCoXuu41fe1c',
                title: "Bài 4: Pháp Luân Chu Thiên Pháp",
                textHuongDan:
                    "Nam/nữ tập theo nam hoặc nữ. Tay không chạm vào cơ thể.",
              ),
            );
          },
          child: itemMenu(
            "assets/images/anh_bai_4.jpg",
            "Học viên tập mẫu bài 4",
          ),
        ),
        InkWell(
          onTap: () {
            AppNavigator.push(
              context,
              WebViewBrowser(
                linkUrl:
                    'https://www.ganjingworld.com/embed/1fdnvgqme2u2yk7Jy0s0VWcsL1ev1c',
                title: "Bài 5: Thần Thông Gia Trì Pháp",
                textHuongDan: "Nam đối xứng nữ | Nữ đối xứng nam.",
              ),
            );
          },
          child: itemMenu(
            "assets/images/anh_bai_5.jpg",
            "Học viên tập mẫu bài 5",
          ),
        ),
      ],
    );
  }

  Widget itemMenu(String imagePath, String text) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openIntro(BuildContext context, List<PageViewModel> listPageViewModel) {
    AppNavigator.push(
      context,
      IntroductionScreenWidget(
        listPageViewModel: listPageViewModel,
        setPageIntro: SetPageIntro.tapcoban,
      ),
    );
  }
}
