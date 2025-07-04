import 'package:bowlingarsenal_app/widgets/app_standard_button.dart';
import 'package:flutter/material.dart';

/// Two action buttons shown on the MyArsenalPage.
class ArsenalActionButtons extends StatelessWidget {
  const ArsenalActionButtons({
    super.key,
    this.onAddPressed,
    this.onAnalyzePressed,
  });
  final VoidCallback? onAddPressed;
  final VoidCallback? onAnalyzePressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Add from Library',
            onPressed: onAddPressed ?? () {},
            customColor: colorScheme.primary,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Analyze Chart',
            onPressed: onAnalyzePressed ?? () {},
            customColor: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
