import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_ui_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// Optimized Virtualized Ball List Widget
/// 
/// Features:
/// - Efficient memory usage with ListView.builder
/// - Optimized item building with itemExtent
/// - Smart scroll performance optimization
/// - Memory-efficient caching strategy
class VirtualizedBallList extends ConsumerStatefulWidget {
  const VirtualizedBallList({super.key});

  @override
  ConsumerState<VirtualizedBallList> createState() => _VirtualizedBallListState();
}

class _VirtualizedBallListState extends ConsumerState<VirtualizedBallList> {
  late ScrollController _scrollController;
  
  // Performance optimization: Cache for frequently accessed items
  final Map<int, Widget> _itemCache = <int, Widget>{};
  
  // Track current state for cache invalidation
  BallLibraryState? _previousState;
  
  // Estimated item height for better performance  
  static const double _estimatedItemHeight = 180.0;
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _itemCache.clear();
    super.dispose();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Auto-load more when reaching 80% of the scroll
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent * 0.8) {
        final currentState = ref.read(ballLibraryControllerProvider);
        if (currentState.hasValue) {
          final state = currentState.value!;
          if (state.hasMoreData && !state.isLoadingMore) {
            ref.read(ballLibraryControllerProvider.notifier).loadMore();
          }
        }
      }
      
      // Clear cache when scrolling far to save memory
      if (_itemCache.length > 50) {
        _clearDistantCacheItems();
      }
    });
  }

  void _clearDistantCacheItems() {
    final currentState = ref.read(ballLibraryControllerProvider);
    if (!currentState.hasValue) return;
    
    final state = currentState.value!;
    
    // Calculate visible range based on scroll position
    final viewportStart = _scrollController.position.pixels;
    final viewportEnd = viewportStart + _scrollController.position.viewportDimension;
    
    final visibleStartIndex = (viewportStart / _estimatedItemHeight).floor();
    final visibleEndIndex = (viewportEnd / _estimatedItemHeight).ceil();
    
    // Keep cache for visible items + buffer
    const bufferSize = 20;
    final keepStartIndex = (visibleStartIndex - bufferSize).clamp(0, state.filteredBalls.length);
    final keepEndIndex = (visibleEndIndex + bufferSize).clamp(0, state.filteredBalls.length);
    
    // Remove items outside the keep range
    _itemCache.removeWhere((index, _) => 
        index < keepStartIndex || index > keepEndIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);
    
    return ballLibraryAsync.when(
      data: (state) {
        // Clear cache if state has changed (filters, sorting, etc.)
        if (_previousState != null && _shouldClearCache(state, _previousState!)) {
          _itemCache.clear();
          // Auto scroll to top after filter/sort operations
          _scrollToTop();
        }
        _previousState = state;
        
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
            physics: const BouncingScrollPhysics(), // Better performance than default
          ),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            itemCount: state.filteredBalls.length + (state.hasMoreData ? 1 : 0),
            itemExtent: _estimatedItemHeight, // Critical for performance
            cacheExtent: _estimatedItemHeight * 20, // Cache 20 items ahead/behind
            addAutomaticKeepAlives: false, // Disable keep alive for better memory
            addRepaintBoundaries: true, // Enable repaint boundaries for smooth scrolling
            itemBuilder: (context, index) => _buildOptimizedItem(context, index, state),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              'Error loading balls: $error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppStandardButton(
              text: 'Retry',
              onPressed: () => ref.invalidate(ballLibraryControllerProvider),
            ),
          ],
        ),
      ),
    );
  }

  /// Check if cache should be cleared due to state changes
  bool _shouldClearCache(BallLibraryState current, BallLibraryState previous) {
    return current.searchText != previous.searchText ||
           current.filters != previous.filters ||
           current.sortCriterion != previous.sortCriterion;
  }

  /// Scroll to top smoothly after filter/sort operations
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildOptimizedItem(BuildContext context, int index, BallLibraryState state) {
    // Load more indicator
    if (index >= state.filteredBalls.length) {
      return _buildLoadMoreFooter(state);
    }

    // In selection mode, avoid cache to reflect real-time UI changes (overlay/checkmark)
    final uiState = ref.watch(ballLibraryUIServiceProvider);
    final isInSelectionMode = uiState.selectionMode != BallLibrarySelectionMode.none;
    if (!isInSelectionMode) {
      // Check cache first for performance when not in selection mode
      if (_itemCache.containsKey(index)) {
        return _itemCache[index]!;
      }
    }

    // Build new item
    final ball = state.filteredBalls[index];
    final ballWidget = _buildBallItem(ball);
    
    // Cache the widget for reuse only when not in selection mode
    if (!isInSelectionMode) {
      _itemCache[index] = ballWidget;
    }
    
    return ballWidget;
  }

  Widget _buildBallItem(BowlingBall ball) {
    final uiServiceNotifier = ref.read(ballLibraryUIServiceProvider.notifier);
    final uiState = ref.watch(ballLibraryUIServiceProvider);
    final isSelected = uiState.selectedBallIds.contains(ball.id);
    final isInSelectionMode = uiState.selectionMode != BallLibrarySelectionMode.none;
    
    return RepaintBoundary( // Optimize repainting
      child: BallCardItem(
        ball: ball,
        theme: Theme.of(context),
        onTap: () => uiServiceNotifier.handleBallTap(
          context: context,
          ball: ball,
        ),
        isSelectionMode: isInSelectionMode,
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildLoadMoreFooter(BallLibraryState state) {
    return Container(
      height: _estimatedItemHeight,
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
                  'Loading more balls...',
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
                        'Load more balls',
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
}

/// Performance Statistics Widget for debugging
class VirtualizedBallListDebugInfo extends ConsumerWidget {
  final VirtualizedBallList ballList;
  
  const VirtualizedBallListDebugInfo({
    super.key,
    required this.ballList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);
    final totalItems = ballLibraryAsync.hasValue ? ballLibraryAsync.value!.filteredBalls.length : 0;
    final hasMore = ballLibraryAsync.hasValue ? ballLibraryAsync.value!.hasMoreData : false;
    final isLoadingMore = ballLibraryAsync.hasValue ? ballLibraryAsync.value!.isLoadingMore : false;
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Performance Debug Info',
            style: TextStyle(
              color: Colors.yellow[300],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Total Items: $totalItems',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Has More: $hasMore',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Loading: $isLoadingMore',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}