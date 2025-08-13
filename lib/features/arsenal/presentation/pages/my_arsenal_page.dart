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
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_ui_service.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';

/// Refactored My Arsenal Page - simplified and component-based
class MyArsenalPage extends ConsumerStatefulWidget {
  const MyArsenalPage({super.key});

  @override
  ConsumerState<MyArsenalPage> createState() => _MyArsenalPageState();
}

class _MyArsenalPageState extends ConsumerState<MyArsenalPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  bool _isSearching = false;

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
              onBlockedSwitch: () => ref.read(arsenalUIServiceProvider.notifier).exitSelectionMode(arsenalState),
            ),
            
            // Management Section
            ArsenalManagementSection(
              bagColors: _bagColors,
              onShowMoreOptions: () => ref.read(arsenalUIServiceProvider.notifier).showMoreOptionsBottomSheet(
                context: context,
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
          onToggleMoveMode: () => ref.read(arsenalUIServiceProvider.notifier).toggleMoveMode(),
          onToggleRemoveMode: () => ref.read(arsenalUIServiceProvider.notifier).toggleRemoveMode(),
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
    final selectionMode = ref.read(arsenalUIServiceProvider.notifier).isInSelectionMode(arsenalState);
    
    return ArsenalAppBar(
      title: const Text('My Arsenal'),
      searchField: TextField(
        controller: _searchController,
        onChanged: (value) {
          ref.read(newArsenalControllerProvider.notifier).updateSearchText(value);
        },
        decoration: const InputDecoration(
          hintText: 'Search balls...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
      isSearching: _isSearching,
      onBack: () {
        final router = GoRouter.of(context);
        if (router.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      onToggleSearch: () {
        setState(() {
          _isSearching = !_isSearching;
          if (!_isSearching) {
            _searchController.clear();
            ref.read(newArsenalControllerProvider.notifier).updateSearchText('');
          }
        });
      },
      actionsOverride: selectionMode ? [] : null,
      moreAction: selectionMode
          ? null
          : IconButton(
              onPressed: () => ref.read(arsenalUIServiceProvider.notifier).showMoreOptionsBottomSheet(
                context: context,
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
      bagIndex: index,
      bagColors: _bagColors,
      vsync: this,
      onTabControllerUpdate: _updateTabController,
    );
  }
}