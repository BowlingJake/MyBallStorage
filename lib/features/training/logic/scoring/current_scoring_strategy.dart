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
    
    // Current 計分模式的關鍵規則：第10格沒有獎勵球，最多只打2球
    // 最大球數：前9格每格最多2球(18) + 第10格最多2球(2) = 20球
    if (rolls.length > 20) {
      return false;
    }
    
    // 驗證每格的基本規則
    return _validateFrameRules(rolls);
  }
  
  /// 驗證每格的規則
  bool _validateFrameRules(List<int> rolls) {
    int rollIndex = 0;
    
    // 驗證前9格
    for (int frame = 0; frame < 9; frame++) {
      if (rollIndex >= rolls.length) break;
      
      final firstRoll = rolls[rollIndex];
      
      if (firstRoll == 10) {
        // Strike: 只有一球
        rollIndex++;
      } else {
        // 需要第二球
        if (rollIndex + 1 >= rolls.length) break;
        
        final secondRoll = rolls[rollIndex + 1];
        
        // 檢查兩球總和不能超過10
        if (firstRoll + secondRoll > 10) {
          return false;
        }
        
        rollIndex += 2;
      }
    }
    
    // 驗證第10格 (Current模式：最多2球，無獎勵球)
    if (rollIndex < rolls.length) {
      final frame10Ball1 = rolls[rollIndex];
      
      if (frame10Ball1 == 10) {
        // 第10格Strike：Current模式結束，但允許編輯過程中的額外數據
        rollIndex++;
      } else {
        // 需要第二球
        if (rollIndex + 1 < rolls.length) {
          final frame10Ball2 = rolls[rollIndex + 1];
          
          // 檢查兩球總和不能超過10
          if (frame10Ball1 + frame10Ball2 > 10) {
            return false;
          }
          
          rollIndex += 2;
        } else {
          // 如果只有第一球，是允許的（遊戲進行中）
          rollIndex++;
        }
      }
      
      // 對於Current模式，如果第10格之後還有數據，警告但允許
      // 這樣可以支持編輯過程中的中間狀態
      if (rollIndex < rolls.length) {
        print('警告：Current模式第10格後還有 ${rolls.length - rollIndex} 個額外數據，將忽略');
      }
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
    
    // 計算前9格（邏輯一致）
    for (var frameNumber = 1; frameNumber <= 9; frameNumber++) {
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
    
    // 計算第10格（特殊邏輯，無獎勵球）
    if (rollIndex < rolls.length) {
      final frame10Result = _calculateFrame10(rolls, rollIndex);
      cumulativeScore += frame10Result.score;
      
      frames.add(BowlingFrame(
        firstBall: frame10Result.firstBall,
        secondBall: frame10Result.secondBall,
        cumulativeScore: cumulativeScore,
      ));
    } else {
      frames.add(const BowlingFrame());
    }
    
    return frames;
  }
  
  /// 計算第10格（Current模式：無獎勵球）
  _FrameResult _calculateFrame10(List<int> rolls, int rollIndex) {
    final firstRoll = rolls[rollIndex];
    
    // 第10格Strike：固定30分，遊戲結束
    if (firstRoll == 10) {
      return _FrameResult(
        firstBall: '',
        secondBall: 'X',
        score: 30,
        nextRollIndex: rollIndex + 1,
      );
    }
    
    // 第10格需要第二球
    if (rollIndex + 1 >= rolls.length) {
      return _FrameResult(
        firstBall: firstRoll.toString(),
        secondBall: '',
        score: firstRoll,
        nextRollIndex: rollIndex + 1,
      );
    }
    
    final secondRoll = rolls[rollIndex + 1];
    
    // 第10格Spare：10 + 第一球分數
    if (firstRoll + secondRoll == 10) {
      return _FrameResult(
        firstBall: firstRoll.toString(),
        secondBall: '/',
        score: 10 + firstRoll,
        nextRollIndex: rollIndex + 2,
      );
    }
    
    // 第10格Open：兩球分數相加
    return _FrameResult(
      firstBall: firstRoll.toString(),
      secondBall: secondRoll.toString(),
      score: firstRoll + secondRoll,
      nextRollIndex: rollIndex + 2,
    );
  }

  /// 計算單一格的結果（第1-9格）
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