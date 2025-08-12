import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';

part 'arsenal_selection_service.g.dart';

/// Service for handling selection mode operations
@riverpod
class ArsenalSelectionService extends _$ArsenalSelectionService {
  @override
  void build() {
    // This service doesn't need to maintain state
  }

  /// Toggle move mode
  void toggleMoveMode() {
    ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
  }

  /// Toggle remove mode
  void toggleRemoveMode() {
    ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
  }

  /// Exit current selection mode (move or remove)
  void exitSelectionMode(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      toggleMoveMode();
    } else if (arsenalState.isRemoveMode) {
      toggleRemoveMode();
    }
  }

  /// Check if currently in any selection mode
  bool isInSelectionMode(NewArsenalState arsenalState) {
    return arsenalState.isMoveMode || arsenalState.isRemoveMode;
  }

  /// Get current selection count
  int getSelectionCount(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      return arsenalState.selectedForMove.length;
    } else if (arsenalState.isRemoveMode) {
      return arsenalState.selectedForRemoval.length;
    }
    return 0;
  }

  /// Get selection mode display text
  String getSelectionModeText(NewArsenalState arsenalState) {
    final count = getSelectionCount(arsenalState);
    if (arsenalState.isMoveMode) {
      return 'Confirm Move ($count)';
    } else if (arsenalState.isRemoveMode) {
      return 'Confirm Remove ($count)';
    }
    return '';
  }

  /// Get selection mode color
  SelectionModeColor getSelectionModeColor(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      return SelectionModeColor.move;
    } else if (arsenalState.isRemoveMode) {
      return SelectionModeColor.remove;
    }
    return SelectionModeColor.none;
  }

  /// Toggle instance selection for move mode
  void toggleInstanceForMove(int instanceId) {
    ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(instanceId);
  }

  /// Toggle instance selection for removal mode
  void toggleInstanceForRemoval(int instanceId) {
    ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instanceId);
  }

  /// Clear all selections in current mode
  void clearSelections(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      // Clear move selections by toggling each selected item
      for (final instanceId in arsenalState.selectedForMove.toList()) {
        toggleInstanceForMove(instanceId);
      }
    } else if (arsenalState.isRemoveMode) {
      // Clear removal selections by toggling each selected item
      for (final instanceId in arsenalState.selectedForRemoval.toList()) {
        toggleInstanceForRemoval(instanceId);
      }
    }
  }

  /// Check if instance is selected in current mode
  bool isInstanceSelected(NewArsenalState arsenalState, int instanceId) {
    if (arsenalState.isMoveMode) {
      return arsenalState.selectedForMove.contains(instanceId);
    } else if (arsenalState.isRemoveMode) {
      return arsenalState.selectedForRemoval.contains(instanceId);
    }
    return false;
  }

  /// Get selected instances for current mode
  Set<int> getSelectedInstances(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      return arsenalState.selectedForMove;
    } else if (arsenalState.isRemoveMode) {
      return arsenalState.selectedForRemoval;
    }
    return {};
  }
}

// Note: SelectionModeColor enum is now defined in arsenal_selection_state_provider.dart