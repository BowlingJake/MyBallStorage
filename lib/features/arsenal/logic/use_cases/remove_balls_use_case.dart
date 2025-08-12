import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

part 'remove_balls_use_case.g.dart';

/// Use case for removing balls from arsenal
@riverpod
class RemoveBallsUseCase extends _$RemoveBallsUseCase {
  @override
  void build() {
    // This use case doesn't need to maintain state
  }

  /// Execute the remove balls use case
  Future<void> execute({
    required BuildContext context,
    Set<int>? selectedInstances,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    
    // Use provided instances or get from current state
    final instancesToRemove = selectedInstances ?? 
        selectionService.getSelectedInstances(arsenalState);
    
    if (instancesToRemove.isEmpty) {
      TopNotification.showError(
        context,
        'No balls selected for removal',
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await ArsenalDialogService.showConfirmationDialog(
      context: context,
      title: 'Confirm Removal',
      message: 'Are you sure you want to remove ${instancesToRemove.length} ball${instancesToRemove.length != 1 ? 's' : ''} from your arsenal?',
      confirmText: 'Remove',
      cancelText: 'Cancel',
    );

    if (!confirmed) {
      return;
    }

    try {
      // Determine removal type based on current bag
      final currentBag = arsenalState.selectedBagNumber;
      final removalType = _determineRemovalType(currentBag);
      
      await _performRemoval(
        context: context,
        instancesToRemove: instancesToRemove,
        removalType: removalType,
        currentBag: currentBag,
      );
      
      // Exit selection mode after successful removal
      selectionService.exitSelectionMode(arsenalState);
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to remove balls: $e',
      );
    }
  }

  /// Determine the type of removal based on current bag
  RemovalType _determineRemovalType(int currentBag) {
    if (currentBag == 1) {
      // Main bag - complete removal from arsenal
      return RemovalType.complete;
    } else {
      // Sub bag - removal from bag only (unless user chooses complete)
      return RemovalType.bagOnly;
    }
  }

  /// Perform the actual removal operation
  Future<void> _performRemoval({
    required BuildContext context,
    required Set<int> instancesToRemove,
    required RemovalType removalType,
    required int currentBag,
  }) async {
    int successCount = 0;
    int failCount = 0;
    
    for (final instanceId in instancesToRemove) {
      try {
        switch (removalType) {
          case RemovalType.bagOnly:
            await _removeFromBagOnly(instanceId, currentBag);
            break;
          case RemovalType.complete:
            await _removeCompletelyFromArsenal(instanceId);
            break;
        }
        successCount++;
      } catch (e) {
        print('Failed to remove instance $instanceId: $e');
        failCount++;
      }
    }
    
    _showRemovalResult(context, successCount, failCount, removalType);
  }

  /// Remove ball from specific bag only
  Future<void> _removeFromBagOnly(int instanceId, int bagNumber) async {
    // Use existing controller method for removal
    final controller = ref.read(newArsenalControllerProvider.notifier);
    await controller.removeInstance(instanceId, 'current-user-id'); // TODO: Get actual user ID
  }

  /// Remove ball completely from arsenal
  Future<void> _removeCompletelyFromArsenal(int instanceId) async {
    // Use existing controller method for complete removal
    final controller = ref.read(newArsenalControllerProvider.notifier);
    await controller.removeInstance(instanceId, 'current-user-id'); // TODO: Get actual user ID
  }

  /// Show removal result to user
  void _showRemovalResult(
    BuildContext context,
    int successCount,
    int failCount,
    RemovalType removalType,
  ) {
    if (successCount > 0) {
      final removalText = removalType == RemovalType.complete 
          ? 'removed from arsenal'
          : 'removed from bag';
      
      TopNotification.showSuccess(
        context,
        'Successfully $removalText $successCount ball${successCount != 1 ? 's' : ''}!',
      );
    }
    
    if (failCount > 0) {
      TopNotification.showError(
        context,
        'Failed to remove $failCount ball${failCount != 1 ? 's' : ''}',
      );
    }
  }

  /// Show tiered removal dialog for sub-bags
  Future<RemovalType?> showTieredRemovalDialog({
    required BuildContext context,
    required int selectedCount,
  }) async {
    // Use static ArsenalDialogService since it's no longer a provider
    
    return await showDialog<RemovalType>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Options'),
        content: Text(
          'How would you like to remove the selected $selectedCount ball${selectedCount != 1 ? 's' : ''}?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(RemovalType.bagOnly),
            child: const Text('Remove from Bag Only'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(RemovalType.complete),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove from Arsenal'),
          ),
        ],
      ),
    );
  }
}

/// Types of removal operations
enum RemovalType {
  bagOnly,    // Remove from current bag only
  complete,   // Remove completely from arsenal
}

extension RemovalTypeExtension on RemovalType {
  String get displayName {
    switch (this) {
      case RemovalType.bagOnly:
        return 'Remove from Bag';
      case RemovalType.complete:
        return 'Remove from Arsenal';
    }
  }
}