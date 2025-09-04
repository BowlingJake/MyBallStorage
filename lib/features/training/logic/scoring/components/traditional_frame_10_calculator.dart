import 'frame_10_calculator.dart';

/// Traditional 計分模式的第10格計算器
/// 
/// 規則：
/// - Strike: 10 + 兩個獎勵球分數，需要3球
/// - Spare: 10 + 一個獎勵球分數，需要3球
/// - Open: 兩球分數相加，需要2球
/// - 有獎勵球概念
class TraditionalFrame10Calculator extends Frame10Calculator {
  @override
  String get modeName => 'Traditional';

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

    // Strike: 需要2個獎勵球
    if (firstRoll == 10) {
      return _calculateStrike(rolls, startIndex);
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

    // Spare: 需要1個獎勵球
    if (firstRoll + secondRoll == 10) {
      return _calculateSpare(rolls, startIndex, firstRoll, secondRoll);
    }

    // Open frame: 兩球分數相加，遊戲結束
    return Frame10Result(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      score: firstRoll + secondRoll,
      isComplete: true,
      rollsUsed: 2,
    );
  }

  Frame10Result _calculateStrike(List<int> rolls, int startIndex) {
    final firstRoll = rolls[startIndex];

    if (startIndex + 2 >= rolls.length) {
      // 獎勵球不足
      final secondBall = startIndex + 1 < rolls.length 
          ? _formatBall(rolls[startIndex + 1])
          : '';
      
      return Frame10Result(
        firstBall: 'X',
        secondBall: secondBall,
        thirdBall: '',
        score: firstRoll + (startIndex + 1 < rolls.length ? rolls[startIndex + 1] : 0),
        isComplete: false,
        rollsUsed: startIndex + 1 < rolls.length ? 2 : 1,
      );
    }

    final secondRoll = rolls[startIndex + 1];
    final thirdRoll = rolls[startIndex + 2];

    return Frame10Result(
      firstBall: 'X',
      secondBall: _formatBall(secondRoll),
      thirdBall: secondRoll == 10 ? 'X' : (thirdRoll == 10 ? 'X' : _formatBall(thirdRoll)),
      score: firstRoll + secondRoll + thirdRoll,
      isComplete: true,
      rollsUsed: 3,
    );
  }

  Frame10Result _calculateSpare(List<int> rolls, int startIndex, int firstRoll, int secondRoll) {
    if (startIndex + 2 >= rolls.length) {
      // 獎勵球不足
      return Frame10Result(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        thirdBall: '',
        score: 10,
        isComplete: false,
        rollsUsed: 2,
      );
    }

    final thirdRoll = rolls[startIndex + 2];
    return Frame10Result(
      firstBall: firstRoll.toString(),
      secondBall: '/',
      thirdBall: _formatBall(thirdRoll),
      score: 10 + thirdRoll,
      isComplete: true,
      rollsUsed: 3,
    );
  }

  String _formatBall(int pins) {
    if (pins == 10) return 'X';
    if (pins == 0) return '-';
    return pins.toString();
  }

  @override
  bool isComplete(List<int> rolls, int startIndex) {
    if (startIndex >= rolls.length) return false;

    final firstRoll = rolls[startIndex];

    // Strike: 需要3球
    if (firstRoll == 10) {
      return startIndex + 2 < rolls.length;
    }

    // 需要第二球
    if (startIndex + 1 >= rolls.length) return false;
    final secondRoll = rolls[startIndex + 1];

    // Spare: 需要3球
    if (firstRoll + secondRoll == 10) {
      return startIndex + 2 < rolls.length;
    }

    // Open: 2球就完成
    return true;
  }

  @override
  int getRequiredRollsCount(List<int> rolls, int startIndex) {
    if (startIndex >= rolls.length) return 1; // 至少需要第一球

    final firstRoll = rolls[startIndex];

    // Strike: 需要3球
    if (firstRoll == 10) return 3;

    if (startIndex + 1 >= rolls.length) return 2; // 至少需要第二球

    final secondRoll = rolls[startIndex + 1];

    // Spare: 需要3球
    if (firstRoll + secondRoll == 10) return 3;

    // Open: 需要2球
    return 2;
  }
}