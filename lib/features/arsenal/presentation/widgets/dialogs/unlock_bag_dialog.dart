import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/buttons/dialog_action_buttons.dart';

Future<String?> showUnlockBagDialog({
  required BuildContext context,
  required int bagIndex,
  required Color accentColor,
}) async {
  final TextEditingController nameController = TextEditingController();
  
  return ArsenalDialog.show<String>(
    context: context,
    title: 'Unlock Bag ${bagIndex + 1}',
    maxWidth: 350,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter bag name...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), 
              borderSide: BorderSide(color: Colors.grey[600]!)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), 
              borderSide: BorderSide(color: Colors.grey[600]!)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), 
              borderSide: BorderSide(color: accentColor)
            ),
            filled: true,
            fillColor: Colors.black.withOpacity(0.6),
          ),
          maxLength: 20,
          autofocus: true,
        ),
      ],
    ),
    actions: [
      DialogActionButtons(
        primaryText: 'Unlock',
        secondaryText: 'Cancel',
        onPrimary: () => Navigator.of(context).pop(nameController.text.trim()),
        onSecondary: () => Navigator.of(context).pop(),
        primaryColor: accentColor,
      ),
    ],
  );
}

