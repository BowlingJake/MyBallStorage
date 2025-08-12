import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_tabs_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/arsenal_app_bar.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_tabs_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_management_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_content_section.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/components/arsenal_bottom_actions.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/handlers/arsenal_bag_handler.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/handlers/arsenal_selection_handler.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/handlers/arsenal_dialog_handler.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';

/// Refactored My Arsenal Page - simplified and component-based
class MyArsenalPage extends ConsumerStatefulWidget {
  const MyArsenalPage({super.key});

  @override
  ConsumerState<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;

  final List<Color> _bagColors = [
    Colors.orange,  // 🟠 主球袋
    Colors.red,     // 🔴 進攻/重型
    Colors.yellow,  // 🟡 全能/中型
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
    if (location.startsWith('/events')) return 4;
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
        context.go('/events');
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
              onBlockedSwitch: () => ArsenalSelectionHandler.exitSelectionMode(ref, arsenalState),
            ),
            
            // Management Section
            ArsenalManagementSection(
              bagColors: _bagColors,
              onShowMoreOptions: () => ArsenalDialogHandler.showMoreOptionsBottomSheet(
                context: context,
                ref: ref,
                arsenalState: arsenalState,
              ),
            ),
            
            // Content Section
            const Expanded(
              child: ArsenalContentSection(),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ArsenalBottomActions(
          onToggleMoveMode: () => ArsenalSelectionHandler.toggleMoveMode(ref),
          onToggleRemoveMode: () => ArsenalSelectionHandler.toggleRemoveMode(ref),
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final selectionMode = ArsenalSelectionHandler.isInSelectionMode(arsenalState);
    
    return ArsenalAppBar(
      isSearchExpanded: false,
      searchController: _searchController,
      onSearchToggle: () {
        setState(() {
          // Handle search toggle if needed
        });
      },
      actionsOverride: selectionMode ? [] : null,
      moreAction: selectionMode
          ? null
          : IconButton(
              onPressed: () => ArsenalDialogHandler.showMoreOptionsBottomSheet(
                context: context,
                ref: ref,
                arsenalState: arsenalState,
              ),
              icon: Icon(
                Icons.more_vert,
                color: ArsenalBagHandler.hasActiveFilters(ref, arsenalState) ? Colors.blue : Colors.white,
                size: 24,
              ),
              tooltip: 'More Options',
            ),
    );
  }

  void _showUnlockBagDialog(int index) async {
    await ArsenalBagHandler.showUnlockBagDialog(
      context: context,
      ref: ref,
      bagIndex: index,
      bagColors: _bagColors,
      vsync: this,
      onTabControllerUpdate: _updateTabController,
    );
  }
}