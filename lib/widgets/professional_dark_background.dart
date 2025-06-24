import 'package:flutter/material.dart';

/// Professional Dark 背景組件 - 專業深色風格
/// 使用指定的圖片作為背景，並提供深色疊加效果
class ProfessionalDarkBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  final Color overlayColor;
  final double overlayOpacity;

  const ProfessionalDarkBackground({
    super.key,
    required this.child,
    this.backgroundImage = 'images/Sport_Tech_Background.png',
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.6,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖片
          Positioned.fill(
            child: Image.asset(
              backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          
          // 深色疊加層
          Positioned.fill(
            child: Container(
              color: overlayColor.withOpacity(overlayOpacity),
            ),
          ),
          
          // 主要內容
          child,
        ],
      ),
    );
  }
} 