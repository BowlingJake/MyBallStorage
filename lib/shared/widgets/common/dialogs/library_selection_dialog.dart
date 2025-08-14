import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/filters/filter_popout.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:core_theme/core_theme.dart';

/// Library Selection Dialog for adding balls to Arsenal
/// 
/// This dialog reuses the Ball Library functionality but displays it in a modal
/// for better UX when adding balls to Arsenal from the Arsenal page.
class LibrarySelectionDialog extends ConsumerStatefulWidget {
  const LibrarySelectionDialog({super.key});

  @override
  ConsumerState<LibrarySelectionDialog> createState() => _LibrarySelectionDialogState();
}

class _LibrarySelectionDialogState extends ConsumerState<LibrarySelectionDialog> {
  Set<int> _selectedBallIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleBallSelection(int ballId) {
    setState(() {
      if (_selectedBallIds.contains(ballId)) {
        _selectedBallIds.remove(ballId);
      } else {
        _selectedBallIds.add(ballId);
      }
    });
  }

  void _resetSelection() {
    setState(() {
      _selectedBallIds.clear();
    });
  }

  void _addSelectedBalls() {
    // Return selected ball IDs to the caller
    Navigator.of(context).pop(_selectedBallIds.toList());
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

  @override
  Widget build(BuildContext context) {
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Header with title and close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[600]!.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Add from Ball Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content area
            Expanded(
              child: ballLibraryAsync.when(
                data: (state) => Column(
                  children: [
                    // Search and control bar
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Search bar
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40, // 減小高度讓搜尋框看起來更細
                                  child: TextField(
                                    controller: _searchController,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.search,
                                    autocorrect: false,
                                    enableSuggestions: true,
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                    decoration: const InputDecoration(
                                      hintText: 'Search balls...',
                                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                      prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                                      border: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.black,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 0, // 最小化垂直內距
                                      ),
                                      isDense: true, // 使TextField更緊湊
                                    ),
                                    onChanged: (text) {
                                      ref
                                          .read(ballLibraryControllerProvider.notifier)
                                          .updateSearchText(text);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Filter button
                              Container(
                                height: 40, // 與搜尋欄一致的高度
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: state.filters.activeFilterCount > 0
                                        ? BrandColors.accentColorDark
                                        : Colors.grey[600]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => _showFilterDialog(context, ref, state),
                                  icon: Stack(
                                    children: [
                                      const Icon(Icons.filter_list, color: Colors.white),
                                      if (state.filters.activeFilterCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: BrandColors.accentColorDark,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Sort button
                              Container(
                                height: 40, // 與搜尋欄一致的高度
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey[600]!,
                                    width: 1.5,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => _showSortDialog(context, ref, state),
                                  icon: const Icon(Icons.sort, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Selection info
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Selected: ${_selectedBallIds.length} ball${_selectedBallIds.length != 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Clear 從這裡移除，改為底部 Reset 按鈕
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Ball list
                    Expanded(
                      child: state.filteredBalls.isEmpty
                          ? _buildEmptyState(state.hasActiveFilters)
                          : _buildBallList(state),
                    ),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
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
            ),

            // Bottom action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[600]!.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppStandardButton(
                      text: _selectedBallIds.isEmpty ? 'Cancel' : 'Reset',
                      fontSize: 14,
                      outlineColor: Colors.white.withOpacity(0.6),
                      foregroundColor: Colors.white.withOpacity(0.9),
                      onPressed: () {
                        if (_selectedBallIds.isEmpty) {
                          Navigator.of(context).pop();
                        } else {
                          _resetSelection();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: 'Add ${_selectedBallIds.length} Ball${_selectedBallIds.length != 1 ? 's' : ''}',
                      fontSize: 14,
                      outlineColor: Colors.white.withOpacity(0.6),
                      foregroundColor: Colors.white.withOpacity(0.9),
                      onPressed: _selectedBallIds.isEmpty ? () {} : _addSelectedBalls,
                    ),
                  ),
                ],
              ),
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

  Widget _buildBallList(BallLibraryState state) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.filteredBalls.length,
        itemBuilder: (context, index) {
          final ball = state.filteredBalls[index];
          final isSelected = _selectedBallIds.contains(ball.id);
          
          return BallCardItem(
            ball: ball,
            theme: Theme.of(context),
            onTap: () => _toggleBallSelection(ball.id),
            isSelectionMode: true,
            isSelected: isSelected,
          );
        },
      ),
    );
  }
}

/// Helper function to show the library selection dialog
Future<List<int>?> showLibrarySelectionDialog(BuildContext context) {
  return showDialog<List<int>>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (BuildContext context) {
      return const LibrarySelectionDialog();
    },
  );
}