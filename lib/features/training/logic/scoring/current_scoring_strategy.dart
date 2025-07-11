import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';
import 'scoring_strategy.dart';

/// Current (現代/World Bowling) 保齡球計分策略
/// 
/// 特色：
/// - Strike: 固定30分
/// - Spare: 10 + 該格第一球分數
/// - 第10格沒有獎勵球，最多只打2球
/// - 所有格計分邏輯一致
class CurrentScoringStrategy implements ScoringStrategy {
  @override
  String get name => 'Current';
  
  @override
  String get description => 'Strike固定30分，Spare為10+第一球分數，第10格無獎勵球';
  
  @override
  int get perfectScore => 300; // 10次Strike = 10 × 30 = 300
  
  @override
  bool validateRolls(List<int> rolls) {
    // 基本驗證：每球分數在0-10之間
    if (rolls.any((roll) => roll < 0 || roll > 10)) {
      return false;
    }
    
    // Current模式最多20球（每格最多2球）
    if (rolls.length > 20) {
      return false;
    }
    
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
    
    // 計算所有10格，邏輯完全一致
    for (var frameNumber = 1; frameNumber <= 10; frameNumber++) {
      if (rollIndex >= rolls.length) {
        // 沒有足夠的數據，返回空格
        frames.add(const BowlingFrame());
        continue;
      }
      
      final frameResult = _calculateFrame(rolls, rollIndex);
      final frameScore = frameResult.score;
      cumulativeScore += frameScore;
      
      frames.add(BowlingFrame(
        firstBall: frameResult.firstBall,
        secondBall: frameResult.secondBall,
        cumulativeScore: cumulativeScore,
      ));
      
      rollIndex = frameResult.nextRollIndex;
    }
    
    return frames;
  }
  
  /// 計算單一格的結果（所有格邏輯一致）
  _FrameResult _calculateFrame(List<int> rolls, int rollIndex) {
    final firstRoll = rolls[rollIndex];
    
    // Strike: 固定30分
    if (firstRoll == 10) {
      return _FrameResult(
        firstBall: '',
        secondBall: 'X',
        score: 30,
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
    
    // Spare: 10 + 第一球分數
    if (firstRoll + secondRoll == 10) {
      return _FrameResult(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        score: 10 + firstRoll, // 關鍵差異：10 + 第一球分數
        nextRollIndex: rollIndex + 2,
      );
    }
    
    // Open frame: 兩球分數總和
    return _FrameResult(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      score: firstRoll + secondRoll,
      nextRollIndex: rollIndex + 2,
    );
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