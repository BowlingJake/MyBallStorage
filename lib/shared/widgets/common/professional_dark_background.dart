import 'package:flutter/material.dart';

/// Professional Dark 背景組件 - 專業深色風格
/// 使用指定的圖片作為背景，並提供深色疊加效果
class ProfessionalDarkBackground extends StatelessWidget {
  const ProfessionalDarkBackground({
    required this.child,
    super.key,
    // 路徑現在應該是完整的，例如 'assets/images/Sport_Tech_Background.webp'
    this.backgroundImage = 'assets/images/Sport_Tech_Background.webp',
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.6,
  });
  final Widget child;
  final String backgroundImage;
  final Color overlayColor;
  final double overlayOpacity;
  // cutoutRects is removed as ColorFiltered does not support cutouts.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 背景圖片 - 使用 ColorFiltered 實現更高效的顏色疊加
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              overlayColor.withOpacity(overlayOpacity),
              BlendMode.darken, // 使用 darken 混合模式來疊加深色
            ),
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),

          // 主要內容
          child,
        ],
      ),
    );
  }
}
