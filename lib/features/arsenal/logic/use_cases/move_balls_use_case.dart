import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/dialogs/move_target_bag_dialog.dart';
import 'package:core_theme/core_theme.dart';

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
    
    // Get selected instances and find which bags they're already in
    final selectedInstances = arsenalState.allInstances
        .where((inst) => arsenalState.selectedForMove.contains(inst.id))
        .toList();
    
    // Get all bags that the selected balls are already in (union)
    final alreadyInBags = <int>{};
    for (final inst in selectedInstances) {
      alreadyInBags.addAll(inst.activeBagNumbers);
    }
    
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

    return await showMoveTargetBagDialog(
      context: context,
      subBags: availableBags,
      bagColors: bagColors,
      currentBagNumber: currentBagNumber,
      selectedCount: selectedCount,
      alreadyInBags: alreadyInBags.toList(),
      userProfile: profile,
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
    try {
      // Get actual user ID from auth controller
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        throw Exception('User not authenticated');
      }
      final userId = authState.value!.id;
      
      // Get selected instances for ball names before moving
      final arsenalState = ref.read(newArsenalControllerProvider);
      final selectedInstances = arsenalState.allInstances
          .where((inst) => instancesToMove.contains(inst.id))
          .toList();
      
      final controller = ref.read(newArsenalControllerProvider.notifier);
      
      // Use the existing controller method for moving balls
      await controller.moveSelectedInstancesToBag(targetBagNumber, userId);
      
      _showMoveResult(context, instancesToMove.length, 0, targetBagNumber, selectedInstances);
    } catch (e) {
      print('Failed to move balls: $e');
      _showMoveResult(context, 0, instancesToMove.length, targetBagNumber, []);
    }
  }


  /// Show move result to user
  void _showMoveResult(
    BuildContext context,
    int successCount,
    int failCount,
    int targetBagNumber,
    List<UserArsenalInstance> movedInstances,
  ) {
    if (successCount > 0) {
      // Get target bag name
      final userProfileState = ref.read(userProfileControllerProvider);
      String targetBagName = 'Bag $targetBagNumber';
      if (userProfileState.profile != null) {
        targetBagName = userProfileState.profile!.getBagName(targetBagNumber) ?? 'Bag $targetBagNumber';
      }
      
      String message;
      if (successCount == 1) {
        // Single ball - show ball name
        final ballName = movedInstances.first.displayName;
        message = 'Successfully moved $ballName to $targetBagName';
      } else {
        // Multiple balls - show count
        message = 'Successfully moved $successCount balls to $targetBagName';
      }
      
      TopNotification.showSuccess(context, message);
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

/// Move Target Bag Dialog with unified style
// Reused unified dialog from presentation layer via showMoveTargetBagDialog