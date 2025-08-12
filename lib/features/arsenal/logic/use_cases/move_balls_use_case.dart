import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

part 'move_balls_use_case.g.dart';

/// Use case for moving balls between bags
@riverpod
class MoveBallsUseCase extends _$MoveBallsUseCase {
  @override
  void build() {
    // This use case doesn't need to maintain state
  }

  /// Execute the move balls use case
  Future<void> execute({
    required BuildContext context,
    required int targetBagNumber,
    Set<int>? selectedInstances,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    
    // Use provided instances or get from current state
    final instancesToMove = selectedInstances ?? 
        selectionService.getSelectedInstances(arsenalState);
    
    if (instancesToMove.isEmpty) {
      TopNotification.showError(
        context,
        'No balls selected for moving',
      );
      return;
    }

    // Validate target bag
    final validationResult = await _validateMove(
      context: context,
      targetBagNumber: targetBagNumber,
      currentBagNumber: arsenalState.selectedBagNumber,
      instancesToMove: instancesToMove,
    );
    
    if (!validationResult.isValid) {
      TopNotification.showError(context, validationResult.errorMessage);
      return;
    }

    try {
      await _performMove(
        context: context,
        instancesToMove: instancesToMove,
        sourceBagNumber: arsenalState.selectedBagNumber,
        targetBagNumber: targetBagNumber,
      );
      
      // Exit selection mode after successful move
      selectionService.exitSelectionMode(arsenalState);
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to move balls: $e',
      );
    }
  }

  /// Show bag selection dialog for move operation
  Future<int?> showBagSelectionDialog({
    required BuildContext context,
    required List<Color> bagColors,
  }) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final userProfileState = ref.read(userProfileControllerProvider);
    
    if (userProfileState.profile == null) {
      TopNotification.showError(context, 'Failed to load user profile');
      return null;
    }

    final profile = userProfileState.profile!;
    final currentBagNumber = arsenalState.selectedBagNumber;
    final selectedCount = arsenalState.selectedForMove.length;
    
    // Get available target bags (exclude main bag and current bag)
    final availableBags = profile.unlockedBags
        .where((bag) => bag.number != 1 && bag.number != currentBagNumber)
        .toList();

    if (availableBags.isEmpty) {
      TopNotification.showError(
        context,
        'No other bags available for moving balls',
      );
      return null;
    }

    return await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Move $selectedCount Ball${selectedCount != 1 ? 's' : ''}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select target bag:'),
            const SizedBox(height: 16),
            ...availableBags.map((bag) => ListTile(
              leading: CircleAvatar(
                backgroundColor: bagColors[bag.number - 1],
                child: Text('${bag.number}'),
              ),
              title: Text(bag.displayName),
              onTap: () => Navigator.of(context).pop(bag.number),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Validate move operation
  Future<MoveValidationResult> _validateMove({
    required BuildContext context,
    required int targetBagNumber,
    required int currentBagNumber,
    required Set<int> instancesToMove,
  }) async {
    // Check if target bag is different from source
    if (targetBagNumber == currentBagNumber) {
      return MoveValidationResult.invalid(
        'Cannot move balls to the same bag',
      );
    }

    // Check if target bag is not the main bag
    if (targetBagNumber == 1) {
      return MoveValidationResult.invalid(
        'Cannot move balls to the main arsenal view',
      );
    }

    // Check if user profile is loaded
    final userProfileState = ref.read(userProfileControllerProvider);
    if (userProfileState.profile == null) {
      return MoveValidationResult.invalid(
        'User profile not loaded',
      );
    }

    // Check if target bag is unlocked
    final profile = userProfileState.profile!;
    final targetBag = profile.unlockedBags
        .where((bag) => bag.number == targetBagNumber)
        .firstOrNull;
    
    if (targetBag == null) {
      return MoveValidationResult.invalid(
        'Target bag is not unlocked',
      );
    }

    return MoveValidationResult.valid();
  }

  /// Perform the actual move operation
  Future<void> _performMove({
    required BuildContext context,
    required Set<int> instancesToMove,
    required int sourceBagNumber,
    required int targetBagNumber,
  }) async {
    int successCount = 0;
    int failCount = 0;
    
    for (final instanceId in instancesToMove) {
      try {
        await _moveInstanceBetweenBags(
          instanceId,
          sourceBagNumber,
          targetBagNumber,
        );
        successCount++;
      } catch (e) {
        print('Failed to move instance $instanceId: $e');
        failCount++;
      }
    }
    
    _showMoveResult(context, successCount, failCount, targetBagNumber);
  }

  /// Move a single instance between bags
  Future<void> _moveInstanceBetweenBags(
    int instanceId,
    int sourceBagNumber,
    int targetBagNumber,
  ) async {
    // Implementation would depend on the controller's methods
    // This is a placeholder for the actual move logic
    await ref.read(newArsenalControllerProvider.notifier)
        .moveBallBetweenBags(instanceId, sourceBagNumber, targetBagNumber);
  }

  /// Show move result to user
  void _showMoveResult(
    BuildContext context,
    int successCount,
    int failCount,
    int targetBagNumber,
  ) {
    if (successCount > 0) {
      TopNotification.showSuccess(
        context,
        'Successfully moved $successCount ball${successCount != 1 ? 's' : ''} to Bag $targetBagNumber!',
      );
    }
    
    if (failCount > 0) {
      TopNotification.showError(
        context,
        'Failed to move $failCount ball${failCount != 1 ? 's' : ''}',
      );
    }
  }
}

/// Result of move validation
class MoveValidationResult {
  final bool isValid;
  final String errorMessage;

  const MoveValidationResult._({
    required this.isValid,
    this.errorMessage = '',
  });

  factory MoveValidationResult.valid() {
    return const MoveValidationResult._(isValid: true);
  }

  factory MoveValidationResult.invalid(String errorMessage) {
    return MoveValidationResult._(
      isValid: false,
      errorMessage: errorMessage,
    );
  }
}