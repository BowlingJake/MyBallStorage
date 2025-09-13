import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';

/// 保齡球計分板數據模型
class BowlingFrame {
  final String firstBall;
  final String secondBall;
  final String thirdBall; // 僅第10格使用
  final int? cumulativeScore;
  
  const BowlingFrame({
    this.firstBall = '',
    this.secondBall = '',
    this.thirdBall = '',
    this.cumulativeScore,
  });
}

/// 獨立的保齡球計分板Widget
class BowlingScoreCardWidget extends StatelessWidget {
  final List<BowlingFrame> frames;
  final Color accentColor;
  final TextStyle? textStyle;
  final Function(int frameIndex)? onFrameTapped; // 新增點擊回調
  final bool showThirdBallInTenthFrame;
  final bool singleRow; // 單行顯示1~10格
  final double frameAspectRatio; // 每個frame的寬高比，預設1.0，可調小變更扁
  final bool useGlowText; // 是否使用發光字體
  final double frameBorderWidth; // 外框線寬
  final double frameBorderRadius; // 外框圓角
  final EdgeInsets frameMargin; // 每格外距
  final bool showFrameShadow; // 是否顯示外框陰影
  final bool useCumulativePill; // 底部分數以膠囊方式顯示
  final Color cumulativeBackgroundColor;
  final EdgeInsets cumulativePadding;
  final double cumulativeBorderRadius;
  final TextStyle? cumulativeTextStyle;
  final bool showSeparatorLine;
  final Color? headerBarColor; // 單行模式下，頂部編號行的背景色
  final bool suppressEdgeMargins; // 首尾格子移除外側邊距，貼齊邊界
  final bool showHeaderNumbers; // 單行模式：顯示數字還是細條
  final double headerBarHeight; // 單行模式：細條高度
  final int tenthFrameFlex; // 第10格的寬度比例（單行時）
  final double? innerBorderWidth; // 內層描邊寬度
  final Color? innerBorderColor; // 內層描邊顏色
  final LinearGradient? frameFillGradient; // 格子內部細膩漸層
  // 分瓶標記（第一球）
  final List<bool>? isSplitPerFrame; // 長度10，true 表示該格第一球為開花
  
  // 球瓶視覺化相關
  final bool showPinVisualization; // 是否顯示球瓶視覺化
  final List<List<bool>>? pinStatesPerFrame; // 每個frame的球瓶狀態，長度10
  final PinVisualizationConfig? pinVisualizationConfig; // 球瓶視覺化配置
  
  
  const BowlingScoreCardWidget({
    super.key,
    required this.frames,
    this.accentColor = const Color(0xFF00B2A9),
    this.textStyle,
    this.onFrameTapped, // 新增參數
    this.showThirdBallInTenthFrame = true,
    this.singleRow = false,
    this.frameAspectRatio = 1.0,
    this.useGlowText = true,
    this.frameBorderWidth = 2.0,
    this.frameBorderRadius = 8.0,
    this.frameMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
    this.showFrameShadow = true,
    this.useCumulativePill = false,
    this.cumulativeBackgroundColor = const Color(0xFF6B7280),
    this.cumulativePadding = const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.cumulativeBorderRadius = 6.0,
    this.cumulativeTextStyle,
    this.showSeparatorLine = true,
    this.headerBarColor,
    this.suppressEdgeMargins = false,
    this.showHeaderNumbers = true,
    this.headerBarHeight = 6.0,
    this.tenthFrameFlex = 1,
    this.innerBorderWidth,
    this.innerBorderColor,
    this.frameFillGradient,
    this.isSplitPerFrame,
    this.showPinVisualization = false, // 預設不顯示
    this.pinStatesPerFrame,
    this.pinVisualizationConfig,
  });

  @override
  Widget build(BuildContext context) {
    // 確保有10格數據
    final paddedFrames = List<BowlingFrame>.from(frames);
    while (paddedFrames.length < 10) {
      paddedFrames.add(const BowlingFrame());
    }

    final baseTextStyle = textStyle ?? const TextStyle(
      color: Colors.white,
      fontFamily: 'Electrolize',
      fontWeight: FontWeight.bold,
    );
    final glowingTextStyle = useGlowText
        ? baseTextStyle.copyWith(shadows: [for (double i = 1; i < 3; i++) Shadow(color: accentColor, blurRadius: 2 * i)])
        : baseTextStyle;

    if (singleRow) {
      // 單行顯示所有10格
      return Column(
        children: [
          if (showHeaderNumbers)
            Container(
              color: headerBarColor,
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: List.generate(10, (index) {
                  return Expanded(
                    child: Text(
                      (index + 1).toString(),
                      textAlign: TextAlign.center,
                      style: glowingTextStyle.copyWith(fontSize: 12),
                    ),
                  );
                }),
              ),
            )
          else
            Container(
              height: headerBarHeight,
              color: headerBarColor ?? Colors.green,
            ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(10, (index) {
              final EdgeInsets customMargin = suppressEdgeMargins
                  ? EdgeInsets.only(
                      left: index == 0 ? 0 : frameMargin.left,
                      right: index == 9 ? 0 : frameMargin.right,
                      top: frameMargin.top,
                      bottom: frameMargin.bottom,
                    )
                  : frameMargin;
              final int flexValue = index == 9 ? (tenthFrameFlex <= 0 ? 1 : tenthFrameFlex) : 1;
              return Expanded(
                flex: flexValue,
                child: _buildFrame(
                  context,
                  index + 1,
                  paddedFrames[index],
                  glowingTextStyle,
                  margin: customMargin,
                ),
              );
            }),
          ),
        ],
      );
    } else {
      // 兩行顯示（原樣）
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
            children: List.generate(5, (index) {
              final EdgeInsets customMargin = suppressEdgeMargins
                  ? EdgeInsets.only(
                      left: index == 0 ? 0 : frameMargin.left,
                      right: index == 4 ? 0 : frameMargin.right,
                      top: frameMargin.top,
                      bottom: frameMargin.bottom,
                    )
                  : frameMargin;
              return Expanded(
                child: _buildFrame(
                  context,
                  index + 1,
                  paddedFrames[index],
                  glowingTextStyle,
                  margin: customMargin,
                ),
              );
            }),
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
            children: List.generate(5, (index) {
              final EdgeInsets customMargin = suppressEdgeMargins
                  ? EdgeInsets.only(
                      left: index == 0 ? 0 : frameMargin.left,
                      right: index == 4 ? 0 : frameMargin.right,
                      top: frameMargin.top,
                      bottom: frameMargin.bottom,
                    )
                  : frameMargin;
              return Expanded(
                child: _buildFrame(
                  context,
                  index + 6,
                  paddedFrames[index + 5],
                  glowingTextStyle,
                  margin: customMargin,
                ),
              );
            }),
          ),
        ],
      );
    }
  }

  Widget _buildFrame(BuildContext context, int frameNumber, BowlingFrame frameData, TextStyle glowingTextStyle, {EdgeInsets? margin}) {
    return AspectRatio(
      aspectRatio: frameAspectRatio,
      child: GestureDetector(
        onTap: onFrameTapped != null ? () => onFrameTapped!(frameNumber - 1) : null, // 轉換為0-based index
        child: Container(
          margin: margin ?? frameMargin,
          decoration: BoxDecoration(
            color: frameFillGradient == null ? Colors.black : null,
            gradient: frameFillGradient,
            borderRadius: BorderRadius.circular(frameBorderRadius),
            border: Border.all(
              color: accentColor,
              width: frameBorderWidth,
            ),
            boxShadow: showFrameShadow
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.18),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              if (innerBorderWidth != null && innerBorderWidth! > 0)
                Positioned.fill(
                  child: Container(
                    margin: EdgeInsets.all(innerBorderWidth!),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        (frameBorderRadius - innerBorderWidth!).clamp(0, frameBorderRadius),
                      ),
                      border: Border.all(
                        color: innerBorderColor ?? accentColor.withOpacity(0.4),
                        width: innerBorderWidth!,
                      ),
                    ),
                  ),
                ),
              ClipRRect(
                borderRadius: BorderRadius.circular((frameBorderRadius - 2).clamp(0, frameBorderRadius)),
                child: _buildFrameBody(context, frameNumber, frameData, glowingTextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrameBody(BuildContext context, int frameNumber, BowlingFrame frameData, TextStyle glowingTextStyle) {
    final bool isTenthFrame = frameNumber == 10;
    
    Widget scoreArea;

    if (isTenthFrame && showThirdBallInTenthFrame) {
      // 第10格可以有3球
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBox(frameData.firstBall, glowingTextStyle, showRightBorder: true, highlightAsSplit: isSplitPerFrame != null && isSplitPerFrame!.length > (frameNumber - 1) && isSplitPerFrame![frameNumber - 1])),
          Expanded(child: _buildSmallScoreBox(frameData.secondBall, glowingTextStyle, showRightBorder: true)),
          Expanded(child: _buildSmallScoreBox(frameData.thirdBall, glowingTextStyle, showRightBorder: false)),
        ],
      );
    } else {
      // 第1-9格
      scoreArea = Row(
        children: [
          Expanded(child: _buildSmallScoreBox(frameData.firstBall, glowingTextStyle, showRightBorder: true, highlightAsSplit: isSplitPerFrame != null && isSplitPerFrame!.length > (frameNumber - 1) && isSplitPerFrame![frameNumber - 1])),
          Expanded(child: _buildSmallScoreBox(frameData.secondBall, glowingTextStyle, showRightBorder: false)),
        ],
      );
    }

    final bool hasScore = frameData.cumulativeScore != null;
    
    // 取得該frame的球瓶狀態
    List<bool> framePinStates = List.generate(10, (_) => false);
    if (showPinVisualization && 
        pinStatesPerFrame != null && 
        pinStatesPerFrame!.length > (frameNumber - 1)) {
      framePinStates = pinStatesPerFrame![frameNumber - 1];
    }
    
    return Column(
      children: [
        Expanded(flex: 2, child: scoreArea),
        if (showSeparatorLine)
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: accentColor,
          ),
        // 累積分數區域 - 調整flex
        Expanded(
          flex: showPinVisualization ? 2 : 3,
          child: Center(
            child: hasScore
                ? (useCumulativePill
                    ? Container(
                        padding: cumulativePadding,
                        decoration: BoxDecoration(
                          color: cumulativeBackgroundColor,
                          borderRadius: BorderRadius.circular(cumulativeBorderRadius),
                        ),
                        child: Text(
                          frameData.cumulativeScore!.toString(),
                          style: (cumulativeTextStyle ?? glowingTextStyle.copyWith(fontSize: 12)),
                        ),
                      )
                    : Text(
                        frameData.cumulativeScore!.toString(),
                        style: glowingTextStyle.copyWith(fontSize: 20),
                      ))
                : const SizedBox.shrink(),
          ),
        ),
        // 球瓶視覺化區域
        if (showPinVisualization)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: PinVisualizationWidget.withConfig(
                pinStates: framePinStates,
                width: double.infinity,
                config: pinVisualizationConfig ?? PinVisualizationConfig(
                  absolutePinRadius: 3.0, // 內嵌模式使用較小的固定大小
                  spacingScaleX: 2.0,
                  spacingScaleY: 1.2,
                  radiusToSpacingMax: 0.0,
                  showFrame: false, // 不顯示外框，因為已經在計分板frame內
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSmallScoreBox(String score, TextStyle textStyle, {required bool showRightBorder, bool highlightAsSplit = false}) {
    return Container(
      decoration: BoxDecoration(
        border: showRightBorder ? Border(
          right: BorderSide(
            color: accentColor.withOpacity(0.7),
            width: 1.5,
          ),
        ) : null,
      ),
      child: Center(
        child: highlightAsSplit && score.isNotEmpty
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 1.5),
                  ),
                  child: Text(score, style: textStyle),
                ),
              )
            : Text(score, style: textStyle),
      ),
    );
  }
} 