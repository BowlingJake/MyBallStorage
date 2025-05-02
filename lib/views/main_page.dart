import 'package:flutter/material.dart';
import 'weapon_library_home_page.dart';
import 'tournament_record_page.dart';
import 'training_page.dart';
import 'settings_page.dart';
import 'user_info_page.dart';


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
    UserInfoPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          color: Colors.white, // Banner 背景色，可自由調整或改成漸層
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Spacer(), // 左側空白
              // 中間 Logo
              Image.asset(
                'assets/images/logo_placeholder.png', // 先用預設圖，之後可換
                height: 40,
                ),
                const Spacer(),
                // 右側鈴鐺按鈕
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    // TODO: 換成你的通知顯示邏輯
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('還沒有新通知')),
                      );
               },
            ),
           ],
         ),
       ),
     ),
      body: Column(
        children: [
          // appBar 已經在上方，這裡只放內容區
          Expanded(child: _pages[_currentIndex]),
        ],
      ),
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
            icon: Icon(Icons.person),
            label: '個人檔案',
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
