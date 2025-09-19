// 檔案路徑： professional_dark_background.dart

import 'package:flutter/material.dart';

class ProfessionalDarkBackground extends StatelessWidget {
  const ProfessionalDarkBackground({
    required this.child,
    super.key,
    // *** 請確保這個路徑是您專案中正確的圖片路徑 ***
    this.backgroundImage = 'assets/images/Sport_Tech_Background.webp',
    this.backgroundColor = const Color(0xFF121212),
    this.centerLogoAsset,
    this.logoOpacity = 0.08,
    this.overlayColor = const Color(0xFF1F1F1F),
    this.overlayOpacity = 0.0,
  });
  final Widget child;
  final String backgroundImage;
  final Color backgroundColor;
  final String? centerLogoAsset;
  final double logoOpacity;
  final Color overlayColor;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    // 使用純色深灰背景
    return Container(
      color: backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (centerLogoAsset != null) ...[
              Center(
                child: Opacity(
                  opacity: logoOpacity,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0.2126, 0.7152, 0.0722, 0, 0,
                      0, 0, 0, 1, 0,
                    ]),
                    child: Image.asset(
                      centerLogoAsset!,
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
            if (overlayOpacity > 0)
              Container(
                color: overlayColor.withOpacity(overlayOpacity),
              ),
            child,
          ],
        ),
      ),
    );
  }
}