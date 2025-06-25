// lib/home_page.dart
import 'package:flutter/material.dart';
import 'dart:ui'; // For BackdropFilter
import 'package:iconsax/iconsax.dart'; // For Iconsax icons
import 'widgets/user_info_section.dart';
import 'widgets/arsenal_section.dart';
import 'widgets/tournament_section.dart';
import 'widgets/modern_tournament_section.dart';
import 'widgets/professional_dark_background.dart';
import 'widgets/section_container.dart'; // 導入新的容器元件
import 'ball_library_page.dart';
import 'views/my_arsenal_page.dart';
import 'views/settings_page.dart';
import 'my_training_page.dart';
import 'demo/brand_palette_demo.dart';
import 'demo/style_showcase_page.dart';

import 'widgets/modern_bottom_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // 用於 BottomNavigationBar
  final _userCardKey = GlobalKey(); // 1. 建立一個 GlobalKey 來追蹤使用者卡片
  Rect? _userCardRect; // 2. 用於儲存卡片的矩形區域

  @override
  void initState() {
    super.initState();
    // 3. 在第一幀渲染結束後，計算卡片的 Rect
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateUserCardRect());
  }

  void _calculateUserCardRect() {
    final RenderBox? renderBox = _userCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      final newRect = Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

      // 檢查是否需要更新，避免不必要的重繪
      if (_userCardRect != newRect) {
        setState(() {
          _userCardRect = newRect;
        });
      }
    }
  }

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
      case 4: // 個人/設定
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        ).then((_) {
          // 返回時重置選中狀態為首頁
          setState(() {
            _selectedIndex = 0;
          });
        });
        break;
    }
    
    print('Bottom Nav Tapped: $index');
  }

  @override
  Widget build(BuildContext context) {
    return ProfessionalDarkBackground(
      backgroundImage: 'images/Sport_Tech_Background.png',
      cutoutRects: _userCardRect != null ? [_userCardRect!] : null, // 將 Rect 傳遞給背景
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true, // 將標題置中
          title: Text(
            'StrikeTrack',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          // 移除 actions
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        drawer: _buildAppDrawer(context), // 加入抽屜選單
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 將 Key 附加到一個非 const 的父元件上
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    key: _userCardKey, // 把 Key "貼" 在這裡
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: const UserInfoSection(
                      // 保持 UserInfoSection 為 const 以獲得性能優化
                      userName: 'Jake Cheng',
                      location: 'Taipei, Taiwan',
                    ),
                  ),
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
                Column(
                  children: [
                    // 風格展示按鈕 - 主要功能
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StyleShowcasePage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.dashboard_customize,
                          size: 20,
                        ),
                        label: Text(
                          'APP 風格展示',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // 品牌色板示例 - 次要功能
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
                  ],
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
      ),
    );
  }

  // 建立抽屜選單 (Drawer)
  Widget _buildAppDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      // 抽屜的右側邊緣使用圓角
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Drawer(
          backgroundColor: theme.colorScheme.surface.withOpacity(0.2),
          elevation: 0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // 抽屜頂部
              SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.transparent, // 背景由BackdropFilter提供
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'StrikeTrack',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // 功能列表
              _buildDrawerItem(
                context,
                icon: Iconsax.setting_2,
                title: 'Settings',
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Iconsax.notification,
                title: 'Notifications',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Notifications Page
                  print('Navigate to Notifications');
                },
              ),
              const Divider(color: Colors.white24, indent: 20, endIndent: 20),
              _buildDrawerItem(
                context,
                icon: Iconsax.info_circle,
                title: 'About',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show About Dialog
                  print('Show About Dialog');
                },
              ),
              _buildDrawerItem(
                context,
                icon: Iconsax.logout,
                title: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement Logout Logic
                  print('Logout Tapped');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 建立抽屜選單的項目
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.onSurface.withOpacity(0.8),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      splashColor: theme.colorScheme.primary.withOpacity(0.2),
    );
  }
}