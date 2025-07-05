// lib/home_page.dart
import 'dart:ui'; // For BackdropFilter

import 'package:bowlingarsenal_app/providers/theme_provider.dart';
import 'package:bowlingarsenal_app/views/settings_page.dart';
import 'package:bowlingarsenal_app/widgets/arsenal_section.dart';
import 'package:bowlingarsenal_app/widgets/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/professional_dark_background.dart';
import 'package:bowlingarsenal_app/widgets/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart'; // For Iconsax icons

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0; // 用於 BottomNavigationBar
  final _userCardKey = GlobalKey(); // 1. 建立一個 GlobalKey 來追蹤使用者卡片
  Rect? _userCardRect; // 2. 用於儲存卡片的矩形區域

  void _calculateUserCardRect() {
    if (!mounted) return;

    final renderBox =
        _userCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      final newRect = Rect.fromLTWH(
        position.dx,
        position.dy,
        size.width,
        size.height,
      );

      // 檢查是否需要更新，避免不必要的重繪
      if (_userCardRect != newRect) {
        setState(() {
          _userCardRect = newRect;
        });
      }
    }
  }

  void _onItemTapped(int index) {
    // If the selected tab is tapped again, do nothing.
    if (index == _selectedIndex) {
      return;
    }

    // Handle navigation logic
    switch (index) {
      case 0: // Home
        // Already on home, do nothing or setState if needed
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case 1: // Ball Library
        context.go('/library');
        break;
      case 2: // Center 'Add' button - Placeholder
        print('Add button tapped');
        // TODO: Implement 'Add' functionality or route
        break;
      case 3: // Training
        context.go('/training');
        break;
      case 4: // Settings
        context.go('/settings');
        break;
    }

    print('Bottom Nav Tapped: $index');
  }

  @override
  Widget build(BuildContext context) {
    // 每次 build 後都延遲計算卡片位置，以應對佈局變化
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateUserCardRect());

    final themeMode = ref.watch(themeProvider);

    return ProfessionalDarkBackground(
      cutoutRects:
          _userCardRect != null ? [_userCardRect!] : null, // 將 Rect 傳遞給背景
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
          actions: [
            IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
              tooltip: 'Toggle Theme',
            ),
            IconButton(
              icon: const Icon(Icons.developer_mode_outlined),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () => context.go('/developer'),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        drawer: _buildAppDrawer(context), // 加入抽屜選單
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 將 Key 附加到一個非 const 的父元件上
                Align(
                  child: Container(
                    key: _userCardKey, // 把 Key "貼" 在這裡
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: const UserInfoSection(),
                  ),
                ),

                const SizedBox(height: 24),

                ArsenalSection(
                  onSeeAllPressed: () => context.go('/my-arsenal'),
                  onItemPressed: (index) {
                    print('Arsenal Item $index pressed');
                    // TODO: 導航到球詳細頁面
                  },
                ),
                const SizedBox(height: 24),
                // ModernTournamentSection(
                //   onSeeAllPressed: () {
                //     print('Navigate to Tournament Page');
                //   },
                //   onTournamentPressed: (tournament) {
                //     print('Tournament ${tournament.name} pressed');
                //   },
                // ),
                const SizedBox(height: 80), // 增加底部空間以確保內容不被導航欄遮擋
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
          backgroundColor: const Color(0x33000000), // 20% 不透明度的純黑色
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
                  Navigator.pop(context); // Close the drawer first
                  context.go('/settings');
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
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.8)),
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
