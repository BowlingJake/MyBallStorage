import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
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

    return Container(
      color: Colors.black,
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
              const SizedBox(height: 8),
              // 三個功能區塊
              _buildActionBlocks(context),
              const SizedBox(height: 12),
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
          const SizedBox(width: 16),
          
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
          const SizedBox(width: 16),
          
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
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 96,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: Colors.white,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
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
          // 訂閱管理選項 - 特殊樣式（皇冠圖示）
          _buildSubscriptionTile(
            context: context,
            onTap: () {
              // TODO: 顯示訂閱相關Dialog
              TopNotification.showSuccess(context, 'Subscription feature coming soon');
            },
          ),
          
          const SizedBox(height: 8),
          
          // Favorite Centers & Patterns選項
          _buildSimpleMenuTile(
            context: context,
            title: 'Favorite Centers & Patterns',
            onTap: () {
              // TODO: 導航到Favorite Centers & Oil Patterns頁面
              TopNotification.showSuccess(context, 'Favorites feature coming soon');
            },
          ),
          
          const SizedBox(height: 8),
          
          // 預留選項1
          _buildSimpleMenuTile(
            context: context,
            title: 'Feature Option 1',
            onTap: () {
              TopNotification.showSuccess(context, 'Feature coming soon');
            },
          ),
          
          const SizedBox(height: 8),
          
          // 預留選項2
          _buildSimpleMenuTile(
            context: context,
            title: 'Feature Option 2',
            onTap: () {
              TopNotification.showSuccess(context, 'Feature coming soon');
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
    required IconData icon,
    required VoidCallback onTap,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? borderColor,
    bool isSpecial = false,
  }) {
    final theme = Theme.of(context);
    
    final effectiveBackgroundColor = backgroundColor ?? Colors.black;
    final effectiveTextColor = textColor ?? Colors.white;
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(0),
          border: isSpecial && borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
        ),
        child: Row(
          children: [
            // 左側圖示
            Icon(
              icon,
              size: 20,
              color: effectiveIconColor,
            ),
            const SizedBox(width: 12),
            
            // 中間文字內容
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: effectiveTextColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // 右側箭頭
            Icon(
              Icons.chevron_right,
              color: effectiveTextColor.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// 構建 Subscription 特殊樣式選單項目（帶皇冠圖示）
  Widget _buildSubscriptionTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          children: [
            // 中間文字內容
            Expanded(
              child: Row(
                children: [
                  Text(
                    'Subscription',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8),
                  // 皇冠圖示
                  const Icon(
                    Icons.military_tech,
                    size: 18,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
            
            // 右側箭頭
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// 構建簡單選單項目（無左側圖示）
  Widget _buildSimpleMenuTile({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          children: [
            // 中間文字內容
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // 右側箭頭
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}