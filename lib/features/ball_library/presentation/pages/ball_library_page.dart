import 'package:bowlingarsenal_app/features/arsenal/widgets/ball_list_view.dart';
import 'package:bowlingarsenal_app/shared/widgets/cards/unified_ball_card.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/features/comparison/presentation/widgets/ball_comparison_dialog.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/filter_popout.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_search_controls.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BallLibraryPage extends ConsumerStatefulWidget {
  const BallLibraryPage({super.key});

  @override
  ConsumerState<BallLibraryPage> createState() => _BallLibraryPageState();
}

class _BallLibraryPageState extends ConsumerState<BallLibraryPage> {
  bool _isComparisonMode = false;
  bool _isAddToArsenalMode = false;
  Set<int> _selectedBallIds = {};

  void _toggleComparisonMode() {
    setState(() {
      _isComparisonMode = !_isComparisonMode;
      _isAddToArsenalMode = false; // Exit add to arsenal mode
      if (!_isComparisonMode) {
        _selectedBallIds.clear();
      }
    });
  }

  void _toggleAddToArsenalMode() {
    setState(() {
      _isAddToArsenalMode = !_isAddToArsenalMode;
      _isComparisonMode = false; // Exit comparison mode
      if (!_isAddToArsenalMode) {
        _selectedBallIds.clear();
      }
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedBallIds.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isComparisonMode = false;
      _isAddToArsenalMode = false;
      _selectedBallIds.clear();
    });
  }

  void _toggleBallSelection(int ballId) {
    setState(() {
      if (_selectedBallIds.contains(ballId)) {
        _selectedBallIds.remove(ballId);
      } else {
        if (_isComparisonMode) {
          // Limit to 2 balls for comparison
          if (_selectedBallIds.length < 2) {
            _selectedBallIds.add(ballId);
          }
        } else if (_isAddToArsenalMode) {
          // No limit for add to arsenal mode
          _selectedBallIds.add(ballId);
        }
      }
    });
  }

  Future<void> _showComparison() async {
    if (_selectedBallIds.length == 2) {
      final ballIds = _selectedBallIds.toList();
      final currentContext = context; // 保存 context 引用
      
      try {
        // 符合架構規範：通過邏輯層獲取球資料
        final (ball1, ball2) = await ref
            .read(ballLibraryControllerProvider.notifier)
            .getBallsForComparison(ballIds);
        
        if (ball1 != null && ball2 != null && mounted) {
          await showDialog<void>(
            context: currentContext,
            builder: (context) => BallComparisonDialog(
              ball1: ball1,
              ball2: ball2,
            ),
          );
          
          // Exit comparison mode after showing dialog
          _toggleComparisonMode();
        }
      } catch (e) {
        // 顯示錯誤訊息
        if (mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(
              content: Text('Failed to load balls for comparison'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/my-arsenal')) {
      return 2;
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateCurrentIndex(location);
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBarConfigs.ballLibrary(
          title: 'Ball Library',
          onBackPressed: () => context.go('/'),
          actions: [
            // Favorites 按鈕
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () => context.go('/favorites'),
              tooltip: 'My Favorites',
            ),
          ],
        ),
        body: ballLibraryAsync.when(
          data: (state) {
            
            return Column(
              children: [
                // 為AppBar留出空間 (AppBar高度 + 狀態列高度)
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 8),
                // 控制面板
                SimpleSearchControls(
                  searchHint: 'Search balls...',
                  onSearchChanged: (text) {
                    ref.read(ballLibraryControllerProvider.notifier).updateSearchText(text);
                  },
                  onFilterTap: () => _showFilterDialog(context, ref, state),
                  onSortTap: () => _showSortDialog(context, ref, state),
                  filterCount: state.filters.activeFilterCount,
                ),
                // 兩個水平按鈕或選擇模式資訊
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: (_isComparisonMode || _isAddToArsenalMode) 
                      ? _buildSelectionModeInfo()
                      : _buildActionButtons(),
                ),
                // 球列表
                Expanded(
                  child: state.filteredBalls.isEmpty
                      ? _buildEmptyState(state.hasActiveFilters)
                      : BallListView(
                          bowlingBalls: state.filteredBalls,
                          onBallTapped: (ball) => _showBallDetail(context, ball),
                          hasMoreData: state.hasMoreData,
                          isLoadingMore: state.isLoadingMore,
                          onLoadMore: () {
                            if (state.hasMoreData && !state.isLoadingMore) {
                              ref.read(ballLibraryControllerProvider.notifier).loadMore();
                            }
                          },
                          isSelectionMode: _isComparisonMode || _isAddToArsenalMode,
                          selectedBallIds: _selectedBallIds,
                          onBallSelectionToggle: _toggleBallSelection,
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading balls: $error',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(ballLibraryControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
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
            }
          },
        ),
      ),
    );
  }




  void _showFilterDialog(BuildContext context, WidgetRef ref, BallLibraryState state) {
    showFilterPopout(
      context,
      initialFilters: state.filters,
      onFiltersChanged: (newFilters) {
        ref.read(ballLibraryControllerProvider.notifier).updateFilters(newFilters);
      },
    );
  }

  void _showSortDialog(BuildContext context, WidgetRef ref, BallLibraryState state) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: BrandColors.accentColorDark,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 標題
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: BrandColors.accentColorDark.withOpacity(0.3), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sort, color: BrandColors.accentColorDark, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        color: BrandColors.textPrimaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // 排序選項
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'ID (Low-High)',
                      const SortCriterion(field: SortField.id, ascending: true),
                      Icons.keyboard_arrow_up,
                    ),
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'ID (High-Low)',
                      const SortCriterion(field: SortField.id, ascending: false),
                      Icons.keyboard_arrow_down,
                    ),
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'Name (A-Z)',
                      const SortCriterion(field: SortField.name, ascending: true),
                      Icons.sort_by_alpha,
                    ),
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'Name (Z-A)',
                      const SortCriterion(field: SortField.name, ascending: false),
                      Icons.sort_by_alpha,
                    ),
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'Brand (A-Z)',
                      const SortCriterion(field: SortField.brand, ascending: true),
                      Icons.business,
                    ),
                    _buildSortOption(
                      context,
                      ref,
                      state,
                      'Brand (Z-A)',
                      const SortCriterion(field: SortField.brand, ascending: false),
                      Icons.business,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    WidgetRef ref,
    BallLibraryState state,
    String title,
    SortCriterion criterion,
    IconData icon,
  ) {
    final isSelected = state.sortCriterion == criterion;

    return InkWell(
      onTap: () {
        ref.read(ballLibraryControllerProvider.notifier).updateSort(criterion);
        Navigator.of(context).pop();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? BrandColors.accentColorDark : BrandColors.textSecondaryDark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? BrandColors.accentColorDark : BrandColors.textPrimaryDark,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                size: 18,
                color: BrandColors.accentColorDark,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(bool hasFilters) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.filter_list_off : Icons.sports_baseball,
            color: Colors.grey,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            hasFilters 
                ? 'No balls match your filters'
                : 'No balls available',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          if (hasFilters) ...[
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadMoreFooter(BuildContext context, WidgetRef ref, BallLibraryState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: state.isLoadingMore
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () {
                ref.read(ballLibraryControllerProvider.notifier).loadMore();
              },
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[600]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Press to load more',
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${state.filteredBalls.length}/${state.totalCount})',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _showBallDetail(BuildContext context, BowlingBall ball) {
    showDialog<void>(
      context: context,
      builder: (context) => BowlingBallDetailWidget(ball: ball),
    );
  }

  /// 建構操作按鈕（正常模式）
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Ball Comparison',
            icon: Icons.compare_arrows,
            height: 36,
            fontSize: 12,
            onPressed: _toggleComparisonMode,
            customColor: Colors.white,
            isPrimary: _isComparisonMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Add to Arsenal',
            icon: Icons.add_circle_outline,
            height: 36,
            fontSize: 12,
            customColor: Colors.white,
            onPressed: _toggleAddToArsenalMode,
          ),
        ),
      ],
    );
  }

  /// 建構選擇模式資訊顯示
  Widget _buildSelectionModeInfo() {
    final selectedCount = _selectedBallIds.length;
    final modeText = _isComparisonMode ? 'Comparison' : 'Add to Arsenal';
    final hasSelection = selectedCount > 0;
    
    return Row(
      children: [
        // 選擇資訊文字
        Expanded(
          child: Text(
            '$modeText: $selectedCount ball${selectedCount != 1 ? 's' : ''} selected',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Add/Compare 標籤 (只在有選擇時顯示)
        if (hasSelection) ...[
          _buildActionTag(
            text: _isComparisonMode ? '' : 'Add', // Comparison mode shows no text, just icon
            icon: _isComparisonMode ? Icons.check : Icons.add,
            color: Colors.green,
            onTap: _isComparisonMode ? _showComparison : () {
              // TODO: Implement add functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Add $selectedCount balls to arsenal'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        // Reset/Exit 標籤
        _buildActionTag(
          text: hasSelection 
              ? (_isComparisonMode ? '' : 'Reset') // Arsenal mode shows "Reset", Comparison mode shows no text
              : 'Exit', // Exit when no selection
          icon: hasSelection 
              ? (_isComparisonMode ? Icons.close : Icons.refresh) // Arsenal mode uses refresh icon
              : Icons.close, // Exit uses close icon
          color: Colors.orange,
          onTap: hasSelection ? _resetSelection : _exitSelectionMode,
        ),
      ],
    );
  }

  /// 建構小標籤按鈕
  Widget _buildActionTag({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}