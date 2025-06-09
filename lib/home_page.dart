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
      // 恢復頂端導航列，只放通知按鈕
      appBar: AppBar(
        title: Text(
          '保齡球裝備庫',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        actions: [
          // 通知按鈕
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: _buildNotificationButton(context),
          ),
        ],
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
              // 用戶資訊區塊 - 現在是可滾動的四方圓角卡片
              const UserInfoSection(
                userName: '打保齡遊戲玩國',
                location: 'New York',
                // userPhotoUrl: 'your_photo_url_here', // 可選
              ),
              
              const SizedBox(height: 24),
              
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
              const SizedBox(height: 20),
              
              // 開發者選項 - 移到內容區域的底部
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BrandPaletteDemoPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.palette_outlined, 
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    size: 18,
                  ),
                  label: Text(
                    '品牌色調色板示例',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ModernBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // 頂端導航列的通知按鈕
  Widget _buildNotificationButton(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.primary.withOpacity(0.1),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          // 通知紅點
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}