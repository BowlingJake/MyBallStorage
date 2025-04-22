import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

/// 請同時在 pubspec.yaml 加上：
/// dependencies:
///   palette_generator: ^0.3.2

class BowlingBallCard extends StatefulWidget {
  final String ballName;
  final String brand;
  final String core;
  final String coverstock;
  final String releaseDate;
  final String imagePath; // asset 圖片路徑

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
  Color? _bgColor;

  @override
  void initState() {
    super.initState();
    _updatePalette();
  }

  Future<void> _updatePalette() async {
    final generator = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.imagePath),
      size: const Size(80, 80),
      maximumColorCount: 20,
    );
    final color = generator.vibrantColor?.color
        ?? generator.dominantColor?.color
        ?? Colors.grey[200]!;
    setState(() => _bgColor = color);
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor ?? Colors.grey[200]!;
    final lum = bg.computeLuminance();
    final textColor = lum < 0.5 ? Colors.white : Colors.black87;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: bg,
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
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.cover,
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
