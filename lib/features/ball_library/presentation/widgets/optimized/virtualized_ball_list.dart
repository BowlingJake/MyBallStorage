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
  final BallLibraryState state;
  
  const VirtualizedBallList({
    super.key,
    required this.state,
  });

  @override
  ConsumerState<VirtualizedBallList> createState() => _VirtualizedBallListState();
}

class _VirtualizedBallListState extends ConsumerState<VirtualizedBallList> {
  late ScrollController _scrollController;
  
  // Performance optimization: Cache for frequently accessed items
  final Map<int, Widget> _itemCache = <int, Widget>{};
  
  // Estimated item height for better performance
  static const double _estimatedItemHeight = 200.0;
  
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
        if (widget.state.hasMoreData && !widget.state.isLoadingMore) {
          ref.read(ballLibraryControllerProvider.notifier).loadMore();
        }
      }
      
      // Clear cache when scrolling far to save memory
      if (_itemCache.length > 50) {
        _clearDistantCacheItems();
      }
    });
  }

  void _clearDistantCacheItems() {
    // Calculate visible range based on scroll position
    final viewportStart = _scrollController.position.pixels;
    final viewportEnd = viewportStart + _scrollController.position.viewportDimension;
    
    final visibleStartIndex = (viewportStart / _estimatedItemHeight).floor();
    final visibleEndIndex = (viewportEnd / _estimatedItemHeight).ceil();
    
    // Keep cache for visible items + buffer
    const bufferSize = 20;
    final keepStartIndex = (visibleStartIndex - bufferSize).clamp(0, widget.state.filteredBalls.length);
    final keepEndIndex = (visibleEndIndex + bufferSize).clamp(0, widget.state.filteredBalls.length);
    
    // Remove items outside the keep range
    _itemCache.removeWhere((index, _) => 
        index < keepStartIndex || index > keepEndIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: false,
        physics: const BouncingScrollPhysics(), // Better performance than default
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: widget.state.filteredBalls.length + (widget.state.hasMoreData ? 1 : 0),
        itemExtent: _estimatedItemHeight, // Critical for performance
        cacheExtent: _estimatedItemHeight * 20, // Cache 20 items ahead/behind
        addAutomaticKeepAlives: false, // Disable keep alive for better memory
        addRepaintBoundaries: true, // Enable repaint boundaries for smooth scrolling
        itemBuilder: (context, index) => _buildOptimizedItem(context, index),
      ),
    );
  }

  Widget _buildOptimizedItem(BuildContext context, int index) {
    // Load more indicator
    if (index >= widget.state.filteredBalls.length) {
      return _buildLoadMoreFooter();
    }

    // Check cache first for performance
    if (_itemCache.containsKey(index)) {
      return _itemCache[index]!;
    }

    // Build new item
    final ball = widget.state.filteredBalls[index];
    final ballWidget = _buildBallItem(ball);
    
    // Cache the widget for reuse
    _itemCache[index] = ballWidget;
    
    return ballWidget;
  }

  Widget _buildBallItem(BowlingBall ball) {
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);
    final isSelected = uiService.isBallSelected(ball.id);
    
    return RepaintBoundary( // Optimize repainting
      child: BallCardItem(
        ball: ball,
        theme: Theme.of(context),
        onTap: () => uiService.handleBallTap(
          context: context,
          ball: ball,
        ),
        isSelectionMode: uiService.isInSelectionMode,
        isSelected: isSelected,
      ),
    );
  }

  Widget _buildLoadMoreFooter() {
    return Container(
      height: _estimatedItemHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: widget.state.isLoadingMore
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
                        '(${widget.state.filteredBalls.length}/${widget.state.totalCount})',
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
            'Total Items: ${ballList.state.filteredBalls.length}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Has More: ${ballList.state.hasMoreData}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Loading: ${ballList.state.isLoadingMore}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}