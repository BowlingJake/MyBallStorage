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

// Helper class for metal texture background
class _MetalTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // 創建細微的點狀紋理
    for (double x = 0; x < size.width; x += 16) {
      for (double y = 0; y < size.height; y += 16) {
        if ((x / 16 + y / 16) % 3 == 0) {
          canvas.drawCircle(Offset(x, y), 0.8, paint);
        }
      }
    }

    // 添加細微的對角線紋理
    final linePaint = Paint()
      ..color = Colors.grey[300]!.withOpacity(0.05)
      ..strokeWidth = 0.5;

    for (double i = -size.height; i < size.width + size.height; i += 24) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[300]!.withOpacity(0.6), // 淡灰色高光
            ringColor.withOpacity(0.9), // 品牌色
            ringColor, // 主色
            ringColor.withOpacity(0.7), // 較深的品牌色
            Colors.grey[800]!.withOpacity(0.8), // 深灰陰影
            Colors.black.withOpacity(0.6), // 黑色邊緣
          ],
          stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          // 主要色彩光暈
          BoxShadow(
            color: ringColor.withOpacity(0.25),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
          // 深色金屬反射（頂部）
          BoxShadow(
            color: Colors.grey[400]!.withOpacity(0.3),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(-1, -2),
          ),
          // 主要深度陰影
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(2, 5),
          ),
          // 邊緣陰影
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(4.0), // 4px 邊框寬度
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[300]!.withOpacity(0.7), // 淡灰色高光
                        ringColor.withOpacity(0.95), // 品牌色
                        ringColor, // 主色
                        ringColor.withOpacity(0.8), // 較深品牌色
                        Colors.grey[700]!.withOpacity(0.9), // 深灰
                        Colors.black.withOpacity(0.7), // 黑色底部
                      ],
                      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(3),
                                          boxShadow: [
                        // 主要陰影
                        BoxShadow(
                          color: ringColor.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                        // 深色金屬反射
                        BoxShadow(
                          color: Colors.grey[400]!.withOpacity(0.4),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: const Offset(-1, -1),
                        ),
                        // 深度陰影
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(1, 3),
                        ),
                      ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                                             // 添加內部深色金屬線條
                       gradient: LinearGradient(
                         begin: Alignment.centerLeft,
                         end: Alignment.centerRight,
                         colors: [
                           Colors.grey[400]!.withOpacity(0.5), // 左側灰色高光
                           Colors.transparent, // 中間透明
                           Colors.transparent, // 中間透明
                           Colors.black.withOpacity(0.4), // 右側深色陰影
                         ],
                         stops: const [0.0, 0.3, 0.7, 1.0],
                       ),
                    ),
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
        // 背景層 - 淡藍灰質感背景配搭金屬卡片
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF5F7FA), // 非常淡的藍灰
                Color(0xFFE8EDF4), // 淡藍灰
                Color(0xFFF5F7FA), // 非常淡的藍灰
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // 添加細微的點狀紋理效果
        Container(
          child: CustomPaint(
            painter: _MetalTexturePainter(),
            size: Size.infinite,
          ),
        ),
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
                  Colors.transparent,
                  Color(0xFFF5F7FA).withOpacity(0.8),
                  Color(0xFFF5F7FA),
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

