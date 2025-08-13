import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_ui_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// Ball Library Content Widget
/// Handles the main content display including ball list and empty states
class BallLibraryContent extends ConsumerWidget {
  const BallLibraryContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);

    return ballLibraryAsync.when(
      data: (state) => state.filteredBalls.isEmpty
          ? _buildEmptyState(state.hasActiveFilters)
          : _buildBallList(context, ref, state),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => _buildErrorState(context, ref, error),
    );
  }

  /// Build empty state when no balls found
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

  /// Build error state
  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    return Center(
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
    );
  }

  /// Build ball list
  Widget _buildBallList(BuildContext context, WidgetRef ref, BallLibraryState state) {
    final uiState = ref.watch(ballLibraryUIServiceProvider);
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.filteredBalls.length + (state.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.filteredBalls.length) {
            // Load more indicator
            return _buildLoadMoreFooter(context, ref, state);
          }
          
          final ball = state.filteredBalls[index];
          final isSelected = uiService.isBallSelected(ball.id);
          
          return BallCardItem(
            ball: ball,
            theme: Theme.of(context),
            onTap: () => uiService.handleBallTap(
              context: context,
              ball: ball,
            ),
            isSelectionMode: uiService.isInSelectionMode,
            isSelected: isSelected,
          );
        },
      ),
    );
  }

  /// Build load more footer
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
}