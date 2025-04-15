import 'package:flutter/material.dart';

class BowlingBallCard extends StatelessWidget {
  final String ballName;
  final String brand;
  final String core;
  final String coverstock;
  final String releaseDate;

  const BowlingBallCard({
    super.key,
    required this.ballName,
    required this.brand,
    required this.core,
    required this.coverstock,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 圖片 placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_baseball, size: 40, color: Colors.blueGrey),
            ),
            const SizedBox(width: 16),
            // 文字資訊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ballName,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text('$brand｜$releaseDate',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Text('Core: $core', style: Theme.of(context).textTheme.bodyMedium),
                  Text('Coverstock: $coverstock', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
