import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/ball_selection_dialog.dart' as dialog;
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class BallSelectionSection extends StatelessWidget {
  const BallSelectionSection({
    required this.selectedBalls,
    required this.onSelectionChanged,
    required this.accentColor,
    super.key,
  });

  final List<BallInfo> selectedBalls;
  final ValueChanged<List<BallInfo>> onSelectionChanged;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          AppStandardButton(
            width: double.infinity,
            isPrimary: true,
            customColor: accentColor,
            icon: Icons.sports_handball_outlined,
            text: 'Select Ball(s) for this Game',
            onPressed: () async {
              final List<dialog.BallInfo>? result = await showDialog(
                context: context,
                builder: (_) => dialog.BallSelectionDialog(
                  initialSelectedBalls: selectedBalls.map((ball) => dialog.BallInfo(
                    id: ball.id,
                    name: ball.name,
                    brand: ball.brand,
                    brandColor: ball.brandColor,
                    imagePath: ball.imagePath,
                  )).toList(),
                ),
              );

              if (result != null) {
                // Convert back to training BallInfo
                final convertedResult = result.map((ball) => BallInfo(
                  id: ball.id,
                  name: ball.name,
                  brand: ball.brand,
                  brandColor: ball.brandColor,
                  imagePath: ball.imagePath,
                )).toList();
                onSelectionChanged(convertedResult);
              }
            },
          ),
          if (selectedBalls.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: selectedBalls.map((ball) => Chip(
                label: Text(ball.name),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                side: BorderSide.none,
                labelStyle: Theme.of(context).textTheme.labelSmall,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              )).toList(),
            ),
          ]
        ],
      ),
    );
  }
} 