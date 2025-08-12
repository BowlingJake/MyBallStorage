import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_bag_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_error_handling_mixin.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_notification_mixin.dart';

/// Mixin for common Arsenal state operations
mixin ArsenalStateMixin on ConsumerWidget 
    implements ArsenalErrorHandlingMixin, ArsenalNotificationMixin {
  
  // === State Getters ===
  
  /// Get current arsenal state
  NewArsenalState getArsenalState(WidgetRef ref) {
    return ref.watch(newArsenalControllerProvider);
  }

  /// Get arsenal bag service
  ArsenalBagService getBagService(WidgetRef ref) {
    return ref.read(arsenalBagServiceProvider.notifier);
  }

  /// Get arsenal selection service
  ArsenalSelectionService getSelectionService(WidgetRef ref) {
    return ref.read(arsenalSelectionServiceProvider.notifier);
  }

  // === State Checks ===

  /// Check if currently in any selection mode
  bool isInSelectionMode(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).isInSelectionMode(state);
  }

  /// Check if currently in move mode
  bool isInMoveMode(WidgetRef ref) {
    return getArsenalState(ref).isMoveMode;
  }

  /// Check if currently in remove mode
  bool isInRemoveMode(WidgetRef ref) {
    return getArsenalState(ref).isRemoveMode;
  }

  /// Check if current bag has data
  bool currentBagHasData(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getBagService(ref).bagHasData(state);
  }

  /// Check if can move from current bag
  bool canMoveFromCurrentBag(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getBagService(ref).canMoveFromBag(state);
  }

  /// Check if has active filters
  bool hasActiveFilters(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getBagService(ref).hasActiveFilters(state);
  }

  // === Selection Operations ===

  /// Get current selection count
  int getSelectionCount(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).getSelectionCount(state);
  }

  /// Get selected instances
  Set<int> getSelectedInstances(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).getSelectedInstances(state);
  }

  /// Check if instance is selected
  bool isInstanceSelected(WidgetRef ref, int instanceId) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).isInstanceSelected(state, instanceId);
  }

  /// Toggle instance selection based on current mode
  void toggleInstanceSelection(WidgetRef ref, int instanceId) {
    final state = getArsenalState(ref);
    if (state.isMoveMode) {
      getSelectionService(ref).toggleInstanceForMove(instanceId);
    } else if (state.isRemoveMode) {
      getSelectionService(ref).toggleInstanceForRemoval(instanceId);
    }
  }

  /// Clear all selections
  void clearAllSelections(WidgetRef ref) {
    final state = getArsenalState(ref);
    getSelectionService(ref).clearSelections(state);
  }

  /// Exit current selection mode
  void exitSelectionMode(WidgetRef ref) {
    final state = getArsenalState(ref);
    getSelectionService(ref).exitSelectionMode(state);
  }

  // === Mode Toggles ===

  /// Toggle move mode
  void toggleMoveMode(WidgetRef ref) {
    getSelectionService(ref).toggleMoveMode();
  }

  /// Toggle remove mode  
  void toggleRemoveMode(WidgetRef ref) {
    getSelectionService(ref).toggleRemoveMode();
  }

  // === Display Helpers ===

  /// Get current bag display text
  String getCurrentBagDisplayText(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getBagService(ref).getSelectedBagDisplayText(state);
  }

  /// Get selection mode text
  String getSelectionModeText(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).getSelectionModeText(state);
  }

  /// Get selection mode color
  SelectionModeColor getSelectionModeColor(WidgetRef ref) {
    final state = getArsenalState(ref);
    return getSelectionService(ref).getSelectionModeColor(state);
  }

  // === Validation Helpers ===

  /// Validate selection for operation
  bool validateSelection(
    WidgetRef ref,
    BuildContext context,
    String operation, {
    int? minSelection,
    int? maxSelection,
  }) {
    final selectionCount = getSelectionCount(ref);
    
    if (selectionCount == 0) {
      showEmptySelectionWarning(context, operation);
      return false;
    }
    
    if (minSelection != null && selectionCount < minSelection) {
      showValidationError(
        context,
        'Selection',
        'Minimum $minSelection ball${minSelection != 1 ? 's' : ''} required for $operation',
      );
      return false;
    }
    
    if (maxSelection != null && selectionCount > maxSelection) {
      showValidationError(
        context,
        'Selection',
        'Maximum $maxSelection ball${maxSelection != 1 ? 's' : ''} allowed for $operation',
      );
      return false;
    }
    
    return true;
  }

  /// Validate bag operation
  bool validateBagOperation(
    WidgetRef ref,
    BuildContext context,
    String operation,
  ) {
    final state = getArsenalState(ref);
    final currentBag = state.selectedBagNumber;
    
    if (operation == 'move' && currentBag == 1) {
      showInvalidOperationWarning(
        context,
        operation,
        'Cannot move from main arsenal view',
      );
      return false;
    }
    
    if (!currentBagHasData(ref)) {
      showInvalidOperationWarning(
        context,
        operation,
        'Current bag is empty',
      );
      return false;
    }
    
    return true;
  }

  // === Safe Operation Helpers ===

  /// Safely execute Arsenal operation with error handling
  Future<T?> safeArsenalOperation<T>(
    BuildContext context,
    String operationName,
    Future<T> operation, {
    String? successMessage,
    Function(T)? onSuccess,
  }) async {
    return await handleArsenalOperation<T>(
      context,
      operationName,
      operation,
      successMessage: successMessage,
      onSuccess: onSuccess,
    );
  }

  /// Safely execute selection-based operation
  Future<T?> safeSelectionOperation<T>(
    WidgetRef ref,
    BuildContext context,
    String operationName,
    Future<T> Function(Set<int> selectedInstances) operation, {
    int? minSelection,
    int? maxSelection,
    String? successMessage,
    Function(T)? onSuccess,
  }) async {
    // Validate selection first
    if (!validateSelection(
      ref,
      context,
      operationName,
      minSelection: minSelection,
      maxSelection: maxSelection,
    )) {
      return null;
    }
    
    final selectedInstances = getSelectedInstances(ref);
    
    return await safeArsenalOperation<T>(
      context,
      operationName,
      operation(selectedInstances),
      successMessage: successMessage,
      onSuccess: onSuccess,
    );
  }

  // === Required Mixin Implementations ===
  
  @override
  void handleArsenalError(BuildContext context, String operation, dynamic error, {String? customMessage}) {
    // Implementation is mixed in from ArsenalErrorHandlingMixin
  }

  @override
  void showArsenalSuccess(BuildContext context, String message, {Duration? duration}) {
    // Implementation is mixed in from ArsenalNotificationMixin
  }

  @override
  void showArsenalError(BuildContext context, String message, {Duration? duration}) {
    // Implementation is mixed in from ArsenalNotificationMixin
  }

  @override
  void showValidationError(BuildContext context, String field, String message) {
    // Implementation is mixed in from ArsenalNotificationMixin
  }

  @override
  void showEmptySelectionWarning(BuildContext context, String operation) {
    // Implementation is mixed in from ArsenalNotificationMixin
  }

  @override
  void showInvalidOperationWarning(BuildContext context, String operation, String reason) {
    // Implementation is mixed in from ArsenalNotificationMixin
  }
}