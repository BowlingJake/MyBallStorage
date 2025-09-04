import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';

/// 第10格計算器的抽象介面
abstract class Frame10Calculator {
  /// 計算第10格的分數和顯示
  Frame10Result calculate(List<int> rolls, int startIndex, int cumulativeScore);
  
  /// 檢查第10格是否已完成
  bool isComplete(List<int> rolls, int startIndex);
  
  /// 獲取第10格需要的總球數
  int getRequiredRollsCount(List<int> rolls, int startIndex);
  
  /// 獲取計分模式名稱
  String get modeName;
}

/// 第10格計算結果
class Frame10Result {
  final String firstBall;
  final String secondBall;
  final String? thirdBall;
  final int score;
  final bool isComplete;
  final int rollsUsed;

  const Frame10Result({
    required this.firstBall,
    required this.secondBall,
    this.thirdBall,
    required this.score,
    required this.isComplete,
    required this.rollsUsed,
  });

  /// 轉換為 BowlingFrame
  BowlingFrame toBowlingFrame(int cumulativeScore) {
    return BowlingFrame(
      firstBall: firstBall,
      secondBall: secondBall,
      thirdBall: thirdBall ?? '',
      cumulativeScore: cumulativeScore + score,
    );
  }
}