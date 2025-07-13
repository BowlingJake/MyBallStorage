import 'package:bowlingarsenal_app/shared/widgets/common/navigation/floating_bottom_navigation.dart';
import 'package:flutter/material.dart';

/// 現代化底部導覽列組件
/// 使用動畫浮動樣式
class ModernBottomNavigation extends StatelessWidget {
  const ModernBottomNavigation({
    required this.currentIndex,
    required this.onTap, // This is still needed to update the index in HomePage
    super.key,
  });
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // We now directly use the animated version
    return AnimatedFloatingBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
