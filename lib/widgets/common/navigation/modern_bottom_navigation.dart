import 'package:bowlingarsenal_app/widgets/common/navigation/floating_bottom_navigation.dart';
import 'package:flutter/material.dart';

/// 現代化底部導覽列組件
/// 使用動畫浮動樣式
class ModernBottomNavigation extends StatelessWidget {

  const ModernBottomNavigation({
    required this.currentIndex, required this.onTap, super.key,
  });
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}

 