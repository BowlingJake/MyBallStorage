import 'package:bowlingarsenal_app/features/training/data/training_repository.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/models/training_state.dart';
import 'package:bowlingarsenal_app/services/training_data_service.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/utils/game_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_controller.g.dart';

/// 提供 TrainingDataService 的 Provider
@riverpod
TrainingDataService trainingDataService(TrainingDataServiceRef ref) {
  return TrainingDataService();
}

/// 提供 TrainingRepository 的 Provider
@riverpod
TrainingRepository trainingRepository(TrainingRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final dataService = ref.watch(trainingDataServiceProvider);
  return TrainingRepository(supabase, dataService);
}

/// 訓練頁面控制器
/// 專注於訓練數據相關的業務邏輯和狀態管理
@riverpod
class TrainingController extends _$TrainingController {
  late final TrainingRepository _repository;

  @override
  TrainingState build() {
    _repository = ref.watch(trainingRepositoryProvider);
    return TrainingState(
      trainingDays: _repository.trainingDays,
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

    final id = _repository.createTrainingDay(
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
    state = state.copyWith(trainingDays: _repository.trainingDays);
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

    final success = _repository.updateTrainingDay(
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
      state = state.copyWith(trainingDays: _repository.trainingDays);
    }
    return success;
  }

  /// 刪除訓練日
  Future<bool> deleteTrainingDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _repository.deleteTrainingDay(dayId);
    if (success) {
      final newSelectedDayIds = Set<String>.from(state.selectedDayIds);
      newSelectedDayIds.remove(dayId);
      
      state = state.copyWith(
        trainingDays: _repository.trainingDays,
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

    final deletedCount = _repository.deleteTrainingDays(state.selectedDayIds);
    
    state = state.copyWith(
      trainingDays: _repository.trainingDays,
      isSelectionMode: false,
      selectedDayIds: {},
    );
    
    return deletedCount;
  }

  /// 新增遊戲到指定訓練日
  Future<bool> addGameToDay(String dayId) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final nextGameNumber = _repository.getNextGameNumber(dayId);
    final newGame = GameGenerator.createDefaultGame(dayId, nextGameNumber);

    final success = _repository.addGameToDay(dayId, newGame);
    
    if (success) {
      state = state.copyWith(trainingDays: _repository.trainingDays);
    }
    return success;
  }

  /// 新增指定遊戲記錄到訓練日
  Future<bool> addGameRecordToDay(String dayId, GameRecord game) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _repository.addGameToDay(dayId, game);
    
    if (success) {
      state = state.copyWith(trainingDays: _repository.trainingDays);
    }
    return success;
  }

  /// 更新遊戲記錄
  Future<bool> updateGame(String dayId, GameRecord updatedGame) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _repository.updateGameInDay(dayId, updatedGame);
    
    if (success) {
      state = state.copyWith(trainingDays: _repository.trainingDays);
    }
    return success;
  }

  /// 刪除遊戲記錄
  Future<bool> deleteGame(GameRecord gameToRemove) async {
    // 模擬網路延遲
    await Future.delayed(Duration.zero);

    final success = _repository.removeGameFromDay(gameToRemove);
    
    if (success) {
      state = state.copyWith(trainingDays: _repository.trainingDays);
    }
    return success;
  }
}
