import 'package:flutter/material.dart';

/// 木雕文字組件 - 強烈的雕刻效果，像真的刻在木頭上
class WoodCarvedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;
  final Color? shadowColor;
  final Color? highlightColor;

  const WoodCarvedText({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
    this.textColor,
    this.shadowColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 更強烈的木雕配色
    final defaultTextColor = textColor ?? const Color(0xFF3E2723); // 非常深的木色
    final defaultShadowColor = shadowColor ?? Colors.black.withOpacity(0.6);
    final defaultHighlightColor = highlightColor ?? Colors.white.withOpacity(0.8);

    return Stack(
      children: [
        // 最深層陰影 - 強烈凹陷效果
        Transform.translate(
          offset: const Offset(3.0, 3.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 中層陰影
        Transform.translate(
          offset: const Offset(2.0, 2.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.3),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 淺層陰影
        Transform.translate(
          offset: const Offset(1.0, 1.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: defaultShadowColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 強烈高光層 - 左上方
        Transform.translate(
          offset: const Offset(-1.5, -1.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: defaultHighlightColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 次高光層
        Transform.translate(
          offset: const Offset(-0.5, -0.5),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white.withOpacity(0.4),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 主文字層 - 深度雕刻效果
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: defaultTextColor,
            letterSpacing: 0.5,
            shadows: [
              // 強烈內陰影 - 凹陷效果
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.4),
              ),
              // 深度陰影
              Shadow(
                offset: const Offset(3.0, 3.0),
                blurRadius: 6.0,
                color: Colors.black.withOpacity(0.2),
              ),
              // 高光效果
              Shadow(
                offset: const Offset(-1.0, -1.0),
                blurRadius: 2.0,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 超深度木雕文字組件 - 極致的雕刻效果
class DeepWoodCarvedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? textColor;

  const DeepWoodCarvedText({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextColor = textColor ?? const Color(0xFF2E1A15); // 極深的木色

    return Stack(
      children: [
        // 最深層陰影 - 極深凹陷
        Transform.translate(
          offset: const Offset(4.0, 4.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 深層陰影
        Transform.translate(
          offset: const Offset(3.0, 3.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.5),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 中層陰影
        Transform.translate(
          offset: const Offset(2.0, 2.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.3),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 淺層陰影
        Transform.translate(
          offset: const Offset(1.0, 1.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.15),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 強烈高光 - 左上方
        Transform.translate(
          offset: const Offset(-2.0, -2.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 中等高光
        Transform.translate(
          offset: const Offset(-1.0, -1.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 主文字層 - 極深雕刻
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: defaultTextColor,
            letterSpacing: 0.5,
            shadows: [
              // 極深內陰影
              Shadow(
                offset: const Offset(3.0, 3.0),
                blurRadius: 6.0,
                color: Colors.black.withOpacity(0.5),
              ),
              // 深度內陰影
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.3),
              ),
              // 淺層內陰影
              Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.2),
              ),
              // 強烈高光
              Shadow(
                offset: const Offset(-1.5, -1.5),
                blurRadius: 3.0,
                color: Colors.white.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 白色木雕文字組件 - 針對深色背景的白色雕刻效果
class WhiteWoodCarvedText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const WhiteWoodCarvedText({
    Key? key,
    required this.text,
    this.fontSize = 20.0,
    this.fontWeight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 深色陰影層 - 右下
        Transform.translate(
          offset: const Offset(2.0, 2.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 中等陰影
        Transform.translate(
          offset: const Offset(1.0, 1.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black.withOpacity(0.4),
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // 主文字層 - 白色雕刻
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.white.withOpacity(0.95),
            letterSpacing: 0.5,
            shadows: [
              // 強烈黑色陰影
              Shadow(
                offset: const Offset(2.0, 2.0),
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.7),
              ),
              // 深度陰影
              Shadow(
                offset: const Offset(1.0, 1.0),
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 