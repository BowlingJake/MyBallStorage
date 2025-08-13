import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

Future<String?> showRemovalOptionsDialog({
  required BuildContext context,
  required int selectedCount,
  required String currentBagName,
}) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext dialogContext) {
      return _RemovalOptionsDialog(
        selectedCount: selectedCount,
        currentBagName: currentBagName,
      );
    },
  );
}

/// Removal Options Dialog with unified style
class _RemovalOptionsDialog extends StatelessWidget {
  const _RemovalOptionsDialog({
    required this.selectedCount,
    required this.currentBagName,
  });

  final int selectedCount;
  final String currentBagName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Remove $selectedCount Ball${selectedCount != 1 ? 's' : ''}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Message
            Text(
              'Choose removal option:',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: AppStandardButton(
                    text: 'Remove from $currentBagName',
                    height: 32,
                    fontSize: 12,
                    customColor: Colors.grey,
                    onPressed: () => Navigator.of(context).pop('bag_only'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppStandardButton(
                    text: 'Remove from All Arsenal',
                    height: 32,
                    fontSize: 12,
                    customColor: Colors.red,
                    isPrimary: true,
                    onPressed: () => Navigator.of(context).pop('complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// tiles 改為並排按鈕，已移除

