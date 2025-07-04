import 'dart:ui'; // For BackdropFilter and ImageFilter

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// 浮動中心按鈕底部導覽列
/// 特色：中心按鈕浮動且有凹槽效果
class FloatingBottomNavigation extends StatelessWidget {

  const FloatingBottomNavigation({
    required this.currentIndex, required this.onTap, super.key,
    this.backgroundColor,
    this.centerButtonColor,
    this.notchMargin = 8.0,
  });
  final int currentIndex;
  final Function(int) onTap;
  final Color? backgroundColor;
  final Color? centerButtonColor;
  final double notchMargin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? Colors.white;
    final centerColor = centerButtonColor ?? theme.colorScheme.primary;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // 底部導覽列主體 - 帶凹槽
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, 70),
          painter: _BottomNavPainter(
            color: bgColor,
            notchMargin: notchMargin,
          ),
          child: SizedBox(
            height: 70,
            child: SafeArea(
              child: Row(
                children: [
                  // 左側按鈕
                  _buildNavItem(Icons.home_rounded, '首頁', 0, theme),
                  _buildNavItem(Icons.people_rounded, '社群', 1, theme),
                  
                  // 中間空白區域（為浮動按鈕留空間）
                  const Expanded(child: SizedBox()),
                  
                  // 右側按鈕
                  _buildNavItem(Icons.sports_baseball_rounded, '訓練', 3, theme),
                  _buildNavItem(Icons.account_circle_rounded, '個人', 4, theme),
                ],
              ),
            ),
          ),
        ),
        
        // 浮動中心按鈕
        Positioned(
          bottom: 25, // 浮動在導覽列上方
          child: GestureDetector(
            onTap: () => onTap(2),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [centerColor, centerColor.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: centerColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, ThemeData theme) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: isSelected
                  ? BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    )
                  : null,
                child: Icon(
                  icon,
                  color: isSelected 
                    ? theme.colorScheme.primary
                    : Colors.grey.shade500,
                  size: 24,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected 
                    ? theme.colorScheme.primary
                    : Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
    }
}

/// 自定義繪製器，用於創建帶凹槽的底部導覽列
class _BottomNavPainter extends CustomPainter {

  _BottomNavPainter({
    required this.color,
    required this.notchMargin,
  });
  final Color color;
  final double notchMargin;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();
    final shadowPath = Path();

    // 計算凹槽的尺寸和位置
    const notchRadius = 35.0; // 凹槽半徑
    final centerX = size.width / 2;
    final notchCenterY = notchMargin; // 凹槽中心Y位置

    // 繪製主體路徑
    _drawMainPath(path, size, centerX, notchCenterY, notchRadius);
    _drawMainPath(shadowPath, size, centerX, notchCenterY, notchRadius);

    // 繪製陰影
    canvas.drawPath(shadowPath, shadowPaint);
    
    // 繪製主體
    canvas.drawPath(path, paint);
  }

  void _drawMainPath(Path path, Size size, double centerX, double notchCenterY, double notchRadius) {
    // 起始點：左下角
    path.moveTo(0, size.height);
    
    // 左側直線到頂部
    path.lineTo(0, 20);
    
    // 頂部圓角
    path.quadraticBezierTo(0, 0, 20, 0);
    
    // 到凹槽開始位置
    path.lineTo(centerX - notchRadius - 20, 0);
    
    // 凹槽左側曲線
    path.quadraticBezierTo(
      centerX - notchRadius - 10, 0,
      centerX - notchRadius, notchCenterY,
    );
    
    // 凹槽弧形
    path.arcToPoint(
      Offset(centerX + notchRadius, notchCenterY),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    
    // 凹槽右側曲線
    path.quadraticBezierTo(
      centerX + notchRadius + 10, 0,
      centerX + notchRadius + 20, 0,
    );
    
    // 右側直線
    path.lineTo(size.width - 20, 0);
    
    // 右上角圓角
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    
    // 右側直線到底部
    path.lineTo(size.width, size.height);
    
    // 底部直線
    path.lineTo(0, size.height);
    
    path.close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 帶動畫效果的浮動底部導覽列
class AnimatedFloatingBottomNavigation extends StatefulWidget {

  const AnimatedFloatingBottomNavigation({
    required this.currentIndex, required this.onTap, super.key,
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
    const navBarHeight = 70;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: navBarHeight + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withOpacity(0.1),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              _buildNavItem(Iconsax.home_2, '首頁', 0, theme),
              _buildNavItem(Iconsax.people, '社群', 1, theme),
              _buildNavItem(Iconsax.add_square, '新增', 2, theme, isCenter: true),
              _buildNavItem(Iconsax.cup, '訓練', 3, theme),
              _buildNavItem(Iconsax.user, '個人', 4, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, ThemeData theme,
      {bool isCenter = false,}) {
    final isSelected = widget.currentIndex == index;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = Colors.white.withOpacity(0.7);

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(4), // Give some space for the shadow
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.7),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ] : [],
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.2 : 1.0,
                child: Icon(
                  icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: isCenter ? 30 : 22,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 