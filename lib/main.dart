import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'menu/intro_list_widget_body.dart';
import 'menu/introduction_screen.dart';
import 'player_widget.dart';
import 'player_widget_9baigiang.dart';

import 'menu_huongdan_page.dart';
import 'memory_config.dart';
import 'memory_monitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MemoryConfig.initialize();
  runApp(const RunAppFalunDafaExercise());
}

class RunAppFalunDafaExercise extends StatefulWidget {
  const RunAppFalunDafaExercise({super.key});

  @override
  State<RunAppFalunDafaExercise> createState() => _RunAppFalunDafaExerciseState();
}

class _RunAppFalunDafaExerciseState extends State<RunAppFalunDafaExercise>
    with AutomaticKeepAliveClientMixin {
  static const _countKey = 'countLogin';

  /// Mặc định lớn để tránh nháy intro trước khi đọc SharedPreferences xong.
  int _launchCount = 10;
  SharedPreferences? _prefs;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _prefs = await SharedPreferences.getInstance();
    final next = (_prefs!.getInt(_countKey) ?? 0) + 1;
    await _prefs!.setInt(_countKey, next);
    if (mounted) setState(() => _launchCount = next);
    await _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) return;
      if (info.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else if (info.flexibleUpdateAllowed) {
        await InAppUpdate.startFlexibleUpdate();
      }
    } catch (e) {
      debugPrint('In-app update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      home: MemoryMonitor(
        showMemoryInfo: false,
        child: SafeArea(
          child: _launchCount < 2
              ? IntroductionScreenWidget(
                  listPageViewModel: listPageViewModelGioiThieuApp,
                  setPageIntro: SetPageIntro.molandau,
                )
              : const FalunDafaExerciseHomePage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}

class FalunDafaExerciseHomePage extends StatefulWidget {
  const FalunDafaExerciseHomePage({super.key});

  @override
  State<FalunDafaExerciseHomePage> createState() => _FalunDafaExerciseHomePageState();
}

class _FalunDafaExerciseHomePageState extends State<FalunDafaExerciseHomePage>
    with AutomaticKeepAliveClientMixin {
  static const _menuIndexKey = 'index_menu_bottom';

  List<Widget>? _tabs;
  int _indexMenu = 0;
  SharedPreferences? _prefs;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadSavedTab();
  }

  List<Widget> get _pages {
    _tabs ??= [
      MenuHome(),
      const PlayerWidget9Baigiang(),
      const PlayerWidget(),
    ];
    return _tabs!;
  }

  Future<void> _loadSavedTab() async {
    _prefs ??= await SharedPreferences.getInstance();
    var i = _prefs!.getInt(_menuIndexKey) ?? 0;
    if (i > _pages.length - 1) i = _pages.length - 1;
    if (mounted) setState(() => _indexMenu = i);
  }

  Future<void> _saveTab(int i) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setInt(_menuIndexKey, i);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: _pages[_indexMenu]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexMenu,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() => _indexMenu = i);
          _saveTab(i);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 71, 71, 71)),
            label: 'Home',
            activeIcon: Icon(Icons.home, color: Color(0xFF2196f3)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack, color: Color.fromARGB(255, 71, 71, 71)),
            label: '9 Lesson',
            activeIcon: Icon(Icons.audiotrack, color: Colors.orange),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement, color: Color.fromARGB(255, 71, 71, 71)),
            label: 'Practice',
            activeIcon: Icon(Icons.self_improvement, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _prefs = null;
    _tabs = null;
    super.dispose();
  }
}
