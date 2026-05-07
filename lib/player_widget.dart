import 'package:flutter/material.dart';
import 'dart:io';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';

import 'menu/play_audio_webview.dart';
import 'download_from_url.dart';

//* Trang play nhạc luyện công
class PlayerWidget extends StatefulWidget {

  const PlayerWidget({super.key,}); // Hàm khởi tạo

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {

  //A. Dữ liệu
  late int indexCurrent = 0; // Vị trí đang được lựa chọn để play | Vị trí được chọn mặc định -> đầu list
  TextStyle textStyle18 = TextStyle(fontSize: 18, color: Colors.black);
  TextStyle textStyle16 = TextStyle(fontSize: 16, color: Colors.black);
  TextStyle styleTextTitle = TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20);
  Map<String, String> _downloadedPathMap = <String, String>{};
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  int? _offlinePlayingIndex;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;
  StreamSubscription<PlayerState>? _stateSub;

  // list chứa source trong assets | Vì dùng AssetsSource nên không cần ghi assets/ ở đầu
  List<AudioSourceModelInternet> listInternetSource = [
    AudioSourceModelInternet("Exercise 1", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_01.mp3"),
    AudioSourceModelInternet("Exercise 2", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_02.mp3"),
    AudioSourceModelInternet("Exercise 3", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_03.mp3"),
    AudioSourceModelInternet("Exercise 4", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_04.mp3"),
    AudioSourceModelInternet("Exercise 5", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_05.mp3"),
    AudioSourceModelInternet("发正念", "https://media.falundafa.org/media1/media/dafa/music/48k/fzn15.mp3"),
  ];

  //B. Khởi tạo
  @override
  void initState() {
    super.initState();
    _getIndexCurrent(); // Lấy indexCurrent (Thứ tự bài nhạc đã play gần nhất) lưu shared
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
  }

  //B.1 Lấy indexCurrent lưu shared
  _getIndexCurrent() async {
    final shared = await SharedPreferences.getInstance();
    int index = shared.getInt("indexCurrent_nhacluyencong") ?? 0;
    if(index >= listInternetSource.length){
      index = listInternetSource.length - 1;
    } else if(index < 0){
      index = 0;
    }
    indexCurrent = index;
    setState(() { }); // Cập nhật cho indexCurrent
  }

  //B.2 Lưu indexCurrent vào shared
  _setIndexCurrentShared(int index) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt("indexCurrent_nhacluyencong", index);
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

  //D. Trang
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(listInternetSource[indexCurrent].name, style: styleTextTitle,)),
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
            indexCurrent = index; // Cập nhật index cho Provider
            _setIndexCurrentShared(index); // Lưu index vào shared
            _playAudio(index);
            setState(() {}); //set state để cập nhật và tránh việc bị lag
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            color: index == indexCurrent ? Colors.deepPurple[200] : Colors.grey[200],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //I. Tên item
                    Expanded(
                      child: Text("${listInternetSource[index].name}", style: textStyle16, overflow: TextOverflow.ellipsis,),
                    ),

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

                    //2. Widget download về máy (Đã tạo sẵn) -> Chọn kích thước phù hợp để hiển thị. Tạo lưu khi click
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
                        ),
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
    Navigator.push(context, MaterialPageRoute(builder: (builder){
      return WebViewBrowserAudio(linkUrl: onlineUrl, title: '${listInternetSource[index].name}',);
    }));
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

// Tạo model truyền thông tin internet source
class AudioSourceModelInternet{
  String name;
  String linkUrl;

  AudioSourceModelInternet(this.name, this.linkUrl);
}
