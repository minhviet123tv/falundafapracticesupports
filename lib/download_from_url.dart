import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';

import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';
import 'package:falun_dafa_practice_supports/common/offline_audio_directory.dart';

/// Nút tải → loading → % → báo hoàn thành.
/// Trên Android/iOS dùng [background_downloader] (tiếp tục khi vào background, có retry/pause tuỳ server).

class DownloadFromUrl extends StatefulWidget {
  final String url;
  final ValueChanged<String>? onDownloadCompleted;
  final ValueChanged<bool>? onDownloadStateChanged;
  DownloadFromUrl({
    required this.url,
    this.onDownloadCompleted,
    this.onDownloadStateChanged,
    super.key,
  });
  @override
  State<DownloadFromUrl> createState() => _DownloadFromUrlState();
}

class _DownloadFromUrlState extends State<DownloadFromUrl> {
  double? _progress = 0.0;
  bool downloadDone = false;
  late bool showLoading = false;
  String? _localPath;

  @override
  void initState() {
    super.initState();
    _syncDownloadStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_progress == 0 && downloadDone == false && showLoading == false)
            IconButton(
              onPressed: () async {
                downloadDone = false;
                showLoading = true;
                setState(() {});
                await _download(widget.url.trim());
              },
              icon: const Icon(Icons.download, color: Colors.deepPurple),
            ),

          if (showLoading == true)
            const SizedBox(
              width: 20,
              height: 20,
              child: Center(child: CircularProgressIndicator()),
            ),

          if (_progress != null && _progress != 0)
            Text("${_progress!.clamp(0.0, 100.0).round()} %"),

          if (downloadDone == true)
            IconButton(
              onPressed: _confirmResetDownload,
              icon: const Icon(Icons.check, color: Colors.green),
            ),
        ],
      ),
    );
  }

  Future<void> _download(String urlText) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) {
      if (!mounted) return;
      setState(() {
        showLoading = false;
        _progress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tải xuống chỉ hỗ trợ Android / iOS'),
        ),
      );
      return;
    }

    final url = urlText.trim();
    final uri = Uri.tryParse(url);
    if (url.isEmpty || uri == null || !uri.hasScheme) {
      if (!mounted) return;
      setState(() {
        showLoading = false;
        _progress = 0.0;
        downloadDone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tải xuống thất bại: URL không hợp lệ')),
      );
      return;
    }

    final fname = _fileNameGuessFromUri(uri);
    final task = DownloadTask(
      url: url,
      filename: fname,
      directory: OfflineAudioDirectory.relativePath,
      baseDirectory: BaseDirectory.applicationDocuments,
      updates: Updates.statusAndProgress,
      retries: 2,
      allowPause: true,
      displayName: fname,
      group: 'audio_offline',
    );

    try {
      final result = await FileDownloader().download(
        task,
        onProgress: (p) {
          if (!mounted || p < 0) return;
          setState(() {
            _progress = (p * 100).clamp(0.0, 100.0);
            showLoading = false;
          });
        },
      );

      if (!mounted) return;

      if (result.status == TaskStatus.complete) {
        final path = await result.task.filePath();
        _localPath = path;
        await DownloadedAudioStore.save(url, path);
        setState(() {
          showLoading = false;
          _progress = 0.0;
          downloadDone = true;
        });
        widget.onDownloadStateChanged?.call(true);
        widget.onDownloadCompleted?.call(path);
        _showSavedSnack(path);
      } else {
        setState(() {
          showLoading = false;
          _progress = 0.0;
          downloadDone = false;
        });
        final err = result.exception?.description ??
            '${result.responseBody ?? ''} ${result.status}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tải xuống thất bại: $err'.trim())),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        showLoading = false;
        _progress = 0.0;
        downloadDone = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tải xuống thất bại: $e')),
      );
    }
  }

  void _showSavedSnack(String fullPath) {
    final tail = fullPath.replaceAll(RegExp(r'.*/'), '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu: $tail')),
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
          title: Row(
            children: const [
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
    final targetPath =
        _localPath ?? await DownloadedAudioStore.resolveExistingLocalPath(widget.url.trim());
    if (targetPath != null && targetPath.isNotEmpty) {
      final file = File(targetPath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    await DownloadedAudioStore.remove(widget.url.trim());

    if (!mounted) return;
    setState(() {
      _localPath = null;
      _progress = 0.0;
      downloadDone = false;
      showLoading = false;
    });
    widget.onDownloadStateChanged?.call(false);
  }
}

String _fileNameGuessFromUri(Uri uri) {
  var name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  name = Uri.decodeComponent(name);
  if (name.isEmpty || !name.contains('.')) {
    name = name.isEmpty ? 'audio.mp3' : '$name.mp3';
  }
  return name.replaceAll(RegExp(r'[^\w.\-]+'), '_');
}
