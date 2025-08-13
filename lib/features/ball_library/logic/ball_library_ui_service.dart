import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/features/comparison/presentation/widgets/ball_comparison_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/filters/filter_popout.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/bag_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up;
import 'package:core_theme/core_theme.dart';

part 'ball_library_ui_service.g.dart';

/// Selection mode types for Ball Library
enum BallLibrarySelectionMode {
  none,
  comparison,
  addToArsenal,
}

/// Ball Library UI Service - unified management for all UI operations
@riverpod
class BallLibraryUIService extends _$BallLibraryUIService {
  @override
  BallLibraryUIState build() {
    return const BallLibraryUIState();
  }

  // === Selection Mode Management ===

  /// Toggle comparison mode
  void toggleComparisonMode() {
    final currentMode = state.selectionMode;
    if (currentMode == BallLibrarySelectionMode.comparison) {
      exitSelectionMode();
    } else {
      state = state.copyWith(
        selectionMode: BallLibrarySelectionMode.comparison,
        selectedBallIds: {},
      );
    }
  }

  /// Toggle add to arsenal mode
  void toggleAddToArsenalMode() {
    final currentMode = state.selectionMode;
    if (currentMode == BallLibrarySelectionMode.addToArsenal) {
      exitSelectionMode();
    } else {
      state = state.copyWith(
        selectionMode: BallLibrarySelectionMode.addToArsenal,
        selectedBallIds: {},
      );
    }
  }

  /// Exit selection mode
  void exitSelectionMode() {
    state = state.copyWith(
      selectionMode: BallLibrarySelectionMode.none,
      selectedBallIds: {},
    );
  }

  /// Reset current selection
  void resetSelection() {
    state = state.copyWith(selectedBallIds: {});
  }

  /// Toggle ball selection
  void toggleBallSelection(int ballId) {
    final currentSelection = Set<int>.from(state.selectedBallIds);
    final isCurrentlySelected = currentSelection.contains(ballId);

    if (isCurrentlySelected) {
      currentSelection.remove(ballId);
    } else {
      switch (state.selectionMode) {
        case BallLibrarySelectionMode.comparison:
          // Limit to 2 balls for comparison
          if (currentSelection.length < 2) {
            currentSelection.add(ballId);
          }
          break;
        case BallLibrarySelectionMode.addToArsenal:
          // No limit for add to arsenal mode
          currentSelection.add(ballId);
          break;
        case BallLibrarySelectionMode.none:
          // Should not happen, but handle gracefully
          break;
      }
    }

    state = state.copyWith(selectedBallIds: currentSelection);
  }

  // === Dialog Management ===

  /// Show ball detail dialog
  void showBallDetail({
    required BuildContext context,
    required BowlingBall ball,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => BowlingBallDetailWidget(ball: ball),
    );
  }

  /// Show comparison dialog
  Future<void> showComparison({
    required BuildContext context,
  }) async {
    if (state.selectedBallIds.length != 2) {
      TopNotification.showError(
        context,
        'Please select exactly 2 balls for comparison',
      );
      return;
    }

    try {
      final ballIds = state.selectedBallIds.toList();
      final (ball1, ball2) = await ref
          .read(ballLibraryControllerProvider.notifier)
          .getBallsForComparison(ballIds);

      if (ball1 != null && ball2 != null) {
        await showDialog<void>(
          context: context,
          builder: (context) => BallComparisonDialog(
            ball1: ball1,
            ball2: ball2,
          ),
        );
        
        // Exit comparison mode after showing dialog
        exitSelectionMode();
      }
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to load balls for comparison',
      );
    }
  }

  /// Show filter dialog
  void showFilterDialog({
    required BuildContext context,
    required BallLibraryState libraryState,
  }) {
    showFilterPopout(
      context,
      initialFilters: libraryState.filters,
      onFiltersChanged: (newFilters) {
        ref.read(ballLibraryControllerProvider.notifier).updateFilters(newFilters);
      },
    );
  }

  /// Show sort dialog
  void showSortDialog({
    required BuildContext context,
    required BallLibraryState libraryState,
  }) {
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
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: BrandColors.accentColorDark.withOpacity(0.3),
                      width: 1,
                    ),
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
              // Sort options
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _buildSortOption(
                      context,
                      libraryState,
                      'ID (Low-High)',
                      const SortCriterion(field: SortField.id, ascending: true),
                      Icons.keyboard_arrow_up,
                    ),
                    _buildSortOption(
                      context,
                      libraryState,
                      'ID (High-Low)',
                      const SortCriterion(field: SortField.id, ascending: false),
                      Icons.keyboard_arrow_down,
                    ),
                    _buildSortOption(
                      context,
                      libraryState,
                      'Name (A-Z)',
                      const SortCriterion(field: SortField.name, ascending: true),
                      Icons.sort_by_alpha,
                    ),
                    _buildSortOption(
                      context,
                      libraryState,
                      'Name (Z-A)',
                      const SortCriterion(field: SortField.name, ascending: false),
                      Icons.sort_by_alpha,
                    ),
                    _buildSortOption(
                      context,
                      libraryState,
                      'Brand (A-Z)',
                      const SortCriterion(field: SortField.brand, ascending: true),
                      Icons.business,
                    ),
                    _buildSortOption(
                      context,
                      libraryState,
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
    BallLibraryState libraryState,
    String title,
    SortCriterion criterion,
    IconData icon,
  ) {
    final isSelected = libraryState.sortCriterion == criterion;

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
              color: isSelected 
                  ? BrandColors.accentColorDark 
                  : BrandColors.textSecondaryDark,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected 
                      ? BrandColors.accentColorDark 
                      : BrandColors.textPrimaryDark,
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

  /// Show bag selection dialog for add to arsenal
  Future<void> showAddToArsenalConfirmation({
    required BuildContext context,
  }) async {
    if (state.selectedBallIds.isEmpty) {
      TopNotification.showError(
        context,
        'Please select at least one ball to add',
      );
      return;
    }

    final selectedBagNumbers = await _showBagSelectionDialog(context);
    if (selectedBagNumbers != null && selectedBagNumbers.isNotEmpty) {
      await _addSelectedBallsToArsenal(context, selectedBagNumbers);
    }
  }

  /// Internal method to show bag selection dialog
  Future<List<int>?> _showBagSelectionDialog(BuildContext context) async {
    // Ensure user is authenticated
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      TopNotification.showError(context, 'Please log in to add balls to arsenal');
      return null;
    }
    final userId = authState.value!.id;

    // Fetch profile via repository
    final repo = ref.read(userProfileRepositoryProvider);
    final up.UserProfile? maybeProfile = await repo.getUserProfile(userId);
    final up.UserProfile profile = maybeProfile ?? await repo.saveUserProfile(
      up.UserProfile(
        userId: userId,
        bag1Name: 'All My Arsenal',
        bag1Unlocked: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    return showBagSelectionDialog(
      context: context,
      profile: profile,
      title: 'Add to Arsenal',
      subtitle: '${state.selectedBallIds.length} selected',
    );
  }

  /// Internal method to add selected balls to arsenal
  Future<void> _addSelectedBallsToArsenal(
    BuildContext context, 
    List<int> selectedBagNumbers,
  ) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(
          context,
          'Please log in to add balls to arsenal',
        );
        return;
      }
      final userId = authState.value!.id;

      // Initialize arsenal and get categories
      await ref.read(newArsenalControllerProvider.notifier).initialize(userId);
      final arsenalState = ref.read(newArsenalControllerProvider);
      
      // Use "My Balls" as default category
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      final ballLibraryState = ref.read(ballLibraryControllerProvider);
      if (!ballLibraryState.hasValue) return;

      final selectedBalls = ballLibraryState.value!.filteredBalls
          .where((ball) => state.selectedBallIds.contains(ball.id))
          .toList();
      
      // Add each selected ball to arsenal
      for (final ball in selectedBalls) {
        try {
          await ref.read(newArsenalControllerProvider.notifier)
              .addBallFromLibraryToMultipleBags(
                userId: userId,
                ballId: ball.id,
                categoryName: categoryName,
                bagNumbers: selectedBagNumbers,
              );
        } catch (e) {
          // Continue adding others even if one fails
        }
      }
      
      final selectedCount = selectedBalls.length;
      TopNotification.showSuccess(
        context,
        'Successfully added $selectedCount ball${selectedCount != 1 ? 's' : ''} to arsenal!',
      );

      // Exit selection mode after successful addition
      exitSelectionMode();
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add balls to arsenal: $e',
      );
    }
  }

  // === Utility Methods ===

  /// Get selection mode display text
  String getSelectionModeText() {
    switch (state.selectionMode) {
      case BallLibrarySelectionMode.comparison:
        return 'Comparison';
      case BallLibrarySelectionMode.addToArsenal:
        return 'Add to Arsenal';
      case BallLibrarySelectionMode.none:
        return '';
    }
  }

  /// Check if in selection mode
  bool get isInSelectionMode => state.selectionMode != BallLibrarySelectionMode.none;

  /// Check if comparison mode
  bool get isComparisonMode => state.selectionMode == BallLibrarySelectionMode.comparison;

  /// Check if add to arsenal mode
  bool get isAddToArsenalMode => state.selectionMode == BallLibrarySelectionMode.addToArsenal;

  /// Get selected count
  int get selectedCount => state.selectedBallIds.length;

  /// Check if ball is selected
  bool isBallSelected(int ballId) => state.selectedBallIds.contains(ballId);

  /// Check if can perform comparison
  bool get canCompare => isComparisonMode && selectedCount == 2;

  /// Check if can add to arsenal
  bool get canAddToArsenal => isAddToArsenalMode && selectedCount > 0;

  /// Get selection mode title for app bar
  String getAppBarTitle() {
    if (isInSelectionMode) {
      return '${getSelectionModeText()}: $selectedCount selected';
    }
    return 'Ball Library';
  }

  /// Handle ball tap based on current mode
  void handleBallTap({
    required BuildContext context,
    required BowlingBall ball,
  }) {
    if (isInSelectionMode) {
      toggleBallSelection(ball.id);
    } else {
      showBallDetail(context: context, ball: ball);
    }
  }
}

/// Ball Library UI State
class BallLibraryUIState {
  final BallLibrarySelectionMode selectionMode;
  final Set<int> selectedBallIds;

  const BallLibraryUIState({
    this.selectionMode = BallLibrarySelectionMode.none,
    this.selectedBallIds = const {},
  });

  BallLibraryUIState copyWith({
    BallLibrarySelectionMode? selectionMode,
    Set<int>? selectedBallIds,
  }) {
    return BallLibraryUIState(
      selectionMode: selectionMode ?? this.selectionMode,
      selectedBallIds: selectedBallIds ?? this.selectedBallIds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BallLibraryUIState &&
        other.selectionMode == selectionMode &&
        other.selectedBallIds.length == selectedBallIds.length &&
        other.selectedBallIds.containsAll(selectedBallIds);
  }

  @override
  int get hashCode => Object.hash(selectionMode, selectedBallIds);
}