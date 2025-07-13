import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/shared/widgets/common/section_title.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/ball_selection_widget.dart'; // 導入新的組件
import 'package:bowlingarsenal_app/features/training/models/training_record.dart'; // For BallInfo

class DeveloperPage extends ConsumerWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Sandbox'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Component Sandbox'),
            const SizedBox(height: 16),

            // --- Test Area for BallSelectionWidget ---
            const Text(
              'Test: Ball Selection Widget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BallSelectionWidget(
              onBallsSelected: (selectedBalls) {
                // In a real scenario, you would update your state here.
                // For testing, we just print the result.
                debugPrint('Selected Balls: ${selectedBalls.map((b) => b.name).toList()}');
              },
            ),

            const SizedBox(height: 24),
            // ... other developer components can be added here
          ],
        ),
      ),
    );
  }
}
