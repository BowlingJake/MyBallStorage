// lib/home_page.dart
import 'dart:ui'; // For BackdropFilter

import 'package:bowlingarsenal_app/shared/providers/app_theme_provider.dart';
import 'package:bowlingarsenal_app/shared/views/settings_page.dart';
// import 'package:bowlingarsenal_app/features/arsenal/widgets/arsenal_section.dart'; // Removed - old widget
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/app_specific/home/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart'; // For Iconsax icons

import 'package:bowlingarsenal_app/shared/providers/providers.dart'; // 引入全局 providers

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/my-arsenal')) {
      return 2; // 修正: Arsenal 頁面對應索引 2
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    if (location.startsWith('/events')) {
      return 4; // 修正: Events 頁面對應索引 4
    }
    if (location == '/') {
      return 0; // 首頁對應索引 0
    }
    // 其他頁面不高亮任何底部導航項
    return -1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    // 將靜態的 body 內容提取出來，並標記為 const
    const pageBody = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: SizedBox(
                width: 400,
                child: UserInfoSection(),
              ),
            ),
            SizedBox(height: 24),
            // TODO: Replace with new Arsenal widget or remove section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[600]!, width: 1),
              ),
              child: const Center(
                child: Text(
                  'Arsenal Section - Coming Soon',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(height: 80),
          ],
        ),
      ),
    );

    return const ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _HomePageAppBar(), // 使用提取的 AppBar
        drawer: _HomePageDrawer(), // 使用提取的 Drawer
        body: pageBody, // 使用 const body
        bottomNavigationBar: _HomePageBottomNav(), // 使用提取的 BottomNav
      ),
    );
  }
}

// --- Extracted Private Widgets for Optimization ---

/// AppBar: 只在需要的地方使用 Consumer 來監聽主題變化
class _HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomePageAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      title: Text(
        'StrikeTrack',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        // 只將主題切換按鈕包裹在 Consumer 中
        Consumer(
          builder: (context, ref, _) {
            final themeMode = ref.watch(currentThemeModeProvider);
            return IconButton(
              icon: Icon(
                themeMode == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
              color: theme.colorScheme.onSurface,
              onPressed: () => ref.read(appThemeProvider.notifier).toggleTheme(),
              tooltip: 'Toggle Theme',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.developer_mode_outlined),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.go('/developer'),
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Drawer: 提取為無狀態 Widget 以提高可讀性和潛在效能
class _HomePageDrawer extends StatelessWidget {
  const _HomePageDrawer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Drawer(
        backgroundColor: theme.canvasColor,
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
            _buildDrawerItem(
              context,
              icon: Iconsax.setting_2,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                context.go('/settings');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Iconsax.location,
              title: 'Favorite Centers & Oil Patterns',
              onTap: () {
                Navigator.pop(context);
                context.go('/favorite_centers_oil_patterns');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Iconsax.notification,
              title: 'Notifications',
              onTap: () {
                Navigator.pop(context);
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
                print('Show About Dialog');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Iconsax.logout,
              title: 'Logout',
              onTap: () {
                Navigator.pop(context);
                print('Logout Tapped');
              },
            ),
          ],
        ),
      ),
    );
  }

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

/// BottomNav: 提取並在內部計算 currentIndex
class _HomePageBottomNav extends StatelessWidget {
  const _HomePageBottomNav();

  // 修正索引計算邏輯，確保與路由路徑正確對應
  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/my-arsenal')) { 
      return 2; // Arsenal 頁面對應索引 2
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    if (location.startsWith('/events')) { 
      return 4; // Events 頁面對應索引 4
    }
    if (location == '/') {
      return 0; // 首頁對應索引 0
    }
    // 其他頁面不高亮任何底部導航項
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    
    // 使用 print 來幫助調試
    print('Current location: $location, calculated index: $currentIndex');
    
    return ModernBottomNavigation(
      currentIndex: currentIndex,
      onTap: (index) {
        // 處理導航邏輯
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/library');
            break;
          case 2:
            context.go('/my-arsenal');
            break;
          case 3:
            context.go('/training');
            break;
          case 4:
            context.go('/events');
            break;
        }
      },
    );
  }
}
