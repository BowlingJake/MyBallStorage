import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class GameActionButtons extends StatelessWidget {
  const GameActionButtons({
    required this.onDelete,
    required this.onClose,
    super.key,
  });

  final VoidCallback onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Delete',
            onPressed: onDelete,
            customColor: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Close',
            onPressed: onClose,
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}