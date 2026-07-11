import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';
import 'package:falun_dafa_practice_supports/common/offline_audio_helper.dart';

/*
Widget tải audio → % tiến trình → tick xanh (reset).
File được lưu vào thư mục riêng của app (offline_audio) để audioplayers
luôn đọc được trên Android 10+ / Samsung (không phụ thuộc Download công khai).
 */

class DownloadFromUrl extends StatefulWidget {
  final String url;
  final ValueChanged<String>? onDownloadCompleted;
  final ValueChanged<bool>? onDownloadStateChanged;

  const DownloadFromUrl({
    required this.url,
    this.onDownloadCompleted,
    this.onDownloadStateChanged,
    super.key,
  });

  @override
  State<DownloadFromUrl> createState() => _DownloadFromUrlState();
}

class _DownloadFromUrlState extends State<DownloadFromUrl> {
  double _progress = 0.0;
  bool downloadDone = false;
  bool showLoading = false;
  String? _localPath;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_syncDownloadStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_progress == 0 && !downloadDone && !showLoading)
            IconButton(
              onPressed: _downloading
                  ? null
                  : () {
                      unawaited(_startDownload());
                    },
              icon: const Icon(Icons.download, color: Colors.deepPurple),
            ),
          if (showLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_progress != 0 && !downloadDone)
            Text('${_progress.toStringAsFixed(0)} %'),
          if (downloadDone)
            IconButton(
              onPressed: () => unawaited(_confirmResetDownload()),
              tooltip: 'Reset bản tải về',
              icon: const Icon(Icons.check, color: Colors.green),
            ),
        ],
      ),
    );
  }

  Future<void> _startDownload() async {
    if (_downloading) return;
    _downloading = true;
    setState(() {
      downloadDone = false;
      showLoading = true;
      _progress = 0;
    });

    final url = widget.url.trim();
    try {
      final path = await _downloadToAppStorage(url);
      await _onDownloadSuccess(path);
    } catch (e, st) {
      debugPrint('App http download failed: $e\n$st');
      try {
        await _downloadViaPluginFallback(url);
      } catch (e2, st2) {
        debugPrint('Plugin download failed: $e2\n$st2');
        if (!mounted) return;
        setState(() {
          showLoading = false;
          _progress = 0;
          downloadDone = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải xuống thất bại: $e2')),
        );
      }
    } finally {
      _downloading = false;
    }
  }

  /// Tải thẳng vào Documents/offline_audio — đường dẫn app kiểm soát 100%.
  Future<String> _downloadToAppStorage(String url) async {
    final targetPath = await OfflineAudioHelper.offlinePathForUrl(url);
    final tmpPath = '$targetPath.part';
    final tmpFile = File(tmpPath);
    if (await tmpFile.exists()) {
      await tmpFile.delete();
    }

    final request = http.Request('GET', Uri.parse(url));
    final response = await request.send();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('HTTP ${response.statusCode}');
    }

    final total = response.contentLength ?? 0;
    var received = 0;
    final sink = tmpFile.openWrite();
    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0 && mounted) {
          final pct = (received * 100 / total).clamp(0, 100).toDouble();
          setState(() {
            showLoading = false;
            _progress = pct;
          });
        } else if (mounted && showLoading) {
          setState(() => showLoading = false);
        }
      }
      await sink.flush();
    } finally {
      await sink.close();
    }

    final target = File(targetPath);
    if (await target.exists()) {
      await target.delete();
    }
    await tmpFile.rename(targetPath);

    if (!await OfflineAudioHelper.localFileReady(targetPath)) {
      throw StateError('Downloaded file empty: $targetPath');
    }
    return targetPath;
  }

  /// Fallback: plugin tải vào appFiles rồi copy sang offline_audio.
  Future<void> _downloadViaPluginFallback(String url) async {
    final completer = Completer<String>();
    FileDownloader.downloadFile(
      url: url,
      name: OfflineAudioHelper.fileNameForUrl(url),
      downloadDestination: DownloadDestinations.appFiles,
      notificationType: NotificationType.progressOnly,
      onProgress: (name, progress) {
        if (!mounted) return;
        setState(() {
          showLoading = false;
          _progress = progress;
        });
      },
      onDownloadCompleted: (path) async {
        try {
          final playable = await OfflineAudioHelper.ensurePlayableLocalFile(
            url: url,
            downloadedPath: path,
          );
          if (!completer.isCompleted) completer.complete(playable);
        } catch (e) {
          if (!completer.isCompleted) completer.completeError(e);
        }
      },
      onDownloadError: (message) {
        if (!completer.isCompleted) {
          completer.completeError(StateError(message));
        }
      },
    );
    final playable = await completer.future.timeout(
      const Duration(minutes: 10),
      onTimeout: () => throw TimeoutException('Download timeout'),
    );
    await _onDownloadSuccess(playable);
  }

  Future<void> _onDownloadSuccess(String path) async {
    final playable = await OfflineAudioHelper.ensurePlayableLocalFile(
      url: widget.url.trim(),
      downloadedPath: path,
    );
    await DownloadedAudioStore.save(widget.url.trim(), playable);
    _localPath = playable;
    if (!mounted) return;
    setState(() {
      _progress = 0;
      downloadDone = true;
      showLoading = false;
    });
    widget.onDownloadStateChanged?.call(true);
    widget.onDownloadCompleted?.call(playable);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã tải xong — có thể phát offline.')),
    );
  }

  Future<void> _syncDownloadStatus() async {
    final localPath =
        await DownloadedAudioStore.resolveExistingLocalPath(widget.url.trim());
    if (!mounted) return;
    setState(() {
      _localPath = localPath;
      downloadDone = localPath != null;
    });
    widget.onDownloadStateChanged?.call(downloadDone);
    if (localPath != null) {
      widget.onDownloadCompleted?.call(localPath);
    }
  }

  Future<void> _confirmResetDownload() async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
          actionsPadding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
          actionsAlignment: MainAxisAlignment.center,
          title: const Row(
            children: [
              Icon(Icons.restart_alt, color: Colors.deepPurple),
              SizedBox(width: 8),
              Text(
                'Reset track',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: const Text(
            'Do you want to reset this track?',
            style: TextStyle(fontSize: 15, height: 1.3),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(110, 42),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(110, 42),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) return;
    await _resetDownloadedFile();
  }

  Future<void> _resetDownloadedFile() async {
    final targetPath = _localPath ??
        await DownloadedAudioStore.resolveExistingLocalPath(widget.url.trim());
    if (targetPath != null && targetPath.isNotEmpty) {
      final file = File(OfflineAudioHelper.normalizeLocalPath(targetPath));
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          debugPrint('Reset audio delete failed: $e');
        }
      }
    }

    // Xóa cả file chuẩn trong offline_audio theo URL.
    try {
      final canonical =
          await OfflineAudioHelper.offlinePathForUrl(widget.url.trim());
      final f = File(canonical);
      if (await f.exists()) await f.delete();
    } catch (_) {}

    await DownloadedAudioStore.remove(widget.url.trim());

    if (!mounted) return;
    setState(() {
      _localPath = null;
      _progress = 0;
      downloadDone = false;
      showLoading = false;
    });
    widget.onDownloadStateChanged?.call(false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã reset bản tải về.')),
    );
  }
}
