import 'package:flutter/material.dart';
import 'floating_bottom_navigation.dart';

/// 現代化底部導覽列組件
/// 使用動畫浮動樣式
class ModernBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? centerButtonColor;
  
  const ModernBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.backgroundColor,
    this.centerButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: backgroundColor,
      centerButtonColor: centerButtonColor,
    );
  }

}

 