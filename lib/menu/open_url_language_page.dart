import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller_app/link_all_page_and_api_enum.dart';

/*
Mở các liên kết theo danh sách và lưu ngôn ngữ yêu thích
flutter_widget_from_html: ^0.15.0 #widget, code html
Chú ý cho code bên trong thẻ HtmlWidget và trong thẻ lại chứa code trong 2 lần dấu ''':
HtmlWidget( ''' <code> ''' )
 */

enum TrangDichCuaLienKet {
  visaoconhanloai,
  falundafa,
  minghui
} // Danh sách enum chia các trường hợp của trang đích đến

//I. Trang giao diện
class OpenUrlPage extends StatefulWidget {
  final TrangDichCuaLienKet trangDichCuaLienKet; // Biến xác định trang đích đến

  OpenUrlPage(
      {required this.trangDichCuaLienKet}); // Hàm khởi tạo có chứa enum xác định trang đích đến

  @override
  State<OpenUrlPage> createState() => _OpenUrlPageState();
}

class _OpenUrlPageState extends State<OpenUrlPage> {
  //A. Dữ liệu
  late TrangDichCuaLienKet trangDichCuaLienKet;
  List<ModelOpenUrl> listOpenUrl = []; // Đưa chung về dạng List<Model> vì có 3 Enum khác nhau
  late ModelOpenUrl modelOpenUrlFavorite;

  //B. Khởi tạo dữ liệu
  @override
  void initState() {
    super.initState();

    //1. Khai báo trang đích và list language theo TrangDichCuaLienKet
    // Vì Enum chỉ lưu trữ dữ liệu, nên khi dùng cho danh sách thì cần dạng model
    trangDichCuaLienKet = widget.trangDichCuaLienKet; // Khai báo theo hàm khởi tạo

    if (trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai) {
      listOpenUrl = VisaoconhanloaiEnum.values.map((element) {
        return ModelOpenUrl(element.url, element.languageName, element.languageCode);
      }).toList();
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.falundafa) {
      listOpenUrl = FalundafaEnum.values.map((element) {
        return ModelOpenUrl(element.url, element.languageName, element.languageCode);
      }).toList();
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.minghui) {
      listOpenUrl = MinghuiEnum.values.map((element) {
        return ModelOpenUrl(element.url, element.languageName, element.languageCode);
      }).toList();
    }

    //2. Lấy ngôn ngữ lưu shared của liên kết
    modelOpenUrlFavorite = ModelOpenUrl("", "", "");
    _getLanguageLink();
  }

  //B.1 Lấy code ngôn ngữ lưu shared của liên kết
  _getLanguageLink() async {
    final shared = await SharedPreferences.getInstance();
    late String languageCode;

    //1. Lấy theo từng trang
    if (trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai) {
      languageCode = await shared.getString("languageCodeVisaoconhanloai") ?? "";
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.falundafa) {
      languageCode = await shared.getString("languageCodeFalundafa") ?? "";
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.minghui) {
      languageCode = await shared.getString("languageCodeMinghui") ?? "";
    }

    //2. Tìm trong danh sách xem có ngôn ngữ như ngôn ngữ đã lưu không -> Cập nhật nếu có
    // Các trường hợp không phải ngôn ngữ đó thì không cần xử lý
    for (int i = 0; i < listOpenUrl.length; i++) {
      if (languageCode.length > 1 && listOpenUrl[i].languageCode == languageCode) {
        modelOpenUrlFavorite = ModelOpenUrl(listOpenUrl[i].link, listOpenUrl[i].languageName,
            listOpenUrl[i].languageCode); // Cập nhật cho modelOpenUrlFavorite toàn cục
      }
    }
    setState(() {}); // Cập nhật cho modelOpenUrlFavorite
  }

  _saveLanguageLink(String keyLanguage) async {
    final shared = await SharedPreferences.getInstance();
    // Gán key theo TrangDichCuaLienKet
    if (trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai) {
      await shared.setString("languageCodeVisaoconhanloai", keyLanguage);
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.falundafa) {
      await shared.setString("languageCodeFalundafa", keyLanguage);
    } else if (trangDichCuaLienKet == TrangDichCuaLienKet.minghui) {
      await shared.setString("languageCodeMinghui", keyLanguage);
    }
  }

  //D. Trang: Danh sách nút để mở liên kết
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select language'),
          backgroundColor: Colors.green,
        ),
        body: Column(
          children: [
            //I. Ngôn ngữ yêu thích
            if (modelOpenUrlFavorite.languageCode.length > 1)
              Container(
                color: Color(0xFFFEF7FF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 6),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _launchInBrowser(
                          Uri.parse(modelOpenUrlFavorite.link)); // Mở link ở trình duyệt web
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      // Kích thước min cho button ngôn ngữ chọn favorite
                      elevation: 1,
                    ),
                    label: Center(
                        child: Text(
                      "${modelOpenUrlFavorite.languageName}",
                      style: TextStyle(color: Colors.blue),
                      textAlign: TextAlign.justify,
                    )),
                    icon: IconButton(
                      onPressed: () {
                        _saveLanguageLink(""); // Bỏ lưu ngôn ngữ khi bấm un favorire -> Lưu empty
                        modelOpenUrlFavorite = ModelOpenUrl("", "", "");
                        setState(() {});
                      },
                      icon: Icon(Icons.star),
                    ),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ),

            //II. Danh sách ngôn ngữ
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: ListView.builder(
                  itemCount: listOpenUrl.length,
                  itemBuilder: (context, index) {
                    // Ẩn ngôn ngữ đã được chọn làm favorite
                    if (modelOpenUrlFavorite.languageCode != listOpenUrl[index].languageCode) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        child: ElevatedButton.icon(
                          // horizontal: 15.0, vertical: 10
                          //1. Sự kiện click button
                          onPressed: () {
                            _launchInBrowser(
                                Uri.parse(listOpenUrl[index].link)); // Mở link ở trình duyệt web
                          },
                          //2. icon favorite
                          icon: IconButton(
                            onPressed: () {
                              _saveLanguageLink(listOpenUrl[index]
                                  .languageCode); // Lưu languageCode ngôn ngữ khi bấm favorire
                              modelOpenUrlFavorite = ModelOpenUrl(
                                  listOpenUrl[index].link,
                                  listOpenUrl[index].languageName,
                                  listOpenUrl[index]
                                      .languageCode); // Cập nhật cho ModelOpenUrl hiện hành
                              setState(() {}); // Cập nhật giao diện
                            },
                            icon: () {
                              if (modelOpenUrlFavorite.languageCode ==
                                  listOpenUrl[index].languageCode) {
                                return Icon(
                                    Icons.star); // Hiện icon đã đánh dấu nếu ngôn ngữ favorite
                              } else {
                                return Icon(Icons
                                    .star_border); // Hiện icon chưa đánh dấu nếu ngôn ngữ không favorite
                              }
                            }(),
                          ),

                          iconAlignment: IconAlignment.end,
                          label: Center(
                              child: Text(
                            "${listOpenUrl[index].languageName}",
                            style: TextStyle(color: Colors.blue),
                            textAlign: TextAlign.justify,
                          )), // Nhãn hiển thị
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //D.1 Hàm mở link url khi click
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}
