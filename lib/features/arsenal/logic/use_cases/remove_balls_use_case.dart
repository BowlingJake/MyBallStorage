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
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';

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
    required WidgetRef widgetRef,
    Set<int>? selectedInstances,
  }) async {
    // 改用與單選一致的對話體驗
    await ArsenalActions.confirmRemoveSelected(
      context: context,
      ref: widgetRef,
    );
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
      String message;
      
      if (removalType == RemovalType.complete) {
        // Complete removal - removed from entire arsenal
        if (successCount == 1) {
          final ballName = removedInstances.first.displayName;
          message = 'Successfully removed $ballName from arsenal';
        } else {
          message = 'Successfully removed $successCount balls from arsenal';
        }
      } else {
        // Bag-only removal - removed from specific bag
        final userProfileState = ref.read(userProfileControllerProvider);
        String bagName;
        
        if (currentBag == 1) {
          bagName = 'All My Arsenal';
        } else {
          bagName = 'Bag $currentBag';
          if (userProfileState.profile != null) {
            bagName = userProfileState.profile!.getBagName(currentBag) ?? 'Bag $currentBag';
          }
        }
        
        if (successCount == 1) {
          final ballName = removedInstances.first.displayName;
          message = 'Successfully removed $ballName from $bagName';
        } else {
          message = 'Successfully removed $successCount balls from $bagName';
        }
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
class _TieredRemovalDialog extends StatefulWidget {
  const _TieredRemovalDialog({
    required this.selectedCount,
    required this.bagName,
  });

  final int selectedCount;
  final String bagName;

  @override
  State<_TieredRemovalDialog> createState() => _TieredRemovalDialogState();
}

class _TieredRemovalDialogState extends State<_TieredRemovalDialog> {
  RemovalType? selectedOption;

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
              'Remove ${widget.selectedCount} Ball${widget.selectedCount != 1 ? 's' : ''}',
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
            // 水平並列的選擇按鈕
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = RemovalType.bagOnly;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedOption == RemovalType.bagOnly ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'From ${widget.bagName}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedOption == RemovalType.bagOnly ? Colors.white : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = RemovalType.complete;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedOption == RemovalType.complete ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        'From All Arsenal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selectedOption == RemovalType.complete ? Colors.white : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: AppStandardButton.destructiveOutlined(
                    text: 'Cancel',
                    height: 40,
                    fontSize: DialogDefaults.buttonFontSize,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppStandardButton.destructive(
                    text: 'Confirm',
                    height: 40,
                    fontSize: DialogDefaults.buttonFontSize,
                    onPressed: selectedOption != null
                        ? () {
                            if (selectedOption != null) {
                              Navigator.of(context).pop(selectedOption);
                            }
                          }
                        : () {},
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}