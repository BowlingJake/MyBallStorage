import 'package:flutter/material.dart';

// Helper class for the grid pattern on the card
class GridPainter extends CustomPainter {
  GridPainter({
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
  bool shouldRepaint(covariant GridPainter oldDelegate) {
    return oldDelegate.gridColor != gridColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.spacing != spacing;
  }
} 