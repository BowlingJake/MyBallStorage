import 'package:flutter/material.dart';

/// 請同時在 pubspec.yaml 加上：
/// dependencies:
///   palette_generator: ^0.3.2

class BowlingBallCard extends StatefulWidget {
  final String ballName;
  final String brand;
  final String core;
  final String coverstock;
  final String releaseDate;
  final String imagePath;

  const BowlingBallCard({
    super.key,
    required this.ballName,
    required this.brand,
    required this.core,
    required this.coverstock,
    required this.releaseDate,
    required this.imagePath,
  });

  @override
  State<BowlingBallCard> createState() => _BowlingBallCardState();
}

class _BowlingBallCardState extends State<BowlingBallCard> {
  // 已移除背景色處理以提升載入效能

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.black87;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 圖片
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: widget.imagePath.isNotEmpty
                  ? Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        Icons.sports_baseball,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            // 文字資訊
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.ballName,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.brand}｜${widget.releaseDate}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: textColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Core: ${widget.core}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                  Text(
                    'Coverstock: ${widget.coverstock}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
