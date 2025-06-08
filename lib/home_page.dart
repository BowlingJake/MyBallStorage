// lib/home_page.dart
import 'package:flutter/material.dart';
import 'widgets/user_info_section.dart';
import 'widgets/arsenal_section.dart';
import 'widgets/tournament_section.dart';
import 'widgets/modern_tournament_section.dart';
import 'ball_library_page.dart';
import 'views/my_arsenal_page.dart';
import 'my_training_page.dart';
import 'demo/brand_palette_demo.dart';

import 'widgets/modern_bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 用於 BottomNavigationBar

  void _onItemTapped(int index) {
    // 導覽邏輯
    switch (index) {
      case 0: // 首頁
        // 已經在首頁，不需要導航
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1: // 社群 (Ball Library)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BallLibraryPage()),
        ).then((_) {
          // 返回時重置選中狀態為首頁
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 2: // 中央按鈕 (新增)
        setState(() {
          _selectedIndex = index;
        });
        print('Add button tapped');
        // TODO: 實現新增功能
        break;
      case 3: // 訓練
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyTrainingPage()),
        ).then((_) {
          // 返回時重置選中狀態為首頁
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
      case 4: // 個人
        setState(() {
          _selectedIndex = index;
        });
        print('Profile button tapped');
        // TODO: 導航到個人頁面
        break;
    }
    
    print('Bottom Nav Tapped: $index');
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
        actions: [

          // 調色板示例入口（開發者選項）
          IconButton(
            icon: Icon(
              Icons.palette_outlined, 
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BrandPaletteDemoPage(),
                ),
              );
            },
            tooltip: '品牌色調色板示例',
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // 固定在頂部的用戶資訊
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: const UserInfoSection(
              userName: '打保齡遊戲玩國',
              location: '@Location',
              // userPhotoUrl: 'your_photo_url_here', // 可選
            ),
          ),
          
          // 可滾動的內容區域
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 24),
                    ModernTournamentSection(
                      onSeeAllPressed: () {
                        print('Navigate to Tournament Page');
                        // TODO: 導航到錦標賽頁面
                      },
                      onTournamentPressed: (tournament) {
                        print('Tournament ${tournament.name} pressed');
                        // TODO: 導航到錦標賽詳細頁面
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}