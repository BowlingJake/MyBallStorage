import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';

/// 訓練回顧資料模型
class TrainingRecap {
  final String sessionTitle;
  final DateTime date;
  final String bowlerName;
  final String bowlingCenter;
  final String oilPattern;
  final List<BowlingScoreData> games;
  final RecapStatistics statistics;

  const TrainingRecap({
    required this.sessionTitle,
    required this.date,
    required this.bowlerName,
    required this.bowlingCenter,
    required this.oilPattern,
    required this.games,
    required this.statistics,
  });

  factory TrainingRecap.fromTrainingDay(TrainingDaySummary trainingDay, String bowlerName) {
    final games = trainingDay.games
        .map((gameRecord) => _convertGameRecordToScoreData(gameRecord))
        .toList();

    final statistics = RecapStatistics.fromGames(games);

    return TrainingRecap(
      sessionTitle: trainingDay.title,
      date: trainingDay.date,
      bowlerName: bowlerName,
      bowlingCenter: trainingDay.center,
      oilPattern: trainingDay.isHousePattern 
          ? 'House Pattern' 
          : '${trainingDay.oilPatternName ?? 'Custom'} (${trainingDay.oilPatternLength ?? 'Unknown'}ft)',
      games: games,
      statistics: statistics,
    );
  }

  /// 將 GameRecord 轉換為 BowlingScoreData
  static BowlingScoreData _convertGameRecordToScoreData(GameRecord gameRecord) {
    final scoreData = BowlingScoreData.newGame();

    // 如果有 frameScores，嘗試重建分數表
    if (gameRecord.frameScores.isNotEmpty) {
      for (var i = 0; i < gameRecord.frameScores.length && i < 10; i++) {
        final frameScore = gameRecord.frameScores[i];
        final frame = scoreData.frames[i];

        // 簡化的分數重建邏輯
        if (frameScore == 10 && i < 9) {
          // Strike
          frame.rolls.add(
            Roll(
              pinsDown: 10,
              pinsStandingAfterThrow: {},
              displayScore: 'X',
              pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            ),
          );
        } else if (frameScore > 0 && frameScore < 10) {
          // 簡化：假設是兩球的組合
          final firstBall = frameScore ~/ 2;
          final secondBall = frameScore - firstBall;

          frame.rolls.add(
            Roll(
              pinsDown: firstBall,
              pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
                  .difference(List.generate(firstBall, (i) => i + 1).toSet()),
              displayScore: firstBall.toString(),
              pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            ),
          );

          if (secondBall > 0) {
            frame.rolls.add(
              Roll(
                pinsDown: secondBall,
                pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
                    .difference(List.generate(frameScore, (i) => i + 1).toSet()),
                displayScore: firstBall + secondBall == 10 ? '/' : secondBall.toString(),
                pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
                    .difference(List.generate(firstBall, (i) => i + 1).toSet()),
              ),
            );
          }
        }

        frame.totalScore = gameRecord.score; // 設定總分到最後一格
      }
    }

    return scoreData;
  }
}

/// 回顧統計資料
class RecapStatistics {
  final double average;
  final double strikePercentage;
  final double sparePercentage;
  final int totalFrames;
  final int strikes;
  final int spares;
  final int opens;

  const RecapStatistics({
    required this.average,
    required this.strikePercentage,
    required this.sparePercentage,
    required this.totalFrames,
    required this.strikes,
    required this.spares,
    required this.opens,
  });

  factory RecapStatistics.fromGames(List<BowlingScoreData> games) {
    if (games.isEmpty) {
      return const RecapStatistics(
        average: 0.0,
        strikePercentage: 0.0,
        sparePercentage: 0.0,
        totalFrames: 0,
        strikes: 0,
        spares: 0,
        opens: 0,
      );
    }

    int totalScore = 0;
    int totalFrames = 0;
    int strikes = 0;
    int spares = 0;
    int opens = 0;

    for (final game in games) {
      for (int i = 0; i < 9; i++) { // 只計算前9格的統計
        final frame = game.frames[i];
        if (frame.rolls.isNotEmpty) {
          totalFrames++;
          
          final firstRoll = frame.rolls[0];
          if (firstRoll.pinsDown == 10) {
            strikes++;
          } else if (frame.rolls.length > 1 && 
                     (firstRoll.pinsDown + frame.rolls[1].pinsDown) == 10) {
            spares++;
          } else if (frame.rolls.length > 1) {
            opens++;
          }
        }
      }
      
      // 計算總分
      final gameTotal = game.frames
          .where((frame) => frame.totalScore != null)
          .lastOrNull?.totalScore ?? 0;
      totalScore += gameTotal;
    }

    final gamesCount = games.length;
    final average = gamesCount > 0 ? totalScore / gamesCount : 0.0;
    final strikePercentage = totalFrames > 0 ? (strikes / totalFrames) * 100 : 0.0;
    final sparePercentage = totalFrames > 0 ? (spares / totalFrames) * 100 : 0.0;

    return RecapStatistics(
      average: average,
      strikePercentage: strikePercentage,
      sparePercentage: sparePercentage,
      totalFrames: totalFrames,
      strikes: strikes,
      spares: spares,
      opens: opens,
    );
  }
} 