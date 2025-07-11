import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_manager.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/bowling_scorecard_widget.dart';

/// 計分狀態類別
class ScoringState {
  const ScoringState({
    required this.rolls,
    required this.frames,
    required this.currentFrameIndex,
    required this.currentRollInFrame,
    required this.isGameComplete,
    required this.isEditMode,
    required this.scoringManager,
  });

  final List<int> rolls;
  final List<BowlingFrame> frames;
  final int currentFrameIndex;
  final int currentRollInFrame;
  final bool isGameComplete;
  final bool isEditMode;
  final ScoringManager scoringManager;

  ScoringState copyWith({
    List<int>? rolls,
    List<BowlingFrame>? frames,
    int? currentFrameIndex,
    int? currentRollInFrame,
    bool? isGameComplete,
    bool? isEditMode,
    ScoringManager? scoringManager,
  }) {
    return ScoringState(
      rolls: rolls ?? List.from(this.rolls),
      frames: frames ?? List.from(this.frames),
      currentFrameIndex: currentFrameIndex ?? this.currentFrameIndex,
      currentRollInFrame: currentRollInFrame ?? this.currentRollInFrame,
      isGameComplete: isGameComplete ?? this.isGameComplete,
      isEditMode: isEditMode ?? this.isEditMode,
      scoringManager: scoringManager ?? this.scoringManager,
    );
  }
}

/// 計分控制器
class ScoringController extends StateNotifier<ScoringState> {
  ScoringController({
    required String scoringMethod,
    List<int>? initialRolls,
  }) : super(
          ScoringState(
            rolls: initialRolls ?? [],
            frames: List.generate(10, (index) => const BowlingFrame()),
            currentFrameIndex: 0,
            currentRollInFrame: 0,
            isGameComplete: false,
            isEditMode: false,
            scoringManager: ScoringManager(mode: _parseScoringMethod(scoringMethod)),
          ),
        ) {
    _initializeState();
  }

  /// 初始化狀態（包括載入現有資料）
  void _initializeState() {
    if (state.rolls.isNotEmpty) {
      // 如果有現有的投球記錄，需要重新計算當前位置
      final advancedState = _advanceToNextInput(state.rolls);
      final isComplete = _checkGameCompleteStatus(
        state.rolls, 
        advancedState.currentFrameIndex, 
        advancedState.currentRollInFrame
      );
      
      state = state.copyWith(
        currentFrameIndex: advancedState.currentFrameIndex,
        currentRollInFrame: advancedState.currentRollInFrame,
        isGameComplete: isComplete,
      );
    }
    _updateScoreDisplay();
  }

  /// 將 scoringMethod 字串轉換為 ScoringMode 枚舉
  static ScoringMode _parseScoringMethod(String method) {
    switch (method.toLowerCase()) {
      case 'current':
        return ScoringMode.current;
      case 'standard':
      case 'traditional':
      default:
        return ScoringMode.traditional;
    }
  }

  /// 更新計分表格顯示
  void _updateScoreDisplay() {
    final newFrames = state.scoringManager.calculateScores(state.rolls);
    state = state.copyWith(frames: newFrames);
  }

  /// 獲取最終分數
  int get finalScore {
    if (state.frames.isEmpty) {
      return 0;
    }
    // 使用 fold 來找到最大的累計分數，這比 lastWhere 更安全
    return state.frames.fold(0, (max, frame) => frame.cumulativeScore > max ? frame.cumulativeScore : max);
  }

  /// 檢查是否可以在指定格輸入
  bool canInputAtFrame(int frameIndex) {
    return frameIndex == state.currentFrameIndex;
  }

  /// 檢查當前格是否已完成
  bool isCurrentFrameComplete() {
    return state.isGameComplete || state.currentFrameIndex >= 10;
  }

  /// 處理球瓶選擇結果
  void processPinSelection(int frameIndex, int selectedPinsDown) {
    if (!canInputAtFrame(frameIndex)) return;

    final newRolls = List<int>.from(state.rolls)..add(selectedPinsDown);
    
    // 推進到下一個輸入位置
    final advancedState = _advanceToNextInput(newRolls);
    
    // 計算新的分數和完成狀態
    final newFrames = state.scoringManager.calculateScores(newRolls);
    final isComplete = _checkGameCompleteStatus(
      newRolls, 
      advancedState.currentFrameIndex, 
      advancedState.currentRollInFrame
    );

    state = state.copyWith(
      rolls: newRolls,
      frames: newFrames,
      currentFrameIndex: advancedState.currentFrameIndex,
      currentRollInFrame: advancedState.currentRollInFrame,
      isGameComplete: isComplete,
    );
  }

  /// 推進到下一個輸入位置的結果
  ({int currentFrameIndex, int currentRollInFrame}) _advanceToNextInput(List<int> rolls) {
    int currentFrameIndex = 0;
    int currentRollInFrame = 0;
    int rollIndex = 0;
    
    while (rollIndex < rolls.length && currentFrameIndex < 10) {
      if (currentFrameIndex < 9) {
        // 第1-9格
        if (currentRollInFrame == 0) {
          // 第一球
          if (rolls[rollIndex] == 10) {
            // Strike，進入下一格
            currentFrameIndex++;
            currentRollInFrame = 0;
          } else {
            // 不是Strike，需要第二球
            currentRollInFrame = 1;
          }
          rollIndex++;
        } else {
          // 第二球
          currentFrameIndex++;
          currentRollInFrame = 0;
          rollIndex++;
        }
      } else {
        // 第10格
        if (currentRollInFrame == 0) {
          currentRollInFrame = 1;
          rollIndex++;
        } else if (currentRollInFrame == 1) {
          // 檢查是否需要第三球
          if (rollIndex >= 2) {
            final firstRoll = rolls[rollIndex - 1];
            final secondRoll = rolls[rollIndex];
            if (firstRoll == 10 || firstRoll + secondRoll == 10) {
              // Strike 或 Spare，需要第三球
              currentRollInFrame = 2;
            } else {
              // 結束
              currentFrameIndex = 10;
            }
          } else {
            currentFrameIndex = 10;
          }
          rollIndex++;
        } else {
          // 第三球
          currentFrameIndex = 10;
          rollIndex++;
        }
      }
    }
    
    return (currentFrameIndex: currentFrameIndex, currentRollInFrame: currentRollInFrame);
  }

  /// 檢查遊戲是否完成
  bool _checkGameCompleteStatus(List<int> rolls, int currentFrameIndex, int currentRollInFrame) {
    if (currentFrameIndex >= 10) {
      return true;
    }
    
    // 如果不在第10格，遊戲未完成
    if (currentFrameIndex < 9) {
      return false;
    }
    
    // 第10格特殊檢查
    int frame10StartIndex = 0;
    int currentFrameIdx = 0;
    int currentRollIdx = 0;
    
    // 計算到第10格的起始位置
    while (currentFrameIdx < 9 && frame10StartIndex < rolls.length) {
      if (currentRollIdx == 0) {
        if (rolls[frame10StartIndex] == 10) {
          // Strike
          currentFrameIdx++;
          currentRollIdx = 0;
        } else {
          currentRollIdx = 1;
        }
        frame10StartIndex++;
      } else {
        // 第二球
        currentFrameIdx++;
        currentRollIdx = 0;
        frame10StartIndex++;
      }
    }
    
    // 檢查第10格的完成狀態
    final frame10RollsCount = rolls.length - frame10StartIndex;
    if (frame10RollsCount < 2) {
      return false; // 至少需要兩球
    }
    
    if (frame10RollsCount >= 3) {
      return true; // 三球已完成
    }
    
    // 只有兩球，檢查是否需要第三球
    final firstRoll = rolls[frame10StartIndex];
    final secondRoll = rolls[frame10StartIndex + 1];
    
    // 如果第一球或前兩球合計為Strike/Spare，需要第三球
    if (firstRoll == 10 || firstRoll + secondRoll == 10) {
      return false; // 需要第三球
    }
    
    return true; // 不需要第三球，遊戲完成
  }



  /// 撤銷上一球
  void undoLastRoll() {
    if (state.rolls.isNotEmpty) {
      final newRolls = List<int>.from(state.rolls)..removeLast();
      final advancedState = _advanceToNextInput(newRolls);
      final newFrames = state.scoringManager.calculateScores(newRolls);
      final isComplete = _checkGameCompleteStatus(
        newRolls, 
        advancedState.currentFrameIndex, 
        advancedState.currentRollInFrame
      );

      state = state.copyWith(
        rolls: newRolls,
        frames: newFrames,
        currentFrameIndex: advancedState.currentFrameIndex,
        currentRollInFrame: advancedState.currentRollInFrame,
        isGameComplete: isComplete,
      );
    }
  }

  /// 切換修改模式
  void toggleEditMode() {
    state = state.copyWith(isEditMode: !state.isEditMode);
  }

  /// 檢查指定格是否有數據可以修改
  bool canEditFrame(int frameIndex) {
    if (!state.isEditMode) return false;
    
    // 計算到該格的投球數
    int rollsUpToFrame = 0;
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        // 第1-9格
        if (rollsUpToFrame < state.rolls.length && state.rolls[rollsUpToFrame] == 10) {
          rollsUpToFrame += 1; // Strike只有一球
        } else {
          rollsUpToFrame += 2; // 兩球
        }
      } else {
        // 第10格邏輯較複雜，暫時簡化
        break;
      }
    }
    
    // 檢查該格是否有數據：需要至少有第一球的數據
    return rollsUpToFrame < state.rolls.length;
  }

  /// 編輯指定格的數據
  void editFrame(int frameIndex, int newFirstBall, int? newSecondBall) {
    // 計算該格在 _rolls 中的起始位置
    int rollStartIndex = 0;
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        // 第1-9格
        if (rollStartIndex < state.rolls.length && state.rolls[rollStartIndex] == 10) {
          rollStartIndex += 1; // Strike只有一球
        } else {
          rollStartIndex += 2; // 兩球
        }
      } else {
        // 第10格（暫時簡化）
        break;
      }
    }
    
    // 確保有足夠的數據可編輯
    if (rollStartIndex >= state.rolls.length) {
      return;
    }
    
    // 取得當前格的數據
    final currentFirstBall = state.rolls[rollStartIndex];
    final hasSecondBall = rollStartIndex + 1 < state.rolls.length && currentFirstBall < 10;
    
    // 更新 _rolls 列表
    final newRolls = List<int>.from(state.rolls);
    newRolls[rollStartIndex] = newFirstBall;
    
    if (newFirstBall == 10) {
      // Strike：移除第二球（如果存在）
      if (hasSecondBall) {
        newRolls.removeAt(rollStartIndex + 1);
      }
    } else {
      // 不是Strike：更新或添加第二球
      if (hasSecondBall) {
        newRolls[rollStartIndex + 1] = newSecondBall!;
      } else {
        newRolls.insert(rollStartIndex + 1, newSecondBall!);
      }
    }
    
    // 重新計算分數和狀態
    final newFrames = state.scoringManager.calculateScores(newRolls);
    final advancedState = _advanceToNextInput(newRolls);
    final isComplete = _checkGameCompleteStatus(
      newRolls, 
      advancedState.currentFrameIndex, 
      advancedState.currentRollInFrame
    );

    state = state.copyWith(
      rolls: newRolls,
      frames: newFrames,
      currentFrameIndex: advancedState.currentFrameIndex,
      currentRollInFrame: advancedState.currentRollInFrame,
      isGameComplete: isComplete,
    );
  }

  /// 計算全倒數
  int countStrikes() {
    int strikes = 0;
    // 只計算前9格的Strike，第10格的X不算作傳統意義上的Strike計數
    int rollIndex = 0;
    for (int i = 0; i < 9; i++) {
      if (rollIndex >= state.rolls.length) break;
      
      if (state.rolls[rollIndex] == 10) {
        strikes++;
        rollIndex++;
      } else {
        rollIndex += 2; // 跳過兩球
      }
    }
    return strikes;
  }

  /// 計算補中數
  int countSpares() {
    int spares = 0;
    int rollIndex = 0;
    for (int i = 0; i < 9; i++) { // 只計算前9格
      if (rollIndex + 1 >= state.rolls.length) break;

      if (state.rolls[rollIndex] < 10) {
        if (state.rolls[rollIndex] + state.rolls[rollIndex + 1] == 10) {
          spares++;
        }
        rollIndex += 2;
      } else {
        // Strike，跳過
        rollIndex++;
      }
    }
    return spares;
  }
}

/// 計分控制器參數
class ScoringControllerParams {
  const ScoringControllerParams({
    required this.scoringMethod,
    this.initialRolls,
    this.gameId, // 添加遊戲ID參數
  });

  final String scoringMethod;
  final List<int>? initialRolls;
  final String? gameId; // 遊戲ID，用於區分不同的遊戲

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoringControllerParams &&
          runtimeType == other.runtimeType &&
          scoringMethod == other.scoringMethod &&
          const ListEquality<int>().equals(initialRolls, other.initialRolls) &&
          gameId == other.gameId; // 加入gameId的比較

  @override
  int get hashCode =>
      scoringMethod.hashCode ^ 
      (initialRolls != null ? const ListEquality<int>().hash(initialRolls) : 0) ^
      (gameId != null ? gameId.hashCode : 0); // 加入gameId的哈希值
}

/// Provider for ScoringController
final scoringControllerProvider = StateNotifierProvider.family<ScoringController, ScoringState, ScoringControllerParams>(
  (ref, params) => ScoringController(
    scoringMethod: params.scoringMethod,
    initialRolls: params.initialRolls,
  ),
); 