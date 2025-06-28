import 'dart:ui';
import 'package:flutter/material.dart';

class GlowBorderButton extends StatelessWidget {
  final VoidCallback onTap;
  final double width;
  final double height;

  const GlowBorderButton({
    super.key,
    required this.onTap,
    this.width = 220.0,
    this.height = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Container(), // 空容器，無文字或圖示
      ),
    );
  }
} 