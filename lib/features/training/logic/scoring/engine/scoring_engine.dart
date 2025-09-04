import 'package:bowlingarsenal_app/features/training/logic/scoring/components/frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/current_frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/components/traditional_frame_10_calculator.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/current_scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/traditional_scoring_strategy.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';

/// 無 UI 的計分引擎，集中策略與第10格計算器
class ScoringEngine {
  ScoringEngine({required ScoringMode mode}) : _mode = mode {
    _strategy = _createStrategy(mode);
    _frame10Calculator = _createFrame10Calculator(mode);
  }

  ScoringMode _mode;
  late ScoringStrategy _strategy;
  late Frame10Calculator _frame10Calculator;

  ScoringMode get mode => _mode;
  ScoringStrategy get strategy => _strategy;
  bool get showThirdBallInTenthFrame => _mode != ScoringMode.current;

  void updateMode(ScoringMode mode) {
    _mode = mode;
    _strategy = _createStrategy(mode);
    _frame10Calculator = _createFrame10Calculator(mode);
  }

  List<BowlingFrame> calculateMergedFrames(List<int> rolls1to9, List<int> rolls10) {
    final merged = <int>[...rolls1to9, ...rolls10];
    return _strategy.calculateScores(merged);
  }

  /// 回傳目前允許輸入的欄位（0-based）。回傳 -1 代表所有輸入完成。
  int getCurrentFrameIndex(List<int> rolls1to9, List<int> rolls10) {
    final pos = _advanceToNextInputForFrames1to9(rolls1to9);
    if (pos.currentFrameIndex < 9) {
      return pos.currentFrameIndex;
    }
    // 第10格：使用對應模式的第10格計算器判斷是否結束
    final isComplete = rolls10.isNotEmpty && _frame10Calculator.isComplete(rolls10, 0);
    return isComplete ? -1 : 9;
  }

  ({int currentFrameIndex, int currentRollInFrame}) _advanceToNextInputForFrames1to9(List<int> rolls) {
    int currentFrameIndex = 0;
    int currentRollInFrame = 0;
    int rollIndex = 0;
    while (rollIndex < rolls.length && currentFrameIndex < 9) {
      if (currentRollInFrame == 0) {
        if (rolls[rollIndex] == 10) {
          currentFrameIndex++;
          currentRollInFrame = 0;
        } else {
          currentRollInFrame = 1;
        }
        rollIndex++;
      } else {
        currentFrameIndex++;
        currentRollInFrame = 0;
        rollIndex++;
      }
    }
    return (currentFrameIndex: currentFrameIndex, currentRollInFrame: currentRollInFrame);
  }

  static ScoringStrategy _createStrategy(ScoringMode mode) {
    switch (mode) {
      case ScoringMode.current:
        return CurrentScoringStrategy();
      case ScoringMode.traditional:
      default:
        return TraditionalScoringStrategy();
    }
  }

  static Frame10Calculator _createFrame10Calculator(ScoringMode mode) {
    switch (mode) {
      case ScoringMode.current:
        return CurrentFrame10Calculator();
      case ScoringMode.traditional:
      default:
        return TraditionalFrame10Calculator();
    }
  }
}


