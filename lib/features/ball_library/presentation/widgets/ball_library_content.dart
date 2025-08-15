import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/optimized/virtualized_ball_list.dart';

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
          AppStandardButton(
            text: 'Retry',
            onPressed: () => ref.invalidate(ballLibraryControllerProvider),
          ),
        ],
      ),
    );
  }

  /// Build optimized ball list with virtualization
  Widget _buildBallList(BuildContext context, WidgetRef ref, BallLibraryState state) {
    return const VirtualizedBallList();
  }

}