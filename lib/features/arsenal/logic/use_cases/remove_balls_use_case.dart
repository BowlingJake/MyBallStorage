import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:core_theme/core_theme.dart';

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

    // Check if in main bag or sub bag and show appropriate dialog
    final currentBag = arsenalState.selectedBagNumber;
    bool confirmed = false;
    
    if (currentBag == 1) {
      // Main bag - simple confirmation
      final result = await showAppConfirmationDialog(
        context: context,
        title: 'Remove Selected Balls',
        message: 'Are you sure you want to completely remove ${instancesToRemove.length} ball${instancesToRemove.length != 1 ? 's' : ''} from your arsenal?',
        confirmText: 'Remove',
        isDangerous: true,
      );
      confirmed = result == true;
    } else {
      // Sub bag - show tiered removal dialog
      final removalType = await _showTieredRemovalDialog(
        context: context,
        selectedCount: instancesToRemove.length,
        currentBag: currentBag,
      );
      if (removalType != null) {
        confirmed = await _confirmRemovalAction(
          context: context,
          removalType: removalType,
          selectedCount: instancesToRemove.length,
          currentBag: currentBag,
        );
      }
    }

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
    
    // Get actual user ID from auth controller
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      throw Exception('User not authenticated');
    }
    final userId = authState.value!.id;
    final controller = ref.read(newArsenalControllerProvider.notifier);
    final arsenalState = ref.read(newArsenalControllerProvider);
    
    // Get selected instances for ball names
    final selectedInstances = arsenalState.allInstances
        .where((inst) => instancesToRemove.contains(inst.id))
        .toList();
    
    try {
      switch (removalType) {
        case RemovalType.bagOnly:
          // Remove all selected instances from the specific bag
          await controller.removeSelectedInstancesFromBag(currentBag, userId);
          successCount = instancesToRemove.length;
          break;
        case RemovalType.complete:
          // Remove all selected instances completely
          await controller.removeSelectedInstances(userId);
          successCount = instancesToRemove.length;
          break;
      }
    } catch (e) {
      print('Failed to remove instances: $e');
      failCount = instancesToRemove.length;
    }
    
    _showRemovalResult(context, successCount, failCount, removalType, currentBag, selectedInstances);
  }


  /// Show removal result to user
  void _showRemovalResult(
    BuildContext context,
    int successCount,
    int failCount,
    RemovalType removalType,
    int currentBag,
    List<UserArsenalInstance> removedInstances,
  ) {
    if (successCount > 0) {
      // Get bag name
      final userProfileState = ref.read(userProfileControllerProvider);
      String bagName;
      
      if (currentBag == 1) {
        // Main bag - use "My Arsenal"
        bagName = 'My Arsenal';
      } else {
        // Sub bag - use custom bag name or default
        bagName = 'Bag $currentBag';
        if (userProfileState.profile != null) {
          bagName = userProfileState.profile!.getBagName(currentBag) ?? 'Bag $currentBag';
        }
      }
      
      String message;
      if (successCount == 1) {
        // Single ball - show ball name
        final ballName = removedInstances.first.displayName;
        message = 'Successful remove $ballName from $bagName';
      } else {
        // Multiple balls - show count
        message = 'Successful remove $successCount balls from $bagName';
      }
      
      TopNotification.showSuccess(context, message);
    }
    
    if (failCount > 0) {
      TopNotification.showError(
        context,
        'Failed to remove $failCount ball${failCount != 1 ? 's' : ''}',
      );
    }
  }

  /// Show tiered removal dialog for sub-bags with unified style
  Future<RemovalType?> _showTieredRemovalDialog({
    required BuildContext context,
    required int selectedCount,
    required int currentBag,
  }) async {
    final userProfileState = ref.read(userProfileControllerProvider);
    String bagName = 'Bag $currentBag';
    if (userProfileState.profile != null) {
      bagName = userProfileState.profile!.getBagName(currentBag) ?? 'Bag $currentBag';
    }
    
    return await showDialog<RemovalType>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => _TieredRemovalDialog(
        selectedCount: selectedCount,
        bagName: bagName,
      ),
    );
  }
  
  /// Confirm removal action with unified dialog
  Future<bool> _confirmRemovalAction({
    required BuildContext context,
    required RemovalType removalType,
    required int selectedCount,
    required int currentBag,
  }) async {
    final userProfileState = ref.read(userProfileControllerProvider);
    String bagName = 'Bag $currentBag';
    if (userProfileState.profile != null) {
      bagName = userProfileState.profile!.getBagName(currentBag) ?? 'Bag $currentBag';
    }
    
    String title, message;
    if (removalType == RemovalType.bagOnly) {
      title = 'Confirm Remove from $bagName';
      message = 'Remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from $bagName only? They will remain in All My Arsenal.';
    } else {
      title = 'Confirm Complete Removal';
      message = 'Completely remove $selectedCount ball${selectedCount != 1 ? 's' : ''} from all bags and your arsenal?';
    }
    
    final result = await showAppConfirmationDialog(
      context: context,
      title: title,
      message: message,
      confirmText: 'Remove',
      isDangerous: true,
    );
    
    return result == true;
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

/// Tiered Removal Dialog with unified style
class _TieredRemovalDialog extends StatelessWidget {
  const _TieredRemovalDialog({
    required this.selectedCount,
    required this.bagName,
  });

  final int selectedCount;
  final String bagName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.red.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Title
            Text(
              'Remove $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Message
            const Text(
              'Choose removal option:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Option buttons (highest risk first)
            AppStandardButton(
              text: 'Remove from All Arsenal',
              height: DialogDefaults.buttonHeight,
              fontSize: DialogDefaults.buttonFontSize,
              width: double.infinity,
              backgroundColor: Colors.red, // 例外：最高位階以填滿表示
              foregroundColor: Colors.white,
              outlineColor: Colors.red,
              onPressed: () => Navigator.of(context).pop(RemovalType.complete),
            ),
            const SizedBox(height: 16),
            AppStandardButton(
              text: 'Remove from $bagName',
              height: DialogDefaults.buttonHeight,
              fontSize: DialogDefaults.buttonFontSize,
              width: double.infinity,
              outlineColor: Colors.red.withOpacity(0.8),
              foregroundColor: Colors.red,
              onPressed: () => Navigator.of(context).pop(RemovalType.bagOnly),
            ),
            const SizedBox(height: 24),
            // Cancel button
            AppStandardButton(
              text: 'Cancel',
              height: DialogDefaults.buttonHeight,
              fontSize: DialogDefaults.buttonFontSize,
              width: double.infinity,
              outlineColor: Colors.white.withOpacity(0.6),
              foregroundColor: Colors.white.withOpacity(0.9),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ],
          ),
        ),
      ),
    );
  }
}