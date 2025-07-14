import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/services/training_data_service.dart';
import 'package:bowlingarsenal_app/utils/game_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 訓練狀態類 - 使用不可變模式
class TrainingState {
  final List<TrainingDaySummary> trainingDays;
  final bool isSelectionMode;
  final Set<String> selectedDayIds;

  const TrainingState({
    required this.trainingDays,
    this.isSelectionMode = false,
    Set<String>? selectedDayIds,
  }) : selectedDayIds = selectedDayIds ?? const {};

  // 建立不可變狀態複本
  TrainingState copyWith({
    List<TrainingDaySummary>? trainingDays,
    bool? isSelectionMode,
    Set<String>? selectedDayIds,
  }) {
    return TrainingState(
      trainingDays: trainingDays ?? this.trainingDays,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedDayIds: selectedDayIds ?? Set.of(this.selectedDayIds),
    );
  }

  // 計算屬性
  bool get hasTrainingData => trainingDays.isNotEmpty;
  int get selectedCount => selectedDayIds.length;
  int get totalSelectedGames => _calculateTotalSelectedGames();

  int _calculateTotalSelectedGames() {
    int totalGames = 0;
    for (final day in trainingDays) {
      if (selectedDayIds.contains(day.id)) {
        totalGames += day.totalGames;
      }
    }
    return totalGames;
  }

  // 檢查是否選中某個訓練日
  bool isDaySelected(String dayId) => selectedDayIds.contains(dayId);

  // 獲取選中訓練日的統計資訊
  Map<String, int> getSelectionStats() {
    return {
      'days': selectedDayIds.length,
      'games': totalSelectedGames,
    };
  }

  // 獲取指定訓練日
  TrainingDaySummary? getTrainingDay(String dayId) {
    return trainingDays.cast<TrainingDaySummary?>().firstWhere(
          (day) => day?.id == dayId,
          orElse: () => null,
        );
  }

  // 獲取指定訓練日的遊戲數量
  int getGameCount(String dayId) {
    final day = getTrainingDay(dayId);
    return day?.totalGames ?? 0;
  }
}

/// 提供 TrainingDataService 的 Provider
final trainingDataServiceProvider = Provider<TrainingDataService>((ref) {
  return TrainingDataService();
});

/// 提供 TrainingController 的 Provider
final trainingControllerProvider = NotifierProvider<TrainingController, TrainingState>(
  () => TrainingController(),
);

/// 訓練頁面控制器
/// 專注於訓練數據相關的業務邏輯和狀態管理
class TrainingController extends Notifier<TrainingState> {
  late final TrainingDataService _dataService;

  @override
  TrainingState build() {
    _dataService = ref.watch(trainingDataServiceProvider);
    return TrainingState(
      trainingDays: _dataService.trainingDays,
      isSelectionMode: false,
    );
  }

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
    
    // 更新狀態
    state = state.copyWith(trainingDays: _dataService.trainingDays);
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
    
    if (success) {
      state = state.copyWith(trainingDays: _dataService.trainingDays);
    }
    return success;
  }

  /// 刪除訓練日
  Future<bool> deleteTrainingDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.deleteTrainingDay(dayId);
    if (success) {
      final newSelectedDayIds = Set<String>.from(state.selectedDayIds);
      newSelectedDayIds.remove(dayId);
      
      state = state.copyWith(
        trainingDays: _dataService.trainingDays,
        selectedDayIds: newSelectedDayIds,
      );
    }
    return success;
  }

  /// 切換選擇模式
  void toggleSelectionMode() {
    final newIsSelectionMode = !state.isSelectionMode;
    
    if (!newIsSelectionMode) {
      state = state.copyWith(
        isSelectionMode: false,
        selectedDayIds: {},
      );
    } else {
      state = state.copyWith(isSelectionMode: true);
    }
  }

  /// 切換日選擇狀態
  void toggleDaySelection(String dayId) {
    if (!state.isSelectionMode) return;

    final newSelectedDayIds = Set<String>.from(state.selectedDayIds);
    
    if (newSelectedDayIds.contains(dayId)) {
      newSelectedDayIds.remove(dayId);
    } else {
      newSelectedDayIds.add(dayId);
    }
    
    state = state.copyWith(selectedDayIds: newSelectedDayIds);
  }

  /// 全選所有訓練日
  void selectAllDays() {
    if (!state.isSelectionMode) return;

    final allDayIds = state.trainingDays.map((day) => day.id).toSet();
    state = state.copyWith(selectedDayIds: allDayIds);
  }

  /// 清除所有選擇
  void clearAllSelections() {
    state = state.copyWith(selectedDayIds: {});
  }

  /// 刪除選中的訓練日
  Future<int> deleteSelectedDays() async {
    if (!state.isSelectionMode || state.selectedDayIds.isEmpty) return 0;

    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final deletedCount = _dataService.deleteTrainingDays(state.selectedDayIds);
    
    state = state.copyWith(
      trainingDays: _dataService.trainingDays,
      isSelectionMode: false,
      selectedDayIds: {},
    );
    
    return deletedCount;
  }

  /// 新增遊戲到指定訓練日
  Future<bool> addGameToDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final nextGameNumber = _dataService.getNextGameNumber(dayId);
    final newGame = GameGenerator.createDefaultGame(dayId, nextGameNumber);

    final success = _dataService.addGameToDay(dayId, newGame);
    
    if (success) {
      state = state.copyWith(trainingDays: _dataService.trainingDays);
    }
    return success;
  }

  /// 新增指定遊戲記錄到訓練日
  Future<bool> addGameRecordToDay(String dayId, GameRecord game) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.addGameToDay(dayId, game);
    
    if (success) {
      state = state.copyWith(trainingDays: _dataService.trainingDays);
    }
    return success;
  }

  /// 更新遊戲記錄
  Future<bool> updateGame(String dayId, GameRecord updatedGame) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.updateGameInDay(dayId, updatedGame);
    
    if (success) {
      state = state.copyWith(trainingDays: _dataService.trainingDays);
    }
    return success;
  }

  /// 刪除遊戲記錄
  Future<bool> deleteGame(GameRecord gameToRemove) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _dataService.removeGameFromDay(gameToRemove);
    
    if (success) {
      state = state.copyWith(trainingDays: _dataService.trainingDays);
    }
    return success;
  }
}
