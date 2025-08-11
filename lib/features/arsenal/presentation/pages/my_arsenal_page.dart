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
  void _showUnlockBagDialog(int index) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 標題
                  Text(
                    'Unlock Bag ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // 名稱輸入框
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter bag name...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[600]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _bagColors[index]),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.6),
                    ),
                    maxLength: 20,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // 按鈕
                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: 'Cancel',
                          height: 36,
                          fontSize: 14,
                          customColor: Colors.grey[400]!,
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Unlock',
                          height: 36,
                          fontSize: 14,
                          customColor: _bagColors[index],
                          isPrimary: true,
                          onPressed: () async {
                            final bagName = nameController.text.trim();
                            if (bagName.isEmpty) {
                              TopNotification.showError(
                                dialogContext,
                                'Please enter a bag name',
                              );
                              return;
                            }
                            
                            try {
                              // 取得使用者ID
                              final authState = ref.read(authControllerProvider);
                              if (!authState.hasValue || authState.value == null) {
                                throw Exception('User not authenticated');
                              }
                              final userId = authState.value!.id;
                              
                              // 更新後端
                              await ref.read(userProfileControllerProvider.notifier).unlockBag(
                                userId: userId,
                                bagNumber: index + 1,
                                bagName: bagName,
                              );
                              
                              Navigator.of(dialogContext).pop();
                              
                              // Re-initialize tab controller with new bag
                              _initializeTabController();
                              setState(() {});
                              
                              if (mounted) {
                                TopNotification.showSuccess(
                                  context,
                                  'Bag ${index + 1} unlocked successfully!',
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                TopNotification.showError(
                                  dialogContext,
                                  'Failed to unlock bag: $e',
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((_) {
      nameController.dispose();
    });
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
        _initializeTabController();
        setState(() {});
      });
    }

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // 可滑動分頁標籤區
            if (_tabController != null) 
              _buildScrollableTabBar(userProfileState),
            
            // 管理按鈕區
            _buildManagementButtonsSection(),
            
            // 內容顯示區
            Expanded(
              child: _buildContentDisplaySection(theme, arsenalState),
            ),
          ],
        ),
        // 移除 FAB，改用 AppBar/底部面板等方式提供動作
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }


  /// B區：重新設計的功能列
  Widget _buildManagementButtonsSection() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 搜尋欄改移至 AppBar，這裡不再顯示
          
          // 視圖控制列
          _buildSecondRowControls(arsenalState),
        ],
      ),
    );
  }

  /// 搜尋欄與更多選項列
  Widget _buildSearchAndMoreOptionsRow(NewArsenalState arsenalState) {
    return Row(
      children: [
        // 搜尋欄
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.blue.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by name or brand...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onChanged: (value) {
                ref.read(newArsenalControllerProvider.notifier).updateSearchText(value);
              },
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 更多選項按鈕（3點選單）
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hasActiveFilters(arsenalState) 
                  ? Colors.blue
                  : Colors.grey[600]!,
              width: 1.5,
            ),
          ),
          child: IconButton(
            onPressed: () => _showMoreOptionsBottomSheet(arsenalState),
            icon: Icon(
              Icons.more_vert,
              color: _hasActiveFilters(arsenalState)
                  ? Colors.blue
                  : Colors.grey[400],
              size: 20,
            ),
            tooltip: 'More Options',
          ),
        ),
      ],
    );
  }

  /// 搜尋欄（單獨顯示）
  Widget _buildSearchBar(NewArsenalState arsenalState) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blue.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name or brand...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onChanged: (value) {
          ref.read(newArsenalControllerProvider.notifier).updateSearchText(value);
        },
      ),
    );
  }


  /// 第一行按鈕組件（有文字版）
  Widget _buildFirstRowButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.blue : Colors.white,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 第一行按鈕組件（圖示版）
  Widget _buildFirstRowIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? Colors.blue : Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                size: 18,
                color: isActive ? Colors.blue : Colors.white,
              ),
            ),
            if (isActive)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// C區：內容顯示區（簡化版，主要控制已移至B區）
  Widget _buildContentDisplaySection(ThemeData theme, NewArsenalState arsenalState) {
    return Column(
      children: [
        // 操作按鈕列（新增/刪除/移動或選擇模式控制）
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: arsenalState.isRemoveMode 
              ? _buildRemoveModeControls(arsenalState)
              : arsenalState.isMoveMode
                  ? _buildMoveModeControls(arsenalState)
                  : _buildActionButtons(),
        ),
        
        // 主內容區域
        Expanded(
          child: _buildMainContent(theme, arsenalState),
        ),
      ],
    );
  }

  /// 第二行：視圖控制功能
  Widget _buildSecondRowControls(NewArsenalState arsenalState) {
    return Row(
      children: [
        // Grid/List 切換按鈕
        _buildViewModeToggle(),
        
        const Spacer(),
        
        // Show the selected bag info
        Text(
          _getSelectedBagDisplayText(arsenalState),
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Get display text for currently selected bag
  String _getSelectedBagDisplayText(NewArsenalState arsenalState) {
    final userProfileState = ref.read(userProfileControllerProvider);
    final selectedBag = arsenalState.selectedBagNumber;
    
    if (selectedBag == 1) {
      return 'Viewing: All My Arsenal';
    } else if (userProfileState.profile != null) {
      final bagName = userProfileState.profile!.getBagName(selectedBag);
      return 'Viewing: ${bagName ?? 'Bag $selectedBag'}';
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildMoreOptionsSheet(arsenalState),
    );
  }

  /// 建構更多選項底部彈窗
  Widget _buildMoreOptionsSheet(NewArsenalState arsenalState) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[600]!,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖拽指示器
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 標題
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'More Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 快速動作
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Move Balls（僅非主袋顯示）
                if ((arsenalState.selectedBagNumber ?? 1) != 1)
                  _buildActionChip(
                    icon: Icons.swap_horiz,
                    label: 'Move',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.of(context).pop();
                      _toggleMoveMode();
                    },
                  ),
                if ((arsenalState.selectedBagNumber ?? 1) != 1)
                  const SizedBox(width: 12),
                _buildActionChip(
                  icon: Icons.remove_circle_outline,
                  label: 'Remove',
                  color: Colors.red,
                  onTap: () {
                    Navigator.of(context).pop();
                    _toggleRemoveMode();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 選項列表
          ListTile(
            leading: Icon(
              Icons.filter_list, 
              color: arsenalState.filters.activeFilterCount > 0 
                  ? Colors.blue 
                  : Colors.grey[400],
            ),
            title: Text(
              'Filter',
              style: TextStyle(
                color: arsenalState.filters.activeFilterCount > 0 
                    ? Colors.blue 
                    : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: arsenalState.filters.activeFilterCount > 0 
                ? Text(
                    '${arsenalState.filters.activeFilterCount} filter${arsenalState.filters.activeFilterCount != 1 ? 's' : ''} active',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  )
                : null,
            onTap: () {
              Navigator.of(context).pop();
              _showFilterDialog(context, ref, arsenalState);
            },
          ),
          
          ListTile(
            leading: Icon(
              Icons.sort, 
              color: arsenalState.sortOption != SortOption.nameAZ 
                  ? Colors.blue 
                  : Colors.grey[400],
            ),
            title: Text(
              'Sort',
              style: TextStyle(
                color: arsenalState.sortOption != SortOption.nameAZ 
                    ? Colors.blue 
                    : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: arsenalState.sortOption != SortOption.nameAZ 
                ? Text(
                    arsenalState.sortOption.displayName,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  )
                : null,
            onTap: () {
              Navigator.of(context).pop();
              _showSortDialog(context);
            },
          ),
          
          // 清除所有篩選器選項
          if (_hasActiveFilters(arsenalState))
            ListTile(
              leading: Icon(Icons.clear, color: Colors.red[400]),
              title: Text(
                'Clear All Filters & Sort',
                style: TextStyle(
                  color: Colors.red[400],
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                ref.read(newArsenalControllerProvider.notifier).clearFilters();
                ref.read(newArsenalControllerProvider.notifier).setSortOption(SortOption.nameAZ);
              },
            ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

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

  /// 建構可滑動的分頁標籤欄
  Widget _buildScrollableTabBar(UserProfileState userProfileState) {
    if (userProfileState.profile == null || _tabController == null) {
      return const SizedBox.shrink();
    }

    final unlockedBags = userProfileState.profile!.unlockedBags;
    final nextBagToUnlock = userProfileState.profile!.nextBagToUnlock;
    
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 16, top: 0, bottom: 8),
      child: TabBar(
        controller: _tabController!,
        isScrollable: true,
        indicatorColor: Colors.transparent, // 移除指示線
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        dividerColor: Colors.transparent, // 移除分隔線
        tabAlignment: TabAlignment.start, // 靠左對齊
        tabs: [
          // 第一個標籤：All My Arsenal
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _bagColors[0].withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _bagColors[0],
                  width: 1.5,
                ),
              ),
              child: Text(
                'All My Arsenal',
                style: TextStyle(
                  color: _bagColors[0],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // 後續標籤：用戶解鎖的球袋
          ...unlockedBags.skip(1).map((bagInfo) {
            final bagIndex = bagInfo.number - 1;
            final bagColor = bagIndex < _bagColors.length 
                ? _bagColors[bagIndex] 
                : Colors.grey;
            
            return Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: bagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: bagColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  bagInfo.name,
                  style: TextStyle(
                    color: bagColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
          
          // 最後一個按鈕：解鎖新球袋
          if (nextBagToUnlock != null)
            Tab(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Unlock Bag $nextBagToUnlock',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
        onTap: (index) {
          // Handle unlock button tap
          // 最後一個index是unlock button (如果nextBagToUnlock不為null)
          final unlockButtonIndex = nextBagToUnlock != null 
              ? 1 + (unlockedBags.length - 1) // "All Arsenal" + skipped bags
              : -1; // No unlock button
              
          if (nextBagToUnlock != null && index == unlockButtonIndex) {
            _showUnlockBagDialog(nextBagToUnlock - 1);
          }
        },
      ),
    );
  }

  /// 建構自訂的 AppBar
  PreferredSizeWidget _buildAppBar() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go('/'),
      ),
      title: _isSearchExpanded
          ? _buildSearchBar(arsenalState)
          : const Text(
              'My Arsenal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      actions: [
        // 搜尋按鈕
        IconButton(
          onPressed: () {
            setState(() {
              _isSearchExpanded = !_isSearchExpanded;
              if (!_isSearchExpanded) {
                _searchController.clear();
                ref.read(newArsenalControllerProvider.notifier).updateSearchText('');
              }
            });
          },
          icon: Icon(
            _isSearchExpanded ? Icons.search_off : Icons.search,
            color: _isSearchExpanded ? Colors.blue : Colors.white,
            size: 24,
          ),
          tooltip: _isSearchExpanded ? 'Close Search' : 'Search',
        ),
        // 直接新增入口
        IconButton(
          onPressed: _showCrossSubBagAddDialog,
          icon: const Icon(Icons.library_add_outlined, color: Colors.white),
          tooltip: 'Add',
        ),
        // 更多選項按鈕（3點選單）移至 AppBar 並置於搜尋按鈕右側
        IconButton(
          onPressed: () => _showMoreOptionsBottomSheet(arsenalState),
          icon: Icon(
            Icons.more_vert,
            color: _hasActiveFilters(arsenalState)
                ? Colors.blue
                : Colors.white,
            size: 24,
          ),
          tooltip: 'More Options',
        ),
        
        const SizedBox(width: 8),
      ],
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

    if (filteredInstances.isEmpty) {
      return _buildEmptyState(theme);
    }

    return arsenalState.viewMode == ArsenalViewMode.grid
        ? _buildGridView(filteredInstances)
        : _buildListView(filteredInstances);
  }


  Widget _buildGridView(List<UserArsenalInstance> filteredInstances) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1, // 調整比例，減少高度但保持足夠空間
        ),
        itemCount: filteredInstances.length,
        itemBuilder: (context, index) {
          final instance = filteredInstances[index];
          final isSelectedForRemoval = arsenalState.selectedForRemoval.contains(instance.id);
          final isSelectedForMove = arsenalState.selectedForMove.contains(instance.id);
          final isSelected = isSelectedForRemoval || isSelectedForMove;
          
          return ArsenalGridCard(
            instance: instance,
            isSelectionMode: arsenalState.isRemoveMode || arsenalState.isMoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode 
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
                : arsenalState.isMoveMode
                    ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(instance.id)
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildListView(List<UserArsenalInstance> filteredInstances) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 32), // 參考Ball Library的設計
        itemCount: filteredInstances.length,
        itemBuilder: (context, index) {
          final instance = filteredInstances[index];
          final isSelectedForRemoval = arsenalState.selectedForRemoval.contains(instance.id);
          final isSelectedForMove = arsenalState.selectedForMove.contains(instance.id);
          final isSelected = isSelectedForRemoval || isSelectedForMove;
          
          return ArsenalSpecificBallCard(
            arsenalBallInstance: instance,
            theme: Theme.of(context),
            isSelectionMode: arsenalState.isRemoveMode || arsenalState.isMoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode 
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
                : arsenalState.isMoveMode
                    ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(instance.id)
                    : null,
            extraInfo: _buildArsenalExtraInfo(instance),
          );
        },
      ),
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

  // FAB 已暫時移除：改採其他互動模式以避免遮擋內容


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
                      TopNotification.showError(
                        context,
                        'Edit functionality coming soon',
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
                  TopNotification.showSuccess(
                    context,
                    'Ball removed successfully',
                  );
                }
              } catch (e) {
                TopNotification.showError(
                  context,
                  'Failed to remove ball: $e',
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

  /// Build normal action buttons (add from library / remove balls)
  Widget _buildActionButtons() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final isMainBag = currentBagNumber == 1;
    
    return Row(
      children: [
        // 第一個按鈕：根據當前球袋顯示不同文字
        Expanded(
          child: AppStandardButton(
            text: isMainBag ? 'Add from Library' : 'Add to This Bag',
            height: 36,
            fontSize: 12,
            customColor: Colors.green,
            onPressed: () => _showCrossSubBagAddDialog(),
          ),
        ),
        const SizedBox(width: 8),
        
        // 第二個按鈕：移動球具（非主袋時顯示）
        if (!isMainBag) ...[
          Expanded(
            child: AppStandardButton(
              text: 'Move Balls',
              icon: Icons.swap_horiz,
              height: 36,
              fontSize: 12,
              customColor: Colors.blue,
              onPressed: () => _toggleMoveMode(),
            ),
          ),
          const SizedBox(width: 8),
        ],
        
        // 移除按鈕
        Expanded(
          child: AppStandardButton(
            text: 'Remove Balls',
            icon: Icons.remove_circle_outline,
            height: 36,
            fontSize: 12,
            customColor: Colors.red,
            onPressed: () => _toggleRemoveMode(),
          ),
        ),
      ],
    );
  }

  /// Build remove mode controls (selection info + action buttons)
  Widget _buildRemoveModeControls(NewArsenalState arsenalState) {
    final selectedCount = arsenalState.selectedForRemoval.length;
    final hasSelection = selectedCount > 0;

    return Row(
      children: [
        // Selection info
        Expanded(
          child: Text(
            '$selectedCount ball${selectedCount != 1 ? 's' : ''} selected',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Delete selected button (only show if has selection)
        if (hasSelection) ...[
          _buildRemoveModeActionButton(
            icon: Icons.delete,
            color: Colors.red,
            onTap: () => _confirmRemoveSelected(),
          ),
          const SizedBox(width: 8),
        ],
        // Exit remove mode button
        _buildRemoveModeActionButton(
          icon: Icons.close,
          color: Colors.orange,
          onTap: () => _toggleRemoveMode(),
        ),
      ],
    );
  }

  /// Build small action button for remove mode
  Widget _buildRemoveModeActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

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

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Text(
          'Remove $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose removal option:',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            
            // 選項 1：僅從當前球袋移除
            _buildRemovalOptionTile(
              icon: Icons.remove_circle_outline,
              title: 'Remove from $currentBagName Only',
              subtitle: 'Keep balls in All My Arsenal',
              color: Colors.orange,
              onTap: () => Navigator.of(context).pop('bag_only'),
            ),
            
            const SizedBox(width: 16),
            
            // 選項 2：從總袋完全刪除
            _buildRemovalOptionTile(
              icon: Icons.delete_forever,
              title: 'Remove from All Arsenal',
              subtitle: 'Completely remove from all bags',
              color: Colors.red,
              onTap: () => Navigator.of(context).pop('complete'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
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

  /// 建構刪除選項項目
  Widget _buildRemovalOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

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
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 拖拽指示器
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // 標題
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Sort Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // 排序選項列表
            ...SortOption.values.map((option) {
              final isSelected = arsenalState.sortOption == option;
              return ListTile(
                title: Text(
                  option.displayName,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected 
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  ref.read(newArsenalControllerProvider.notifier).setSortOption(option);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
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
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Text(
          isMainBag ? 'Add to Arsenal' : 'Add to $currentBagName',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isMainBag 
                ? 'Choose where to add new balls:'
                : 'Choose source to add balls from:',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            
            // 新增選項
            _buildAddOptionTile(
              icon: Icons.library_books,
              title: 'Ball Library',
              subtitle: 'Add new balls from the library',
              color: Colors.green,
              onTap: () => Navigator.of(context).pop('library'),
            ),
            
            if (!isMainBag) ...[
              const SizedBox(height: 12),
              _buildAddOptionTile(
                icon: Icons.inventory,
                title: 'All My Arsenal',
                subtitle: 'Move existing balls from main collection',
                color: Colors.blue,
                onTap: () => Navigator.of(context).pop('main_bag'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
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

  /// 建構新增選項項目
  Widget _buildAddOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color.withOpacity(0.6),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

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

  /// Build move mode controls (selection info + action buttons)
  Widget _buildMoveModeControls(NewArsenalState arsenalState) {
    final selectedCount = arsenalState.selectedForMove.length;
    final hasSelection = selectedCount > 0;
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final userProfileState = ref.watch(userProfileControllerProvider);

    return Row(
      children: [
        // Selection info
        Expanded(
          child: Text(
            '$selectedCount ball${selectedCount != 1 ? 's' : ''} selected to move',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Move selected button (only show if has selection)
        if (hasSelection) ...[
          _buildRemoveModeActionButton(
            icon: Icons.arrow_forward,
            color: Colors.blue,
            onTap: () => _showBagSelectionForMove(arsenalState, userProfileState),
          ),
          const SizedBox(width: 8),
        ],
        
        // Exit move mode button
        _buildRemoveModeActionButton(
          icon: Icons.close,
          color: Colors.orange,
          onTap: () => _toggleMoveMode(),
        ),
      ],
    );
  }

  /// 顯示移動目標球袋選擇
  Future<void> _showBagSelectionForMove(NewArsenalState arsenalState, UserProfileState userProfileState) async {
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    final selectedCount = arsenalState.selectedForMove.length;
    
    if (userProfileState.profile == null) {
      TopNotification.showError(context, 'Failed to load user profile');
      return;
    }

    final profile = userProfileState.profile!;
    final availableBags = profile.unlockedBags
        .where((bag) => bag.number != currentBagNumber) // 排除當前球袋
        .toList();

    if (availableBags.isEmpty) {
      TopNotification.showError(
        context,
        'No other bags available for moving balls',
      );
      return;
    }

    final targetBagNumber = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        title: Text(
          'Move $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose target bag:',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            
            // 目標球袋選擇列表
            ...availableBags.map((bagInfo) {
              final bagColor = _bagColors[bagInfo.number - 1];
              
              return ListTile(
                title: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: bagColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        bagInfo.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.of(context).pop(bagInfo.number),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );

    if (targetBagNumber != null) {
      await _confirmMoveToBag(targetBagNumber, selectedCount);
    }
  }

  /// 確認移動到目標球袋
  Future<void> _confirmMoveToBag(int targetBagNumber, int selectedCount) async {
    final userProfileState = ref.read(userProfileControllerProvider);
    String targetBagName = 'Bag $targetBagNumber';
    if (userProfileState.profile != null) {
      targetBagName = userProfileState.profile!.getBagName(targetBagNumber) ?? 'Bag $targetBagNumber';
    }

    final result = await showAppConfirmationDialog(
      context: context,
      title: 'Confirm Move',
      message: 'Move $selectedCount ball${selectedCount != 1 ? 's' : ''} to $targetBagName?',
      confirmText: 'Move',
      cancelText: 'Cancel',
    );

    if (result == true) {
      try {
        final authState = ref.read(authControllerProvider);
        if (authState.hasValue && authState.value != null) {
          final userId = authState.value!.id;
          await ref.read(newArsenalControllerProvider.notifier).moveSelectedInstancesToBag(targetBagNumber, userId);
          
          if (mounted) {
            TopNotification.showSuccess(
              context,
              'Successfully moved $selectedCount ball${selectedCount != 1 ? 's' : ''} to $targetBagName',
            );
          }
        }
      } catch (e) {
        if (mounted) {
          TopNotification.showError(
            context,
            'Failed to move balls: $e',
          );
        }
      }
    }
  }

}