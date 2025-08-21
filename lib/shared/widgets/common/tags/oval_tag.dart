import 'package:flutter/material.dart';

/// 通用橢圓標籤組件
/// 提供與 arsenal scrollable bar 標籤一致的視覺風格
class OvalTag extends StatelessWidget {
  const OvalTag({
    super.key,
    required this.text,
    required this.color,
    this.onTap,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w600,
    this.horizontalPadding = 12,
    this.verticalPadding = 6,
    this.borderWidth = 1.5,
    this.backgroundOpacity = 0.1,
  });

  /// 標籤文字
  final String text;

  /// 標籤顏色（用於文字、邊框和背景）
  final Color color;

  /// 點擊回調
  final VoidCallback? onTap;

  /// 字體大小
  final double fontSize;

  /// 字體粗細
  final FontWeight fontWeight;

  /// 水平內邊距
  final double horizontalPadding;

  /// 垂直內邊距
  final double verticalPadding;

  /// 邊框寬度
  final double borderWidth;

  /// 背景透明度
  final double backgroundOpacity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(backgroundOpacity),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: borderWidth,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}