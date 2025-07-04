import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/services/training_data_service.dart';
import 'package:bowlingarsenal_app/utils/game_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainingControllerProvider = ChangeNotifierProvider(
  (ref) => TrainingController(),
);

/// 訓練頁面控制器
/// 專注於訓練數據相關的業務邏輯和狀態管理
class TrainingController extends ChangeNotifier {
  final TrainingDataService _dataService = TrainingDataService();

  // 選擇模式狀態
  bool _isSelectionMode = false;
  final Set<String> _selectedDayIds = {};

  // Getters
  List<TrainingDaySummary> get trainingDays => _dataService.trainingDays;
  bool get hasTrainingData => _dataService.hasTrainingData;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedDayIds => Set.unmodifiable(_selectedDayIds);
  int get selectedCount => _selectedDayIds.length;
  int get totalSelectedGames => _selectedDayIds
      .map((id) => _dataService.getTrainingDay(id)?.totalGames ?? 0)
      .fold(0, (a, b) => a + b);

  /// 創建新的訓練記錄
  Future<String> createTrainingRecord({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    String? oilPatternLength,
  }) async {
    // 模擬網路延遲，為未來資料庫操作做準備
    await Future.delayed(Duration.zero);

    final id = _dataService.createTrainingDay(
      title: title,
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
    );
    notifyListeners();
    return id;
  }

  /// 更新訓練記錄
  Future<bool> updateTrainingRecord(
    String dayId, {
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    String? oilPatternLength,
  }) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.updateTrainingDay(
      dayId,
      title: title,
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
    );
    if (success) notifyListeners();
    return success;
  }

  /// 刪除訓練日
  Future<bool> deleteTrainingDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.deleteTrainingDay(dayId);
    if (success) {
      _selectedDayIds.remove(dayId);
      notifyListeners();
    }
    return success;
  }

  /// 切換選擇模式
  void toggleSelectionMode() {
    _isSelectionMode = !_isSelectionMode;
    if (!_isSelectionMode) {
      _selectedDayIds.clear();
    }
    notifyListeners();
  }

  /// 切換日選擇狀態
  void toggleDaySelection(String dayId) {
    if (!_isSelectionMode) return;

    if (_selectedDayIds.contains(dayId)) {
      _selectedDayIds.remove(dayId);
    } else {
      _selectedDayIds.add(dayId);
    }
    notifyListeners();
  }

  /// 全選所有訓練日
  void selectAllDays() {
    if (!_isSelectionMode) return;

    _selectedDayIds.clear();
    _selectedDayIds.addAll(trainingDays.map((day) => day.id));
    notifyListeners();
  }

  /// 清除所有選擇
  void clearAllSelections() {
    _selectedDayIds.clear();
    notifyListeners();
  }

  /// 刪除選中的訓練日
  Future<int> deleteSelectedDays() async {
    if (!_isSelectionMode || _selectedDayIds.isEmpty) return 0;

    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final deletedCount = _dataService.deleteTrainingDays(_selectedDayIds);
    _selectedDayIds.clear();
    _isSelectionMode = false;
    notifyListeners();
    return deletedCount;
  }

  /// 新增遊戲到指定訓練日
  Future<bool> addGameToDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final nextGameNumber = _dataService.getNextGameNumber(dayId);
    final newGame = GameGenerator.createDefaultGame(dayId, nextGameNumber);

    final success = _dataService.addGameToDay(dayId, newGame);
    if (success) notifyListeners();
    return success;
  }

  /// 新增指定遊戲記錄到訓練日
  Future<bool> addGameRecordToDay(String dayId, GameRecord game) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.addGameToDay(dayId, game);
    if (success) notifyListeners();
    return success;
  }

  /// 更新遊戲記錄
  Future<bool> updateGame(GameRecord updatedGame) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.updateGameInDay(updatedGame);
    if (success) notifyListeners();
    return success;
  }

  /// 刪除遊戲記錄
  Future<bool> deleteGame(GameRecord gameToRemove) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.removeGameFromDay(gameToRemove);
    if (success) notifyListeners();
    return success;
  }

  /// 獲取指定訓練日
  TrainingDaySummary? getTrainingDay(String dayId) {
    return _dataService.getTrainingDay(dayId);
  }

  /// 檢查是否選中某個訓練日
  bool isDaySelected(String dayId) {
    return _selectedDayIds.contains(dayId);
  }

  /// 獲取選中訓練日的統計資訊
  Map<String, int> getSelectionStats() {
    final totalDays = _selectedDayIds.length;
    var totalGames = 0;

    for (final dayId in _selectedDayIds) {
      final day = _dataService.getTrainingDay(dayId);
      if (day != null) {
        totalGames += day.totalGames;
      }
    }

    return {'days': totalDays, 'games': totalGames};
  }
}
