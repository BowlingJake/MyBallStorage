import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_specific_ball_card.dart';
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
      ref.read(newArsenalControllerProvider.notifier).initialize(userId);
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
    final arsenalState = ref.watch(newArsenalControllerProvider);
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
            _buildBagManagementSection(theme, arsenalState),
            
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

  /// 獲取分類的顯示名稱
  String _getCategoryDisplayName(String? category) {
    return category ?? 'All My Arsenal';
  }

  /// B區：球袋管理區 (下拉選單 + 新增球袋按鈕)
  Widget _buildBagManagementSection(ThemeData theme, NewArsenalState arsenalState) {
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
                value: _getCategoryDisplayName(arsenalState.selectedCategory),
                items: ref.read(newArsenalControllerProvider.notifier).allAvailableCategories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
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
                    ref.read(newArsenalControllerProvider.notifier).selectCategory(newValue);
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
                // TODO: Implement new category management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category management coming soon')),
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
  Widget _buildContentDisplaySection(ThemeData theme, NewArsenalState arsenalState) {
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
                      onTap: () => ref.read(newArsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.grid),
                    ),
                    _buildViewModeButton(
                      theme,
                      icon: Iconsax.element_equal,
                      isSelected: arsenalState.viewMode == ArsenalViewMode.list,
                      onTap: () => ref.read(newArsenalControllerProvider.notifier).setViewMode(ArsenalViewMode.list),
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

  Widget _buildMainContent(ThemeData theme, NewArsenalState arsenalState) {
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

    final filteredInstances = ref.read(newArsenalControllerProvider.notifier).filteredInstances;
    print('Arsenal Page: Displaying ${filteredInstances.length} instances, Selected category: ${arsenalState.selectedCategory ?? "All My Arsenal"}');

    if (filteredInstances.isEmpty) {
      return _buildEmptyState(theme);
    }

    return arsenalState.viewMode == ArsenalViewMode.grid
        ? _buildGridView(filteredInstances)
        : _buildListView(filteredInstances);
  }


  Widget _buildGridView(List<UserArsenalInstance> filteredInstances) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredInstances.length,
      itemBuilder: (context, index) {
        final instance = filteredInstances[index];
        return ArsenalSpecificBallCard(
          arsenalBallInstance: instance,
          theme: Theme.of(context),
          extraInfo: _buildArsenalExtraInfo(instance),
        );
      },
    );
  }

  Widget _buildListView(List<UserArsenalInstance> filteredInstances) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 32), // 參考Ball Library的設計
      itemCount: filteredInstances.length,
      itemBuilder: (context, index) {
        final instance = filteredInstances[index];
        return ArsenalSpecificBallCard(
          arsenalBallInstance: instance,
          theme: Theme.of(context),
          extraInfo: _buildArsenalExtraInfo(instance),
        );
      },
    );
  }

  /// 建構 Arsenal 專用的額外資訊
  Widget _buildArsenalExtraInfo(UserArsenalInstance instance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Layout info
        Text(
          instance.layoutDisplayString,
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
          'Games Used: ${instance.gamesUsed}',
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        // 移除 Categories 顯示
      ],
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


  void _showInstanceDetails(UserArsenalInstance instance) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ball name
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      instance.bowlingBall?.name ?? 'Unknown Ball',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Ball details
              if (instance.bowlingBall != null) ...[
                Text(
                  'Brand: ${instance.bowlingBall!.brand}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
              ],
              
              // Layout information
              Text(
                'Layout: ${instance.layoutDisplayString}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              
              // Games used
              Text(
                'Games Used: ${instance.gamesUsed}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              
              // Categories
              if (instance.allCategories.isNotEmpty) ...[
                Text(
                  'Categories: ${instance.allCategories.join(", ")}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
              ],
              
              // Added date
              Text(
                'Added: ${instance.addedDate?.toString().split(' ')[0] ?? 'Unknown'}',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              
              // Notes if available
              if (instance.notes != null && instance.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Notes:',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  instance.notes!,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Implement edit functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit functionality coming soon')),
                      );
                    },
                    child: const Text('Edit', style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // TODO: Implement remove functionality
                      _confirmRemoveInstance(instance);
                    },
                    child: const Text('Remove', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRemoveInstance(UserArsenalInstance instance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: const Text('Remove Ball', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to remove "${instance.bowlingBall?.name ?? 'this ball'}" from your arsenal?',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                final authState = ref.read(authControllerProvider);
                if (authState.hasValue && authState.value != null) {
                  final userId = authState.value!.id;
                  await ref.read(newArsenalControllerProvider.notifier).removeInstance(instance.id, userId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ball removed successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to remove ball: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
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