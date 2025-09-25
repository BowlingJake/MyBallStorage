import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/arsenal_app_bar.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_tabs_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_management_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_content_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_ui_service.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/move_balls_use_case.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/multi_bag_selection_dialog.dart';

/// Refactored My Arsenal Page - simplified and component-based
class MyArsenalPage extends ConsumerStatefulWidget {
  const MyArsenalPage({super.key});

  @override
  ConsumerState<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;

  // 使用統一的袋子顏色服務
  List<Color> get _bagColors => BagColorService.getAllBagColors();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _initializeData() {
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      ref.read(newArsenalControllerProvider.notifier).initialize(userId);
      ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
    }
  }

  void _updateTabController(TabController? newController) {
    _tabController?.dispose();
    _tabController = newController;
    setState(() {});
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0;
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
        context.go('/tournament');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final userProfileState = ref.watch(userProfileControllerProvider);

    // Initialize tab controller when user profile is loaded
    if (userProfileState.profile != null && _tabController == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final newTabController = ArsenalTabsController.createTabController(
          vsync: this,
          userProfileState: userProfileState,
          onBagSelected: (bag) => ref.read(newArsenalControllerProvider.notifier).selectBag(bag),
        );
        _updateTabController(newTabController);
      });
    }

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Tabs Section
            ArsenalTabsSection(
              tabController: _tabController,
              bagColors: _bagColors,
              onUnlockTap: (index) => _showUnlockBagDialog(index),
              onBlockedSwitch: (tappedIndex) {
                // 進入選取模式後阻止切換；若用戶仍點別的袋，直接退出選取並切換
                ref.read(arsenalUIServiceProvider.notifier).exitSelectionMode(arsenalState);
                _tabController?.index = tappedIndex;
              },
            ),
            
            // Management Section
            ArsenalManagementSection(
              bagColors: _bagColors,
              onShowMoreOptions: () => ref.read(arsenalUIServiceProvider.notifier).showMoreOptionsBottomSheet(
                context: context,
                widgetRef: ref,
                arsenalState: arsenalState,
              ),
            ),
            
            // Content Section
            const Expanded(
              child: ArsenalContentSection(),
            ),
          ],
        ),
        // Bottom navigation bar with selection mode support
        bottomNavigationBar: Consumer(
          builder: (context, ref, child) {
            final selectionState = ref.watch(arsenalSelectionStateProviderProvider);
            final currentIndex = _calculateCurrentIndex(location);

            if (selectionState.isInSelectionMode) {
              return _buildSelectionBottomBar(context, ref, selectionState);
            } else {
              return ModernBottomNavigation(
                currentIndex: currentIndex,
                onTap: (index) => _navigateToIndex(context, index),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final genericSelection = ref.watch(arsenalSelectionStateProviderProvider).isInSelectionMode;
    final selectionMode = genericSelection || ref.read(arsenalUIServiceProvider.notifier).isInSelectionMode(arsenalState);
    
    return ArsenalAppBar(
      title: const Text('My Arsenal'),
      searchField: const SizedBox.shrink(),
      isSearching: false,
      onBack: () {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      onToggleSearch: () {},
      actionsOverride: selectionMode
          ? []
          : [
              IconButton(
                onPressed: () => ref.read(arsenalUIServiceProvider.notifier).showAddToCurrentBag(
                      context: context,
                      widgetRef: ref,
                    ),
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'Add',
              ),
              const SizedBox(width: 8),
            ],
      moreAction: selectionMode
          ? null
          : IconButton(
              onPressed: () => ref.read(arsenalUIServiceProvider.notifier).showMoreOptionsBottomSheet(
                context: context,
                widgetRef: ref,
                arsenalState: arsenalState,
              ),
              icon: Icon(
                Icons.more_vert,
                color: ref.read(arsenalUIServiceProvider.notifier).hasActiveFilters(arsenalState) ? Colors.blue : Colors.white,
                size: 24,
              ),
              tooltip: 'More Options',
            ),
    );
  }

  void _showUnlockBagDialog(int index) async {
    await ref.read(arsenalUIServiceProvider.notifier).showUnlockBagDialog(
      context: context,
      widgetRef: ref,
      bagIndex: index,
      bagColors: _bagColors,
      vsync: this,
      onTabControllerUpdate: _updateTabController,
    );
  }

  /// Build selection mode bottom action bar
  Widget _buildSelectionBottomBar(BuildContext context, WidgetRef ref, ArsenalSelectionState selectionState) {
    final selectedCount = selectionState.selectedCount;
    final canPerformAction = selectionState.canPerformActions;
    final currentBag = ref.read(newArsenalControllerProvider).selectedBagNumber;
    // 主袋 Add：>0 可用；子袋 Move：僅允許單選
    final bool isMainBag = currentBag == 1;
    final canPrimary = isMainBag ? (selectedCount > 0) : (selectedCount == 1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Selection count display
            Text(
              'Selected $selectedCount ball${selectedCount != 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // Action buttons - Move and Remove side by side
            Row(
              children: [
                // Move button (left)
                Expanded(
                  child: AppStandardButton(
                    text: _getMoveButtonText(),
                    height: 40,
                    enabled: canPrimary,
                    onPressed: () {
                      if (canPrimary) {
                        _performMoveAction(context, ref);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Remove button (right)
                Expanded(
                  child: AppStandardButton.destructive(
                    text: 'Remove',
                    height: 40,
                    enabled: canPerformAction,
                    onPressed: () {
                      if (canPerformAction) {
                        _performRemoveAction(context, ref);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _performMoveAction(BuildContext context, WidgetRef ref) {
    final selectionState = ref.read(arsenalSelectionStateProviderProvider);
    final selectedIds = selectionState.selectedInstanceIds.toList();

    if (selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected')),
      );
      return;
    }

    final arsenalState = ref.read(newArsenalControllerProvider);
    final currentBag = arsenalState.selectedBagNumber;

    if (currentBag == 1) {
      // 主袋：Add to Other Bags（不從主袋移除）
      _addSelectedToOtherBag(context, ref, selectedIds);
    } else {
      // 子袋：Move（僅允許單選）
      if (!ref.read(newArsenalControllerProvider).isMoveMode) {
        ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
      }
      // 僅同步第一顆（規則：只允許單選）
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(selectedIds.first);

      ref.read(arsenalUIServiceProvider.notifier).showMoveSelected(
        context: context,
        bagColors: _bagColors,
      );
    }
  }

  void _performRemoveAction(BuildContext context, WidgetRef ref) {
    final selectionState = ref.read(arsenalSelectionStateProviderProvider);
    final selectedIds = selectionState.selectedInstanceIds.toList();

    if (selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items selected')),
      );
      return;
    }

    // 啟用 Remove 模式並同步選取（UseCase 讀取控制器集合）
    if (!ref.read(newArsenalControllerProvider).isRemoveMode) {
      ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
    }
    for (final id in selectedIds) {
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(id);
    }

    // 顯示移除確認並執行（取消不退出選擇模式）
    ref.read(arsenalUIServiceProvider.notifier).confirmRemoveSelected(
      context: context,
      widgetRef: ref,
    );
  }

  String _getMoveButtonText() {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectedBag = arsenalState.selectedBagNumber;

    if (selectedBag == 1) {
      return 'Add to Other Bags';
    } else {
      return 'Move';
    }
  }

  Future<void> _addSelectedToOtherBag(BuildContext context, WidgetRef ref, List<int> instanceIds) async {
    // 多選目標子袋（排除主袋與目前袋）
    final userProfileState = ref.read(userProfileControllerProvider);
    final profile = userProfileState.profile;
    if (profile == null) {
      TopNotification.showError(context, 'Failed to load user profile');
      return;
    }

    final availableBags = profile.unlockedBags
        .where((b) => b.number != 1)
        .toList();

    final targetBags = await showMultiBagSelectionDialog(
      context: context,
      subBags: availableBags,
      bagColors: _bagColors,
      currentBagNumber: 1,
      selectedCount: instanceIds.length,
      userProfile: profile,
      titleText: 'Add ${instanceIds.length} Ball${instanceIds.length != 1 ? 's' : ''} to Bags',
    );
    if (targetBags == null || targetBags.isEmpty) {
      return;
    }

    // 執行「新增到子袋」而非移動
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in')),
      );
      return;
    }
    final userId = authState.value!.id;
    for (final bag in targetBags) {
      await ref.read(newArsenalControllerProvider.notifier).addExistingInstancesToBag(
        instanceIds: instanceIds,
        bagNumber: bag,
        userId: userId,
      );
    }

    // 成功提示
    TopNotification.showSuccess(context, 'Added ${instanceIds.length} ball${instanceIds.length != 1 ? 's' : ''} to ${targetBags.length} bag${targetBags.length != 1 ? 's' : ''}');

    // 結束通用選取模式
    ref.read(arsenalSelectionStateProviderProvider.notifier).exitSelectionMode();
  }
}