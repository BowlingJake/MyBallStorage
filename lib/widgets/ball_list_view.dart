import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/theme/brand_colors.dart';
import 'package:flutter/material.dart';
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
  final hsvColor = HSVColor.fromColor(color);
  var newHue = (hsvColor.hue + hueDelta) % 360;
  if (newHue < 0) newHue += 360;
  return hsvColor.withHue(newHue).toColor();
}

// Helper function to create radial gradient overlay for matte effect
RadialGradient createMatteOverlay(List<Color> brandColors) {
  final primaryColor = brandColors.isNotEmpty ? brandColors.first : Colors.grey;
  final matteColor1 = adjustHue(primaryColor, 15);
  final matteColor2 = adjustHue(primaryColor, -12);
  
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

    for (var i = -size.height; i < size.width + size.height; i += 24) {
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
  _GridPainter({
    required this.gridColor,
    required this.strokeWidth,
    required this.spacing,
  });
  final Color gridColor;
  final double strokeWidth;
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (var i = spacing; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }

    for (var i = spacing; i < size.height; i += spacing) {
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

class _SpecValue extends StatelessWidget {
  const _SpecValue({required this.label, required this.value, required this.theme});

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SpecDivider extends StatelessWidget {
  const _SpecDivider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: color.withOpacity(0.5),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final Color color;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Card Item Widget with Color Ring Design
class _BallCardItem extends StatelessWidget {

  const _BallCardItem({
    required this.ball,
    required this.theme,
    this.onTap,
    this.onLongPress,
  });
  final BowlingBall ball;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final ringColor = brandPalette.shade600;

    // 根據品牌主色動態產生金屬光澤的漸層
    final brandColor = brandPalette.primary;
    final hsvColor = HSVColor.fromColor(brandColor);

    final highlightColor = hsvColor.withValue( (hsvColor.value + 0.3).clamp(0.0, 1.0) ).withSaturation( (hsvColor.saturation - 0.2).clamp(0.0, 1.0) ).toColor();
    final shadowColor = hsvColor.withValue( (hsvColor.value - 0.4).clamp(0.0, 1.0) ).toColor();


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
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Stack(
              children: [
                // 主要內容 - 兩行佈局
                Row(
                  children: [
                    // 左側球的圖片
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 光暈背景
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: ringColor.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          // 球體圖片
                          ClipOval(
                            child: Image.network(
                              ball.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              // 圖片載入時顯示佔位符
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                              // 圖片載入失敗時顯示錯誤圖示
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error_outline, color: Colors.grey, size: 40),
                            ),
                          ),
                           // 添加霧面效果的 overlay
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: createMatteOverlay(brandPalette.getAllShades()),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 右側球的資訊
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 球名
                          Text(
                            ball.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          const SizedBox(height: 4),

                          // 品牌
                          Text(
                            cleanBrandName(ball.brand),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 8),
                          
                          // 核心和球皮資訊
                          Row(
                            children: [
                              _InfoChip(
                                icon: Icons.settings,
                                label: getCoreCategory(ball.core),
                                color: brandPalette.shade400,
                                theme: theme,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _InfoChip(
                                  icon: Icons.layers,
                                  label: ball.coverstock,
                                  color: brandPalette.shade400,
                                  theme: theme,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // 右上角的規格數據
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: ringColor.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _SpecValue(
                          label: 'RG',
                          value: ball.rg?.toStringAsFixed(3) ?? 'N/A',
                          theme: theme,
                        ),
                        _SpecDivider(color: ringColor),
                        _SpecValue(
                          label: 'Diff',
                          value: ball.diff?.toStringAsFixed(3) ?? 'N/A',
                          theme: theme,
                        ),
                        if (ball.intDiff != null && ball.intDiff! > 0) ...[
                          _SpecDivider(color: ringColor),
                          _SpecValue(
                            label: 'IntDiff',
                            value: ball.intDiff!.toStringAsFixed(3),
                            theme: theme,
                          ),
                        ],
                      ],
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

  const BallListView({
    required this.bowlingBalls, super.key,
    this.searchText = '',
    required this.onBallTapped,
  });
  final List<BowlingBall> bowlingBalls;
  final String searchText;
  final void Function(BowlingBall) onBallTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (bowlingBalls.isEmpty) {
      return Center(
        child: Text(
          searchText.isNotEmpty ? 'No balls match your search.' : 'No balls in your arsenal yet.',
          style: theme.textTheme.bodyMedium,
        ),
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
          padding: const EdgeInsets.only(bottom: 32),
          itemCount: bowlingBalls.length,
          itemBuilder: (context, index) {
            final ball = bowlingBalls[index];
            return _BallCardItem(
              ball: ball,
              theme: theme,
              onTap: () => onBallTapped(ball),
              onLongPress: () {
                // 長按事件可以自訂，例如彈出快速操作選單
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Long-pressed on ${ball.name}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

