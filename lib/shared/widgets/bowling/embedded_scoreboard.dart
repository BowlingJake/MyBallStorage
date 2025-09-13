import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/scoring_board.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_visualization_config.dart';

/// 球瓶數據封裝
class PinData {
  final List<int> rolls19;
  final List<List<bool>> rollStates19;
  final List<int> rolls10;
  final List<List<bool>> rollStates10;

  const PinData({
    required this.rolls19,
    required this.rollStates19,
    required this.rolls10,
    required this.rollStates10,
  });
}

/// 內嵌式計分板 - 球瓶視覺化直接在每個frame內部
class EmbeddedScoreboard extends StatelessWidget {
  final List<BowlingFrame> frames;
  final void Function(int frameIndex) onFrameTapped;
  final bool showThirdBallInTenthFrame;
  final PinData pinData;
  final bool showPinVisualization;
  final String? title;
  final Color? accentColor;

  const EmbeddedScoreboard({
    super.key,
    required this.frames,
    required this.onFrameTapped,
    required this.showThirdBallInTenthFrame,
    required this.pinData,
    this.showPinVisualization = true,
    this.title,
    this.accentColor,
  });

  /// 將 PinData 轉換為每個frame的球瓶狀態
  List<List<bool>> _generatePinStatesPerFrame() {
    List<List<bool>> result = [];
    
    for (int frameIndex = 0; frameIndex < 10; frameIndex++) {
      List<bool> pinStates;
      
      if (frameIndex < 9) {
        // 1-9格：使用PinVisualizationHelper
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: pinData.rolls19,
          rollStates: pinData.rollStates19,
          frameIndex: frameIndex,
        );
      } else {
        // 第10格：使用第10格數據
        pinStates = PinVisualizationHelper.getFramePinStates(
          rolls: pinData.rolls10,
          rollStates: pinData.rollStates10,
          frameIndex: frameIndex,
        );
      }
      
      result.add(pinStates);
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final pinStatesPerFrame = _generatePinStatesPerFrame();
    
    return ScoringBoard(
      title: title,
      frames: frames,
      onFrameTapped: onFrameTapped,
      showThirdBallInTenthFrame: showThirdBallInTenthFrame,
      // 使用開發者頁面的現有配置
      singleRow: true,
      frameAspectRatio: 0.78,
      removeOuterContainer: true,
      padding: EdgeInsets.zero,
      useGlowText: false,
      frameMargin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.0),
      frameBorderWidth: 1.0,
      frameBorderRadius: 4.0,
      showFrameShadow: false,
      showHeaderNumbers: true,
      headerBarHeight: 0.0,
      tenthFrameFlex: 1,
      accentColor: accentColor ?? Colors.blue,
      // 內嵌球瓶視覺化配置
      showPinVisualization: showPinVisualization,
      pinStatesPerFrame: pinStatesPerFrame,
      pinVisualizationConfig: PinVisualizationConfig(
        absolutePinRadius: 3.0, // 內嵌模式使用小而清晰的球瓶
        spacingScaleX: 2.0,
        spacingScaleY: 1.2,
        radiusToSpacingMax: 0.0, // 禁用相對限制
        showFrame: false, // 不顯示外框
      ),
    );
  }
}