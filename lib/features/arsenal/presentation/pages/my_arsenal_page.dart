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
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/bag_management_dialog.dart';
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

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> {
  bool _isSearchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  
  
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
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // B區：管理按鈕區
            _buildManagementButtonsSection(),
            
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


  /// B區：管理按鈕區 (Bag Management + 搜尋篩選排序功能)
  Widget _buildManagementButtonsSection() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _isSearchExpanded ? _buildExpandedSearchSection(arsenalState) : _buildNormalManagementSection(arsenalState),
    );
  }

  /// 正常管理區域 (顯示 Bag Management + 搜尋篩選排序按鈕)
  Widget _buildNormalManagementSection(NewArsenalState arsenalState) {
    return Row(
      children: [
        // Bag Management 按鈕
        Expanded(
          child: _buildManagementButton(
            text: 'Bag Management',
            onPressed: () => showBagManagementDialog(context),
          ),
        ),
        const SizedBox(width: 8),
        
        // 搜尋欄 (Ball Library 風格，較短)
        GestureDetector(
          onTap: () {
            setState(() {
              _isSearchExpanded = true;
            });
          },
          child: Container(
            width: 120, // 較短的搜尋欄
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Icon(Icons.search, color: Colors.grey, size: 18),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'Search...',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 篩選按鈕 (Ball Library 風格)
        GestureDetector(
          onTap: () => _showFilterDialog(context, ref, arsenalState),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: arsenalState.filters.activeFilterCount > 0
                    ? Colors.blue
                    : Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.filter_list, color: Colors.grey, size: 18),
                ),
                if (arsenalState.filters.activeFilterCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 排序按鈕 (Ball Library 風格)
        GestureDetector(
          onTap: () {
            // TODO: 實作排序功能
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(Icons.sort, color: Colors.grey, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  /// 展開搜尋區域 (隱藏 Bag Management，顯示搜尋欄 + 篩選排序按鈕)
  Widget _buildExpandedSearchSection(NewArsenalState arsenalState) {
    return Row(
      children: [
        // 展開的搜尋欄 (Ball Library 風格：外部 Container + 內部無背景 TextField)
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search arsenal...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 18),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearchExpanded = false;
                      _searchController.clear();
                    });
                    ref.read(newArsenalControllerProvider.notifier).updateSearchText('');
                  },
                  icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                isDense: true,
              ),
              onChanged: (text) {
                ref.read(newArsenalControllerProvider.notifier).updateSearchText(text);
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 篩選按鈕 (Ball Library 風格)
        GestureDetector(
          onTap: () => _showFilterDialog(context, ref, arsenalState),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: arsenalState.filters.activeFilterCount > 0
                    ? Colors.blue
                    : Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.filter_list, color: Colors.grey, size: 18),
                ),
                if (arsenalState.filters.activeFilterCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        
        // 排序按鈕 (Ball Library 風格)
        GestureDetector(
          onTap: () {
            // TODO: 實作排序功能
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8), // Ball Library 的背景色
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(Icons.sort, color: Colors.grey, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  /// 建構管理按鈕
  Widget _buildManagementButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return AppStandardButton(
      text: text,
      height: 36,
      fontSize: 14,
      customColor: Colors.white,
      isPrimary: false, // 使用outlined樣式
      onPressed: onPressed,
    );
  }

  /// C區：內容顯示區
  Widget _buildContentDisplaySection(ThemeData theme, NewArsenalState arsenalState) {
    return Column(
      children: [
        // 水平控制欄：Grid/List 切換按鈕 + 球袋選擇按鈕
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
              
              const SizedBox(width: 12),
              
              // 球袋選擇按鈕
              _buildBagSelectorButton(arsenalState),
            ],
          ),
        ),
        
        // 新增/刪除按鈕列或選擇模式控制列
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: arsenalState.isRemoveMode 
              ? _buildRemoveModeControls(arsenalState)
              : _buildActionButtons(),
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

  /// 建構自訂的 AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go('/'),
      ),
      title: const Text(
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
    );
  }


  /// 建構球袋選擇按鈕
  Widget _buildBagSelectorButton(NewArsenalState arsenalState) {
    final userProfileState = ref.watch(userProfileControllerProvider);
    final currentBagNumber = arsenalState.selectedBagNumber ?? 1;
    
    // 取得當前球袋名稱
    String bagName = 'All My Arsenal'; // 預設名稱
    if (userProfileState.profile != null) {
      bagName = userProfileState.profile!.getBagName(currentBagNumber) ?? 'Bag $currentBagNumber';
    }
    
    // 取得球袋對應的顏色 (index = bagNumber - 1)
    final bagColor = _bagColors[currentBagNumber - 1];
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _showBagSelectorBottomSheet(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(20), // 橢圓形
            border: Border.all(
              color: bagColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  bagName,
                  style: TextStyle(
                    color: bagColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: bagColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 顯示球袋選擇底部彈出選單
  void _showBagSelectorBottomSheet() {
    final userProfileState = ref.read(userProfileControllerProvider);
    final arsenalState = ref.read(newArsenalControllerProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBagSelectorSheet(userProfileState, arsenalState),
    );
  }

  /// 建構球袋選擇底部彈出選單
  Widget _buildBagSelectorSheet(UserProfileState userProfileState, NewArsenalState arsenalState) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
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
              'Select Bag',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // 球袋選項列表
          if (userProfileState.profile != null)
            ...userProfileState.profile!.unlockedBags.map((bagInfo) {
              final isSelected = (arsenalState.selectedBagNumber ?? 1) == bagInfo.number;
              final bagColor = _bagColors[bagInfo.number - 1];
              
              return ListTile(
                title: Text(
                  bagInfo.name,
                  style: TextStyle(
                    color: isSelected ? bagColor : Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'Bag ${bagInfo.number}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                trailing: isSelected 
                    ? Icon(Icons.check, color: bagColor)
                    : null,
                onTap: () {
                  // 更新選中的球袋
                  ref.read(newArsenalControllerProvider.notifier).selectBag(bagInfo.number);
                  Navigator.of(context).pop();
                },
              );
            }).toList()
          else
            // 載入中或無資料時的預設選項
            ListTile(
              title: Text(
                'All My Arsenal',
                style: TextStyle(
                  color: _bagColors[0], // 袋子1的顏色 (紅色)
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Bag 1',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.check, color: _bagColors[0]),
            ),
          
          const SizedBox(height: 24),
        ],
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
          final isSelected = arsenalState.selectedForRemoval.contains(instance.id);
          
          return ArsenalGridCard(
            instance: instance,
            isSelectionMode: arsenalState.isRemoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode 
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
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
          final isSelected = arsenalState.selectedForRemoval.contains(instance.id);
          
          return ArsenalSpecificBallCard(
            arsenalBallInstance: instance,
            theme: Theme.of(context),
            isSelectionMode: arsenalState.isRemoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode 
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
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

  Widget _buildFloatingActionButton(ThemeData theme) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: 導航到分析頁面
        TopNotification.showError(
          context,
          '分析功能即將推出',
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
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Add from Library',
            height: 36,
            fontSize: 12,
            customColor: Colors.green,
            onPressed: () => _showLibrarySelectionDialog(),
          ),
        ),
        const SizedBox(width: 12),
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

  /// Confirm and remove selected instances
  Future<void> _confirmRemoveSelected() async {
    final selectedCount = ref.read(newArsenalControllerProvider).selectedForRemoval.length;
    
    final result = await showAppConfirmationDialog(
      context: context,
      title: 'Remove Selected Balls',
      message: 'Are you sure you want to remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from your arsenal?',
      confirmText: 'Remove',
      cancelText: 'Cancel',
    );

    if (result == true) {
      try {
        final authState = ref.read(authControllerProvider);
        if (authState.hasValue && authState.value != null) {
          final userId = authState.value!.id;
          await ref.read(newArsenalControllerProvider.notifier).removeSelectedInstances(userId);
          
          if (mounted) {
            TopNotification.showSuccess(
              context,
              'Successfully removed $selectedCount ball${selectedCount != 1 ? 's' : ''}',
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
  }

}