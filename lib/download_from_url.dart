import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:falun_dafa_practice_supports/common/downloaded_audio_store.dart';

/// Nút tải audio: loading → % → dấu check (tải xong, chơi offline được).
/// Lưu file vào thư mục Documents của app (iOS + Android).
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
  bool _isDownloading = false;

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
              onPressed: () {
                downloadDone = false;
                showLoading = true;
                setState(() {});
                _download(widget.url.trim());
              },
              icon: const Icon(Icons.download, color: Colors.deepPurple),
            ),
          if (showLoading == true)
            const SizedBox(
              width: 20,
              height: 20,
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_progress != 0) Text('${_progress.toStringAsFixed(0)} %'),
          if (downloadDone == true)
            IconButton(
              onPressed: _confirmResetDownload,
              icon: const Icon(Icons.check, color: Colors.green),
            ),
        ],
      ),
    );
  }

  Future<void> _download(String url) async {
    if (_isDownloading) return;
    _isDownloading = true;

    try {
      final uri = Uri.parse(url);
      if (!uri.hasScheme || !(uri.isScheme('http') || uri.isScheme('https'))) {
        throw Exception('URL không hợp lệ');
      }

      final request = http.Request('GET', uri);
      final response = await http.Client().send(request);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final total = response.contentLength ?? 0;
      final bytes = <int>[];
      var received = 0;

      await for (final chunk in response.stream) {
        bytes.addAll(chunk);
        received += chunk.length;
        if (!mounted) return;
        if (total > 0) {
          final percent = (received / total) * 100;
          setState(() {
            _progress = percent.clamp(0, 100);
            if (_progress > 0) showLoading = false;
          });
        } else if (showLoading) {
          setState(() => showLoading = false);
        }
      }

      final savePath = await _buildSavePath(url);
      final file = File(savePath);
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes, flush: true);

      _localPath = savePath;
      await DownloadedAudioStore.save(url, savePath);

      if (!mounted) return;
      setState(() {
        _progress = 0.0;
        downloadDone = true;
        showLoading = false;
      });
      widget.onDownloadStateChanged?.call(true);
      widget.onDownloadCompleted?.call(savePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã tải xong — có thể nghe offline')),
      );
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
    } finally {
      _isDownloading = false;
    }
  }

  Future<String> _buildSavePath(String url) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/offline_audio');
    final uri = Uri.parse(url);
    var name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'audio.mp3';
    name = name.replaceAll(RegExp(r'[^\w.\-]'), '_');
    if (name.isEmpty || !name.contains('.')) {
      name = 'audio_${url.hashCode.abs()}.mp3';
    }
    // Tránh trùng tên giữa các URL khác nhau.
    final safeStem = '${url.hashCode.abs()}_$name';
    return '${dir.path}/$safeStem';
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
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
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
