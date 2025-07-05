import 'package:bowlingarsenal_app/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/views/training/add_game_choice_dialog.dart';
import 'package:bowlingarsenal_app/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteConfirmationDialog(
  BuildContext context, {
  required int itemCount,
  required VoidCallback onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: '確認刪除',
        content: '確定要刪除${itemCount > 1 ? ' $itemCount 個' : '這個'}訓練記錄嗎？此操作無法撤銷。',
        confirmText: '刪除',
        cancelText: '取消',
        onConfirm: onConfirm,
        isDangerous: true,
      );
    },
  );
}

Future<void> showAddGameChoiceDialog({
  required BuildContext context,
  required String dayId,
  required TrainingController controller,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AddGameChoiceDialog(
        dayId: dayId,
        gameNumber: controller.getGameCount(dayId) + 1,
      );
    },
  );
} 