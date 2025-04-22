import 'package:flutter/material.dart';
import 'weapon_library_home_page.dart';
import 'tournament_record_page.dart';
import 'training_page.dart';
import 'settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    WeaponLibraryHomePage(),
    TournamentRecordPage(),
    TrainingPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_handball),
            label: '武器庫',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium),
            label: '比賽記錄',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '訓練模式',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
