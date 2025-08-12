import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/managers/arsenal_dialog_manager.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/move_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/remove_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_error_handling_mixin.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_notification_mixin.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/mixins/arsenal_state_mixin.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/appbar/management_section.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

/// Refactored Arsenal Management Section using new mixins and patterns
class ArsenalManagementSectionRefactored extends ConsumerWidget 
    with ArsenalErrorHandlingMixin, ArsenalNotificationMixin, ArsenalStateMixin {
  
  final List<Color> bagColors;
  final VoidCallback onShowMoreOptions;

  const ArsenalManagementSectionRefactored({
    super.key,
    required this.bagColors,
    required this.onShowMoreOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = getArsenalState(ref);
    
    return Builder(builder: (context) {
      if (isInSelectionMode(ref)) {
        return _buildSelectionModeBar(context, ref);
      }
      
      return ManagementSection(
        getSelectedBagText: (state) => getCurrentBagDisplayText(ref),
        onMore: onShowMoreOptions,
      );
    });
  }

  Widget _buildSelectionModeBar(BuildContext context, WidgetRef ref) {
    final selectionCount = getSelectionCount(ref);
    final selectionModeText = getSelectionModeText(ref);
    final isMove = isInMoveMode(ref);
    final selectionColor = getSelectionModeColor(ref);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: AppStandardButton(
              text: selectionModeText,
              onPressed: () => _handleConfirmSelection(context, ref, isMove),
              customColor: _getColorFromSelectionMode(selectionColor),
              isPrimary: true,
              whiteForeground: true,
              enabled: selectionCount > 0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppStandardButton(
              text: 'Exit',
              onPressed: () => _handleExitSelection(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleConfirmSelection(BuildContext context, WidgetRef ref, bool isMove) async {
    // Validate selection first
    if (!validateSelection(ref, context, isMove ? 'move' : 'remove')) {
      return;
    }

    try {
      if (isMove) {
        await _handleMoveConfirmation(context, ref);
      } else {
        await _handleRemoveConfirmation(context, ref);
      }
    } catch (error) {
      handleArsenalError(
        context,
        isMove ? 'move balls' : 'remove balls',
        error,
      );
    }
  }

  Future<void> _handleMoveConfirmation(BuildContext context, WidgetRef ref) async {
    await safeSelectionOperation(
      ref,
      context,
      'move balls',
      (selectedInstances) async {
        final moveBallsUseCase = ref.read(moveBallsUseCaseProvider.notifier);
        final targetBag = await moveBallsUseCase.showBagSelectionDialog(
          context: context,
          bagColors: bagColors,
        );
        
        if (targetBag != null) {
          await moveBallsUseCase.execute(
            context: context,
            targetBagNumber: targetBag,
            selectedInstances: selectedInstances,
          );
        }
      },
      minSelection: 1,
      onSuccess: (_) {
        exitSelectionMode(ref);
        showBallMovedSuccess(context, getSelectionCount(ref), 0); // Will be updated with actual target
      },
    );
  }

  Future<void> _handleRemoveConfirmation(BuildContext context, WidgetRef ref) async {
    await safeSelectionOperation(
      ref,
      context,
      'remove balls',
      (selectedInstances) async {
        final removeBallsUseCase = ref.read(removeBallsUseCaseProvider.notifier);
        
        // Show confirmation dialog first
        final dialogManager = ref.read(arsenalDialogManagerProvider.notifier);
        final arsenalState = getArsenalState(ref);
        final isFromMainBag = arsenalState.selectedBagNumber == 1;
        final currentBagName = getCurrentBagDisplayText(ref);
        
        final confirmation = await dialogManager.showRemovalConfirmationDialog(
          context: context,
          ballCount: selectedInstances.length,
          isFromMainBag: isFromMainBag,
          currentBagName: currentBagName,
        );
        
        if (confirmation != null) {
          await removeBallsUseCase.execute(
            context: context,
            selectedInstances: selectedInstances,
          );
        }
      },
      minSelection: 1,
      onSuccess: (_) {
        exitSelectionMode(ref);
        showBallRemovedSuccess(context, getSelectionCount(ref), 'removed');
      },
    );
  }

  void _handleExitSelection(BuildContext context, WidgetRef ref) {
    final modeType = isInMoveMode(ref) ? 'Move' : 'Remove';
    exitSelectionMode(ref);
    showSelectionModeExited(context, modeType);
  }

  Color _getColorFromSelectionMode(SelectionModeColor selectionColor) {
    switch (selectionColor) {
      case SelectionModeColor.move:
        return Colors.blue;
      case SelectionModeColor.remove:
        return Colors.red;
      case SelectionModeColor.none:
        return Colors.grey;
    }
  }
}