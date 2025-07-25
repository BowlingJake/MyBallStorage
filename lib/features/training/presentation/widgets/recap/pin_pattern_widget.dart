import 'package:flutter/material.dart';

class PinPatternWidget extends StatelessWidget {
  final Set<int> pinsDown;
  final Size size;

  const PinPatternWidget({
    super.key,
    required this.pinsDown,
    this.size = const Size(40, 30),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PinPatternPainter(pinsDown: pinsDown),
      size: size,
    );
  }
}

class PinPatternPainter extends CustomPainter {
  final Set<int> pinsDown;

  PinPatternPainter({required this.pinsDown});

  @override
  void paint(Canvas canvas, Size size) {
    final pinPositions = _getPinPositions(size);
    
    for (int pin = 1; pin <= 10; pin++) {
      final isDown = pinsDown.contains(pin);
      _drawPin(canvas, pinPositions[pin - 1], isDown);
    }
  }

  List<Offset> _getPinPositions(Size size) {
    // 保齡球瓶的標準三角形排列
    // 後排：7, 8, 9, 10 (4個)
    // 第三排：4, 5, 6 (3個)  
    // 第二排：2, 3 (2個)
    // 前排：1 (1個)
    
    final double pinRadius = size.width * 0.04;
    final double spacing = size.width * 0.08;
    
    // 計算起始位置（從前到後）
    final double centerX = size.width / 2;
    final double bottomY = size.height - pinRadius - 2;
    
    return [
      // Pin 1 (最前面)
      Offset(centerX, bottomY),
      
      // Pin 2, 3 (第二排)
      Offset(centerX - spacing / 2, bottomY - spacing * 0.866),
      Offset(centerX + spacing / 2, bottomY - spacing * 0.866),
      
      // Pin 4, 5, 6 (第三排)
      Offset(centerX - spacing, bottomY - spacing * 0.866 * 2),
      Offset(centerX, bottomY - spacing * 0.866 * 2),
      Offset(centerX + spacing, bottomY - spacing * 0.866 * 2),
      
      // Pin 7, 8, 9, 10 (第四排，最後面)
      Offset(centerX - spacing * 1.5, bottomY - spacing * 0.866 * 3),
      Offset(centerX - spacing / 2, bottomY - spacing * 0.866 * 3),
      Offset(centerX + spacing / 2, bottomY - spacing * 0.866 * 3),
      Offset(centerX + spacing * 1.5, bottomY - spacing * 0.866 * 3),
    ];
  }

  void _drawPin(Canvas canvas, Offset position, bool isDown) {
    final double pinRadius = 2.0;
    
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = isDown 
          ? Colors.red.withOpacity(0.8)  // 被擊倒的瓶子用紅色
          : Colors.white.withOpacity(0.9); // 站立的瓶子用白色

    // 繪製瓶子（小圓點）
    canvas.drawCircle(position, pinRadius, paint);
    
    // 如果被擊倒，加一個 X 標記
    if (isDown) {
      final strokePaint = Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = 1.0;
      
      // 畫 X
      canvas.drawLine(
        Offset(position.dx - pinRadius * 0.7, position.dy - pinRadius * 0.7),
        Offset(position.dx + pinRadius * 0.7, position.dy + pinRadius * 0.7),
        strokePaint,
      );
      canvas.drawLine(
        Offset(position.dx + pinRadius * 0.7, position.dy - pinRadius * 0.7),
        Offset(position.dx - pinRadius * 0.7, position.dy + pinRadius * 0.7),
        strokePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PinPatternPainter oldDelegate) {
    return pinsDown != oldDelegate.pinsDown;
  }
} 