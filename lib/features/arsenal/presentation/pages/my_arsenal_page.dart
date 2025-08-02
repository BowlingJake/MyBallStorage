import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/category_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/cards/unified_ball_card.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/category_selector.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/add_ball_from_library_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/category_management_dialog.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_search_controls.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/custom_dropdown.dart';

/// 全新設計的 My Arsenal 主頁面
class MyArsenalPage extends ConsumerStatefulWidget {
  const MyArsenalPage({super.key});

  @override
  ConsumerState<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> {
  @override
  void initState() {
    super.initState();
    // 初始化時載入用戶資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }


  void _initializeData() {
    // 使用真實數據
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      ref.read(arsenalControllerProvider.notifier).initialize(userId);
      ref.read(categoryControllerProvider.notifier).loadCategories(userId);
    }
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/events')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final arsenalState = ref.watch(arsenalControllerProvider);
    final sortedCategories = ref.watch(sortedCategoriesProvider);
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBarConfigs.arsenal(
          title: 'My Arsenal',
          onBackPressed: () => context.go('/'),
        ),
        body: Column(
          children: [
            // B區：球袋管理區 (移到頂部)
            _buildBagManagementSection(theme, sortedCategories, arsenalState),
            
            // C區：內容顯示區
            Expanded(
              child: _buildContentDisplaySection(theme, arsenalState),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(theme),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

  /// 獲取分類的英文顯示名稱
  String _getCategoryDisplayName(BagCategory? category) {
    if (category == null) return 'All My Arsenal';
    
    // 直接返回分類名稱，現在只有英文的 "All My Arsenal"
    return category.name;
  }

  /// B區：球袋管理區 (下拉選單 + 新增球袋按鈕)
  Widget _buildBagManagementSection(ThemeData theme, List<BagCategory> categories, ArsenalState arsenalState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 球袋下拉選單 - 縮小到螢幕1/3寬度
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[600]!,
                  width: 1.5,
                ),
              ),
              child: CustomDropdown<String>(
                hintText: 'Select Category',
                value: arsenalState.selectedCategoryId,
                items: arsenalState.allAvailableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryId,
                    child: Text(
                      _getCategoryDisplayName(category),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref.read(arsenalControllerProvider.notifier).selectCategory(newValue);
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 新增球袋按鈕 - 縮小尺寸
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CategoryManagementDialog(),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 16,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  /// C區：內容顯示區
  Widget _buildContentDisplaySection(ThemeData theme, ArsenalState arsenalState) {
    return Column(
      children: [
        // 控制按鈕區域 - 參考Ball Library的簡潔設計
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Grid/List 切換按鈕
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildViewModeButton(
                      theme,
                      icon: Iconsax.grid_1,
                      isSelected: arsenalState.viewMode == ArsenalViewMode.grid,
                      onTap: () => ref.read(arsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.grid),
                    ),
                    _buildViewModeButton(
                      theme,
                      icon: Iconsax.element_equal,
                      isSelected: arsenalState.viewMode == ArsenalViewMode.list,
                      onTap: () => ref.read(arsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.list),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Add balls 按鈕 (移除圖標)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 1.5,
                  ),
                ),
                child: TextButton(
                  onPressed: () => context.go('/library'),
                  child: const Text(
                    'Add Balls',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // 內容區域 - 直接顯示，無額外容器
        Expanded(
          child: _buildMainContent(theme, arsenalState),
        ),
      ],
    );
  }


  Widget _buildViewModeButton(
    ThemeData theme, {
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected 
              ? Colors.white
              : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme, ArsenalState arsenalState) {
    if (arsenalState.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (arsenalState.error != null) {
      return _buildErrorState(theme, arsenalState.error!);
    }

    final filteredBalls = arsenalState.filteredBalls;
    print('Arsenal Page: Displaying ${filteredBalls.length} balls, Selected category: ${arsenalState.selectedCategoryId}');

    if (filteredBalls.isEmpty) {
      return _buildEmptyState(theme);
    }

    return arsenalState.viewMode == ArsenalViewMode.grid
        ? _buildGridView(filteredBalls)
        : _buildListView(filteredBalls);
  }


  Widget _buildGridView(List<ArsenalBallInstance> filteredBalls) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredBalls.length,
      itemBuilder: (context, index) {
        final ball = filteredBalls[index];
        return ArsenalBallCard(
          ballInstance: ball,
          onTap: () => _showBallDetails(ball),
        );
      },
    );
  }

  Widget _buildListView(List<ArsenalBallInstance> filteredBalls) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 32), // 參考Ball Library的設計
      itemCount: filteredBalls.length,
      itemBuilder: (context, index) {
        final ball = filteredBalls[index];
        return UnifiedBallCard(
          arsenalBallInstance: ball,
          theme: Theme.of(context),
          onTap: () => _showBallDetails(ball),
          showFavoriteButton: false, // Arsenal balls don't need favorite button
          extraInfo: _buildArsenalExtraInfo(ball),
        );
      },
    );
  }

  /// 建構 Arsenal 專用的額外資訊
  Widget _buildArsenalExtraInfo(ArsenalBallInstance ball) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Layout info
        Text(
          _buildLayoutText(ball),
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Games used
        Text(
          'Games Used: ${ball.gamesUsed}',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// 建構 Layout 文字
  String _buildLayoutText(ArsenalBallInstance ball) {
    if (!ball.hasLayout) {
      return 'Layout: Not set';
    }
    
    final layout = ball.layout!;
    final pinToPap = layout.pinToPap.toStringAsFixed(1);
    final papToMb = layout.papToMb.toStringAsFixed(1);
    final psaAngle = layout.psaAngle.toStringAsFixed(0);
    
    // 格式：5.0 x 4.0 x 50 (Control)
    return 'Layout: ${pinToPap}" x ${papToMb}" x ${psaAngle}° (${layout.layoutType.displayName})';
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.bag,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Your bag is empty',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first ball from the library',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/library'),
            child: const Text('Browse Library'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 80,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            '載入失敗',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _initializeData,
            icon: const Icon(Iconsax.refresh),
            label: const Text('重新載入'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: 導航到分析頁面
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('分析功能即將推出'),
            backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
          ),
        );
      },
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      child: const Icon(Iconsax.chart_2),
    );
  }

  void _showAddBallOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '新增球具',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Iconsax.book),
              title: const Text('從球庫選擇'),
              subtitle: const Text('選擇現有的保齡球'),
              onTap: () {
                Navigator.pop(context);
                _showAddFromLibraryDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.add_square),
              title: const Text('自定義新增'),
              subtitle: const Text('手動新增球具'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 導航到自定義新增頁面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('自定義新增功能即將推出')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBallDetails(ArsenalBallInstance ball) {
    // TODO: 實現球具詳細資訊頁面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('查看 ${ball.displayName} 的詳細資訊')),
    );
  }

  void _showAddFromLibraryDialog(BuildContext context) {
    final arsenalState = ref.read(arsenalControllerProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddBallFromLibraryDialog(
        preselectedCategoryId: arsenalState.selectedCategoryId,
      ),
    );
  }


  void _navigateToIndex(BuildContext context, int index) {
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
    }
  }
}