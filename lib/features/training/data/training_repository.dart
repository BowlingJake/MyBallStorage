import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';
import 'package:bowlingarsenal_app/features/training/data/repositories/supabase_training_repository.dart';
import 'package:bowlingarsenal_app/services/training_data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrainingRepository {
  final SupabaseClient _supabase;
  final TrainingDataService _dataService;
  late final SupabaseTrainingRepository _supabaseRepo;

  TrainingRepository(this._supabase, this._dataService) {
    _supabaseRepo = SupabaseTrainingRepository(_supabase);
  }

  Future<void> updateGameNotes(String gameId, String? notes) async {
    try {
      await _supabase
          .from('games')
          .update({'notes': notes})
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to update game notes: $e');
    }
  }

  Future<void> deleteGame(String gameId) async {
    try {
      await _supabase
          .from('games')
          .delete()
          .eq('id', gameId);
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  Future<List<TrainingRecord>> getTrainingRecords() async {
    try {
      final sessions = await _supabaseRepo.getTrainingSessions();
      
      // 轉換為舊的 TrainingRecord 格式以保持向後相容
      return sessions.map((session) => TrainingRecord(
        id: session.id,
        title: session.title,
        date: session.date,
        score: 0, // 需要計算平均分數
        notes: '', // 可以從 games 中聚合
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch training records: $e');
    }
  }

  // 新方法：直接獲取 training sessions
  Future<List<TrainingSession>> getTrainingSessions() async {
    try {
      return await _supabaseRepo.getTrainingSessions();
    } catch (e) {
      throw Exception('Failed to fetch training sessions: $e');
    }
  }

  // 新方法：獲取特定 session 的 games
  Future<List<Game>> getGamesForSession(String sessionId) async {
    try {
      return await _supabaseRepo.getGamesForSession(sessionId);
    } catch (e) {
      throw Exception('Failed to fetch games: $e');
    }
  }

  // 舊方法保持向後相容
  Future<List<TrainingRecord>> getTrainingRecordsLegacy() async {
    try {
      final sessions = await _supabaseRepo.getTrainingSessions();
      
      // 轉換為舊的 TrainingRecord 格式以保持向後相容
      return sessions.map((session) => TrainingRecord(
        id: session.id,
        title: session.title,
        date: session.date,
        score: 0, // 需要計算平均分數
        notes: '', // 可以從 games 中聚合
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch training records: $e');
    }
  }

  Future<void> updateTrainingRecord(TrainingRecord record) async {
    try {
      // 暫時保留舊方法，實際應該更新對應的 training_session
      throw UnimplementedError('Please use updateTrainingSession instead');
    } catch (e) {
      throw Exception('Failed to update training record: $e');
    }
  }

  // 獲取所有訓練日 (暫時透過 service，未來應直接存取資料庫)
  List<TrainingDaySummary> get trainingDays => _dataService.trainingDays;

  // 創建訓練日 (暫時透過 service，未來應直接存取資料庫)
  String createTrainingDay({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    int? oilPatternLength,
  }) {
    return _dataService.createTrainingDay(
      title: title,
      date: date,
      center: center,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
    );
  }

  // 更新訓練日 (暫時透過 service，未來應直接存取資料庫)
  bool updateTrainingDay(
    String dayId, {
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    int? oilPatternLength,
  }) {
    return _dataService.updateTrainingDay(
      dayId,
      title: title,
      date: date,
      center: center,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
    );
  }

  // 刪除訓練日 (暫時透過 service，未來應直接存取資料庫)
  bool deleteTrainingDay(String dayId) {
    return _dataService.deleteTrainingDay(dayId);
  }

  // 刪除多個訓練日 (暫時透過 service，未來應直接存取資料庫)
  int deleteTrainingDays(Set<String> dayIds) {
    return _dataService.deleteTrainingDays(dayIds);
  }

  // === 新的 Supabase 直接方法 ===
  
  Future<TrainingSession> createTrainingSessionDirect({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    String? oilPatternName,
    int? oilPatternLength,
    required String scoringMethod,
    required String inputMethod,
  }) async {
    return await _supabaseRepo.createTrainingSession(
      title: title,
      date: date,
      center: center,
      isHousePattern: isHousePattern,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
    );
  }
  
  Future<List<TrainingSession>> getTrainingSessionsDirect() async {
    return await _supabaseRepo.getTrainingSessions();
  }
  
  Future<List<Game>> getGamesForSessionDirect(String sessionId) async {
    return await _supabaseRepo.getGamesForSession(sessionId);
  }
  
  Future<void> deleteTrainingSessionDirect(String sessionId) async {
    await _supabaseRepo.deleteTrainingSession(sessionId);
  }
  
  Future<Game> createGameDirect({
    required String trainingSessionId,
    required int gameNumber,
    required int totalScore,
    List<int> frameScores = const [],
    int strikes = 0,
    int spares = 0,
    String? notes,
    List<Map<String, dynamic>> ballsUsed = const [],
    // 新的個別 frame 欄位
    int frame1Ball1 = 0,
    int frame1Ball2 = 0,
    int frame2Ball1 = 0,
    int frame2Ball2 = 0,
    int frame3Ball1 = 0,
    int frame3Ball2 = 0,
    int frame4Ball1 = 0,
    int frame4Ball2 = 0,
    int frame5Ball1 = 0,
    int frame5Ball2 = 0,
    int frame6Ball1 = 0,
    int frame6Ball2 = 0,
    int frame7Ball1 = 0,
    int frame7Ball2 = 0,
    int frame8Ball1 = 0,
    int frame8Ball2 = 0,
    int frame9Ball1 = 0,
    int frame9Ball2 = 0,
    int frame10Ball1 = 0,
    int frame10Ball2 = 0,
    int? frame10Ball3,
  }) async {
    return await _supabaseRepo.createGame(
      trainingSessionId: trainingSessionId,
      gameNumber: gameNumber,
      totalScore: totalScore,
      frameScores: frameScores,
      strikes: strikes,
      spares: spares,
      notes: notes,
      ballsUsed: ballsUsed,
      // 傳遞新的 frame 欄位
      frame1Ball1: frame1Ball1,
      frame1Ball2: frame1Ball2,
      frame2Ball1: frame2Ball1,
      frame2Ball2: frame2Ball2,
      frame3Ball1: frame3Ball1,
      frame3Ball2: frame3Ball2,
      frame4Ball1: frame4Ball1,
      frame4Ball2: frame4Ball2,
      frame5Ball1: frame5Ball1,
      frame5Ball2: frame5Ball2,
      frame6Ball1: frame6Ball1,
      frame6Ball2: frame6Ball2,
      frame7Ball1: frame7Ball1,
      frame7Ball2: frame7Ball2,
      frame8Ball1: frame8Ball1,
      frame8Ball2: frame8Ball2,
      frame9Ball1: frame9Ball1,
      frame9Ball2: frame9Ball2,
      frame10Ball1: frame10Ball1,
      frame10Ball2: frame10Ball2,
      frame10Ball3: frame10Ball3,
    );
  }

  Future<Game> updateGameDirect(Game game) async {
    return await _supabaseRepo.updateGame(game);
  }

  // 獲取下一個遊戲編號 (暫時透過 service，未來應直接存取資料庫)
  int getNextGameNumber(String dayId) {
    return _dataService.getNextGameNumber(dayId);
  }

  // 新增遊戲到訓練日 (暫時透過 service，未來應直接存取資料庫)
  bool addGameToDay(String dayId, GameRecord game) {
    return _dataService.addGameToDay(dayId, game);
  }

  // 更新遊戲記錄 (暫時透過 service，未來應直接存取資料庫)
  bool updateGameInDay(String dayId, GameRecord updatedGame) {
    return _dataService.updateGameInDay(dayId, updatedGame);
  }

  // 移除遊戲記錄 (暫時透過 service，未來應直接存取資料庫)
  bool removeGameFromDay(GameRecord gameToRemove) {
    return _dataService.removeGameFromDay(gameToRemove);
  }
}