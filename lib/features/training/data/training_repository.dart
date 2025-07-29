import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/services/training_data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TrainingRepository {
  final SupabaseClient _supabase;
  final TrainingDataService _dataService;

  TrainingRepository(this._supabase, this._dataService);

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
      final response = await _supabase
          .from('training_records')
          .select('*')
          .order('timestamp', ascending: false);
      
      return response
          .map((json) => TrainingRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch training records: $e');
    }
  }

  Future<void> updateTrainingRecord(TrainingRecord record) async {
    try {
      await _supabase
          .from('training_records')
          .update(record.toJson())
          .eq('id', record.id);
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
    String? oilPatternLength,
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
    String? oilPatternLength,
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