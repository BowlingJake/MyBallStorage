import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScoreFrameWidget extends StatelessWidget {
  final int frameNumber; // 第幾格 (1-10)
  final String? ball1Score; // 第一球得分或標記 (例如 "X", "7")
  final String? ball2Score; // 第二球得分或標記 (例如 "/", "2")
  final String? ball3Score; // 第三球得分或標記 (僅第10格用)
  final String? frameTotalScore; // 本局累計總分
  final bool isTenthFrame; // 是否為第10格
  final double availableWidth; // 新增參數
  final bool isCurrentFrame;

  const ScoreFrameWidget({
    super.key,
    required this.frameNumber,
    this.ball1Score,
    this.ball2Score,
    this.ball3Score, // 只有第10格才可能用到
    this.frameTotalScore,
    this.isTenthFrame = false,
    required this.availableWidth, // 新增參數
    this.isCurrentFrame = false,
  });

  @override
  Widget build(BuildContext context) {
    const BorderSide borderSide = BorderSide(color: Colors.black, width: 0.5);

    // 計算各部分的高度比例，考慮邊框寬度
    final double frameNumberHeight = (availableWidth - 2) * 0.3; // 減去邊框寬度
    final double scoreBoxHeight = (availableWidth - 2) * 0.4; // 減去邊框寬度
    final double totalScoreHeight = (availableWidth - 2) * 0.3; // 減去邊框寬度

    // 計算小格子的寬度，考慮邊框寬度
    final double smallBoxWidth = (availableWidth - (isTenthFrame ? 3 : 2)) / (isTenthFrame ? 3 : 2); // 減去邊框寬度

    return Container(
      width: availableWidth,
      height: availableWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: isCurrentFrame ? Colors.blue : Colors.grey,
          width: isCurrentFrame ? 1.0 : 0.5, // 減小高亮邊框的寬度
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // 局數顯示
          Container(
            height: frameNumberHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              border: const Border(bottom: borderSide),
              color: isCurrentFrame ? Colors.blue.withOpacity(0.1) : null,
            ),
            child: Center(
              child: Text(
                frameNumber.toString(),
                style: TextStyle(
                  fontSize: availableWidth * 0.15,
                  fontWeight: FontWeight.bold,
                  color: isCurrentFrame ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ),
          // 得分格子
          SizedBox(
            height: scoreBoxHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildBallScoreBox(
                  ball1Score,
                  smallBoxWidth,
                  scoreBoxHeight,
                  borderSide,
                  isLeftMost: true,
                  fontSize: availableWidth * 0.15,
                ),
                _buildBallScoreBox(
                  ball2Score,
                  smallBoxWidth,
                  scoreBoxHeight,
                  borderSide,
                  fontSize: availableWidth * 0.15,
                ),
                if (isTenthFrame)
                  _buildBallScoreBox(
                    ball3Score,
                    smallBoxWidth,
                    scoreBoxHeight,
                    borderSide,
                    isRightMost: true,
                    fontSize: availableWidth * 0.15,
                  ),
              ],
            ),
          ),
          // 總分顯示
          Container(
            height: totalScoreHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(top: borderSide),
            ),
            child: Center(
              child: Text(
                frameTotalScore ?? "",
                style: TextStyle(
                  fontSize: availableWidth * 0.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBallScoreBox(
    String? score,
    double width,
    double height,
    BorderSide border, {
    bool isLeftMost = false,
    bool isRightMost = false,
    required double fontSize,
  }) {
    Widget displayWidget;
    
    if (score == "X") {
      displayWidget = SvgPicture.asset(
        'assets/images/strike_symbol.svg',
        width: width * 0.8,
        height: height * 0.8,
        fit: BoxFit.contain,
      );
    } else if (score == "/") {
      displayWidget = SvgPicture.asset(
        'assets/images/spare_symbol.svg',
        width: width * 0.8,
        height: height * 0.8,
        fit: BoxFit.contain,
      );
    } else {
      displayWidget = Text(
        score ?? "",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          left: isLeftMost ? BorderSide.none : border,
          right: isRightMost ? BorderSide.none : border,
        ),
      ),
      child: Center(child: displayWidget),
    );
  }
}
