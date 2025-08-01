import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/category_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_card.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/category_selector.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/add_ball_from_library_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/category_management_dialog.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';

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
        appBar: _buildAppBar(theme),
        body: Column(
          children: [
            // 分類選擇器
            if (sortedCategories.isNotEmpty)
              CategorySelector(
                categories: sortedCategories,
                selectedCategoryId: arsenalState.selectedCategoryId,
                onCategorySelected: (categoryId) {
                  ref.read(arsenalControllerProvider.notifier).selectCategory(categoryId);
                },
              ),
            
            // 主要內容區域
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildMainContent(theme, arsenalState),
              ),
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

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      centerTitle: false,
      title: Row(
        children: [
          Icon(
            Iconsax.bag,
            color: theme.colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            'My Arsenal',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      actions: [
        // 視圖切換按鈕
        Consumer(
          builder: (context, ref, child) {
            final viewMode = ref.watch(arsenalControllerProvider.select((state) => state.viewMode));
            return IconButton(
              onPressed: () {
                final newMode = viewMode == ArsenalViewMode.grid 
                    ? ArsenalViewMode.list 
                    : ArsenalViewMode.grid;
                ref.read(arsenalControllerProvider.notifier).setViewMode(newMode);
              },
              icon: Icon(
                viewMode == ArsenalViewMode.grid ? Iconsax.element_equal : Iconsax.grid_1,
                color: theme.colorScheme.onSurface,
              ),
            );
          },
        ),
        // 分類管理按鈕
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CategoryManagementDialog(),
            );
          },
          icon: Icon(
            Iconsax.setting_4,
            color: theme.colorScheme.onSurface,
          ),
        ),
        // 搜尋按鈕
        IconButton(
          onPressed: () {
            // TODO: 實現搜尋功能
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('搜尋功能即將推出'),
                backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
              ),
            );
          },
          icon: Icon(
            Iconsax.search_normal,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
      ],
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

    if (filteredBalls.isEmpty) {
      return _buildEmptyState(theme);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // 球袋標題
          _buildSectionHeader(theme, arsenalState),
          
          // 球具列表
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: arsenalState.viewMode == ArsenalViewMode.grid
                  ? _buildGridView(filteredBalls)
                  : _buildListView(filteredBalls),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, ArsenalState arsenalState) {
    final selectedCategory = arsenalState.selectedCategory;
    final ballCount = arsenalState.filteredBalls.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: selectedCategory?.themeColor.withOpacity(0.1) ?? 
               theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            selectedCategory?.icon ?? Iconsax.bag,
            color: selectedCategory?.themeColor ?? theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCategory?.name ?? '所有球具',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$ballCount 顆球具',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // 加號按鈕
          Container(
            decoration: BoxDecoration(
              color: (selectedCategory?.themeColor ?? theme.colorScheme.primary).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _showAddBallOptions(context),
              icon: Icon(
                Iconsax.add,
                color: selectedCategory?.themeColor ?? theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
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
      itemCount: filteredBalls.length,
      itemBuilder: (context, index) {
        final ball = filteredBalls[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ArsenalBallCard(
            ballInstance: ball,
            onTap: () => _showBallDetails(ball),
            isListView: true,
          ),
        );
      },
    );
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
            '球袋是空的',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '從球庫新增你的第一顆球',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/library'),
            icon: const Icon(Iconsax.add_circle),
            label: const Text('瀏覽球庫'),
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