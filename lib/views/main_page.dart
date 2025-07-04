import 'package:bowlingarsenal_app/theme/text_styles.dart';
import 'package:bowlingarsenal_app/views/settings_page.dart';
import 'package:bowlingarsenal_app/views/tournament_record_page.dart';
import 'package:bowlingarsenal_app/views/training_page.dart';
import 'package:bowlingarsenal_app/views/user_info_page.dart';
import 'package:bowlingarsenal_app/views/weapon_library_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
    const appBarColor = Color(0xFFA3D5DC);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SizedBox(
          height: 44,
          child: SvgPicture.asset(
            'assets/images/logo_placeholder.png',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('還沒有新通知', style: AppTextStyles.body)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 頭像與人名區塊（獨立於AppBar下方）
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.account_circle, size: 32, color: Colors.blueGrey),
                  ),
                  SizedBox(width: 8),
                  Text('鄭行越', style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          // 主體頁面
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
