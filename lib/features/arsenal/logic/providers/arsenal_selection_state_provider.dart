import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'arsenal_selection_state_provider.freezed.dart';
part 'arsenal_selection_state_provider.g.dart';

/// Arsenal selection state containing only selection-related state
@freezed
class ArsenalSelectionState with _$ArsenalSelectionState {
  const factory ArsenalSelectionState({
    @Default(false) bool isRemoveMode,
    @Default({}) Set<int> selectedForRemoval,
    @Default(false) bool isMoveMode,
    @Default({}) Set<int> selectedForMove,
    @Default(SelectionModeType.none) SelectionModeType activeMode,
    @Default(false) bool isSelectionLocked, // Prevents accidental changes
  }) = _ArsenalSelectionState;
}

/// Selection mode types
enum SelectionModeType {
  none,
  remove,
  move,
}

/// Selection mode color for UI feedback
enum SelectionModeColor {
  none,
  remove,
  move,
}

/// Arsenal selection state provider - handles only selection-related operations
@riverpod
class ArsenalSelectionStateProvider extends _$ArsenalSelectionStateProvider {
  @override
  ArsenalSelectionState build() {
    return const ArsenalSelectionState();
  }

  // === Mode Management ===

  /// Enter remove mode
  void enterRemoveMode() {
    if (state.isSelectionLocked) return;
    
    state = state.copyWith(
      isRemoveMode: true,
      isMoveMode: false,
      activeMode: SelectionModeType.remove,
      selectedForRemoval: {},
      selectedForMove: {},
    );
  }

  /// Enter move mode
  void enterMoveMode() {
    if (state.isSelectionLocked) return;
    
    state = state.copyWith(
      isRemoveMode: false,
      isMoveMode: true,
      activeMode: SelectionModeType.move,
      selectedForRemoval: {},
      selectedForMove: {},
    );
  }

  /// Exit all selection modes
  void exitAllModes() {
    if (state.isSelectionLocked) return;
    
    state = state.copyWith(
      isRemoveMode: false,
      isMoveMode: false,
      activeMode: SelectionModeType.none,
      selectedForRemoval: {},
      selectedForMove: {},
    );
  }

  /// Toggle remove mode
  void toggleRemoveMode() {
    if (state.isSelectionLocked) return;
    
    if (state.isRemoveMode) {
      exitAllModes();
    } else {
      enterRemoveMode();
    }
  }

  /// Toggle move mode
  void toggleMoveMode() {
    if (state.isSelectionLocked) return;
    
    if (state.isMoveMode) {
      exitAllModes();
    } else {
      enterMoveMode();
    }
  }

  // === Selection Management ===

  /// Toggle instance selection for removal
  void toggleInstanceForRemoval(int instanceId) {
    if (!state.isRemoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForRemoval);
    if (updatedSelection.contains(instanceId)) {
      updatedSelection.remove(instanceId);
    } else {
      updatedSelection.add(instanceId);
    }
    
    state = state.copyWith(selectedForRemoval: updatedSelection);
  }

  /// Toggle instance selection for move
  void toggleInstanceForMove(int instanceId) {
    if (!state.isMoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForMove);
    if (updatedSelection.contains(instanceId)) {
      updatedSelection.remove(instanceId);
    } else {
      updatedSelection.add(instanceId);
    }
    
    state = state.copyWith(selectedForMove: updatedSelection);
  }

  /// Add instance to removal selection
  void addToRemovalSelection(int instanceId) {
    if (!state.isRemoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForRemoval)
      ..add(instanceId);
    state = state.copyWith(selectedForRemoval: updatedSelection);
  }

  /// Add instance to move selection
  void addToMoveSelection(int instanceId) {
    if (!state.isMoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForMove)
      ..add(instanceId);
    state = state.copyWith(selectedForMove: updatedSelection);
  }

  /// Remove instance from removal selection
  void removeFromRemovalSelection(int instanceId) {
    if (!state.isRemoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForRemoval)
      ..remove(instanceId);
    state = state.copyWith(selectedForRemoval: updatedSelection);
  }

  /// Remove instance from move selection
  void removeFromMoveSelection(int instanceId) {
    if (!state.isMoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForMove)
      ..remove(instanceId);
    state = state.copyWith(selectedForMove: updatedSelection);
  }

  /// Select multiple instances for removal
  void selectMultipleForRemoval(List<int> instanceIds) {
    if (!state.isRemoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForRemoval)
      ..addAll(instanceIds);
    state = state.copyWith(selectedForRemoval: updatedSelection);
  }

  /// Select multiple instances for move
  void selectMultipleForMove(List<int> instanceIds) {
    if (!state.isMoveMode || state.isSelectionLocked) return;
    
    final updatedSelection = Set<int>.from(state.selectedForMove)
      ..addAll(instanceIds);
    state = state.copyWith(selectedForMove: updatedSelection);
  }

  /// Clear all selections
  void clearAllSelections() {
    if (state.isSelectionLocked) return;
    
    state = state.copyWith(
      selectedForRemoval: {},
      selectedForMove: {},
    );
  }

  /// Select all available instances (for current mode)
  void selectAll(List<int> availableInstanceIds) {
    if (state.isSelectionLocked) return;
    
    if (state.isRemoveMode) {
      state = state.copyWith(selectedForRemoval: availableInstanceIds.toSet());
    } else if (state.isMoveMode) {
      state = state.copyWith(selectedForMove: availableInstanceIds.toSet());
    }
  }

  // === Lock Management ===

  /// Lock selection to prevent changes during operations
  void lockSelection() {
    state = state.copyWith(isSelectionLocked: true);
  }

  /// Unlock selection to allow changes
  void unlockSelection() {
    state = state.copyWith(isSelectionLocked: false);
  }

  // === Query Methods ===

  /// Check if instance is selected for removal
  bool isSelectedForRemoval(int instanceId) {
    return state.selectedForRemoval.contains(instanceId);
  }

  /// Check if instance is selected for move
  bool isSelectedForMove(int instanceId) {
    return state.selectedForMove.contains(instanceId);
  }

  /// Check if instance is selected in current mode
  bool isInstanceSelected(int instanceId) {
    if (state.isRemoveMode) return isSelectedForRemoval(instanceId);
    if (state.isMoveMode) return isSelectedForMove(instanceId);
    return false;
  }

  /// Check if in any selection mode
  bool get isInAnySelectionMode {
    return state.isRemoveMode || state.isMoveMode;
  }

  /// Get current selection count
  int get currentSelectionCount {
    if (state.isRemoveMode) return state.selectedForRemoval.length;
    if (state.isMoveMode) return state.selectedForMove.length;
    return 0;
  }

  /// Get current selected instances
  Set<int> get currentSelectedInstances {
    if (state.isRemoveMode) return state.selectedForRemoval;
    if (state.isMoveMode) return state.selectedForMove;
    return {};
  }

  /// Get selection mode display text
  String get selectionModeText {
    switch (state.activeMode) {
      case SelectionModeType.remove:
        final count = state.selectedForRemoval.length;
        return count > 0 ? 'Remove ($count)' : 'Remove';
      case SelectionModeType.move:
        final count = state.selectedForMove.length;
        return count > 0 ? 'Move ($count)' : 'Move';
      case SelectionModeType.none:
        return '';
    }
  }

  /// Get selection mode color
  SelectionModeColor get selectionModeColor {
    switch (state.activeMode) {
      case SelectionModeType.remove:
        return SelectionModeColor.remove;
      case SelectionModeType.move:
        return SelectionModeColor.move;
      case SelectionModeType.none:
        return SelectionModeColor.none;
    }
  }

  /// Check if can perform current selection action
  bool get canPerformAction {
    return currentSelectionCount > 0 && !state.isSelectionLocked;
  }

  /// Validate selection for operation
  bool validateSelection({
    int? minSelection,
    int? maxSelection,
  }) {
    final count = currentSelectionCount;
    
    if (count == 0) return false;
    
    if (minSelection != null && count < minSelection) return false;
    if (maxSelection != null && count > maxSelection) return false;
    
    return true;
  }

  /// Get validation error message
  String? getValidationError({
    int? minSelection,
    int? maxSelection,
  }) {
    final count = currentSelectionCount;
    
    if (count == 0) {
      return 'No items selected for ${state.activeMode.name}';
    }
    
    if (minSelection != null && count < minSelection) {
      return 'Minimum $minSelection item${minSelection != 1 ? 's' : ''} required';
    }
    
    if (maxSelection != null && count > maxSelection) {
      return 'Maximum $maxSelection item${maxSelection != 1 ? 's' : ''} allowed';
    }
    
    return null;
  }
}