import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class TrainingEmptyState extends StatelessWidget {
  final VoidCallback onAddRecord;

  const TrainingEmptyState({
    Key? key,
    required this.onAddRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 圖示
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.sports,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 標題
            Text(
              'Start Your Bowling Journey',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
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
            
            // Add Record 按鈕
            GFButton(
              onPressed: onAddRecord,
              text: "Add Training Record",
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
              type: GFButtonType.solid,
              color: theme.colorScheme.primary,
              size: GFSize.LARGE,
              shape: GFButtonShape.pills,
              fullWidthButton: false,
            ),
          ],
        ),
      ),
    );
  }
} 