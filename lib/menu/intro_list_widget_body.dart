import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/*
Nơi chứa dữ liệu sẵn cho intro
 */

//I. Dữ liệu chung
var styleTextIntro1 = TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w700);
var styleTextBody2 = TextStyle(fontSize: 16.0, color: Colors.black);
var styleTextNumberPage = TextStyle(fontSize: 16.0, color: Colors.grey);
var colorIconAudioPlay = Colors.deepPurple;

enum SetPageIntro {molandau ,gioithieuapp, tapcoban} // enum tạo key xác định trang sẽ trả về sau khi dùng intro (Có thể tạo nhiều key tuỳ số lượng cần dùng)

// double get c_width (BuildContext context) => MediaQuery.of(context).size.width*0.8;

//I.1 Mẫu deco cho bên trong page
const pageDecoration = PageDecoration(
  titleTextStyle: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w700, color: Colors.white),
  bodyTextStyle: const TextStyle(fontSize: 19.0),
  bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
  pageColor: Colors.green, // nền
  imagePadding: EdgeInsets.zero, // khoảng cách vào trong ảnh
  fullScreen: false, // Nền chiếm toàn màn hình
);

//I.2 Hàm mở link url khi click
Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
    throw Exception('Could not launch $url');
  }
}

//II.1 List bao gồm từng trang PageViewModel của phần: giới thiệu App
List<PageViewModel> listPageViewModelGioiThieuApp = [

  //1. Trang mở đầu
  PageViewModel(
    title: "About app",
    reverse: true, // Đảo ngược thứ tự title và ảnh
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration (
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "Hiện nay có rất nhiều người đã biết đến sự tốt đẹp của Pháp Luân Công (Pháp Luân Đại Pháp) và bắt đầu tu luyện.\n"
            "\nĐể nghe 9 bài giảng hoặc đọc sách, trong đó sách chính là \"Chuyển Pháp Luân\" (có nội dung như 9 bài giảng), học viên có thể truy cập tại chủ www.falundafa.org hoặc in thành sách, tải file âm thanh về để sử dụng.\n"
            "\nỨng dụng này được tạo ra bởi học viên Pháp Luân Công nhằm hỗ trợ các học viên khác truy cập dữ liệu học tập trực tuyến trên trang chủ www.falundafa.org\n"
            "\nNgoài ra ứng dụng còn có phần hướng dẫn tập cơ bản nhằm giúp học viên mới tiếp cận môn học (có nút hỗ trợ tải audio về máy để sử dụng khi không dùng internet, bằng cách mở thư mục của máy sau khi đã tải về hoặc sử dụng trình mở nhạc của máy).\n"
            "\nĐể tìm hiểu đầy đủ về Pháp Luân Công (Pháp Luân Đại Pháp) vui lòng truy cập:\n",
            style: styleTextBody2, textAlign: TextAlign.justify,
          ),
          Row(children: [
            Icon(Icons.arrow_right),
            InkWell(
                onTap: (){
                  _launchInBrowser(Uri.parse("https://www.falundafa.org/")); // url_launcher: ^6.2.6 | import 'package:url_launcher/url_launcher.dart';
                },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [ //mảng text span
                    TextSpan(text: "Home: ", style: styleTextBody2.copyWith(color: Colors.black,), ),
                    TextSpan(text: 'www.falundafa.org ' , style: styleTextBody2.copyWith(color: Colors.blue)),
                  ],
                  style: styleTextBody2,
                ),
              ),
            ),
          ],),
          Row(children: [
            Icon(Icons.arrow_right),
            InkWell(
              onTap: (){
                _launchInBrowser(Uri.parse("https://www.minghui.org/"));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "News: ", style: styleTextBody2.copyWith(color: Colors.black)),
                    TextSpan(text: 'www.minghui.org ' , style: styleTextBody2.copyWith(color: Colors.blue)),
                  ],
                  style: styleTextBody2,
                ),
              ),
            ),
          ],),
          Text("\n1", style: styleTextNumberPage, textAlign: TextAlign.center,),
        ],
      ),
    ),

    // body: "Text", // Chỉ chọn một trong hai, và bắt buộc phải có 1 trong 2: (body == null) != (bodyWidget == null)
    // image: _buildFullscreenImage(), // Không dùng ảnh khi đã có bodyWidget

    //Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
    decoration: pageDecoration.copyWith(
      bodyFlex: 7, // Chiếm diện tích của body
      imageFlex: 3, // Chiếm diện tích của image
      bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
      imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
      // pageColor: Colors.lightGreen,
    ),
    // image: _buildImage('images/lotus_10.jpg'),
  ),

  //2. Trang giới thiệu tính năng
  PageViewModel (
    title: "Features and buttons",
    reverse: true, // Đảo ngược thứ tự title và ảnh
    bodyWidget: Column(
      children: [

        //1. Hướng dẫn tính năng chung
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration (
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            border: TableBorder.all(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
            columnWidths: {0 : FractionColumnWidth(.375), 1: FractionColumnWidth(.30), 2: FractionColumnWidth(.325)}, // Map: {Thứ tự cột: tỷ lệ chiếm chiều rộng width} | Không đặt thì mặc định là chia đều
            children: [
              TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(child: Text("Feature", style: styleTextIntro1, textAlign: TextAlign.center,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(child: Text("Lesson", style: styleTextIntro1, textAlign: TextAlign.center)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(child: Text("Practice music", style: styleTextIntro1, textAlign: TextAlign.center)),
                    ),
                  ]
              ),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Text("Use internet", textAlign: TextAlign.center,)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green,)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green,)),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Text("Save latest", textAlign: TextAlign.center)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green,)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green)),
                ),
              ]),

              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Text("Download to phone", textAlign: TextAlign.center)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(child: Icon(Icons.check_circle, color: Colors.green)),
                ),
              ]),
            ],
          ),
        ),
        SizedBox(height: 15,),

        //2. Hướng dẫn nút bấm
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration (
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Table(
                border: TableBorder.all(color: Colors.grey, borderRadius: BorderRadius.circular(5)),
                columnWidths: {0 : FractionColumnWidth(.40), 1: FractionColumnWidth(.60)}, // Map: {Thứ tự cột: tỷ lệ chiếm chiều rộng width} | Không đặt thì mặc định là chia đều
                children: [
                  TableRow(children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(child: Text("Button", style: styleTextBody2.copyWith(fontWeight: FontWeight.w700,), textAlign: TextAlign.center))),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(child: Text("Uses", style: styleTextBody2.copyWith(fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(Icons.play_circle_fill, color: Colors.orangeAccent),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(child: Text("Listen, view online", textAlign: TextAlign.center)),
                    ),
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(Icons.download, color: colorIconAudioPlay),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(child: Text("Download to phone", textAlign: TextAlign.center)),
                    ),
                  ]),
                  TableRow(children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Icon(Icons.zoom_out_map,),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(child: Text("Extend", textAlign: TextAlign.center)),
                      ),
                    ],),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(Icons.open_in_new,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(child: Text("Open in browser", textAlign: TextAlign.center)),
                    ),
                  ],),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Icon(Icons.picture_as_pdf,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Center(child: Text("Read, download PDF", textAlign: TextAlign.center)),
                    ),
                  ],),
                ],
              ),

              Center(child: Text("\n2", style: styleTextNumberPage, textAlign: TextAlign.center,)),
            ],
          ),
        ),
      ],
    ),

    // Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
    decoration: pageDecoration.copyWith (
      bodyFlex: 7, // Chiếm diện tích của body
      imageFlex: 3, // Chiếm diện tích của image
      bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
      imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
      // pageColor: Colors.lightGreen, // Màu nền trang
    ),
  ),

  //3. Trang thông tin liên hệ
  // PageViewModel(
  //   title: "Privacy policy & Contact",
  //   reverse: true, // Đảo ngược thứ tự title và ảnh
  //   bodyWidget: Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration (
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Center(
  //           child: HtmlWidget(
  //             '''
  //           <!DOCTYPE html>
  //           <html>
  //           <head>
  //             <meta charset='utf-8'>
  //             <meta name='viewport' content='width=device-width'>
  //             <style> body { font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; padding:1em; } p {text-align: justify;} </style>
  //           </head>
  //           <body>
  //           <strong>Privacy Policy Falun Dafa Practice Supports</strong>
  //           <p>Falun Dafa Practice Supports built the  app as (free / ad-supported / buy in the application) app. This SERVICE is provided by Falun Dafa Practice Supports and is intended for use as is.</p>
  //           <p>This page is used to inform visitors regarding our policies with the collection, use, and disclosure of Personal Information if anyone decided to use our Service.</p>
  //           <p>If you choose to use our Service, then you agree to the collection and use of information in relation to this policy.</p>
  //           <p><strong>Information Collection and Use</strong></p>
  //           <p>We do not collect personal data (full name, address, contact information, email, phone number, image, ... Personal documents any other)
  //           <p>The information that we request will be retained on your device and is not collected by us in any way.</p>
  //           <p>Applications can collect data used such as: Login time, usage status ...</p>
  //           </p>
  //           <div>
  //           <p>The app does use third-party services that may collect information used to identify you.</p>
  //             <p> Link to the privacy policy of third-party service providers used by the app</p>
  //           <ul><li><a href="https://www.google.com/policies/privacy/" target="_blank" rel="noopener noreferrer">Google Play Services</a></li><li><a href="https://support.google.com/admob/answer/6128543?hl=en" target="_blank" rel="noopener noreferrer">AdMob</a></li><li><a href="https://firebase.google.com/support/privacy" target="_blank" rel="noopener noreferrer">Google Analytics for Firebase</a></li><li><a href="https://firebase.google.com/support/privacy/" target="_blank" rel="noopener noreferrer">Firebase Crashlytics</a></li><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----></ul></div> <p><strong>Log Data</strong></p>
  //           <p>
  //             We want to inform you that whenever you
  //             use our Service, in a case of an error in the app
  //             We collect data and information (through third-party
  //             products) on your phone called Log Data. This Log Data may
  //             include information such as your device Internet Protocol
  //             (“IP”) address, device name, operating system version, the
  //             configuration of the app when utilizing [my/our] Service,
  //             the time and date of your use of the Service, and other
  //             statistics.
  //           </p>
  //
  //           <p><strong>Service Providers</strong></p>
  //           <p> We may employ third-party companies and individuals due to the following reasons: </p>
  //           <ul><li>To facilitate our Service;</li> <li>To provide the Service on our behalf;</li> <li>To perform Service-related services; or</li> <li>To assist us in analyzing how our Service is used.</li></ul>
  //           <p>
  //             We want to inform users of this Service
  //             that these third parties have access to their Personal
  //             Information. The reason is to perform the tasks assigned to
  //             them on our behalf. However, they are obligated not to
  //             disclose or use the information for any other purpose.
  //           </p>
  //           <p><strong>Security</strong></p>
  //           <p>
  //             We value your trust in providing us your
  //             Personal Information, thus we are striving to use commercially
  //             acceptable means of protecting it. But remember that no method
  //             of transmission over the internet, or method of electronic
  //             storage is 100% secure and reliable, and We cannot
  //             guarantee its absolute security.
  //           </p>
  //           <p><strong>Links to Other Sites</strong></p>
  //           <p>
  //             This Service may contain links to other sites. If you click on
  //             a third-party link, you will be directed to that site. Note
  //             that these external sites are not operated by us.
  //             Therefore, We strongly advise you to review the
  //             Privacy Policy of these websites. We have
  //             no control over and assume no responsibility for the content,
  //             privacy policies, or practices of any third-party sites or
  //             services.
  //           </p>
  //           <p><strong>Children’s Privacy</strong></p>
  //           <div>
  //           <p> These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13 years of age. In the case We discover that a child under 13 has provided us with personal information, We immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that We will be able to do the necessary actions. </p>
  //            </div> <!---->
  //           <p><strong>Changes to This Privacy Policy</strong></p>
  //           <p> We may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. We will notify you of any changes by posting the new Privacy Policy on this page. </p>
  //           <p>This policy is effective as of 2024-06-01</p> <p><strong>Contact Us</strong></p>
  //           <p>If you have any questions or suggestions about our Privacy Policy, do not hesitate to contact me at: </p>
  //           <p>minhviet.dragon@gmail.com</p>
  //           <p>This privacy policy page was created at <a href="https://privacypolicytemplate.net" target="_blank" rel="noopener noreferrer">privacypolicytemplate.net </a>and modified/generated by <a href="https://app-privacy-policy-generator.nisrulz.com/" target="_blank" rel="noopener noreferrer">App Privacy Policy Generator</a></p>
  //           </body>
  //           </html>
  //           ''',
  //           ),
  //         ),
  //
  //         Text("\n3", style: styleTextNumberPage, textAlign: TextAlign.center,),
  //       ],
  //     ),
  //   ),
  //
  //   //Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
  //   decoration: pageDecoration.copyWith(
  //     bodyFlex: 7, // Chiếm diện tích của body
  //     imageFlex: 3, // Chiếm diện tích của image
  //     bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
  //     imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
  //     // pageColor: Colors.lightGreen,
  //   ),
  //   // image: _buildImage('images/lotus_10.jpg'),
  // ),
];

//II.2 List bao gồm từng trang PageViewModel của phần: Hướng dẫn tập cơ bản
List<PageViewModel> listPageViewModelHuongDanTapCoBan = [

  //1. Trang hướng dẫn học pháp
  PageViewModel(
    title: "Hướng dẫn tổng quan",
    reverse: true, // Đảo ngược thứ tự title và ảnh
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration (
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "\"Tu\" là từ Hán Việt, \"tu\" có nghĩa là sửa hay sửa đổi, còn \"luyện\" là rèn luyện, mục đích để đảm bảo, giữ gìn những gì sau khi tu được. Có thể nói rằng \"tu luyện\" là việc sửa lại bản thân và giữ gìn những gì đã sửa được.\n"
            "\nPháp Luân Công là môn tu luyện của Phật Pháp giúp người học có thể tu luyện ngay trong cuộc sống như tại gia đình, nơi làm việc, trường học ... Trong đó chú trọng việc sửa đổi các tâm tính không tốt như tâm tật đố, tâm lý hiển thị, tâm tranh đấu ...\n"
            "\nViệc tập luyện 5 bài công pháp giúp học viên trở nên khoẻ mạnh hơn nhờ những thay đổi tích cực của cơ thể."
            "\nĐể tu luyện tâm tính, học viên cần học pháp bằng việc lắng nghe 9 bài giảng của sư phụ hoặc đọc sách, trong đó sách chính là Chuyển Pháp Luân (có chung nội dung với 9 bài giảng)."
            "\nTại trang chủ www.falundafa.org còn có các sách và kinh văn như: Sách Đại Viên Mãn Pháp giúp hiểu rõ cơ lý của động tác, sách hỗ trợ khác như Tinh Tấn Yếu Chỉ và giảng pháp tại các nơi của sư phụ (có giải đáp nhiều câu hỏi của học viên) ...\n"
            "\nHọc viên cũng có thể truy cập trang minghui.org để theo dõi các thông tin mới và bài viết quan trọng của môn học như: Ba việc nên làm của đệ tử Đại Pháp, bài viết \"Vì sao có nhân loại\"...\n"
            "\nKhi đọc sách, kinh văn, học viên nên đặt sách, kinh văn ở những nơi như trên bàn, giá đỡ trên cao, tĩnh. Không nên đặt ở những nơi thấp như dưới đất, sàn nhà, hoặc nơi rung lắc ... Học viên có thể vừa ngồi song bàn vừa đọc.\n"
            ,
            style: styleTextBody2, textAlign: TextAlign.justify,
          ),
          
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   ClipRRect(
          //     borderRadius: BorderRadius.circular(15),
          //     child: Image.asset("assets/images/phone_1.jpg", width: 150),
          //   ),
          //   ClipRRect(
          //     borderRadius: BorderRadius.circular(15),
          //     child: Image.asset("assets/images/phone_2.jpg", width: 150)
          //   ),
          // ],),

          Text(
            "Trong quá trình học tập, các học viên có thể kết nối với nhau để tham khảo, chia sẻ quá trình học tập, giúp bản thân có thêm góc nhìn. Tu luyện là một quá trình lâu dài nên khi mới tập các học viên nên kiên nhẫn và thực hiện tốt việc học tập của mình."
            ,
            style: styleTextBody2, textAlign: TextAlign.justify,
          ),

          Text("\n1", style: styleTextNumberPage, textAlign: TextAlign.right,),
        ],
      ),
    ),

    // body: "Text", // Chỉ chọn một trong hai, và bắt buộc phải có 1 trong 2: (body == null) != (bodyWidget == null)
    // image: _buildFullscreenImage(), // Không dùng ảnh khi đã có bodyWidget

    //Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
    decoration: pageDecoration.copyWith(
      bodyFlex: 7, // Chiếm diện tích của body
      imageFlex: 3, // Chiếm diện tích của image
      bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
      imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
      // pageColor: Colors.lightGreen,
    ),
    // image: _buildImage('images/lotus_10.jpg'),
  ),

  //2. Hướng dẫn luyện công cơ bản
  PageViewModel (
    title: "Phần luyện công",
    reverse: true, // Đảo ngược thứ tự title và ảnh
    bodyWidget: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration (
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "Khi mới tập, học viên có thể chỉ cần đơn giản là tập theo động tác của các học viên đã biết tập, hoặc theo video của học viên tập mẫu.\n"
            ,
            style: styleTextBody2, textAlign: TextAlign.justify,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset("assets/images/anh_bai_1.jpg", width: double.infinity),
          ),
          Text(
            "\nSau khi đã tập tương đối quen khoảng 1~2 tháng, học viên cần điều chỉnh động tác cho chính xác bằng cách đọc sách Đại Viên Mãn Pháp để hiểu rõ cơ lý của từng động tác hoặc xem video hướng dẫn tập trong trang falundafa.org. Ngoài ra cũng có thể nhờ các học viên đã tập thành thạo điều chỉnh giúp. \n\nSau đây là hướng dẫn của App cho học viên mới tiếp cận.\n"
            "\n○ Khi nhìn và tập theo học viên tập mẫu:"
            "\n- Bài 1,3,5: Động tác của nam đối xứng với nữ, nữ đối xứng với nam."
            "\n- Bài 2: Nam/nữ động tác như nhau."
            "\n- Bài 4: Nam/nữ tập theo nam hoặc nữ\n"
            "\n○ Tư thế chuẩn bị cho cả 5 bài:"
            "\n- Chân rộng bằng vai đối với những bài tập tư thế đứng. Đầu gối hơi trùng nhẹ, không thẳng cứng."
            "\n- Lưỡi đặt hàm trên, hàm răng tách hở ra, môi miệng ngậm lại."
            "\n- Đầu luôn ngay ngắn, hướng về phía trước, tâm tĩnh."
            "\n- Nhắm mắt khi tập (khi đã thuộc động tác, nhịp tập)."
            "\n- Động tác \"Điệp khấu tiểu phúc\" (Hai tay đặt trước bụng) thì hai tay cách nhau khoảng một lần độ dày của bàn tay, đồng thời cách bụng cũng tầm đó (không chạm vào bụng).\n"
            "\n○ Lưu ý trong từng bài tập:"
            "\n - Bài 1: Duỗi thành động tác, sau đó mới căng lên rồi đột nhiên buông lỏng."
            "\n - Bài 2: Thời lượng tập của mỗi động tác có thể để lâu bao nhiêu thì để bấy lâu."
            "\n - Bài 3: Lưu ý hướng của lòng bàn tay."
            "\n - Bài 4: Tay không chạm vào cơ thể."
            "\n - Bài 5: Có thể tập lâu bao nhiêu thì để bấy lâu.",
            style: styleTextBody2, textAlign: TextAlign.justify,
          ),
          Text("\n2", style: styleTextNumberPage, textAlign: TextAlign.right,),
        ],
      ),
    ),

    // Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
    decoration: pageDecoration.copyWith (
      bodyFlex: 7, // Chiếm diện tích của body
      imageFlex: 3, // Chiếm diện tích của image
      bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
      imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
      // pageColor: Colors.lightGreen, // Màu nền trang
    ),
  ),
];

//II.3 List trang PageViewModel của phần: Liên hệ
// List<PageViewModel> listPageViewModelLienHe = [
//
//   //1. Trang hướng dẫn học pháp
//   PageViewModel(
//     title: "Liên hệ",
//     reverse: true, // Đảo ngược thứ tự title và ảnh
//     bodyWidget: Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration (
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Mọi thông tin liên hệ vui lòng gửi đến: \nEmail: mvdragon.dev@gmail.com",
//             style: styleTextBody2, textAlign: TextAlign.justify,
//           ),
//         ],
//       ),
//     ),
//
//     //Kiểu dáng (sao chép của mẫu chung, cài đặt thêm tính năng riêng)
//     decoration: pageDecoration.copyWith(
//       bodyFlex: 7, // Chiếm diện tích của body
//       imageFlex: 3, // Chiếm diện tích của image
//       bodyAlignment: Alignment.topCenter, // Căn chỉnh vị trí của bodyWidget
//       imageAlignment: Alignment.bottomCenter, // Căn chỉnh vị trí của image (nếu có)
//       // pageColor: Colors.lightGreen,
//     ),
//   ),
// ];