import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';
import 'package:bowlingarsenal_app/features/training/data/models/frame_data.dart';
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
    // 轉換 balls_used JSON 為 BallInfo 列表
    final ballsUsed = game.ballsUsed.map((ballJson) => BallInfo(
      id: (ballJson['id'] ?? '').toString(),
      name: (ballJson['name'] ?? '').toString(),
      brand: (ballJson['brand'] ?? '').toString(),
      brandColor: (ballJson['brandColor'] ?? '#000000').toString(),
      imagePath: ballJson['imagePath']?.toString(),
    )).toList();

    // 將新的個別 frame 欄位轉換為 frameScores 陣列（向後相容）
    final calculatedFrameScores = _calculateFrameScoresFromIndividualFields(game);

    return GameRecord(
      id: game.id,
      gameNumber: game.gameNumber,
      score: game.totalScore,
      frameScores: calculatedFrameScores.isNotEmpty ? calculatedFrameScores : game.frameScores,
      strikes: game.strikes,
      spares: game.spares,
      notes: game.notes,
      timestamp: game.timestamp,
      ballsUsed: ballsUsed.isNotEmpty ? ballsUsed : null,
      ballUsed: ballsUsed.isNotEmpty ? ballsUsed.first : null,
    );
  }

  /// 從個別 frame 欄位計算 frameScores 陣列
  static List<int> _calculateFrameScoresFromIndividualFields(Game game) {
    final frameScores = <int>[];
    
    // 使用 Game 擴展方法取得 FrameData 列表
    final frames = game.frames;
    
    for (final frame in frames) {
      int frameScore;
      
      if (frame.ball1 == 10) {
        // Strike
        frameScore = 10;
      } else if (frame.ball1 + frame.ball2 == 10) {
        // Spare
        frameScore = 10;
      } else {
        // Open frame
        frameScore = frame.ball1 + frame.ball2;
      }
      
      // 第10格可能有第三球
      if (frame.frameNumber == 10 && frame.ball3 != null) {
        frameScore += frame.ball3!;
      }
      
      frameScores.add(frameScore);
    }
    
    return frameScores;
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