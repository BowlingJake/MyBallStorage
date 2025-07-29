import 'package:bowlingarsenal_app/features/arsenal/widgets/ball_list_view.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/filter_popout.dart';
import 'package:bowlingarsenal_app/features/ball_library/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BallLibraryPage extends ConsumerWidget {
  const BallLibraryPage({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateCurrentIndex(location);
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Ball Library',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: ballLibraryAsync.when(
          data: (state) => Column(
            children: [
              const SizedBox(height: 100),
              // 新的簡化控制面板將在下一步添加
              _buildSimplifiedControls(context, ref, state),
              const SizedBox(height: 16),
              // 球列表
              Expanded(
                child: state.filteredBalls.isEmpty
                    ? _buildEmptyState(state.hasActiveFilters)
                    : BallListView(
                        bowlingBalls: state.filteredBalls,
                        onBallTapped: (ball) => _showBallDetail(context, ball),
                      ),
              ),
            ],
          ),
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

  Widget _buildSimplifiedControls(BuildContext context, WidgetRef ref, BallLibraryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // 搜尋框 - 線框未填滿
          TextField(
            onChanged: (text) =>
                ref.read(ballLibraryControllerProvider.notifier).updateSearchText(text),
            decoration: InputDecoration(
              hintText: 'Search balls...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          // 篩選和排序按鈕
          Row(
            children: [
              Expanded(
                child: _buildAppStandardButton(
                  text: state.filters.activeFilterCount > 0 
                      ? 'Filter (${state.filters.activeFilterCount})' 
                      : 'Filter',
                  icon: Icons.filter_list,
                  onPressed: () => _showFilterDialog(context, ref, state),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildAppStandardButton(
                  text: 'Sort',
                  icon: Icons.sort,
                  onPressed: () => _showSortDialog(context, ref, state),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppStandardButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
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
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return _SortDialog(
          currentSort: state.sortCriterion,
          onSortChanged: (SortCriterion newSort) {
            ref.read(ballLibraryControllerProvider.notifier).updateSort(newSort);
            Navigator.of(context).pop();
          },
        );
      },
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

  void _showBallDetail(BuildContext context, BowlingBall ball) {
    if (kDebugMode) {
      print('Tapped on ball: ${ball.name}');
    }
    
    showDialog<void>(
      context: context,
      builder: (context) => BowlingBallDetailWidget(ball: ball),
    );
  }
}

class _SortDialog extends StatelessWidget {
  const _SortDialog({
    required this.currentSort,
    required this.onSortChanged,
  });

  final SortCriterion currentSort;
  final void Function(SortCriterion) onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[900]?.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildSortOption('Name', SortField.name),
            _buildSortOption('Brand', SortField.brand),
            _buildSortOption('Release Year', SortField.releaseYear),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAppStandardButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    isPrimary: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAppStandardButton(
                    text: 'Apply',
                    onPressed: () => Navigator.of(context).pop(),
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, SortField field) {
    final isSelected = currentSort.field == field;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (isSelected) {
                  // Toggle ascending/descending if same field
                  onSortChanged(currentSort.copyWith(ascending: !currentSort.ascending));
                } else {
                  // Select new field with ascending order
                  onSortChanged(SortCriterion(field: field));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[600]!,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isSelected ? Colors.blue : Colors.white,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(
                        currentSort.ascending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.blue,
                        size: 18,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppStandardButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.blue : Colors.grey[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(text),
    );
  }
}