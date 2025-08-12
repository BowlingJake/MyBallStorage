import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_specific_ball_card.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_grid_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/filters/filter_popout.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/library_selection_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/arsenal_app_bar.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/selection_app_bar_actions.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/bottom_sheet/arsenal_more_bottom_sheet.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/tabs/arsenal_tabs.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/lists/arsenal_grid_view.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/lists/arsenal_list_view.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/common/view_mode_toggle.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/lists/arsenal_extra_info.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/unlock_bag_dialog.dart' as unlock_dialog;
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/sort_options_sheet.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/removal_options_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/move_target_bag_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/add_to_bag_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/instance_details_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/states/arsenal_empty_state.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/states/arsenal_error_state.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/search_bar.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/management_section.dart';

/// 全新設計的 My Arsenal 主頁面
class MyArsenalPage extends ConsumerStatefulWidget {
  const MyArsenalPage({super.key});

  @override
  ConsumerState<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> with TickerProviderStateMixin {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  
  
  // 與 bag management dialog 相同的9個顏色
  final List<Color> _bagColors = [
    Colors.red,     // 🔴 競賽/重要
    Colors.orange,  // 🟠 練習/日常
    Colors.yellow,  // 🟡 特殊/活動
    Colors.green,   // 🟢 備用/新手
    Colors.blue,    // 🔵 進階/技術
    Colors.purple,  // 🟣 實驗/測試
    Colors.cyan,    // 🔵 青色/專業
    Colors.white,   // 🤍 基礎/標準
    Colors.brown,   // 🟤 復古/經典
  ];

  @override
  void initState() {
    super.initState();
    // 初始化時載入用戶資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForSelectionMode();
      _initializeData();
    });
  }

  void _checkForSelectionMode() {
    // 不再需要檢查參數，選擇模式現在由 controller 管理
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }


  void _initializeData() {
    // 使用真實數據
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      ref.read(newArsenalControllerProvider.notifier).initialize(userId);
      // 同時載入用戶 profile 以獲取球袋資訊
      ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
    }
  }

  /// 初始化TabController基於用戶profile
  void _initializeTabController() {
    final userProfileState = ref.read(userProfileControllerProvider);
    if (userProfileState.profile != null) {
      final unlockedBags = userProfileState.profile!.unlockedBags;
      final nextBagToUnlock = userProfileState.profile!.nextBagToUnlock;
      
      // 計算tab總數：
      // 1 (All My Arsenal) + (unlockedBags.length - 1) for skipped bags + 1 (unlock button if available)
      int tabCount = 1 + (unlockedBags.length - 1); // "All My Arsenal" + other unlocked bags
      if (nextBagToUnlock != null) {
        tabCount += 1; // Add unlock button if there's a next bag to unlock
      }
      
      _tabController?.dispose();
      _tabController = TabController(
        length: tabCount,
        vsync: this,
        initialIndex: 0, // Start with "All My Arsenal"
      );
      
      // Listen to tab changes to update the selected bag in the controller
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          final selectedIndex = _tabController!.index;
          if (selectedIndex == 0) {
            // "All My Arsenal" tab
            ref.read(newArsenalControllerProvider.notifier).selectBag(1);
          } else if (selectedIndex <= unlockedBags.length - 1) {
            // Regular bag tabs (skip bag 1 since it's "All My Arsenal")
            final bagInfo = unlockedBags.skip(1).toList()[selectedIndex - 1];
            ref.read(newArsenalControllerProvider.notifier).selectBag(bagInfo.number);
          }
          // The last tab is the unlock button, no bag selection needed
        }
      });
    }
  }

  /// 顯示解鎖球袋對話框
  void _showUnlockBagDialog(int index) async {
    final ok = await ArsenalActions.unlockBag(
      context: context,
      ref: ref,
      bagIndex: index,
      accentColor: _bagColors[index],
    );
    if (ok) {
      _tabController?.dispose();
      final userProfileState = ref.read(userProfileControllerProvider);
      _tabController = ArsenalTabsController.createTabController(
        vsync: this,
        userProfileState: userProfileState,
        onBagSelected: (bag) => ref.read(newArsenalControllerProvider.notifier).selectBag(bag),
      );
      setState(() {});
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
    final userProfileState = ref.watch(userProfileControllerProvider);
    final theme = Theme.of(context);

    // Initialize tab controller when user profile is loaded
    if (userProfileState.profile != null && _tabController == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tabController?.dispose();
        _tabController = ArsenalTabsController.createTabController(
          vsync: this,
          userProfileState: userProfileState,
          onBagSelected: (bag) => ref.read(newArsenalControllerProvider.notifier).selectBag(bag),
        );
        setState(() {});
      });
    }

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // 可滑動分頁標籤區（抽出為元件）
            if (_tabController != null)
              ArsenalTabs(
                controller: _tabController!,
                userProfileState: userProfileState,
                bagColors: _bagColors,
                onUnlockTap: (idx) => _showUnlockBagDialog(idx),
                selectionMode: arsenalState.isMoveMode || arsenalState.isRemoveMode,
                onBlockedSwitch: () {
                  // 選擇模式下嘗試切換球袋：預設自動退出選擇模式
                  if (arsenalState.isMoveMode) {
                    _toggleMoveMode();
                  } else if (arsenalState.isRemoveMode) {
                    _toggleRemoveMode();
                  }
                },
              ),
            
            // 管理按鈕/情境列
            Builder(builder: (context) {
              final isMove = arsenalState.isMoveMode;
              final isRemove = arsenalState.isRemoveMode;
              final selectionMode = isMove || isRemove;
              if (selectionMode) {
                final count = isMove
                    ? arsenalState.selectedForMove.length
                    : arsenalState.selectedForRemoval.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: isMove ? 'Confirm Move ($count)' : 'Confirm Remove ($count)',
                          onPressed: () {
                            if (isMove) {
                              ArsenalActions.showMoveSelected(context: context, ref: ref, bagColors: _bagColors);
                            } else {
                              ArsenalActions.confirmRemoveSelected(context: context, ref: ref);
                            }
                          },
                          customColor: isMove ? Colors.blue : Colors.red,
                          isPrimary: true,
                          whiteForeground: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Exit',
                          onPressed: () {
                            if (isMove) {
                              _toggleMoveMode();
                            } else {
                              _toggleRemoveMode();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ManagementSection(
                getSelectedBagText: (state) => _getSelectedBagDisplayText(state),
                onMore: () => _showMoreOptionsBottomSheet(arsenalState),
              );
            }),
            
            // 內容顯示區
            Expanded(
              child: _buildContentDisplaySection(theme, arsenalState),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildBottomActionBar(),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }


  // 管理區與搜尋列已抽出


  // 舊的第一行按鈕元件已移除

  /// C區：內容顯示區（簡化版，主要控制已移至B區）
  Widget _buildContentDisplaySection(ThemeData theme, NewArsenalState arsenalState) {
    return _buildMainContent(theme, arsenalState);
  }

  // 第二行控制列已抽出

  /// Get display text for currently selected bag
  String _getSelectedBagDisplayText(NewArsenalState arsenalState) {
    final userProfileState = ref.read(userProfileControllerProvider);
    final selectedBag = arsenalState.selectedBagNumber;
    
    if (selectedBag == 1) {
      return 'Viewing: All My Arsenal';
    } else if (userProfileState.profile != null) {
      final bagName = userProfileState.profile!.displayNameForBag(selectedBag);
      return 'Viewing: $bagName';
    }
    
    return 'Viewing: Bag $selectedBag';
  }

  /// 檢查是否有活躍的篩選器或排序
  bool _hasActiveFilters(NewArsenalState arsenalState) {
    return arsenalState.filters.activeFilterCount > 0 || 
           arsenalState.sortOption != SortOption.nameAZ;
  }

  /// 顯示更多選項底部彈窗
  void _showMoreOptionsBottomSheet(NewArsenalState arsenalState) {
    final canMove = (arsenalState.selectedBagNumber ?? 1) != 1;
    ArsenalActions.openMoreOptionsSheet(
      context: context,
      ref: ref,
      activeFilterCount: arsenalState.filters.activeFilterCount,
      sortOption: arsenalState.sortOption,
      canMove: canMove,
    );
  }

  // 舊的更多選項面板已以 `ArsenalMoreBottomSheet` 取代

  /// 視圖模式切換按鈕組
  Widget _buildViewModeToggle() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final theme = Theme.of(context);
    
    return Container(
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

  // 分頁標籤欄已抽出為 `ArsenalTabs`

  /// 建構自訂的 AppBar
  PreferredSizeWidget _buildAppBar() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final bool isMove = arsenalState.isMoveMode;
    final bool isRemove = arsenalState.isRemoveMode;
    final bool selectionMode = isMove || isRemove;

    return ArsenalAppBar(
      title: const Text(
        'My Arsenal',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      searchField: ArsenalSearchBar(
        controller: _searchController,
        onChanged: (value) => ref.read(newArsenalControllerProvider.notifier).updateSearchText(value),
      ),
      isSearching: _isSearchExpanded,
      onBack: () => context.go('/'),
      onToggleSearch: () {
        setState(() {
          _isSearchExpanded = !_isSearchExpanded;
          if (!_isSearchExpanded) {
            _searchController.clear();
            ref.read(newArsenalControllerProvider.notifier).updateSearchText('');
          }
        });
      },
      actionsOverride: selectionMode ? [] : null,
      moreAction: selectionMode
          ? null
          : IconButton(
              onPressed: () => _showMoreOptionsBottomSheet(arsenalState),
              icon: Icon(
                Icons.more_vert,
                color: _hasActiveFilters(arsenalState) ? Colors.blue : Colors.white,
                size: 24,
              ),
              tooltip: 'More Options',
            ),
    );
  }

  /// 底部浮動操作列（加球/移動/刪除）
  Widget? _buildBottomActionBar() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final isMove = arsenalState.isMoveMode;
    final isRemove = arsenalState.isRemoveMode;
    if (isMove || isRemove) {
      return null;
    }

    final int currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final bool isMainBag = currentBagNumber == 1;
    final bool hasData = arsenalState.allInstances
        .any((i) => isMainBag ? true : i.isInBag(currentBagNumber));

    final theme = Theme.of(context);
    final double width = MediaQuery.of(context).size.width - 24; // 左右各留 12px
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom == 0 ? 0 : 2,
      ),
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            Expanded(
              child: AppStandardButton(
                text: isMainBag ? 'Add from Library' : 'Add to This Bag',
                height: 36,
                fontSize: 12,
                backgroundColor: Colors.black,
                outlineColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                disabledForegroundColor: Colors.grey,
                disabledOutlineColor: Colors.grey,
                isPrimary: true,
                whiteForeground: false,
                onPressed: () => ArsenalActions.showAddToCurrentBag(context: context, ref: ref),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppStandardButton(
                text: 'Move',
                icon: Icons.swap_horiz,
                height: 36,
                fontSize: 12,
                backgroundColor: Colors.black,
                outlineColor: Colors.blue,
                foregroundColor: Colors.blue,
                disabledForegroundColor: Colors.grey,
                disabledOutlineColor: Colors.grey,
                isPrimary: true,
                enabled: !isMainBag && hasData,
                onPressed: _toggleMoveMode,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppStandardButton(
                text: 'Remove',
                icon: Icons.remove_circle_outline,
                height: 36,
                fontSize: 12,
                backgroundColor: Colors.black,
                outlineColor: Colors.red,
                foregroundColor: Colors.red,
                disabledForegroundColor: Colors.grey,
                disabledOutlineColor: Colors.grey,
                isPrimary: true,
                enabled: hasData,
                onPressed: _toggleRemoveMode,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildMainContent(ThemeData theme, NewArsenalState arsenalState) {
    if (arsenalState.isLoading) {
      return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
    }

    if (arsenalState.error != null) {
      return ArsenalErrorState(error: arsenalState.error!, onRetry: _initializeData);
    }

    final filteredInstances = ref.read(newArsenalControllerProvider.notifier).filteredInstances;

    if (filteredInstances.isEmpty) {
      return const ArsenalEmptyState();
    }

    return arsenalState.viewMode == ArsenalViewMode.grid
        ? ArsenalGridView(instances: filteredInstances)
        : ArsenalListView(
            instances: filteredInstances,
            extraInfoBuilder: _buildArsenalExtraInfo,
          );
  }


  // Grid/List 已抽出為獨立元件


  /// 建構 Arsenal 專用的額外資訊
  Widget _buildArsenalExtraInfo(UserArsenalInstance instance) => ArsenalExtraInfo(instance: instance);

  // 空/錯誤狀態已抽出

  // FAB 已暫時移除：改採其他互動模式以避免遮擋內容


  void _showInstanceDetails(UserArsenalInstance instance) {
    ArsenalActions.showInstanceDetails(context: context, ref: ref, instance: instance);
  }

  void _confirmRemoveInstance(UserArsenalInstance instance) {
    ArsenalActions.showInstanceDetails(context: context, ref: ref, instance: instance);
  }


  void _navigateToIndex(BuildContext context, int index) => ArsenalActions.navigateToIndex(context, index);

  void _showFilterDialog(BuildContext context, WidgetRef ref, NewArsenalState arsenalState) {
    showFilterPopout(
      context,
      initialFilters: arsenalState.filters,
      onFiltersChanged: (newFilters) {
        ref.read(newArsenalControllerProvider.notifier).updateFilters(newFilters);
      },
    );
  }


  /// Show library selection dialog for adding balls to arsenal
  Future<void> _showLibrarySelectionDialog() async {
    final selectedBallIds = await showLibrarySelectionDialog(context);
    
    if (selectedBallIds != null && selectedBallIds.isNotEmpty) {
      await _addSelectedBallsToArsenal(selectedBallIds);
    }
  }


  /// Add selected balls from library to arsenal
  Future<void> _addSelectedBallsToArsenal(List<int> ballIds) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(
          context,
          'Please log in to add balls to arsenal',
        );
        return;
      }
      final userId = authState.value!.id;

      // Get current arsenal state to determine category
      final arsenalState = ref.read(newArsenalControllerProvider);
      
      // Use "My Balls" as default category, or first existing category
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      // Add each selected ball to arsenal
      int successCount = 0;
      int failCount = 0;
      
      for (final ballId in ballIds) {
        try {
          await ref.read(newArsenalControllerProvider.notifier).addBallFromLibrary(
            userId: userId,
            ballId: ballId,
            categoryName: categoryName,
          );
          successCount++;
        } catch (e) {
          print('Failed to add ball ID: $ballId, Error: $e');
          failCount++;
        }
      }

      // Show success/error notification
      if (successCount > 0) {
        TopNotification.showSuccess(
          context,
          'Successfully added $successCount ball${successCount != 1 ? 's' : ''} to arsenal!',
        );
      }
      
      if (failCount > 0) {
        TopNotification.showError(
          context,
          'Failed to add $failCount ball${failCount != 1 ? 's' : ''}. Some balls may already be in your arsenal.',
        );
      }
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add balls to arsenal: $e',
      );
    }
  }

  /// Toggle remove mode in arsenal
  void _toggleRemoveMode() {
    ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
  }

  // 舊的行動按鈕列已移除（改由 AppBar + BottomSheet 提供）

  // 移除模式控制列與小按鈕已由 AppBar 情境列接手

  // 底部面板用的動作 Chip
  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Confirm and remove selected instances
  Future<void> _confirmRemoveSelected() async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectedCount = arsenalState.selectedForRemoval.length;
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final isMainBag = currentBagNumber == 1;
    
    if (isMainBag) {
      // 在主袋中，直接從總袋刪除
      final result = await showAppConfirmationDialog(
        context: context,
        title: 'Remove Selected Balls',
        message: 'Are you sure you want to completely remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from your arsenal?',
        confirmText: 'Remove',
        cancelText: 'Cancel',
      );

      if (result == true) {
        await _performCompleteRemoval(selectedCount);
      }
    } else {
      // 在子袋中，提供分級刪除選項
      await _showTieredRemovalDialog(selectedCount, currentBagNumber);
    }
  }

  /// 顯示分級刪除對話框
  Future<void> _showTieredRemovalDialog(int selectedCount, int currentBagNumber) async {
    final userProfileState = ref.read(userProfileControllerProvider);
    String currentBagName = 'Bag $currentBagNumber';
    if (userProfileState.profile != null) {
      currentBagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }

    final result = await showRemovalOptionsDialog(
      context: context,
      selectedCount: selectedCount,
      currentBagName: currentBagName,
    );

    if (result != null) {
      switch (result) {
        case 'bag_only':
          await _performBagOnlyRemoval(selectedCount, currentBagNumber);
          break;
        case 'complete':
          await _performCompleteRemoval(selectedCount);
          break;
      }
    }
  }

  // 刪除選項 UI 已抽出

  /// 執行僅從當前球袋移除
  Future<void> _performBagOnlyRemoval(int selectedCount, int bagNumber) async {
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        await ref.read(newArsenalControllerProvider.notifier).removeSelectedInstancesFromBag(bagNumber, userId);
        
        if (mounted) {
          final userProfileState = ref.read(userProfileControllerProvider);
          String bagName = 'Bag $bagNumber';
          if (userProfileState.profile != null) {
            bagName = userProfileState.profile!.getBagName(bagNumber) ?? 'Bag $bagNumber';
          }
          
          TopNotification.showSuccess(
            context,
            'Successfully removed $selectedCount ball${selectedCount != 1 ? 's' : ''} from $bagName',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        TopNotification.showError(
          context,
          'Failed to remove balls from bag: $e',
        );
      }
    }
  }

  /// 執行完全刪除
  Future<void> _performCompleteRemoval(int selectedCount) async {
    try {
      final authState = ref.read(authControllerProvider);
      if (authState.hasValue && authState.value != null) {
        final userId = authState.value!.id;
        await ref.read(newArsenalControllerProvider.notifier).removeSelectedInstances(userId);
        
        if (mounted) {
          TopNotification.showSuccess(
            context,
            'Successfully removed $selectedCount ball${selectedCount != 1 ? 's' : ''} from arsenal',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        TopNotification.showError(
          context,
          'Failed to remove balls: $e',
        );
      }
    }
  }

  /// 顯示排序選項對話框
  void _showSortDialog(BuildContext context) {
    final arsenalState = ref.read(newArsenalControllerProvider);
    showSortOptionsSheet(
      context: context,
      selected: arsenalState.sortOption,
      onSelect: (option) => ref.read(newArsenalControllerProvider.notifier).setSortOption(option),
    );
  }

  /// 顯示跨球袋新增對話框
  Future<void> _showCrossSubBagAddDialog() async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final isMainBag = currentBagNumber == 1;
    
    // 獲取當前球袋名稱
    final userProfileState = ref.read(userProfileControllerProvider);
    String currentBagName = 'All My Arsenal';
    if (userProfileState.profile != null && !isMainBag) {
      currentBagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }
    
    final result = await showAddToBagDialog(
      context: context,
      isMainBag: isMainBag,
      currentBagName: currentBagName,
    );
    
    if (result != null) {
      switch (result) {
        case 'library':
          await _showLibrarySelectionForCurrentBag();
          break;
        case 'main_bag':
          await _showMainBagSelectionForCurrentBag();
          break;
      }
    }
  }

  // 新增選項 UI 已抽出

  /// 為當前球袋從博物館選擇球具
  Future<void> _showLibrarySelectionForCurrentBag() async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    
    final selectedBallIds = await showLibrarySelectionDialog(context);
    
    if (selectedBallIds != null && selectedBallIds.isNotEmpty) {
      await _addSelectedBallsToSpecificBag(selectedBallIds, currentBagNumber);
    }
  }

  /// 為當前球袋從主袋選擇球具
  Future<void> _showMainBagSelectionForCurrentBag() async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    
    // 獲取主袋中不在當前球袋的球具
    final mainBagInstances = arsenalState.allInstances
        .where((instance) => !instance.isInBag(currentBagNumber))
        .toList();
    
    if (mainBagInstances.isEmpty) {
      TopNotification.showError(
        context,
        'No balls available to add from main collection',
      );
      return;
    }
    
    // TODO: 實作主袋球具選擇對話框
    TopNotification.showError(
      context,
      'Main bag selection coming soon!',
    );
  }

  /// 將選定的球具加入特定球袋
  Future<void> _addSelectedBallsToSpecificBag(List<int> ballIds, int targetBagNumber) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(
          context,
          'Please log in to add balls to arsenal',
        );
        return;
      }
      final userId = authState.value!.id;

      // Get current arsenal state to determine category
      final arsenalState = ref.read(newArsenalControllerProvider);
      
      // Use "My Balls" as default category, or first existing category
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      // 預設包含球袋1和目標球袋
      final bagNumbers = targetBagNumber == 1 
          ? [1] 
          : [1, targetBagNumber];

      // Add each selected ball to the specified bag(s)
      int successCount = 0;
      int failCount = 0;
      
      for (final ballId in ballIds) {
        try {
          await ref.read(newArsenalControllerProvider.notifier).addBallFromLibraryToMultipleBags(
            userId: userId,
            ballId: ballId,
            categoryName: categoryName,
            bagNumbers: bagNumbers,
          );
          successCount++;
        } catch (e) {
          print('Failed to add ball ID: $ballId, Error: $e');
          failCount++;
        }
      }

      // Show success/error notification
      if (successCount > 0) {
        final userProfileState = ref.read(userProfileControllerProvider);
        String bagName = 'All My Arsenal';
        if (userProfileState.profile != null && targetBagNumber != 1) {
          bagName = userProfileState.profile!.getBagName(targetBagNumber) ?? 'Bag $targetBagNumber';
        }
        
        TopNotification.showSuccess(
          context,
          'Successfully added $successCount ball${successCount != 1 ? 's' : ''} to $bagName!',
        );
      }
      
      if (failCount > 0) {
        TopNotification.showError(
          context,
          'Failed to add $failCount ball${failCount != 1 ? 's' : ''}. Some balls may already be in your arsenal.',
        );
      }
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add balls to bag: $e',
      );
    }
  }

  /// Toggle move mode
  void _toggleMoveMode() {
    ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
  }

  // 移動模式控制列已由 AppBar 情境列接手

  /// 顯示移動目標球袋選擇
  Future<void> _showBagSelectionForMove(NewArsenalState arsenalState, UserProfileState userProfileState) async {
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final selectedCount = arsenalState.selectedForMove.length;
    
    if (userProfileState.profile == null) {
      TopNotification.showError(context, 'Failed to load user profile');
      return;
    }

    final profile = userProfileState.profile!;
    // 僅在子球袋間移動：排除主球袋與當前球袋
    final subBags = profile.unlockedBags
        .where((bag) => bag.number != 1)
        .toList();

    if (subBags.where((b) => b.number != currentBagNumber).isEmpty) {
      TopNotification.showError(
        context,
        'No other bags available for moving balls',
      );
      return;
    }

    final targetBagNumber = await showMoveTargetBagDialog(
      context: context,
      subBags: subBags,
      bagColors: _bagColors,
      currentBagNumber: currentBagNumber,
      selectedCount: selectedCount,
    );

    if (targetBagNumber != null) {
      // 交由抽離的動作封裝處理
      await ArsenalActions.showMoveSelected(context: context, ref: ref, bagColors: _bagColors);
    }
  }

  /// 確認移動到目標球袋
  Future<void> _confirmMoveToBag(int targetBagNumber, int selectedCount) async {}

}