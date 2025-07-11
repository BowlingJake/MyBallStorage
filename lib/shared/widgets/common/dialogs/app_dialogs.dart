import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
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
        title: 'Confirm Delete',
        content: 'Are you sure you want to delete ${itemCount > 1 ? ' $itemCount ' : 'this '}training record? This action cannot be undone.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        onConfirm: onConfirm,
        isDangerous: true,
      );
    },
  );
}

 