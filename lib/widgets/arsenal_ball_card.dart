import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/arsenal_ball.dart';
import '../models/ball_adapter.dart';
import '../theme/brand_colors.dart';
import 'ball_detail_popout.dart';

/// Helper function to adjust hue of a color by specified degrees
Color adjustHue(Color color, double hueDelta) {
  HSVColor hsvColor = HSVColor.fromColor(color);
  double newHue = (hsvColor.hue + hueDelta) % 360;
  if (newHue < 0) newHue += 360;
  return hsvColor.withHue(newHue).toColor();
}

/// Helper function to create radial gradient overlay for matte effect
RadialGradient createMatteOverlay(List<Color> brandColors) {
  Color primaryColor = brandColors.first;
  Color matteColor1 = adjustHue(primaryColor, 15.0);
  Color matteColor2 = adjustHue(primaryColor, -12.0);
  
  return RadialGradient(
    center: const Alignment(0.3, -0.2),
    radius: 1.4,
    colors: [
      matteColor1.withOpacity(0.18),
      matteColor2.withOpacity(0.12),
      primaryColor.withOpacity(0.06),
      Colors.transparent,
    ],
    stops: const [0.0, 0.4, 0.7, 1.0],
  );
}

/// Card displaying a bowling ball with image and basic info.
/// New layout: name on top, image in center, info at bottom, all centered.
/// Background uses brand colors based on ball brand - style from Ball Library.
/// Long press opens ball detail popout.
/// Enhanced with 4px brand color ring around the entire card.
class ArsenalBallCard extends StatelessWidget {
  final ArsenalBall ball;
  const ArsenalBallCard({super.key, required this.ball});

  /// 顯示球的詳細資訊 popout
  void _showBallDetail(BuildContext context) {
    final bowlingBall = arsenalBallToBowlingBall(ball);
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return BowlingBallDetailWidget(ball: bowlingBall);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('yyyy/MM/dd');
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final ringColor = brandPalette.shade600;
    
    return GestureDetector(
      onLongPress: () => _showBallDetail(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: ringColor,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: ringColor.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  ball.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 3,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.8,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.08),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.06),
                              blurRadius: 22,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        child: Container(
                          width: 60,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: const BorderRadius.all(
                              Radius.elliptical(30, 7.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 25,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                                color: Colors.black.withOpacity(0.15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                        ),
                        child: ClipOval(
                          child: Stack(
                            children: [
                              Image.asset(
                                ball.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                filterQuality: FilterQuality.high,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(0, 0.7),
                                    radius: 0.6,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.25),
                                    ],
                                    stops: const [0.7, 1.0],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.3, -0.3),
                                    radius: 0.8,
                                    colors: [
                                      Colors.black.withOpacity(0.15),
                                      Colors.black.withOpacity(0.05),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.4, 0.8],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ball.brand,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ringColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              dateFormatter.format(ball.dateAdded),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_view,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              ball.layout,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
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
    );
  }
}
