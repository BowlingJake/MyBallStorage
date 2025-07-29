import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';

class BallCardItem extends StatelessWidget {
  const BallCardItem({
    required this.ball,
    required this.theme,
    this.onTap,
    this.onLongPress,
    super.key,
  });
  
  final BowlingBall ball;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;


  @override
  Widget build(BuildContext context) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColor = brandPalette[400]!;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.black.withOpacity(0.8),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left: Ball Image (Full Height)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.withOpacity(0.3),
                          border: Border.all(
                            color: brandColor.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.5),
                          child: ball.imageUrl.isNotEmpty && ball.imageUrl != 'https://via.placeholder.com/150'
                              ? Image.network(
                                  ball.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.sports_baseball,
                                      color: Colors.white54,
                                      size: 35,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.sports_baseball,
                                  color: Colors.white54,
                                  size: 35,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right: Information Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top: Ball Name
                          Text(
                            ball.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Middle: Core & Cover Types
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Core Type: ${getCoreCategory(ball.core)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cover Type: ${ball.coverstockType ?? ball.coverstock ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Bottom: RG, Diff, MB Data Blocks
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'RG',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ball.rg?.toStringAsFixed(3) ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Diff',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ball.diff?.toStringAsFixed(3) ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'MB',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        (ball.mbDiff == null || ball.mbDiff == 0) 
                                            ? 'N/A' 
                                            : ball.mbDiff!.toStringAsFixed(3),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom-left corner decoration
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    brandColor.withOpacity(0.8),
                    brandColor.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Top-right corner decoration
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(14),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    brandColor.withOpacity(0.8),
                    brandColor.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 