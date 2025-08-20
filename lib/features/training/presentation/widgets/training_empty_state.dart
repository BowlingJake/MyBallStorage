import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:flutter/material.dart';

class TrainingEmptyState extends StatelessWidget {
  const TrainingEmptyState({required this.onAddRecord, super.key});
  final VoidCallback onAddRecord;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 描述
            Text(
              'Record your training sessions\nTrack your progress',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Add Record 按鈕 - 使用 AppStandardButton
            AppStandardButton(
              text: 'Add Training Record',
              icon: Icons.add_circle_outline,
              onPressed: onAddRecord,
            ),
          ],
        ),
      ),
    );
  }
}
