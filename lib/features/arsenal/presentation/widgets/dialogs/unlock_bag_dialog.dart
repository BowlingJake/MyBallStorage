import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

Future<String?> showUnlockBagDialog({
  required BuildContext context,
  required int bagIndex,
  required Color accentColor,
}) async {
  final TextEditingController nameController = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 350),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[600]!, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Unlock Bag ${bagIndex + 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter bag name...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[600]!)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[600]!)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: accentColor)),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.6),
                ),
                maxLength: 20,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppStandardButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppStandardButton(
                      text: 'Unlock',
                      onPressed: () => Navigator.of(dialogContext).pop(nameController.text.trim()),
                      customColor: accentColor,
                      isPrimary: true,
                      whiteForeground: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  nameController.dispose();
  return result;
}

