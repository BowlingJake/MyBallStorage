import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_dialog_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/move_balls_use_case.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/use_cases/remove_balls_use_case.dart';

class ArsenalDialogHandler {
  static void showMoreOptionsBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required NewArsenalState arsenalState,
  }) {
    ArsenalDialogService.showMoreOptionsBottomSheet(
      context: context,
      ref: ref,
      arsenalState: arsenalState,
    );
  }

  static void showAddToCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalDialogService.showAddToCurrentBag(
      context: context,
      ref: ref,
    );
  }

  static Future<void> showMoveSelected({
    required BuildContext context,
    required WidgetRef ref,
    required List<Color> bagColors,
  }) async {
    final moveBallsUseCase = ref.read(moveBallsUseCaseProvider.notifier);
    final targetBag = await moveBallsUseCase.showBagSelectionDialog(
      context: context,
      bagColors: bagColors,
    );
    
    if (targetBag != null) {
      await moveBallsUseCase.execute(
        context: context,
        targetBagNumber: targetBag,
      );
    }
  }

  static Future<void> confirmRemoveSelected({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final removeBallsUseCase = ref.read(removeBallsUseCaseProvider.notifier);
    await removeBallsUseCase.execute(context: context);
  }

  static Future<bool> showUnlockBagDialog({
    required BuildContext context,
    required WidgetRef ref,
    required int bagIndex,
    required Color accentColor,
  }) async {
    return await ArsenalDialogService.showUnlockBagDialog(
      context: context,
      ref: ref,
      bagIndex: bagIndex,
      accentColor: accentColor,
    );
  }

  static void showLibrarySelection({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalDialogService.showLibrarySelection(
      context: context,
      ref: ref,
    );
  }

  static void showBallDetails({
    required BuildContext context,
    required WidgetRef ref,
    required int instanceId,
  }) {
    ArsenalDialogService.showBallDetails(
      context: context,
      instanceId: instanceId,
    );
  }
}