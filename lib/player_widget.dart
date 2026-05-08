import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as audio_session;
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
  static const String _selectedPracticeIndicesKey = "selected_practice_indices_v1";

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
  StreamSubscription<void>? _completeSub;
  bool _selectionMode = false;
  List<int> _selectedIndices = <int>[];
  List<int> _queue = <int>[];
  int _queuePointer = -1;

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
    unawaited(_configureAudioSession());
    _getIndexCurrent(); // Lấy indexCurrent (Thứ tự bài nhạc đã play gần nhất) lưu shared
    _loadDownloadedPathMap();
    _loadSelectedIndices();
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
    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      unawaited(_playNextInQueue());
    });
  }

  Future<void> _configureAudioSession() async {
    try {
      final session = await audio_session.AudioSession.instance;
      await session.configure(audio_session.AudioSessionConfiguration.music());
      await _audioPlayer.setAudioContext(
        AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: <AVAudioSessionOptions>{
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
        ),
      );
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      debugPrint("Audio session config error: $e");
    }
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

  Future<void> _loadSelectedIndices() async {
    final shared = await SharedPreferences.getInstance();
    final raw = shared.getString(_selectedPracticeIndicesKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        final loaded = decoded
            .whereType<int>()
            .where((e) => e >= 0 && e < listInternetSource.length)
            .toList();
        if (!mounted) return;
        setState(() {
          _selectedIndices = loaded;
        });
      }
    } catch (_) {
      // Ignore invalid legacy data.
    }
  }

  Future<void> _saveSelectedIndices() async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString(_selectedPracticeIndicesKey, jsonEncode(_selectedIndices));
  }

  bool _isDownloaded(int index) {
    return _downloadedPathMap.containsKey(listInternetSource[index].linkUrl);
  }

  bool get _hasDownloadedAny {
    for (var i = 0; i < listInternetSource.length; i++) {
      if (_isDownloaded(i)) return true;
    }
    return false;
  }

  bool get _isSelectedQueueActive {
    if (_queue.isEmpty || _queuePointer < 0 || _queuePointer >= _queue.length) {
      return false;
    }
    return _selectedIndices.contains(_queue[_queuePointer]);
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();
    _completeSub?.cancel();
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

      body: Column(
        children: [
          _buildSelectionControls(),
          const SizedBox(height: 12),
          Expanded(child: listViewItem()),
        ],
      ),
    );
  }

  Widget _buildSelectionControls() {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey.shade50,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuButton(
                        icon: _selectionMode ? Icons.check_box : Icons.check_box_outlined,
                        label: _selectionMode ? "Done" : "Select",
                        onTap: () {
                          setState(() {
                            _selectionMode = !_selectionMode;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _menuButton(
                        icon: _isSelectedQueueActive
                            ? (_playerState == PlayerState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded)
                            : Icons.play_arrow_rounded,
                        label: _isSelectedQueueActive
                            ? (_playerState == PlayerState.playing ? "Pause Selected" : "Resume Selected")
                            : "Play Selected",
                        enabled: _selectedIndices.isNotEmpty,
                        highlighted: _selectedIndices.isNotEmpty,
                        onTap: () async {
                          if (_isSelectedQueueActive) {
                            if (_playerState == PlayerState.playing) {
                              await _audioPlayer.pause();
                            } else if (_playerState == PlayerState.paused) {
                              await _audioPlayer.resume();
                            } else {
                              await _startSelectedQueue();
                            }
                            return;
                          }
                          setState(() {
                            _selectionMode = false; // Bấm play coi như đã chọn xong
                          });
                          await _startSelectedQueue();
                        },
                      ),
                      const SizedBox(width: 8),
                      _menuButton(
                        icon: Icons.clear_all,
                        label: "Clear",
                        enabled: _selectedIndices.isNotEmpty,
                        onTap: () {
                          setState(() {
                            _selectedIndices.clear();
                          });
                          unawaited(_saveSelectedIndices());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildSelectedTracksWidget(),
                ),
              ],
            ),
          ],
        ),
      );
  }

  Widget _buildSelectedTracksWidget() {
    if (_selectedIndices.isEmpty) {
      if (_selectionMode && !_hasDownloadedAny) {
        return Text(
          "Please download tracks to use this feature.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Selected: none",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      );
    }

    final spans = <InlineSpan>[
      TextSpan(
        text: "Selected: ",
        style: TextStyle(
          fontSize: 13,
          color: Colors.blueGrey.shade700,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    ];

    for (var i = 0; i < _selectedIndices.length; i++) {
      final index = _selectedIndices[i];
      final isCurrent = index == _offlinePlayingIndex;
      spans.add(
        TextSpan(
          text: listInternetSource[index].name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? Colors.deepOrange : Colors.blueGrey.shade700,
            height: 1.35,
          ),
        ),
      );
      if (i < _selectedIndices.length - 1) {
        spans.add(
          TextSpan(
            text: ", ",
            style: TextStyle(
              fontSize: 13,
              color: Colors.blueGrey.shade500,
              height: 1.35,
            ),
          ),
        );
      }
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
    bool highlighted = false,
  }) {
    final isHighlighted = enabled && highlighted;
    final backgroundColor = isHighlighted
        ? Colors.orangeAccent.withValues(alpha: 0.18)
        : (enabled ? Colors.white : Colors.grey.shade200);
    final foregroundColor = isHighlighted
        ? Colors.deepOrange
        : (enabled ? Colors.blueGrey.shade800 : Colors.grey);

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isHighlighted ? Colors.orangeAccent : Colors.blueGrey.shade100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: foregroundColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
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
            _onPlayPausePressed(index);
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
                    if (_selectionMode)
                      Checkbox(
                        value: _selectedIndices.contains(index),
                        onChanged: _isDownloaded(index)
                            ? (value) {
                                setState(() {
                                  if (value == true) {
                                    if (!_selectedIndices.contains(index)) {
                                      _selectedIndices.add(index);
                                    }
                                  } else {
                                    _selectedIndices.remove(index);
                                  }
                                });
                                unawaited(_saveSelectedIndices());
                              }
                            : null,
                      ),
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
                              _selectedIndices.remove(index);
                              unawaited(_saveSelectedIndices());
                            }
                            if (mounted) {
                              setState(() {});
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
    _queue = <int>[];
    _queuePointer = -1;
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
    if (_selectedIndices.isNotEmpty) {
      if (_selectedIndices.contains(index)) {
        await _playFromSelectedIndex(index);
      } else {
        _queue = <int>[];
        _queuePointer = -1;
        await _playAudio(index);
      }
      return;
    }
    await _playAudio(index);
  }

  Future<void> _startSelectedQueue() async {
    final valid = <int>[];
    for (final index in _selectedIndices) {
      final url = listInternetSource[index].linkUrl;
      final path = _downloadedPathMap[url];
      if (path == null) continue;
      if (await File(path).exists()) {
        valid.add(index);
      } else {
        await DownloadedAudioStore.remove(url);
        _downloadedPathMap.remove(url);
      }
    }

    if (valid.isEmpty) {
      _selectedIndices.clear();
      await _saveSelectedIndices();
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No downloaded tracks in your selection.")),
      );
      return;
    }

    _queue = valid;
    _queuePointer = 0;
    await _playOfflineFromQueueIndex(_queue[_queuePointer]);
  }

  Future<void> _playOfflineFromQueueIndex(int index) async {
    final url = listInternetSource[index].linkUrl;
    final path = _downloadedPathMap[url];
    if (path == null || !await File(path).exists()) {
      _downloadedPathMap.remove(url);
      _selectedIndices.remove(index);
      await DownloadedAudioStore.remove(url);
      await _saveSelectedIndices();
      await _playNextInQueue();
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(DeviceFileSource(path));
    if (!mounted) return;
    setState(() {
      _offlinePlayingIndex = index;
      _position = Duration.zero;
      indexCurrent = index;
    });
    unawaited(_setIndexCurrentShared(index));
  }

  Future<void> _playNextInQueue() async {
    if (_queue.isEmpty) return;
    _queuePointer += 1;
    if (_queuePointer >= _queue.length) {
      _queue = <int>[];
      _queuePointer = -1;
      if (!mounted) return;
      setState(() {
        _offlinePlayingIndex = null;
        _position = Duration.zero;
        _duration = Duration.zero;
      });
      return;
    }
    await _playOfflineFromQueueIndex(_queue[_queuePointer]);
  }

  Future<void> _playFromSelectedIndex(int index) async {
    final valid = <int>[];
    for (final selectedIndex in _selectedIndices) {
      final url = listInternetSource[selectedIndex].linkUrl;
      final path = _downloadedPathMap[url];
      if (path == null) continue;
      if (await File(path).exists()) {
        valid.add(selectedIndex);
      } else {
        await DownloadedAudioStore.remove(url);
        _downloadedPathMap.remove(url);
      }
    }

    if (valid.isEmpty) {
      await _startSelectedQueue();
      return;
    }

    _queue = valid;
    _queuePointer = valid.indexOf(index);
    if (_queuePointer < 0) {
      _queuePointer = 0;
    }
    await _playOfflineFromQueueIndex(_queue[_queuePointer]);
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
