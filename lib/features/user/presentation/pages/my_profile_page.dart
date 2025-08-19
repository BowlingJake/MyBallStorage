import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/features/user/presentation/widgets/profile_info_card.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

/// My Profile Page
/// 用戶個人資料頁面，包含頂部和底部導航
class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  
  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0; // Home 或其他頁面（包含 my-profile）
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Profile',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/'),
            tooltip: 'Back to Home',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: theme.colorScheme.onSurface,
              onPressed: () => context.go('/edit_profile'),
              tooltip: 'Edit Profile',
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 頂部用戶信息卡片
              const ProfileInfoCard(),
              const SizedBox(height: 12),
              // 三個功能區塊
              _buildActionBlocks(context),
              const SizedBox(height: 16),
              // 下方選單列表
              _buildMenuList(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) {
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
                context.go('/tournament');
                break;
            }
          },
        ),
      ),
    );
  }

  /// 構建三個並排的功能區塊
  Widget _buildActionBlocks(BuildContext context) {
    final theme = Theme.of(context);
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    // 計算主球袋中的球數
    final mainBagBallCount = arsenalState.allInstances
        .where((instance) => instance.bag1 == true)
        .length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // My Arsenal 區塊
          Expanded(
            child: _buildActionBlock(
              context: context,
              title: 'My Arsenal',
              subtitle: '$mainBagBallCount balls',
              icon: Icons.sports,
              color: theme.colorScheme.secondary,
              onTap: () => context.go('/my-arsenal'),
            ),
          ),
          const SizedBox(width: 12),
          
          // Training 區塊
          Expanded(
            child: _buildActionBlock(
              context: context,
              title: 'Training',
              subtitle: 'Coming Soon',
              icon: Icons.fitness_center,
              color: theme.colorScheme.secondary,
              onTap: () {
                // TODO: 導航到 Training 頁面
                TopNotification.showSuccess(context, 'Training feature coming soon!');
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Tournament 區塊
          Expanded(
            child: _buildActionBlock(
              context: context,
              title: 'Tournament',
              subtitle: 'Coming Soon',
              icon: Icons.emoji_events,
              color: theme.colorScheme.secondary,
              onTap: () {
                // TODO: 導航到 Tournament 頁面
                TopNotification.showSuccess(context, 'Tournament feature coming soon!');
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 構建單個功能區塊
  Widget _buildActionBlock({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 構建下方選單列表
  Widget _buildMenuList(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 訂閱管理選項
          _buildMenuTile(
            context: context,
            title: '訂閱管理',
            subtitle: '管理您的訂閱計劃',
            icon: Icons.card_membership,
            onTap: () {
              // TODO: 顯示訂閱相關Dialog
              TopNotification.showSuccess(context, '訂閱管理功能開發中');
            },
          ),
          
          const SizedBox(height: 8),
          
          // Favorite Centers & Patterns選項
          _buildMenuTile(
            context: context,
            title: 'Favorite Centers & Patterns',
            subtitle: '管理喜愛的球館和油型',
            icon: Icons.favorite,
            onTap: () {
              // TODO: 導航到Favorite Centers & Oil Patterns頁面
              TopNotification.showSuccess(context, 'Favorites功能開發中');
            },
          ),
          
          const SizedBox(height: 8),
          
          // 預留選項1
          _buildMenuTile(
            context: context,
            title: '功能選項1',
            subtitle: '即將推出',
            icon: Icons.extension,
            onTap: () {
              TopNotification.showSuccess(context, '功能開發中');
            },
          ),
          
          const SizedBox(height: 8),
          
          // 預留選項2
          _buildMenuTile(
            context: context,
            title: '功能選項2',
            subtitle: '即將推出',
            icon: Icons.settings_applications,
            onTap: () {
              TopNotification.showSuccess(context, '功能開發中');
            },
          ),
        ],
      ),
    );
  }

  /// 構建單個選單項目
  Widget _buildMenuTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // 左側圖示
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 24,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            
            // 中間文字內容
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            // 右側箭頭
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}