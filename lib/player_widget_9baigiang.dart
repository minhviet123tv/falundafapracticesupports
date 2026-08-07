import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';
import 'package:falun_dafa_practice_supports/common/app_language_sync.dart';
import 'package:falun_dafa_practice_supports/common/app_text_theme.dart';
import 'package:falun_dafa_practice_supports/common/language_menu_order.dart';
import 'package:falun_dafa_practice_supports/common/swipe_to_back.dart';

import 'controller_app/link_internet_list_baigiang_quocte.dart';
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
  TextStyle textStyle18 = TextStyle(fontSize: 19, color: Colors.black);
  TextStyle textStyle16 = TextStyle(fontSize: 17, color: Colors.black);
  var styleTextTitle = AppTextStyles.title(fontSize: 19);
  double border10 = 10.0;
  late LanguageNameAndCode languageNameAndCode; // Xác định ngôn ngữ theo enum tự tạo
  Map<String, String> _downloadedPathMap = <String, String>{};
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  int? _offlinePlayingIndex;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<PlayerState>? _stateSub;

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
    _loadDownloadedPathMap();
    _positionSub = _audioPlayer.onPositionChanged.listen((value) {
      if (!mounted) return;
      setState(() => _position = value);
    });
    _durationSub = _audioPlayer.onDurationChanged.listen((value) {
      if (!mounted) return;
      setState(() => _duration = value);
    });
    _stateSub = _audioPlayer.onPlayerStateChanged.listen((value) {
      if (!mounted) return;
      setState(() => _playerState = value);
    });

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

  Future<void> _loadDownloadedPathMap() async {
    final map = await DownloadedAudioStore.getAll();
    if (!mounted) return;
    setState(() {
      _downloadedPathMap = map;
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
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
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: PopupMenuButton<LanguageNameAndCode>(
              tooltip: 'Select language',
              position: PopupMenuPosition.under,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(border10)),
              onSelected: (LanguageNameAndCode value) {
                setState(() {
                  languageNameAndCode = value;
                  _getListInternetSource();
                  _setLanguageEnum(languageNameAndCode);
                });
                unawaited(AppLanguageSync.onUserSelected(value.name));
              },
              itemBuilder: (context) {
                final ordered = LanguageMenuOrder.sort(
                  LanguageNameAndCode.values,
                  name: (e) => e.name,
                  label: (e) => e.tengoc,
                );
                return ordered
                    .map(
                      (value) => PopupMenuItem<LanguageNameAndCode>(
                        value: value,
                        height: 44,
                        child: Text(value.tengoc,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(border10)),
                  border: Border.all(color: Colors.white70),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.audiotrack, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        languageNameAndCode.tengoc,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 18, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ),
        title: Text(listInternetSource[indexCurrent].name, style: styleTextTitle),
        centerTitle: true,
        toolbarHeight: 60,
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
            indexCurrent = index; // Cập nhật index
            _setIndexCurrentShared(index); // Lưu shared
            setState(() { }); // Cập nhật index được chọn trên UI
            _playAudio(index);

          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            color: index == indexCurrent ? Colors.deepPurple[200] : Colors.grey[200], // Phải cập nhật ở Provider để lấy đúng indexCurrent khi có thay đổi
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //I. Tên item
                    Expanded(child: Text("${listInternetSource[index].name}", style: textStyle16, overflow: TextOverflow.ellipsis,)),

                    //II. Nhóm icon download và open in browser
                    Row(
                      children: [

                    //1. Icon play (Chức năng giống như click vào item, nhưng để hiện nút cho dễ hiểu)
                    IconButton(
                      onPressed: (){
                        indexCurrent = index; // Cập nhật index cho Provider
                        _setIndexCurrentShared(index); // Lưu index vào shared
                        _onPlayPausePressed(index);
                        setState(() {}); //set state để cập nhật và tránh việc bị lag
                      },
                      icon: Icon(
                        _offlinePlayingIndex == index && _playerState == PlayerState.playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.orangeAccent,
                        size: 32,
                      ),
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
                        child: DownloadFromUrl(
                          key: ValueKey(
                            '${listInternetSource[index].linkUrl}_${_downloadedPathMap[listInternetSource[index].linkUrl] ?? ''}',
                          ),
                          url: listInternetSource[index].linkUrl,
                          onDownloadCompleted: (path) {
                            _downloadedPathMap[listInternetSource[index].linkUrl] = path;
                            if (mounted) setState(() {});
                          },
                          onDownloadStateChanged: (isDone) {
                            if (!isDone) {
                              _downloadedPathMap.remove(listInternetSource[index].linkUrl);
                            }
                          },
                        )
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
                if (_offlinePlayingIndex == index) _buildOfflineProgress(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineProgress() {
    final maxMs = _duration.inMilliseconds <= 0 ? 1 : _duration.inMilliseconds;
    final currentMs = _position.inMilliseconds.clamp(0, maxMs);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Slider(
            min: 0,
            max: maxMs.toDouble(),
            value: currentMs.toDouble(),
            onChanged: (value) => _audioPlayer.seek(Duration(milliseconds: value.toInt())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position), style: const TextStyle(fontSize: 12)),
              Text(_formatDuration(_duration), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = value.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _playAudio(int index) async {
    final onlineUrl = listInternetSource[index].linkUrl;
    final localPathFromMap = _downloadedPathMap[onlineUrl];

    if (localPathFromMap != null) {
      final file = File(localPathFromMap);
      if (await file.exists()) {
        await _audioPlayer.stop();
        await _audioPlayer.play(DeviceFileSource(localPathFromMap));
        if (!mounted) return;
        setState(() {
          _offlinePlayingIndex = index;
          _position = Duration.zero;
        });
        return;
      } else {
        await DownloadedAudioStore.remove(onlineUrl);
        _downloadedPathMap.remove(onlineUrl);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("File offline không còn tồn tại, chuyển sang phát online.")),
          );
          setState(() {});
        }
      }
    }

    await _audioPlayer.stop();
    if (mounted) {
      setState(() {
        _offlinePlayingIndex = null;
        _position = Duration.zero;
        _duration = Duration.zero;
      });
    }
    if (!mounted) return;
    AppNavigator.push(
      context,
      WebViewBrowserAudio(
        linkUrl: onlineUrl,
        title: '${listInternetSource[index].name}',
      ),
    );
  }

  Future<void> _onPlayPausePressed(int index) async {
    final isCurrentOffline = _offlinePlayingIndex == index;
    if (isCurrentOffline && _playerState == PlayerState.playing) {
      await _audioPlayer.pause();
      return;
    }
    if (isCurrentOffline && _playerState == PlayerState.paused) {
      await _audioPlayer.resume();
      return;
    }
    await _playAudio(index);
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