import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../controller_app/link_all_page_and_api_enum.dart';
import '../../common/app_language_sync.dart';
import '../../common/app_webview_config.dart';
import '../../common/browser_helper.dart';
import '../../common/compact_web_url_bar.dart';
import '../../common/language_menu_order.dart';
import '../../common/webview_immersive_mixin.dart';

class VisaoconhanloaiWebview extends StatefulWidget {
  static const String routeName = 'VisaoconhanloaiWebview_routeName';

  @override
  State<VisaoconhanloaiWebview> createState() => _VisaoconhanloaiWebviewState();
}

class _VisaoconhanloaiWebviewState extends State<VisaoconhanloaiWebview>
    with SingleTickerProviderStateMixin, WebviewImmersiveMixin {
  late final WebViewController _controller;
  late VisaoconhanloaiEnum visaoconhanloaiEnum;
  final double _border10 = 10.0;
  int progressLoadWeb = 0;
  String? _currentUrl;

  @override
  void initState() {
    super.initState();
    initImmersive();
    visaoconhanloaiEnum = VisaoconhanloaiEnum.english;

    final WebViewController controller = AppWebViewConfig.createController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() => progressLoadWeb = progress);
          },
          onPageStarted: (String url) {
            onImmersivePageStarted();
          },
          onPageFinished: (String url) {
            _currentUrl = url;
            unawaited(_onPageFinished());
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) _currentUrl = change.url;
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'ScrollReporter',
        onMessageReceived: (JavaScriptMessage message) {
          handleImmersiveScrollReport(message.message);
        },
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      );

    _controller = controller;
    unawaited(_bootstrapWebView());
  }

  Future<void> _bootstrapWebView() async {
    await AppWebViewConfig.applyPlatformSettings(_controller);
    await _getLanguageLink();
  }

  Future<void> _onPageFinished() async {
    await AppWebViewConfig.onPageFinishedEnhancements(_controller);
    await installImmersiveScrollReporter(_controller);
    await onImmersivePageFinished();
    if (mounted) setState(() {});
  }

  Future<void> _getLanguageLink() async {
    final shared = await SharedPreferences.getInstance();
    final languageCode =
        shared.getString('languageCodeVisaoconhanloai') ?? 'english';
    visaoconhanloaiEnum = VisaoconhanloaiEnum.values.byName(languageCode);
    await _controller.loadRequest(Uri.parse(visaoconhanloaiEnum.url));
    if (mounted) setState(() {});
  }

  Future<void> _saveLanguageLink(String languageCode) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setString('languageCodeVisaoconhanloai', languageCode);
  }

  @override
  void dispose() {
    disposeImmersive();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget _buildToolbar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 20),
          tooltip: 'Quay lại',
        ),
        PopupMenuButton<VisaoconhanloaiEnum>(
          tooltip: 'Chọn ngôn ngữ',
          position: PopupMenuPosition.under,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_border10),
          ),
          onSelected: (VisaoconhanloaiEnum value) {
            setState(() {
              visaoconhanloaiEnum = value;
              _controller.loadRequest(Uri.parse(visaoconhanloaiEnum.url));
              _saveLanguageLink(visaoconhanloaiEnum.languageCode);
            });
            unawaited(AppLanguageSync.onUserSelected(value.languageCode));
          },
          itemBuilder: (context) {
            final ordered = LanguageMenuOrder.sort(
              VisaoconhanloaiEnum.values,
              name: (e) => e.name,
              label: (e) => e.languageName,
            );
            return ordered
                .map(
                  (value) => PopupMenuItem<VisaoconhanloaiEnum>(
                    value: value,
                    height: 44,
                    child: Text(value.languageName),
                  ),
                )
                .toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  visaoconhanloaiEnum.languageName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
        ),
        const Spacer(),
        FutureBuilder<String?>(
          future: BrowserHelper.getCurrentUrl(_controller),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                BrowserHelper.launchExternal(Uri.parse(snapshot.data!));
              },
              icon: const Icon(Icons.open_in_new, size: 20),
            );
          },
        ),
        buildImmersiveToggleButton(),
      ],
    );
  }

  Widget _buildUrlBar() {
    return CompactWebUrlBar(
      controller: _controller,
      currentUrl: _currentUrl ?? visaoconhanloaiEnum.url,
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildImmersiveScaffold(
      toolbar: _buildToolbar(),
      urlBar: _buildUrlBar(),
      onPop: () => Navigator.pop(context),
      body: progressLoadWeb <= 20
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
