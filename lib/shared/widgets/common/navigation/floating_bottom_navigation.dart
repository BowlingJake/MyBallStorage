import 'dart:ui'; // For BackdropFilter and ImageFilter

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 添加 flutter_svg 包
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/shared/icons/my_flutter_app_icons.dart'; // 導入自定義圖標

/// 帶動畫效果的浮動底部導覽列
class AnimatedFloatingBottomNavigation extends StatefulWidget {
  const AnimatedFloatingBottomNavigation({
    required this.currentIndex,
    required this.onTap, // onTap 將由父元件處理導航邏輯
    super.key,
  });
  final int currentIndex;
  final Function(int) onTap;

  @override
  State<AnimatedFloatingBottomNavigation> createState() =>
      _AnimatedFloatingBottomNavigationState();
}

class _AnimatedFloatingBottomNavigationState
    extends State<AnimatedFloatingBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const navBarHeight = 70.0;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: navBarHeight + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.1),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2), width: 0.5),
            ),
          ),
          child: Row(
            // **RESTRUCTURED NAV ITEMS**
            children: [
              _buildNavItem(Iconsax.home_2, 0, theme),       // Home
              _buildNavItem(MyFlutterApp.search, 1, theme),          // Library
              _buildNavItem(MyFlutterApp.bowling_ball, 2, theme),  // Arsenal
              _buildNavItem(MyFlutterApp.bowling_pin, 3, theme),      // Training
              _buildNavItem(MyFlutterApp.trophy, 4, theme),   // Events
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
    ThemeData theme,
  ) {
    final isSelected = widget.currentIndex == index;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = Colors.white.withOpacity(0.7);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 只調用 onTap 回調，讓父元件處理導航邏輯
          widget.onTap(index);
        },
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(4), // Give some space for the shadow
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: selectedColor.withOpacity(0.7),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ]
                  : [],
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 250),
              scale: isSelected ? 1.2 : 1.0,
              child: Icon(
                icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: 24, // Standardized size
              ),
            ),
          ),
        ),
      ),
    );
  }
}
