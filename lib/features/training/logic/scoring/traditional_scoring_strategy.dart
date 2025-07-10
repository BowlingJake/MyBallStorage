import 'package:bowlingarsenal_app/widgets/bowling/bowling_scorecard_widget.dart';
import 'scoring_strategy.dart';

/// 傳統保齡球計分策略
/// 
/// 特色：
/// - Strike: 10 + 後兩球分數
/// - Spare: 10 + 後一球分數
/// - 第10格有獎勵球機會
class TraditionalScoringStrategy implements ScoringStrategy {
  @override
  String get name => '傳統計分';
  
  @override
  String get description => 'Strike和Spare會獲得後續球的分數獎勵，第10格可以投獎勵球';
  
  @override
  int get perfectScore => 300; // 12次連續Strike
  
  @override
  bool validateRolls(List<int> rolls) {
    // 基本驗證：每球分數在0-10之間
    if (rolls.any((roll) => roll < 0 || roll > 10)) {
      return false;
    }
    
    // 詳細驗證邏輯可以後續擴充
    return true;
  }
  
  @override
  List<BowlingFrame> calculateScores(List<int> rolls) {
    if (!validateRolls(rolls)) {
      throw ArgumentError('Invalid rolls data');
    }
    
    final frames = <BowlingFrame>[];
    var rollIndex = 0;
    var cumulativeScore = 0;
    
    // 計算前9格
    for (var frameNumber = 1; frameNumber <= 9; frameNumber++) {
      if (rollIndex >= rolls.length) {
        // 沒有足夠的數據，返回空格
        frames.add(const BowlingFrame());
        continue;
      }
      
      final frameResult = _calculateFrame(rolls, rollIndex, frameNumber);
      final frameScore = frameResult.score;
      cumulativeScore += frameScore;
      
      frames.add(BowlingFrame(
        firstBall: frameResult.firstBall,
        secondBall: frameResult.secondBall,
        cumulativeScore: cumulativeScore,
      ));
      
      rollIndex = frameResult.nextRollIndex;
    }
    
    // 計算第10格
    if (rollIndex < rolls.length) {
      final frame10Result = _calculateFrame10(rolls, rollIndex);
      cumulativeScore += frame10Result.score;
      
      frames.add(BowlingFrame(
        firstBall: frame10Result.firstBall,
        secondBall: frame10Result.secondBall,
        thirdBall: frame10Result.thirdBall,
        cumulativeScore: cumulativeScore,
      ));
    } else {
      frames.add(const BowlingFrame());
    }
    
    return frames;
  }
  
  /// 計算單一格的結果（第1-9格）
  _FrameResult _calculateFrame(List<int> rolls, int rollIndex, int frameNumber) {
    final firstRoll = rolls[rollIndex];
    
    // Strike
    if (firstRoll == 10) {
      final bonus = _getStrikeBonus(rolls, rollIndex);
      return _FrameResult(
        firstBall: '',
        secondBall: 'X',
        score: 10 + bonus,
        nextRollIndex: rollIndex + 1,
      );
    }
    
    // 需要第二球
    if (rollIndex + 1 >= rolls.length) {
      return _FrameResult(
        firstBall: firstRoll.toString(),
        secondBall: '',
        score: firstRoll,
        nextRollIndex: rollIndex + 1,
      );
    }
    
    final secondRoll = rolls[rollIndex + 1];
    
    // Spare
    if (firstRoll + secondRoll == 10) {
      final bonus = _getSpareBonus(rolls, rollIndex);
      return _FrameResult(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        score: 10 + bonus,
        nextRollIndex: rollIndex + 2,
      );
    }
    
    // Open frame
    return _FrameResult(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      score: firstRoll + secondRoll,
      nextRollIndex: rollIndex + 2,
    );
  }
  
  /// 計算第10格
  _Frame10Result _calculateFrame10(List<int> rolls, int rollIndex) {
    final firstRoll = rolls[rollIndex];
    
    // 第10格 Strike
    if (firstRoll == 10) {
      if (rollIndex + 2 >= rolls.length) {
        // 獎勵球不足
        return _Frame10Result(
          firstBall: 'X',
          secondBall: rollIndex + 1 < rolls.length ? _formatBall(rolls[rollIndex + 1]) : '',
          thirdBall: '',
          score: firstRoll + (rollIndex + 1 < rolls.length ? rolls[rollIndex + 1] : 0),
        );
      }
      
      final secondRoll = rolls[rollIndex + 1];
      final thirdRoll = rolls[rollIndex + 2];
      
      return _Frame10Result(
        firstBall: 'X',
        secondBall: _formatBall(secondRoll),
        thirdBall: secondRoll == 10 ? 'X' : _formatBall(thirdRoll),
        score: firstRoll + secondRoll + thirdRoll,
      );
    }
    
    // 第10格需要第二球
    if (rollIndex + 1 >= rolls.length) {
      return _Frame10Result(
        firstBall: firstRoll.toString(),
        secondBall: '',
        thirdBall: '',
        score: firstRoll,
      );
    }
    
    final secondRoll = rolls[rollIndex + 1];
    
    // 第10格 Spare
    if (firstRoll + secondRoll == 10) {
      if (rollIndex + 2 >= rolls.length) {
        return _Frame10Result(
          firstBall: firstRoll.toString(),
          secondBall: '/',
          thirdBall: '',
          score: 10,
        );
      }
      
      final thirdRoll = rolls[rollIndex + 2];
      return _Frame10Result(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        thirdBall: _formatBall(thirdRoll),
        score: 10 + thirdRoll,
      );
    }
    
    // 第10格 Open frame
    return _Frame10Result(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      thirdBall: '',
      score: firstRoll + secondRoll,
    );
  }
  
  /// 取得Strike的獎勵分數
  int _getStrikeBonus(List<int> rolls, int strikeIndex) {
    // 需要後兩球的分數
    if (strikeIndex + 2 >= rolls.length) {
      return 0; // 獎勵球不足
    }
    
    return rolls[strikeIndex + 1] + rolls[strikeIndex + 2];
  }
  
  /// 取得Spare的獎勵分數
  int _getSpareBonus(List<int> rolls, int spareIndex) {
    // 需要後一球的分數
    if (spareIndex + 2 >= rolls.length) {
      return 0; // 獎勵球不足
    }
    
    return rolls[spareIndex + 2];
  }
  
  /// 格式化球的顯示
  String _formatBall(int pins) {
    if (pins == 10) return 'X';
    return pins.toString();
  }
}

/// 格結果輔助類
class _FrameResult {
  final String firstBall;
  final String secondBall;
  final int score;
  final int nextRollIndex;
  
  const _FrameResult({
    required this.firstBall,
    required this.secondBall,
    required this.score,
    required this.nextRollIndex,
  });
}

/// 第10格結果輔助類
class _Frame10Result {
  final String firstBall;
  final String secondBall;
  final String thirdBall;
  final int score;
  
  const _Frame10Result({
    required this.firstBall,
    required this.secondBall,
    required this.thirdBall,
    required this.score,
  });
} 