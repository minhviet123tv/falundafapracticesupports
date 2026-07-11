import 'package:flutter/material.dart';

import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:audio_session/audio_session.dart' as audio_session;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';
import 'package:falun_dafa_practice_supports/common/offline_audio_helper.dart';

import 'menu/play_audio_webview.dart';
import 'download_from_url.dart';
import 'common/swipe_to_back.dart';

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
  late int indexCurrent = 0;
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
  StreamSubscription<audio_session.AudioInterruptionEvent>? _interruptionSub;

  List<AudioSourceModelInternet> listInternetSource = [
    AudioSourceModelInternet("Exercise 1", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_01.mp3"),
    AudioSourceModelInternet("Exercise 2", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_02.mp3"),
    AudioSourceModelInternet("Exercise 3", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_03.mp3"),
    AudioSourceModelInternet("Exercise 4", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_04.mp3"),
    AudioSourceModelInternet("Exercise 5", "https://media.falundafa.org/media1/media/dafa/exercise/320k/exercise_05.mp3"),
    AudioSourceModelInternet("发正念", "https://media.falundafa.org/media1/media/dafa/music/48k/fzn15.mp3"),
  ];

  @override
  void initState() {
    super.initState();
    unawaited(_configureAudioSession());
    _getIndexCurrent();
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

      await _interruptionSub?.cancel();
      _interruptionSub = session.interruptionEventStream.listen((event) {
        if (event.begin) return;
        unawaited(_onAudioInterruptionEnded());
      });
    } catch (e) {
      debugPrint("Audio session config error: $e");
    }
  }

  Future<void> _onAudioInterruptionEnded() async {
    await _ensurePlaybackSessionActive();
    if (!mounted) return;
    if (_offlinePlayingIndex == null) return;
    try {
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Practice audio resume after interruption: $e");
    }

    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted || _offlinePlayingIndex == null) return;
    await _recoverStalledIfNeededBasedOnOfflineContext();
  }

  Future<void> _recoverStalledIfNeeded({
    required bool Function() stillValid,
    required String devicePath,
  }) async {
    Future<void> hardReplay() async {
      if (!stillValid()) return;
      await _ensurePlaybackSessionActive();
      await _audioPlayer.stop();
      await Future<void>.delayed(const Duration(milliseconds: 80));
      await _ensurePlaybackSessionActive();
      await _audioPlayer.play(DeviceFileSource(devicePath));
    }

    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!stillValid() || !mounted) return;

    bool stalledAtStart() =>
        _audioPlayer.state == PlayerState.playing &&
        _duration > const Duration(seconds: 1) &&
        _position < const Duration(milliseconds: 450);

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!stillValid() || !mounted) return;

    final bool zombiePlaying = _audioPlayer.state == PlayerState.playing &&
        _duration <= Duration.zero &&
        _position <= Duration.zero;

    if (!stalledAtStart() && !zombiePlaying) return;

    debugPrint(
      "Practice audio: stalled/zombie (${_audioPlayer.state}, pos=${_position.inMilliseconds}, dur=${_duration.inMilliseconds}) → soft recover",
    );
    await _ensurePlaybackSessionActive();
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint("Practice audio soft recover failed: $e");
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!stillValid() || !mounted) return;

    final bool stillStalledAfterSoft = stalledAtStart() ||
        (_audioPlayer.state == PlayerState.playing && zombiePlaying);
    if (stillStalledAfterSoft) {
      debugPrint("Practice audio: still stalled → hard replay");
      await hardReplay();

      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (!stillValid() || !mounted) return;
      final bool z2 = _audioPlayer.state == PlayerState.playing &&
          _duration <= Duration.zero &&
          _position <= Duration.zero;
      if (stalledAtStart() ||
          (_audioPlayer.state == PlayerState.playing && z2)) {
        await hardReplay();
      }
    }
  }

  Future<void> _recoverStalledIfNeededBasedOnOfflineContext() async {
    final index = _offlinePlayingIndex;
    if (index == null || index < 0 || index >= listInternetSource.length) {
      return;
    }
    final url = listInternetSource[index].linkUrl;
    final path = await DownloadedAudioStore.resolvePlayablePath(
      url,
      memoryMap: _downloadedPathMap,
    );
    if (path == null) return;
    await _recoverStalledIfNeeded(
      stillValid: () => mounted && _offlinePlayingIndex == index,
      devicePath: path,
    );
  }

  Future<void> _ensurePlaybackSessionActive() async {
    try {
      final session = await audio_session.AudioSession.instance;
      await session.setActive(true);
    } catch (e) {
      debugPrint("Audio session setActive failed: $e");
    }
  }

  Future<void> _startSingleOfflinePlaybackWithFocusRetry(String path, int index) async {
    final devicePath = OfflineAudioHelper.normalizeLocalPath(path);

    await OfflineAudioHelper.playLocalFile(_audioPlayer, devicePath);

    unawaited(
      _recoverStalledIfNeeded(
        stillValid: () => mounted && _offlinePlayingIndex == index,
        devicePath: devicePath,
      ),
    );
  }

  _getIndexCurrent() async {
    final shared = await SharedPreferences.getInstance();
    int index = shared.getInt("indexCurrent_nhacluyencong") ?? 0;
    if(index >= listInternetSource.length){
      index = listInternetSource.length - 1;
    } else if(index < 0){
      index = 0;
    }
    indexCurrent = index;
    setState(() { });
  }

  _setIndexCurrentShared(int index) async {
    final shared = await SharedPreferences.getInstance();
    shared.setInt("indexCurrent_nhacluyencong", index);
  }

  Future<void> _loadDownloadedPathMap() async {
    final map = await DownloadedAudioStore.getAll();
    // Chuẩn hóa + loại bỏ path chết; ưu tiên file trong offline_audio.
    final cleaned = <String, String>{};
    for (final entry in map.entries) {
      final playable = await DownloadedAudioStore.resolvePlayablePath(entry.key);
      if (playable != null) {
        cleaned[DownloadedAudioStore.normalizeUrl(entry.key)] = playable;
      }
    }
    if (!mounted) return;
    setState(() {
      _downloadedPathMap = cleaned;
    });
  }

  @override
  void dispose() {
    final interruptionCancel = _interruptionSub?.cancel();
    _interruptionSub = null;
    if (interruptionCancel != null) unawaited(interruptionCancel);
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

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

  Widget listViewItem() {
    return ListView.builder(
      itemCount: listInternetSource.length,
      itemBuilder: (BuildContext context, int index) {

        return GestureDetector(
          onTap: (){
            indexCurrent = index;
            _setIndexCurrentShared(index);
            _onPlayPausePressed(index);
            setState(() {});
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
                    Expanded(
                      child: Text("${listInternetSource[index].name}", style: textStyle16, overflow: TextOverflow.ellipsis,),
                    ),
                    Row(
                      children: [
                    IconButton(
                      onPressed: (){
                        indexCurrent = index;
                        _setIndexCurrentShared(index);
                        _onPlayPausePressed(index);
                        setState(() {});
                      },
                      icon: Icon(
                        _offlinePlayingIndex == index && _playerState == PlayerState.playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.orangeAccent,
                        size: 32,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 60, height: 50,
                      child: DownloadFromUrl(
                          key: ValueKey(
                            '${listInternetSource[index].linkUrl}_${_downloadedPathMap[DownloadedAudioStore.normalizeUrl(listInternetSource[index].linkUrl)] ?? ''}',
                          ),
                          url: listInternetSource[index].linkUrl,
                          onDownloadCompleted: (path) {
                            final key = DownloadedAudioStore.normalizeUrl(
                              listInternetSource[index].linkUrl,
                            );
                            _downloadedPathMap[key] =
                                OfflineAudioHelper.normalizeLocalPath(path);
                            if (mounted) setState(() {});
                          },
                          onDownloadStateChanged: (isDone) {
                            final key = DownloadedAudioStore.normalizeUrl(
                              listInternetSource[index].linkUrl,
                            );
                            if (!isDone) {
                              _downloadedPathMap.remove(key);
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                    ),
                    IconButton(
                      onPressed: (){
                        _openInBrowser(Uri.parse(listInternetSource[index].linkUrl));
                        indexCurrent = index;
                        _setIndexCurrentShared(index);
                        setState(() {});
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
    final localPath = await DownloadedAudioStore.resolvePlayablePath(
      onlineUrl,
      memoryMap: _downloadedPathMap,
    );

    if (localPath != null) {
      if (!mounted) return;
      setState(() {
        _offlinePlayingIndex = index;
        _position = Duration.zero;
        _duration = Duration.zero;
      });
      try {
        await _startSingleOfflinePlaybackWithFocusRetry(localPath, index);
      } catch (e) {
        debugPrint('Practice audio play failed: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không phát được file offline: $e')),
        );
      }
      return;
    }

    final staleKey = DownloadedAudioStore.normalizeUrl(onlineUrl);
    if (_downloadedPathMap.containsKey(staleKey)) {
      _downloadedPathMap.remove(staleKey);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Không tìm thấy file offline — hãy Reset rồi tải lại. Đang mở online.',
            ),
          ),
        );
        setState(() {});
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
        title: listInternetSource[index].name,
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

  Future<void> _openInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $url');
    }
  }

}

class AudioSourceModelInternet{
  String name;
  String linkUrl;

  AudioSourceModelInternet(this.name, this.linkUrl);
}
