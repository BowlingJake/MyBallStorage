import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'arsenal_selection_state_provider.freezed.dart';
part 'arsenal_selection_state_provider.g.dart';

/// Arsenal selection state containing only selection-related state
@freezed
class ArsenalSelectionState with _$ArsenalSelectionState {
  const factory ArsenalSelectionState({
    @Default(SelectionModeType.none) SelectionModeType selectionMode,
    @Default({}) Set<int> selectedInstanceIds,
    @Default(false) bool isSelectionLocked, // Prevents accidental changes
  }) = _ArsenalSelectionState;

  const ArsenalSelectionState._();

  /// Check if in selection mode
  bool get isInSelectionMode {
    return selectionMode != SelectionModeType.none;
  }

  /// Get current selection count
  int get selectedCount {
    return selectedInstanceIds.length;
  }

  /// Check if can perform actions
  bool get canPerformActions {
    return selectedCount > 0 && !isSelectionLocked;
  }
}

/// Selection mode types
enum SelectionModeType {
  none,
  selection, // Generic selection mode like Library
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

  /// Toggle selection mode
  void toggleSelectionMode() {
    if (state.isSelectionLocked) return;

    if (state.isInSelectionMode) {
      exitSelectionMode();
    } else {
      enterSelectionMode();
    }
  }

  /// Enter selection mode
  void enterSelectionMode() {
    if (state.isSelectionLocked) return;

    state = state.copyWith(
      selectionMode: SelectionModeType.selection,
      selectedInstanceIds: {},
    );
  }

  /// Exit selection mode
  void exitSelectionMode() {
    if (state.isSelectionLocked) return;

    state = state.copyWith(
      selectionMode: SelectionModeType.none,
      selectedInstanceIds: {},
    );
  }

  // === Selection Management ===

  /// Toggle instance selection
  void toggleInstanceSelection(int instanceId) {
    if (!state.isInSelectionMode || state.isSelectionLocked) return;

    final updatedSelection = Set<int>.from(state.selectedInstanceIds);
    if (updatedSelection.contains(instanceId)) {
      updatedSelection.remove(instanceId);
    } else {
      updatedSelection.add(instanceId);
    }

    state = state.copyWith(selectedInstanceIds: updatedSelection);
  }

  /// Clear all selections
  void clearAllSelections() {
    if (state.isSelectionLocked) return;

    state = state.copyWith(selectedInstanceIds: {});
  }

  /// Select all available instances
  void selectAll(List<int> availableInstanceIds) {
    if (!state.isInSelectionMode || state.isSelectionLocked) return;

    state = state.copyWith(selectedInstanceIds: availableInstanceIds.toSet());
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

  /// Check if instance is selected
  bool isInstanceSelected(int instanceId) {
    return state.selectedInstanceIds.contains(instanceId);
  }

  /// Get selected instances
  Set<int> get selectedInstances => state.selectedInstanceIds;

}