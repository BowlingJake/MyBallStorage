// lib/home_page.dart
import 'package:flutter/material.dart';
import 'widgets/user_info_section.dart';
import 'widgets/arsenal_section.dart';
import 'widgets/tournament_section.dart';
import 'ball_library_page.dart';
import 'views/my_arsenal_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 用於 BottomNavigationBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      
      // 導覽邏輯
      if (index == 1) { // 社群按鈕（索引 1）
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BallLibraryPage()),
        );
      }
      // 其他導覽邏輯可以在這裡添加
      // if (index == 0) { /* 首頁 */ }
      // if (index == 2) { /* 中央按鈕 */ }
      // if (index == 3) { /* 錦標賽 */ }
      // if (index == 4) { /* 個人 */ }
      
      print('Bottom Nav Tapped: $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.nightlight_round, color: Theme.of(context).colorScheme.onSurface), 
          onPressed: () {
            // 狀態切換邏輯
            print('Leading icon pressed');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoSection(
                userName: '打保齡遊戲玩國',
                userTitle: '使用者名牌',
                location: '@Location',
                // userPhotoUrl: 'your_photo_url_here', // 可選
              ),
              SizedBox(height: 24),
              ArsenalSection(
                onSeeAllPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProviderScope(
                        child: MyArsenalPage(),
                      ),
                    ),
                  );
                },
                onItemPressed: (index) {
                  print('Arsenal Item $index pressed');
                  // TODO: 導航到球詳細頁面
                },
              ),
              SizedBox(height: 24),
              TournamentSection(
                onSeeAllPressed: () {
                  print('Navigate to Tournament Page');
                  // TODO: 導航到錦標賽頁面
                },
                onItemPressed: (index) {
                  print('Tournament Item $index pressed');
                  // TODO: 導航到錦標賽詳細頁面
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首頁'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '社群'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline, size: 36), label: ''), // 中央圖示可調整
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: '錦標賽'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '個人'),
        ],
      ),
    );
  }
}