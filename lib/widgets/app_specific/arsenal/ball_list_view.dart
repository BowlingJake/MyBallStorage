import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/theme/brand_colors.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bowlingarsenal_app/viewmodels/weapon_library_viewmodel.dart';
// import '../../../models/bowling_ball.dart';
import 'package:gradient_borders/gradient_borders.dart';
// import 'package:getwidget/getwidget.dart'; // GFListTile is no longer used
import 'package:bowlingarsenal_app/widgets/painters/grid_painter.dart';
import 'package:bowlingarsenal_app/widgets/painters/metal_texture_painter.dart';

// Helper function to create radial gradient overlay for matte effect
RadialGradient createMatteOverlay(List<Color> brandColors) {
  final primaryColor = brandColors.first;
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
                    const SizedBox(height: 6),
                    // 第二行：Core Type 和 Cover Type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Core Type: ${getCoreCategory(ball.core)}',
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
                            'Cover Type: ${ball.coverstock}',
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: ringColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
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
  const BallListView({
    required this.bowlingBalls,
    this.onBallTapped,
    this.onBallLongPress,
    super.key,
  });

  final List<BowlingBall> bowlingBalls;
  final Function(BowlingBall)? onBallTapped;
  final Function(BowlingBall)? onBallLongPress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final balls = ref.watch(filteredBowlingBallProvider);
    final balls = bowlingBalls; // Use passed list

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
            size: Size.infinite,
            painter: MetalTexturePainter(),
          ),
        ),
        // 網格圖案
        Positioned.fill(
          child: CustomPaint(
            size: Size.infinite,
            painter: GridPainter(
              gridColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              strokeWidth: 1.2,
              spacing: 28,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 32),
          itemCount: balls.length,
          itemBuilder: (context, index) {
            final ball = balls[index];
            return _BallCardItem(
              ball: ball,
              theme: Theme.of(context),
              onTap: () {
                onBallTapped?.call(ball);
                // print('Tapped on ${ball.name}');
              },
              onLongPress: () {
                onBallLongPress?.call(ball);
                // print('Long pressed on ${ball.name}');
              },
            );
          },
        ),
      ],
    );
  }
}

