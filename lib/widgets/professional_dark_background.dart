import 'package:flutter/material.dart';

/// Professional Dark 背景組件 - 專業深色風格
/// 使用指定的圖片作為背景，並提供深色疊加效果
class ProfessionalDarkBackground extends StatelessWidget {
  final Widget child;
  final String backgroundImage;
  final Color overlayColor;
  final double overlayOpacity;
  final List<Rect>? cutoutRects;

  const ProfessionalDarkBackground({
    super.key,
    required this.child,
    this.backgroundImage = 'images/Sport_Tech_Background.png',
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.6,
    this.cutoutRects,
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
          
          // 使用 CustomPaint 繪製帶有 "開孔" 的疊加層
          Positioned.fill(
            child: CustomPaint(
              painter: _OverlayPainter(
                overlayColor: overlayColor.withOpacity(overlayOpacity),
                cutoutRects: cutoutRects,
              ),
            ),
          ),
          
          // 主要內容
          child,
        ],
      ),
    );
  }
}

/// 一個自訂的繪製器，用於繪製一個帶有矩形孔洞的疊加層。
class _OverlayPainter extends CustomPainter {
  final Color overlayColor;
  final List<Rect>? cutoutRects;

  _OverlayPainter({required this.overlayColor, this.cutoutRects});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    // 建立一個覆蓋整個畫布的路徑
    Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 如果有提供開孔區域，就從主路徑中減去它們
    if (cutoutRects != null) {
      for (final rect in cutoutRects!) {
        // 使用 Path.combine 的 difference 操作來 "挖洞"
        path = Path.combine(
          PathOperation.difference,
          path,
          Path()..addRect(rect),
        );
      }
    }
    
    // 將最終的路徑 (可能帶有孔洞) 繪製到畫布上
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _OverlayPainter oldDelegate) {
    // 僅當顏色或開孔區域列表發生變化時才重繪
    return oldDelegate.overlayColor != overlayColor ||
           oldDelegate.cutoutRects != cutoutRects;
  }
} 