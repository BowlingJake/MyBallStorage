import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';

/// 受控的計分板組件：不持有業務邏輯，只渲染與回傳事件
class ScoringBoard extends StatelessWidget {
  const ScoringBoard({
    super.key,
    required this.frames,
    required this.onFrameTapped,
    required this.showThirdBallInTenthFrame,
    this.singleRow = true,
    this.frameAspectRatio = 0.9,
    this.title,
    this.padding = const EdgeInsets.all(16.0),
    this.removeOuterContainer = false,
    this.useGlowText = false,
    this.frameMargin = const EdgeInsets.symmetric(horizontal: 1, vertical: 0.5),
    this.frameBorderWidth = 1.2,
    this.frameBorderRadius = 6.0,
    this.showFrameShadow = false,
    this.suppressEdgeMargins = true,
    this.showHeaderNumbers = false,
    this.headerBarHeight = 6.0,
    this.headerBarColor,
    this.tenthFrameFlex = 1,
    this.accentColor,
    this.innerBorderWidth,
    this.innerBorderColor,
    this.frameFillGradient,
    this.useCumulativePill,
    this.cumulativeBackgroundColor,
    this.cumulativePadding,
    this.cumulativeBorderRadius,
    this.cumulativeTextStyle,
    this.showSeparatorLine,
    this.isSplitPerFrame,
    this.showPinVisualization = false, // 是否顯示內嵌球瓶視覺化
    this.pinStatesPerFrame, // 每個frame的球瓶狀態
    this.pinVisualizationConfig, // 球瓶視覺化配置
  });

  final List<BowlingFrame> frames;
  final void Function(int frameIndex) onFrameTapped;
  final bool showThirdBallInTenthFrame;
  final bool singleRow;
  final double frameAspectRatio;
  final String? title;
  final EdgeInsetsGeometry padding;
  final bool removeOuterContainer;
  final bool useGlowText;
  final EdgeInsets frameMargin;
  final double frameBorderWidth;
  final double frameBorderRadius;
  final bool showFrameShadow;
  final bool suppressEdgeMargins;
  final bool showHeaderNumbers;
  final double headerBarHeight;
  final Color? headerBarColor;
  final int tenthFrameFlex;
  final Color? accentColor;
  final double? innerBorderWidth;
  final Color? innerBorderColor;
  final LinearGradient? frameFillGradient;
  final bool? useCumulativePill;
  final Color? cumulativeBackgroundColor;
  final EdgeInsets? cumulativePadding;
  final double? cumulativeBorderRadius;
  final TextStyle? cumulativeTextStyle;
  final bool? showSeparatorLine;
  final List<bool>? isSplitPerFrame;
  // 新增：內嵌球瓶視覺化相關參數
  final bool showPinVisualization;
  final List<List<bool>>? pinStatesPerFrame;
  final PinVisualizationConfig? pinVisualizationConfig;
  

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
        ],
        BowlingScoreCardWidget(
          frames: frames,
          onFrameTapped: onFrameTapped,
          showThirdBallInTenthFrame: showThirdBallInTenthFrame,
          singleRow: singleRow,
          frameAspectRatio: frameAspectRatio,
          useGlowText: useGlowText,
          accentColor: accentColor ?? const Color(0xFF00B2A9),
          frameBorderWidth: frameBorderWidth,
          frameBorderRadius: frameBorderRadius,
          frameMargin: frameMargin,
          showFrameShadow: showFrameShadow,
          suppressEdgeMargins: suppressEdgeMargins,
          showHeaderNumbers: showHeaderNumbers,
          headerBarHeight: headerBarHeight,
          headerBarColor: headerBarColor,
          tenthFrameFlex: tenthFrameFlex,
          innerBorderWidth: innerBorderWidth,
          innerBorderColor: innerBorderColor,
          frameFillGradient: frameFillGradient,
          useCumulativePill: useCumulativePill ?? false,
          cumulativeBackgroundColor: cumulativeBackgroundColor ?? const Color(0xFF6B7280),
          cumulativePadding: cumulativePadding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          cumulativeBorderRadius: cumulativeBorderRadius ?? 6.0,
          cumulativeTextStyle: cumulativeTextStyle,
          showSeparatorLine: showSeparatorLine ?? true,
          isSplitPerFrame: isSplitPerFrame,
          // 新增：內嵌球瓶視覺化參數
          showPinVisualization: showPinVisualization,
          pinStatesPerFrame: pinStatesPerFrame,
          pinVisualizationConfig: pinVisualizationConfig,
        ),
      ],
    );

    if (removeOuterContainer) {
      return Padding(padding: padding, child: content);
    }

    return Card(child: Padding(padding: padding, child: content));
  }
}


