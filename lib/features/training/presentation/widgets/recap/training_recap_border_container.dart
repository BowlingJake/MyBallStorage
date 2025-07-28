import 'package:flutter/material.dart';
import 'package:core_theme/core_theme.dart';

/// 邊框式容器基礎元件
/// 
/// 提供深色科技風的邊框樣式，支持三種邊框層級：
/// - primary: 主要邊框（發光效果）
/// - secondary: 次要邊框（標準樣式）
/// - tertiary: 輔助邊框（淡色樣式）
class TrainingRecapBorderContainer extends StatelessWidget {
  const TrainingRecapBorderContainer({
    super.key,
    required this.child,
    this.borderType = BorderType.secondary,
    this.padding,
    this.margin,
    this.height,
    this.width,
  });

  final Widget child;
  final BorderType borderType;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: _getDecoration(),
      child: child,
    );
  }

  BoxDecoration _getDecoration() {
    switch (borderType) {
      case BorderType.primary:
        return BoxDecoration(
          border: Border.all(
            color: BrandColors.accentColorDark,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: BrandColors.accentColorDark.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        );
      case BorderType.secondary:
        return BoxDecoration(
          border: Border.all(
            color: BrandColors.accentColorDark.withOpacity(0.4),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        );
      case BorderType.tertiary:
        return BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6),
        );
    }
  }
}

/// 邊框類型枚舉
enum BorderType {
  primary,   // 主要邊框（發光）
  secondary, // 次要邊框（標準）
  tertiary,  // 輔助邊框（淡色）
}

/// 設計Token - 尺寸定義
class TrainingRecapSizes {
  static const double headerHeight = 45.0;  // 從50減至45
  static const double statsHeight = 30.0;   // 從35減至30
  static const double gameCardHeight = 35.0; // 從38減至35
  static const double actionsHeight = 45.0;  // 從50減至45
  static const double scoreRowHeight = 18.0; // 從20減至18
  static const double pinRowHeight = 6.0;    // 從8減至6
  
  // 間距系統
  static const double spacingXS = 2.0;
  static const double spacingS = 4.0;
  static const double spacingM = 8.0;
  static const double spacingL = 12.0;
}

/// 設計Token - 顏色定義
class TrainingRecapColors {
  // 邊框顏色
  static const Color primaryBorder = BrandColors.accentColorDark;
  static const Color secondaryBorder = Color(0x664A9EAF);
  static const Color tertiaryBorder = Color(0x33FFFFFF);
  
  // 內容顏色
  static const Color strongText = Color(0xFFFFFFFF);
  static const Color mediumText = Color(0xB3FFFFFF);
  static const Color weakText = Color(0x80FFFFFF);
  
  // 分數顏色
  static const Color strike = Color(0xFFF39C12);  // Strike金色
  static const Color spare = BrandColors.accentColorDark;  // Spare藍綠
  static const Color open = Color(0xFFBDC3C7);   // Open灰色
  static const Color gameTitle = BrandColors.accentColorDark;
}