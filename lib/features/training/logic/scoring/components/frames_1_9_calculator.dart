import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';

/// 前1-9格通用計算器
class Frames1To9Calculator {
  /// 使用指定的策略計算前1-9格的顯示結果
  /// 會自動忽略超過第9格所需的多餘投球數據
  static List<BowlingFrame> calculate(List<int> rolls, ScoringStrategy strategy) {
    final consumed = consumeRollsUpToFrame9(rolls);
    final truncated = rolls.take(consumed).toList();
    final frames = strategy.calculateScores(truncated);
    return frames;
  }

  /// 回傳到第9格（含）為止所需消耗的 rolls 數量
  /// 若資料未滿9格，則回傳當前已使用的數量
  static int consumeRollsUpToFrame9(List<int> rolls) {
    int framesCompleted = 0;
    int rollIndex = 0;
    while (rollIndex < rolls.length && framesCompleted < 9) {
      final first = rolls[rollIndex];
      if (first == 10) {
        // Strike：一球結束該格
        rollIndex += 1;
        framesCompleted += 1;
      } else {
        // 需要第二球（若不存在則代表資料尚未完整）
        if (rollIndex + 1 < rolls.length) {
          // 合法性檢查交給策略自身，這裡只做消耗
          rollIndex += 2;
          framesCompleted += 1;
        } else {
          // 只有第一球，停止
          rollIndex += 1;
          break;
        }
      }
    }
    return rollIndex;
  }
}


