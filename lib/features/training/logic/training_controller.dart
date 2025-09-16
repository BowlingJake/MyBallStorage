import 'package:bowlingarsenal_app/features/training/data/training_repository.dart';
import 'package:bowlingarsenal_app/features/training/data/models/training_session.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';
import 'package:bowlingarsenal_app/features/training/data/converters/training_data_converter.dart';
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
    ref.keepAlive(); // 保持provider活躍，避免頁面切換時重建
    _repository = ref.watch(trainingRepositoryProvider);
    
    // 非同步初始化，避免阻塞UI
    Future.microtask(() => _loadTrainingData());
    
    return TrainingState(
      trainingDays: _repository.trainingDays, // 初始為空，待 _loadTrainingData 更新
    );
  }
  
  /// 從 Supabase 載入資料並更新狀態
  Future<void> _loadTrainingData() async {
    try {
      final sessions = await _repository.getTrainingSessionsDirect();
      final summaries = await TrainingDataConverter.sessionsToSummaries(
        sessions,
        (sessionId) => _repository.getGamesForSessionDirect(sessionId),
      );
      
      state = state.copyWith(trainingDays: summaries);
    } catch (e) {
      print('Error loading training data: $e');
    }
  }
  
  /// 手動重新載入資料
  Future<void> refreshTrainingData() async {
    await _loadTrainingData();
  }

  /// 創建新的訓練記錄 (使用新的 Supabase 整合)
  Future<TrainingSession> createTrainingSession({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    int? oilPatternLength,
  }) async {
    final session = await _repository.createTrainingSessionDirect(
      title: title,
      date: date,
      center: center,
      isHousePattern: isHousePattern,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
    );
    
    // 重新載入資料以反映變更
    await refreshTrainingData();
    return session;
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
    int? oilPatternLength,
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

  /// 刪除訓練日 (使用 Supabase)
  Future<bool> deleteTrainingDay(String dayId) async {
    try {
      await _repository.deleteTrainingSessionDirect(dayId);
      
      // 重新載入資料並更新選擇狀態
      await refreshTrainingData();
      
      final newSelectedDayIds = Set<String>.from(state.selectedDayIds);
      newSelectedDayIds.remove(dayId);
      state = state.copyWith(selectedDayIds: newSelectedDayIds);
      
      return true;
    } catch (e) {
      print('Delete training session error: $e');
      return false;
    }
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

  /// 新增遊戲到指定訓練日 (使用 Supabase)
  Future<bool> addGameToDay(String dayId) async {
    try {
      // 獲取當前 session 的遊戲數量來決定下一個遊戲編號
      final currentGames = await _repository.getGamesForSessionDirect(dayId);
      final nextGameNumber = currentGames.length + 1;
      
      // 建立預設遊戲 (0分，所有 frame 球數都為 0)
      await _repository.createGameDirect(
        trainingSessionId: dayId,
        gameNumber: nextGameNumber,
        totalScore: 0,
        frameScores: List.filled(10, 0),
        strikes: 0,
        spares: 0,
        // 新的個別 frame 欄位，全部設為 0
        frame1Ball1: 0, frame1Ball2: 0,
        frame2Ball1: 0, frame2Ball2: 0,
        frame3Ball1: 0, frame3Ball2: 0,
        frame4Ball1: 0, frame4Ball2: 0,
        frame5Ball1: 0, frame5Ball2: 0,
        frame6Ball1: 0, frame6Ball2: 0,
        frame7Ball1: 0, frame7Ball2: 0,
        frame8Ball1: 0, frame8Ball2: 0,
        frame9Ball1: 0, frame9Ball2: 0,
        frame10Ball1: 0, frame10Ball2: 0,
        frame10Ball3: null,
      );
      
      // 重新載入資料
      await refreshTrainingData();
      return true;
    } catch (e) {
      print('Add game error: $e');
      return false;
    }
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

  /// 更新遊戲記錄 (使用 Supabase)
  Future<bool> updateGame(String dayId, GameRecord updatedGame) async {
    try {
      // 將 GameRecord 轉換為 Game 模型並更新到 Supabase
      final gameToUpdate = await _convertGameRecordToGame(updatedGame, dayId);
      await _repository.updateGameDirect(gameToUpdate);
      
      // 重新載入資料以反映變更
      await refreshTrainingData();
      return true;
    } catch (e) {
      print('Update game error: $e');
      return false;
    }
  }

  /// 將 GameRecord 轉換為 Game 模型的輔助方法
  Future<Game> _convertGameRecordToGame(GameRecord gameRecord, String sessionId) async {
    // 如果需要，先從後端獲取現有的 Game 資料來保留其他欄位
    final existingGames = await _repository.getGamesForSessionDirect(sessionId);
    Game? existingGame;
    for (final g in existingGames) {
      if (g.id == gameRecord.id) {
        existingGame = g;
        break;
      }
    }
    existingGame ??= Game(
      id: gameRecord.id,
      trainingSessionId: sessionId,
      gameNumber: gameRecord.gameNumber,
      totalScore: gameRecord.score,
      strikes: gameRecord.strikes,
      spares: gameRecord.spares,
      createdAt: gameRecord.timestamp,
      updatedAt: gameRecord.timestamp,
    );

    // 更新基本資料，但保留現有的 frame 欄位（因為 GameRecord 沒有個別 frame 資訊）
    return existingGame.copyWith(
      totalScore: gameRecord.score,
      strikes: gameRecord.strikes,
      spares: gameRecord.spares,
      notes: gameRecord.notes,
    );
  }

  /// 更新遊戲記錄並包含 frame 資料 (直接使用 Supabase)
  Future<bool> updateGameWithFrameData({
    required String gameId,
    required int totalScore,
    required List<int> frameScores,
    required int strikes,
    required int spares,
    String? notes,
    List<Map<String, dynamic>>? ballsUsed,
    required Map<String, int> frameData,
    int? currentFrame,
    bool? isCompleted,
    String? scoringMode,
  }) async {
    try {
      // 先獲取現有的遊戲資料
      final sessions = await _repository.getTrainingSessionsDirect();
      Game? existingGame;
      String? sessionId;
      
      for (final session in sessions) {
        final games = await _repository.getGamesForSessionDirect(session.id);
        final game = games.cast<Game?>().firstWhere(
          (g) => g?.id == gameId,
          orElse: () => null,
        );
        if (game != null) {
          existingGame = game;
          sessionId = session.id;
          break;
        }
      }
      
      if (existingGame == null) {
        print('Game not found: $gameId');
        return false;
      }

      // 合併 frame 資料到現有遊戲
      final updatedGame = existingGame.copyWith(
        totalScore: totalScore,
        strikes: strikes,
        spares: spares,
        notes: notes,
        isCompleted: isCompleted ?? existingGame.isCompleted,
        scoringMode: scoringMode ?? existingGame.scoringMode,
      );

      // 更新到 Supabase
      await _repository.updateGameDirect(updatedGame);
      
      // 重新載入資料
      await refreshTrainingData();
      return true;
    } catch (e) {
      print('Update game with frame data error: $e');
      return false;
    }
  }

  /// 根據 ID 獲取完整的 Game 資料
  Future<Game?> getGameById(String gameId) async {
    try {
      final sessions = await _repository.getTrainingSessionsDirect();
      
      for (final session in sessions) {
        final games = await _repository.getGamesForSessionDirect(session.id);
        Game? game;
        for (final g in games) {
          if (g.id == gameId) { game = g; break; }
        }
        if (game != null) {
          return game;
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting game by ID: $e');
      return null;
    }
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
