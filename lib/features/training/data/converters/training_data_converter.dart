import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game_roll.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';

class TrainingDataConverter {
  /// 將 TrainingSession 和對應的 Games 轉換為 TrainingDaySummary
  static TrainingDaySummary sessionToSummary(
    TrainingSession session, 
    List<Game> games,
  ) {
    final gameRecords = games.map((game) => _gameToGameRecord(game)).toList();
    
    return TrainingDaySummary(
      id: session.id,
      title: session.title,
      date: session.date,
      center: session.center,
      oilPatternName: session.oilPatternName,
      oilPatternLength: session.oilPatternLength,
      isHousePattern: session.isHousePattern,
      scoringMethod: session.scoringMethod,
      inputMethod: session.inputMethod,
      games: gameRecords,
      createdAt: session.createdAt,
    );
  }

  /// 將多個 TrainingSession 轉換為 TrainingDaySummary 列表
  static Future<List<TrainingDaySummary>> sessionsToSummaries(
    List<TrainingSession> sessions,
    Future<List<Game>> Function(String sessionId) getGamesForSession,
  ) async {
    final summaries = <TrainingDaySummary>[];
    
    for (final session in sessions) {
      final games = await getGamesForSession(session.id);
      summaries.add(sessionToSummary(session, games));
    }
    
    return summaries;
  }

  /// 將 Game 轉換為 GameRecord
  static GameRecord _gameToGameRecord(Game game) {
    // 新 schema：equipment → BallInfo
    final ballsUsed = game.equipment.map((e) => BallInfo(
      id: e.ballId,
      name: e.ballName,
      brand: '',
      brandColor: '#000000',
    )).toList();

    final frameScores = _calculateFrameScoresFromFrames(game.frames);

    return GameRecord(
      id: game.id,
      gameNumber: game.gameNumber,
      score: game.totalScore,
      frameScores: frameScores,
      strikes: game.strikes,
      spares: game.spares,
      notes: game.notes,
      timestamp: game.createdAt,
      ballsUsed: ballsUsed.isNotEmpty ? ballsUsed : null,
      ballUsed: ballsUsed.isNotEmpty ? ballsUsed.first : null,
    );
  }

  static List<int> _calculateFrameScoresFromFrames(List<GameFrame> frames) {
    final scores = <int>[];
    for (final f in frames) {
      final int s = f.frameScore ?? f.rolls.fold(0, (acc, r) => acc + r.pinsKnocked);
      scores.add(s);
    }
    return scores;
  }

  /// 將 TrainingDaySummary 轉換回 TrainingSession（用於更新）
  static TrainingSession summaryToSession(TrainingDaySummary summary) {
    return TrainingSession(
      id: summary.id,
      userId: '', // 會在 Repository 中自動填入
      title: summary.title,
      date: summary.date,
      center: summary.center,
      isHousePattern: summary.isHousePattern,
      oilPatternName: summary.oilPatternName,
      oilPatternLength: summary.oilPatternLength,
      scoringMethod: summary.scoringMethod,
      inputMethod: summary.inputMethod,
      createdAt: summary.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}