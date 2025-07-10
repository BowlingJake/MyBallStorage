import 'package:flutter/material.dart';

/// 保齡球計分板數據模型
class BowlingFrame {
  final String firstBall;
  final String secondBall;
  final String thirdBall; // 僅第10格使用
  final int cumulativeScore;
  
  const BowlingFrame({
    this.firstBall = '',
    this.secondBall = '',
    this.thirdBall = '',
    this.cumulativeScore = 0,
  });
}

/// 獨立的保齡球計分板Widget
class BowlingScoreCardWidget extends StatelessWidget {
  final List<BowlingFrame> frames;
  final Color accentColor;
  final TextStyle? textStyle;
  final Function(int frameIndex)? onFrameTapped; // 新增點擊回調
  
  const BowlingScoreCardWidget({
    super.key,
    required this.frames,
    this.accentColor = const Color(0xFF00B2A9),
    this.textStyle,
    this.onFrameTapped, // 新增參數
  });

  @override
  Widget build(BuildContext context) {
    // 確保有10格數據
    final paddedFrames = List<BowlingFrame>.from(frames);
    while (paddedFrames.length < 10) {
      paddedFrames.add(const BowlingFrame());
    }

    final glowingTextStyle = textStyle ?? TextStyle(
      color: Colors.white,
      fontFamily: 'Electrolize',
      shadows: [
        for (double i = 1; i < 3; i++) 
          Shadow(color: accentColor, blurRadius: 2 * i),
      ],
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        // --- 第一排編號 (1-5) ---
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Text(
                (index + 1).toString(),
                textAlign: TextAlign.center,
                style: glowingTextStyle.copyWith(fontSize: 14),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        
        // --- 第一排計分格 (1-5) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => 
            Expanded(child: _buildFrame(context, index + 1, paddedFrames[index], glowingTextStyle))
          ),
        ),
        const SizedBox(height: 12),
        
        // --- 第二排編號 (6-10) ---
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Text(
                (index + 6).toString(),
                textAlign: TextAlign.center,
                style: glowingTextStyle.copyWith(fontSize: 14),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        
        // --- 第二排計分格 (6-10) ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) => 
            Expanded(child: _buildFrame(context, index + 6, paddedFrames[index + 5], glowingTextStyle))
          ),
        ),
      ],
    );
  }

  Widget _buildFrame(BuildContext context, int frameNumber, BowlingFrame frameData, TextStyle glowingTextStyle) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: GestureDetector(
        onTap: onFrameTapped != null ? () => onFrameTapped!(frameNumber - 1) : null, // 轉換為0-based index
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: accentColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: _buildFrameBody(context, frameNumber, frameData, glowingTextStyle),
          ),
        ),
      ),
    );
  }

  Widget _buildFrameBody(BuildContext context, int frameNumber, BowlingFrame frameData, TextStyle glowingTextStyle) {
    final bool isTenthFrame = frameNumber == 10;
    
    Widget scoreArea;

    if (isTenthFrame) {
      // 第10格可以有3球
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBox(frameData.firstBall, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBox(frameData.secondBall, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBox(frameData.thirdBall, glowingTextStyle, showRightBorder: false)),
        ],
      );
    } else {
      // 第1-9格
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBox(frameData.firstBall, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBox(frameData.secondBall, glowingTextStyle, showRightBorder: false)),
        ],
      );
    }

    return Column(
      children: [
        Expanded(flex: 2, child: scoreArea),
        Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.2),
                accentColor,
                accentColor.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              frameData.cumulativeScore > 0 ? frameData.cumulativeScore.toString() : '',
              style: glowingTextStyle.copyWith(fontSize: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScoreBox(String score, TextStyle textStyle, {required bool showRightBorder}) {
    return Container(
      decoration: BoxDecoration(
        border: showRightBorder ? Border(
          right: BorderSide(
            color: accentColor.withOpacity(0.7),
            width: 1.5,
          ),
        ) : null,
      ),
      child: Center(child: Text(score, style: textStyle)),
    );
  }
} 