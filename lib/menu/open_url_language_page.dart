import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/*
Mở các liên kết theo danh sách và lưu ngôn ngữ yêu thích
flutter_widget_from_html: ^0.15.0 #widget, code html
Chú ý cho code bên trong thẻ HtmlWidget và trong thẻ lại chứa code trong 2 lần dấu ''':
HtmlWidget( ''' <code> ''' )
 */

enum TrangDichCuaLienKet {visaoconhanloai, falundafa, minghui} // Danh sách enum chia các trường hợp của trang đích đến

//I. Trang giao diện
class OpenUrlPage extends StatefulWidget {

  final TrangDichCuaLienKet trangDichCuaLienKet; // Biến xác định trang đích đến

  OpenUrlPage({required this.trangDichCuaLienKet}); // Hàm khởi tạo có chứa enum xác định trang đích đến

  @override
  State<OpenUrlPage> createState() => _OpenUrlPageState();
}

class _OpenUrlPageState extends State<OpenUrlPage> {

  //A. Dữ liệu
  late TrangDichCuaLienKet trangDichCuaLienKet;
  List<ModelOpenUrl> listOpenUrl = [];
  late ModelOpenUrl modelOpenUrlFavorite;

  //B. Khởi tạo dữ liệu
  @override
  void initState() {
    super.initState();

    //1. Khai báo trang đích và list language theo TrangDichCuaLienKet
    trangDichCuaLienKet = widget.trangDichCuaLienKet; // Khai báo theo hàm khởi tạo

    if(trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai){
      listOpenUrl = listOpenUrlVisaoconhanloai;
    } else if(trangDichCuaLienKet == TrangDichCuaLienKet.falundafa){
      listOpenUrl = listOpenUrlFalundafa;
    } else if(trangDichCuaLienKet == TrangDichCuaLienKet.minghui){
      listOpenUrl = listOpenUrlMinghui;
    }

    //2. Lấy ngôn ngữ lưu shared của liên kết
    modelOpenUrlFavorite = ModelOpenUrl("", "", "");
    _getLanguageLink();
  }

  //B.1 Lấy code ngôn ngữ lưu shared của liên kết
  _getLanguageLink () async {
    final shared = await SharedPreferences.getInstance();
    late String languageCode;

    // Lấy theo từng trang
    if(trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai){
      languageCode = await shared.getString("languageCodeVisaoconhanloai") ?? "";
    } else if(trangDichCuaLienKet == TrangDichCuaLienKet.falundafa){
      languageCode = await shared.getString("languageCodeFalundafa") ?? "";
    } else if(trangDichCuaLienKet == TrangDichCuaLienKet.minghui){
      languageCode = await shared.getString("languageCodeMinghui") ?? "";
    }

    // Tìm trong danh sách xem có ngôn ngữ như ngôn ngữ đã lưu không -> Cập nhật nếu có | Các trường hợp không phải ngôn ngữ đó thì không cần xử lý
    for(int i=0; i<listOpenUrl.length; i++){
      if(languageCode.length > 1 && listOpenUrl[i].languageCode == languageCode){
        modelOpenUrlFavorite = ModelOpenUrl(listOpenUrl[i].link, listOpenUrl[i].languageName, listOpenUrl[i].languageCode); // Cập nhật cho modelOpenUrlFavorite toàn cục
      }
    }
    setState(() {}); // Cập nhật cho modelOpenUrlFavorite
  }

  _saveLanguageLink (String keyLanguage) async {
    final shared = await SharedPreferences.getInstance();
    // Gán key theo TrangDichCuaLienKet
    if(trangDichCuaLienKet == TrangDichCuaLienKet.visaoconhanloai) {
      await shared.setString("languageCodeVisaoconhanloai", keyLanguage);
    } else if( trangDichCuaLienKet == TrangDichCuaLienKet.falundafa){
      await shared.setString("languageCodeFalundafa", keyLanguage);
    } else if( trangDichCuaLienKet == TrangDichCuaLienKet.minghui){
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
            if(modelOpenUrlFavorite.languageCode.length > 1)
              Container(
                color: Color(0xFFFEF7FF),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8, bottom: 6),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      _launchInBrowser(Uri.parse(modelOpenUrlFavorite.link)); // Mở link ở trình duyệt web
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Kích thước min cho button ngôn ngữ chọn favorite
                      elevation: 1,
                    ),
                    label: Center(child: Text("${modelOpenUrlFavorite.languageName}", style: TextStyle(color: Colors.blue), textAlign: TextAlign.justify,)),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                child: ListView.builder(
                  itemCount: listOpenUrl.length,
                  itemBuilder: (context, index){

                    // Ẩn ngôn ngữ đã được chọn làm favorite
                    if(modelOpenUrlFavorite.languageCode != listOpenUrl[index].languageCode){

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                        child: ElevatedButton.icon ( // horizontal: 15.0, vertical: 10
                          //1. Sự kiện click button
                          onPressed: (){
                            _launchInBrowser(Uri.parse(listOpenUrl[index].link)); // Mở link ở trình duyệt web
                          },
                          //2. icon favorite
                          icon: IconButton(
                            onPressed: () {
                              _saveLanguageLink(listOpenUrl[index].languageCode); // Lưu languageCode ngôn ngữ khi bấm favorire
                              modelOpenUrlFavorite = ModelOpenUrl(listOpenUrl[index].link, listOpenUrl[index].languageName, listOpenUrl[index].languageCode); // Cập nhật cho ModelOpenUrl hiện hành
                              setState(() {}); // Cập nhật giao diện
                            },
                            icon: (){
                              if(modelOpenUrlFavorite.languageCode == listOpenUrl[index].languageCode){
                                return Icon(Icons.star); // Hiện icon đã đánh dấu nếu ngôn ngữ favorite
                              } else {
                                return Icon(Icons.star_border); // Hiện icon chưa đánh dấu nếu ngôn ngữ không favorite
                              }
                            }(),
                          ),

                          iconAlignment: IconAlignment.end,
                          label: Center(child: Text("${listOpenUrl[index].languageName}", style: TextStyle(color: Colors.blue), textAlign: TextAlign.justify,)), // Nhãn hiển thị
                        ),
                      );
                    } else {
                      return SizedBox();
                    };
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
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $url');
    }
  }
}

class ModelOpenUrl {
  String link;
  String languageName;
  String languageCode;
  ModelOpenUrl(this.link, this.languageName, this.languageCode);
}

//II. Các danh sách liên kết
List<ModelOpenUrl> listOpenUrlFalundafa = [
  ModelOpenUrl("https://en.falundafa.org/?v=bks04", "English", "english"),
  ModelOpenUrl("https://gb.falundafa.org/?v=bks04", "中文简体", "chinese"),
  ModelOpenUrl("https://af.falundafa.org/?v=bks04", "Afrikaans", "afrikaans"),
  ModelOpenUrl("https://ar.falundafa.org/?v=bks04", "Arabic / العربية", "arabic"),
  ModelOpenUrl("https://ba.falundafa.org/?v=bks04", "Bangla", "bangla"),
  ModelOpenUrl("https://bs.falundafa.org/?v=bks04", "Bosanski", "bosanski"),
  ModelOpenUrl("https://by.falundafa.org/?v=bks04", "Belarus", "belarus"),
  ModelOpenUrl("https://bg.falundafa.org/?v=bks04", "Български", "bungari"),
  ModelOpenUrl("https://www.falundafa.org/eng/language/burmese.html?v=bks04", "Burmese", "burmese"),
  ModelOpenUrl("https://cs.falundafa.org/?v=bks04", "Česky", 'cesky'),
  ModelOpenUrl("https://da.falundafa.org/?v=bks04", "Dansk", 'dansk'),
  ModelOpenUrl("https://de.falundafa.org/?v=bks04", "Deutsch", "deutsch"),
  ModelOpenUrl("https://es.falundafa.org/?v=bks04", "Español", "espanol"),
  ModelOpenUrl("https://en.falundafa.org/language/estonian.html?v=bks04", "Eesti", 'eesti'),
  ModelOpenUrl("https://el.falundafa.org/?v=bks04", "Ελληνικά", 'greek' ),
  ModelOpenUrl("https://fa.falundafa.org/?v=bks04", "Farsi / فارسی", 'farsi'),
  ModelOpenUrl("https://fr.falundafa.org/?v=bks04", "Français", 'francais'),
  ModelOpenUrl("https://he.falundafa.org/?v=bks04", "עברית", 'hebrew'),
  ModelOpenUrl("https://hi.falundafa.org/?v=bks04", "Hindi / हिन्दी", 'hindi'),
  ModelOpenUrl("https://hr.falundafa.org/?v=bks04", "Hrvatski", 'hrvatski'),
  ModelOpenUrl("https://id.falundafa.org/?v=bks04", "Bahasa Indonesia", 'indonesia'),
  ModelOpenUrl("https://it.falundafa.org/?v=bks04", "Italiano", 'italiano'),
  ModelOpenUrl("https://kn.falundafa.org/?v=bks04", "Kannada", 'kannada'),
  ModelOpenUrl("https://lv.falundafa.org/?v=bks04", "Latviski", 'latviski'),
  ModelOpenUrl("https://falundafa.org/eng/language/lithuanian.html?v=bks04", "Lietuvių", 'lietuvių'),
  ModelOpenUrl("https://en.falundafa.org/language/laotian.html?v=bks04", "Laotian / ລາວ", 'laotian'),
  ModelOpenUrl("https://hu.falundafa.org/?v=bks04", "Magyar", 'magyar'),
  ModelOpenUrl("https://mk.falundafa.org/?v=bks04", "Македонски", 'macedonia'),
  ModelOpenUrl("https://mn.falundafa.org/?v=bks04", "Монгол / ᠮᠣᠩᠭᠣᠯ", 'mongolia'),
  ModelOpenUrl("https://nl.falundafa.org/?v=bks04", "Nederlands", 'nederlands'),
  ModelOpenUrl("https://ja.falundafa.org/?v=bks04", "Japan / 日本語", 'japan'),
  ModelOpenUrl("https://kh.falundafa.org/falun-dafa-books.html?v=bks04", "Khmer / ខ្មែរ", 'khmer'),
  ModelOpenUrl("https://no.falundafa.org/?v=bks04", "Norsk / Bokmål", 'norsk'),
  ModelOpenUrl("https://pl.falundafa.org/?v=bks04", "Polski", 'polski'),
  ModelOpenUrl("https://pt.falundafa.org/?v=bks04", "Português", 'portugues'),
  ModelOpenUrl("https://ro.falundafa.org/?v=bks04", "Română", 'romana'),
  ModelOpenUrl("https://rus.falundafa.org/?v=bks04", "Русский", 'russian'),
  ModelOpenUrl("https://lk.falundafa.org/?v=bks04", "Sinhala / සිංහල", 'sinhala'),
  ModelOpenUrl("https://sk.falundafa.org/?v=bks04", "Slovenčina", 'slovencina'),
  ModelOpenUrl("https://sl.falundafa.org/?v=bks04", "Slovenščina", 'slovenscina'),
  ModelOpenUrl("https://sr.falundafa.org/?v=bks04", "Srpski / Српски", 'srpski'),
  ModelOpenUrl("https://fi.falundafa.org/?v=bks04", "Suomi", 'suomi'),
  ModelOpenUrl("https://sv.falundafa.org/?v=bks04", "Svenska", 'svenska'),
  ModelOpenUrl("https://sq.falundafa.org/?v=bks04", "Shqip / Albanian", 'shqip'),
  ModelOpenUrl("https://ko.falundafa.org/?v=bks04", "Korean / 한국어", 'korean'),
  ModelOpenUrl("https://th.falundafa.org/?v=bks04", "Thai / ไทย", 'thai'),
  ModelOpenUrl("https://www.falundafa.org/eng/language/tibetan.html?v=bks04", "Tibetan / བོད་ཡིག", 'tibetan'),
  ModelOpenUrl("https://vi.falundafa.org/?v=bks04", "Tiếng Việt", 'vietnamese'),
  ModelOpenUrl("https://tr.falundafa.org/?v=bks04", "Türkçe", 'turkce'),
  ModelOpenUrl("https://uk.falundafa.org/?v=bks04", "Ukrainian / Українська", 'ukrainian'),
];

List<ModelOpenUrl> listOpenUrlVisaoconhanloai = [
  ModelOpenUrl("https://en.minghui.org/html/articles/2023/1/21/206699.html", "English", "english"),
  ModelOpenUrl("https://www.minghui.org/mh/articles/2023/1/20/%E4%B8%BA%E4%BB%80%E4%B9%88%E4%BC%9A%E6%9C%89%E4%BA%BA%E7%B1%BB-455562.html", "中文简体", "chinese"),
  ModelOpenUrl("https://bs.minghui.org/articles/6858", "Bosanski", "bosanski"),
  ModelOpenUrl("https://de.minghui.org/html/articles/2023/1/23/165840.html", "Deutsch", "deutsch"),
  ModelOpenUrl("https://es.minghui.org/html/articles/2023/1/21/126075.html", "Español", 'espanol'),
  ModelOpenUrl("https://fa.minghui.org/html/articles/2023/1/21/133405.html", "فارسی", 'farsi'),
  ModelOpenUrl("https://fr.minghui.org/html/articles/2023/1/21/103887.html", "Français", 'francais'),
  ModelOpenUrl("https://he.minghui.org/html/articles/2023/1/23/41878.html", "עברית", 'hebrew'),
  ModelOpenUrl("https://hr.minghui.org/articles/6858", "Hrvatski", 'hrvatski'),
  ModelOpenUrl("https://id.minghui.org/html/articles/2023/1/25/130727.html", "Bahasa Indonesia", 'indonesia'),
  ModelOpenUrl("https://it.minghui.org/html/articles/2023/1/25/21201.html", "Italiano", 'italiano'),
  ModelOpenUrl("https://jp.minghui.org/2023/01/23/89043.html", "日本語", 'japan'),
  ModelOpenUrl("https://www.minghui.or.kr/archives/masters-recent-articles/118601", "한국어", 'korean'),
  ModelOpenUrl("https://pl.minghui.org/html/articles/2023/1/23/911.html", "Polski", 'polski'),
  ModelOpenUrl("https://pt.minghui.org/html/articles/2023/1/21/8438.html", "Português", 'portugues'),
  ModelOpenUrl("https://ru.minghui.org/html/articles/2023/1/21/1172085.html", "Русский", 'russian'),
  ModelOpenUrl("https://sk.minghui.org/2023/01/21/preco-existuje-ludstvo", "Slovenčina", 'slovencina'),
  ModelOpenUrl("https://sr.minghui.org/articles/6858", "Српски", 'srpski'),
  ModelOpenUrl("https://th.minghui.org/html/articles/2023/1/31/3010.html", "ไทย", 'thai'),
  ModelOpenUrl("https://vn.minghui.org/jw/kinh_van_20230120.html", "Tiếng Việt", 'vietnamese'),
  ModelOpenUrl("https://tr.minghui.org/html/articles/2023/1/24/11239.html", "Türkçe", 'turkce'),
  ModelOpenUrl("https://uk.minghui.org/html/articles/2023/1/20/1155.html", "Українська", 'ukrainian'),
];

List<ModelOpenUrl> listOpenUrlMinghui = [
  ModelOpenUrl("https://en.minghui.org/", "English", "english"),
  ModelOpenUrl("https://big5.minghui.org/", "正體中文", "chinese"),
  ModelOpenUrl("https://www.minghui.org/", "简体中文", 'chinese2'),
  ModelOpenUrl("https://ar.minghui.org/", "العربية", "arabic"),
  ModelOpenUrl("https://bs.minghui.org/", "Bosanski", "bosanski"),
  ModelOpenUrl("https://cs.minghui.org/", "Česky", 'cesky'),
  ModelOpenUrl("https://de.minghui.org/", "Deutsch", "deutsch"),
  ModelOpenUrl("https://es.minghui.org/", "Español", 'espanol'),
  ModelOpenUrl("https://fa.minghui.org/", "فارسی", 'farsi'),
  ModelOpenUrl("https://fr.minghui.org/", "Francais", 'francais'),
  ModelOpenUrl("https://he.minghui.org/", "עברית", 'hebrew'),
  ModelOpenUrl("https://hr.minghui.org/", "Hrvatski", 'hrvatski'),
  ModelOpenUrl("https://id.minghui.org/", "Indonesian", 'indonesia'),
  ModelOpenUrl("https://it.minghui.org/", "Italiano", 'italiano'),
  ModelOpenUrl("https://jp.minghui.org/", "日本語", 'japan'),
  ModelOpenUrl("https://www.minghui.or.kr/", "한국어", 'korean'),
  ModelOpenUrl("https://pl.minghui.org/", "Polski", 'polski'),
  ModelOpenUrl("https://pt.minghui.org/", "Português", 'portugues'),
  ModelOpenUrl("https://ru.minghui.org/", "Русский", 'russian'),
  ModelOpenUrl("https://sk.minghui.org/", "Slovenčina", 'slovencina'),
  ModelOpenUrl("https://sr.minghui.org/", "Српски", 'srpski'),
  ModelOpenUrl("https://th.minghui.org/", "ไทย", 'thai'),
  ModelOpenUrl("https://vn.minghui.org/news", "Tiếng Việt", 'vietnamese'),
  ModelOpenUrl("https://tr.minghui.org/", "Türkçe", 'turkce'),
  ModelOpenUrl("https://uk.minghui.org/", "Українська", 'ukrainian'),
];