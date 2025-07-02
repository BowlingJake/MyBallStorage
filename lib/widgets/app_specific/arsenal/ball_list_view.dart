import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/theme/brand_colors.dart';
// import 'package:bowlingarsenal_app/viewmodels/weapon_library_viewmodel.dart';
// import '../../../models/bowling_ball.dart';
import 'package:gradient_borders/gradient_borders.dart';
// import 'package:getwidget/getwidget.dart'; // GFListTile is no longer used

// Helper function to extract core category (Symmetric/Asymmetric)
String getCoreCategory(String coreName) {
  if (coreName.trim().isEmpty) {
    return '未知'; // Handle empty core names
  }
  final parts = coreName.trim().split(' ');
  return parts.last; // Return last part (works even if no space)
}

// Helper function to clean brand name (remove "bowling" word)
String cleanBrandName(String brandName) {
  return brandName
      .replaceAll(RegExp(r'\bbowling\b', caseSensitive: false), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' '); // Remove extra spaces
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
    final ringColor = brandPalette.shade600;

    // 根據品牌主色動態產生金屬光澤的漸層
    final Color brandColor = brandPalette.primary;
    final HSVColor hsvColor = HSVColor.fromColor(brandColor);

    final Color highlightColor = hsvColor.withValue( (hsvColor.value + 0.3).clamp(0.0, 1.0) ).withSaturation( (hsvColor.saturation - 0.2).clamp(0.0, 1.0) ).toColor();
    final Color shadowColor = hsvColor.withValue( (hsvColor.value - 0.4).clamp(0.0, 1.0) ).toColor();


    final brandGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        highlightColor,
        brandColor,
        shadowColor,
        brandColor,
        highlightColor,
      ],
      stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: GradientBoxBorder(
          gradient: brandGradient,
          width: 3, // 邊框寬度
        ),
        boxShadow: [
          // 主要深度陰影，讓卡片浮起來
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(4, 4),
          ),
          // 品牌色光暈效果
          BoxShadow(
            color: brandColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // 內層圓角需比外層小
          color: theme.colorScheme.surface,
        ),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(15), // 確保點擊效果也被裁切
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Stack(
              children: [
                // 主要內容 - 兩行佈局
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 第一行：球名
                    Text(
                      ball.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6.0),
                    // 第二行：Core Type 和 Cover Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Core Type: ${getCoreCategory(ball.core)}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(0.5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Cover Type: ${ball.coverstock}",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // 右上角品牌標籤（橢圓形，無框線）
                Positioned(
                  top: 0,
                  right: 0, 
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: ringColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Text(
                      cleanBrandName(ball.brand),
                      style: TextStyle(
                        color: ringColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
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

class BallListView extends ConsumerWidget {
  const BallListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final balls = ref.watch(filteredBowlingBallProvider);
    final balls = []; // Placeholder

    if (balls.isEmpty) {
      return const Center(
        child: Text('No balls match the current filters.'),
      );
    }

    return Stack(
      children: [
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
              theme: Theme.of(context),
              onTap: () {
                // onBallTap?.call(ball);
                print('Tapped on ${ball.name}');
              },
              onLongPress: () {
                onBallLongPress?.call(ball);
                print('Long pressed on ${ball.name}');
              },
            );
          },
        ),
      ],
    );
  }
}

