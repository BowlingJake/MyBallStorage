import 'frame_10_calculator.dart';

/// Current 計分模式的第10格計算器
/// 
/// 規則：
/// - Strike: 固定30分，只需1球，遊戲結束
/// - Spare: 10 + 第一球分數，需要2球，遊戲結束
/// - Open: 兩球分數相加，需要2球，遊戲結束
/// - 沒有獎勵球概念
class CurrentFrame10Calculator extends Frame10Calculator {
  @override
  String get modeName => 'Current';

  @override
  Frame10Result calculate(List<int> rolls, int startIndex, int cumulativeScore) {
    if (startIndex >= rolls.length) {
      // 沒有資料
      return const Frame10Result(
        firstBall: '',
        secondBall: '',
        score: 0,
        isComplete: false,
        rollsUsed: 0,
      );
    }

    final firstRoll = rolls[startIndex];

    // Strike: 固定30分，遊戲結束
    if (firstRoll == 10) {
      return Frame10Result(
        firstBall: '',
        secondBall: 'X',
        score: 30,
        isComplete: true,
        rollsUsed: 1,
      );
    }

    // 需要第二球
    if (startIndex + 1 >= rolls.length) {
      // 只有第一球
      return Frame10Result(
        firstBall: firstRoll.toString(),
        secondBall: '',
        score: firstRoll,
        isComplete: false,
        rollsUsed: 1,
      );
    }

    final secondRoll = rolls[startIndex + 1];

    // Spare: 10 + 第一球分數
    if (firstRoll + secondRoll == 10) {
      return Frame10Result(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        score: 10 + firstRoll,
        isComplete: true,
        rollsUsed: 2,
      );
    }

    // Open frame: 兩球分數相加
    return Frame10Result(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      score: firstRoll + secondRoll,
      isComplete: true,
      rollsUsed: 2,
    );
  }

  @override
  bool isComplete(List<int> rolls, int startIndex) {
    if (startIndex >= rolls.length) return false;

    final firstRoll = rolls[startIndex];

    // Strike: 1球就完成
    if (firstRoll == 10) return true;

    // 非Strike: 需要2球
    return startIndex + 1 < rolls.length;
  }

  @override
  int getRequiredRollsCount(List<int> rolls, int startIndex) {
    if (startIndex >= rolls.length) return 1; // 至少需要第一球

    final firstRoll = rolls[startIndex];

    // Strike: 只需1球
    if (firstRoll == 10) return 1;

    // 非Strike: 需要2球
    return 2;
  }
}