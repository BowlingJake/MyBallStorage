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
  // Get the primary brand color (first color in the gradient)
  Color primaryColor = brandColors.first;
  
  // Create colors with subtle hue adjustments for natural matte effect
  Color matteColor1 = adjustHue(primaryColor, 15.0);  // +15度 (恢復原本)
  Color matteColor2 = adjustHue(primaryColor, -12.0); // -12度 (稍微調整)
  
  // Debug: 打印霧面效果顏色
  print('Natural Matte - Primary: $primaryColor, +15°: $matteColor1, -12°: $matteColor2');
  
  return RadialGradient(
    center: Alignment(0.3, -0.2), // 恢復原本位置
    radius: 1.4, // 適中的範圍
    colors: [
      matteColor1.withOpacity(0.18), // 降低透明度避免紋路
      matteColor2.withOpacity(0.12), // 更自然的疊加
      primaryColor.withOpacity(0.06), // 微弱的原色疊加
      Colors.transparent, // 邊緣透明
    ],
    stops: [0.0, 0.4, 0.7, 1.0], // 簡化停止點
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
    // Helper function to parse string to double safely
    double? parseDouble(String? value) {
      if (value == null || value.isEmpty) return null;
      return double.tryParse(value);
    }

    // Helper function to get image URL based on ball name
    String getImageUrl(String ballName) {
      // 檢查是否有對應的本地圖片
      if (ballName == 'Jackal EXJ') {
        return 'assets/images/Jackal EXJ.jpg';
      }
      // 可以在這裡添加更多球的圖片映射
      // if (ballName == 'Other Ball Name') {
      //   return 'assets/images/Other Ball Name.jpg';
      // }
      
      // 如果沒有對應圖片，返回預設的佔位符
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
    this.gridColor = Colors.white24, // Color of the grid lines
    this.strokeWidth = 0.5,          // Thickness of the grid lines
    this.spacing = 8.0,             // Spacing between grid lines
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw vertical lines
    for (double i = spacing; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    // Draw horizontal lines
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

// Custom Card Item Widget
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
    // Use brand-specific gradient colors
    final List<Color> gradientColors = getGradientColorsForBrand(ball.brand, theme);
    
    // Debug: 打印品牌名稱和具體顏色值
    print('Ball: ${ball.name}, Brand: "${ball.brand}"');
    print('Colors: ${gradientColors.map((c) => c.toString()).join(', ')}');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18), // 確保內容也遵循圓角
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // 陰影顏色
            blurRadius: 6, // 模糊半徑
            spreadRadius: 0, // 擴散半徑為0，讓陰影更集中乾淨
            offset: const Offset(0, 3), // 垂直偏移，營造浮起感
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        // Apply brand gradient to the entire card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18), // 確保內容也遵循圓角
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          // Add radial gradient overlay for matte effect
          decoration: BoxDecoration(
            gradient: createMatteOverlay(gradientColors),
          ),
          child: Container(
            // Add very light overlay for better text readability while keeping colors vibrant
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.10), // 稍微提高可讀性
                  Colors.white.withOpacity(0.08), // 保持自然
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
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
                          // Line 1: Ball Name
                          Text(
                            ball.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // 改為白色以在鮮豔背景上更清晰
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          // Line 2: Brand Name
                          Text(
                            ball.brand,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w500,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6.0),
                          // Line 3: Core Type | Cover Type
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Core Type: ${getCoreCategory(ball.core)}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 精緻的垂直分隔線
                              Container(
                                width: 1,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Cover Type: ${ball.coverstock}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 2,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Add a subtle brand color indicator on the right
                    Container(
                      width: 4,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
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

    return ListView.builder(
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
    );
  }
}
