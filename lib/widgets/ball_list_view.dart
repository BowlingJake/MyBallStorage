import 'package:flutter/material.dart';
import '../theme/brand_colors.dart';
// import 'package:getwidget/getwidget.dart'; // GFListTile is no longer used

// Helper function to extract core category (Symmetric/Asymmetric)
String getCoreCategory(String coreName) {
  if (coreName.trim().isEmpty) {
    return '未知'; // Handle empty core names
  }
  final parts = coreName.trim().split(' ');
  return parts.last; // Return last part (works even if no space)
}

// Helper function to adjust hue of a color by specified degrees
Color adjustHue(Color color, double hueDelta) {
  HSVColor hsvColor = HSVColor.fromColor(color);
  double newHue = (hsvColor.hue + hueDelta) % 360;
  if (newHue < 0) newHue += 360;
  return hsvColor.withHue(newHue).toColor();
}

// Helper function to create radial gradient overlay for matte effect
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

// 保齡球資料模型
class BowlingBall {
  final String id;
  final String name;
  final String brand;
  final String coverstock; // 球皮類型（用於卡片顯示）
  final String coverstockName; // 球皮完整名稱（用於詳細視窗）
  final String core;
  final String imageUrl; // Not used in the new card design directly
  final double? rg; // RG (徑向迴轉半徑)
  final double? differential; // Diff (差動值)
  final double? massBias; // MB Diff (質量偏心)

  BowlingBall({
    required this.id,
    required this.name,
    required this.brand,
    required this.coverstock,
    this.coverstockName = '',
    required this.core,
    this.imageUrl = 'https://via.placeholder.com/80x80/A3D5DC/FFFFFF?Text=Ball',
    this.rg,
    this.differential,
    this.massBias,
  });

  factory BowlingBall.fromJson(Map<String, dynamic> json) {
    double? parseDouble(String? value) {
      if (value == null || value.isEmpty) return null;
      return double.tryParse(value);
    }

    String getImageUrl(String ballName) {
      if (ballName == 'Jackal EXJ') {
        return 'assets/images/Jackal EXJ.jpg';
      }
      return 'https://via.placeholder.com/80x80/A3D5DC/FFFFFF?Text=Ball';
    }

    return BowlingBall(
      id: json['Ball'] ?? '',
      name: json['Ball'] ?? '',
      brand: json['Brand'] ?? '',
      coverstock: json['Coverstock Category'] ?? '',
      coverstockName: json['Coverstock Name'] ?? '',
      core: json['Core'] ?? '',
      imageUrl: getImageUrl(json['Ball'] ?? ''),
      rg: parseDouble(json['RG']),
      differential: parseDouble(json['Diff']),
      massBias: parseDouble(json['MB Diff']),
    );
  }
}

// Helper class for the grid pattern on the card
class _GridPainter extends CustomPainter {
  final Color gridColor;
  final double strokeWidth;
  final double spacing;

  _GridPainter({
    this.gridColor = Colors.white24,
    this.strokeWidth = 0.5,
    this.spacing = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (double i = spacing; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (double i = spacing; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.spacing != spacing;
  }
}

// Custom Card Item Widget with Color Ring Design
class _BallCardItem extends StatelessWidget {
  final BowlingBall ball;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const _BallCardItem({
    Key? key,
    required this.ball,
    required this.theme,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final List<Color> gradientColors = brandPalette.getCardGradient();
    final bool isWarmColor = brandPalette.isWarmColor();
    final ringColor = brandPalette.shade600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.grey[50],
          // 微灰白色背景，既不刺眼又讓色環突出
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ball.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        ball.brand,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ringColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Core Type: ${getCoreCategory(ball.core)}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 1,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Cover Type: ${ball.coverstock}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: ringColor,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: ringColor.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
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

class BallListView extends StatelessWidget {
  final List<BowlingBall> balls;
  final String searchText;
  final Function(BowlingBall)? onBallTap;
  final Function(BowlingBall)? onBallLongPress;

  const BallListView({
    Key? key,
    required this.balls,
    this.searchText = '',
    this.onBallTap,
    this.onBallLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (balls.isEmpty) {
      return Center(
        child: Text(
          searchText.isNotEmpty ? 'No balls match your search.' : 'No balls in your arsenal yet.',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 32.0),
          itemCount: balls.length,
          itemBuilder: (context, index) {
            final ball = balls[index];
            return _BallCardItem(
              ball: ball,
              theme: theme,
              onTap: () {
                onBallTap?.call(ball);
                print('Tapped on ${ball.name}');
              },
              onLongPress: () {
                onBallLongPress?.call(ball);
                print('Long pressed on ${ball.name}');
              },
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface.withOpacity(0.0),
                  theme.colorScheme.surface.withOpacity(0.8),
                  theme.colorScheme.surface,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
