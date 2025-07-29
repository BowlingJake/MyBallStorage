import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart'; // Added for debugPrint

import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_manager.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/models/roll_record.dart';
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

  final List<RollRecord> rolls;
  final List<BowlingFrame> frames;
  final int currentFrameIndex;
  final int currentRollInFrame;
  final bool isGameComplete;
  final bool isEditMode;
  final ScoringManager scoringManager;

  ScoringState copyWith({
    List<RollRecord>? rolls,
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
    List<RollRecord>? initialRolls,
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
      final pinCounts = state.rolls.map((r) => r.pinsDownCount).toList();
      // 如果有現有的投球記錄，需要重新計算當前位置
      final advancedState = _advanceToNextInput(pinCounts);
      final isComplete = _checkGameCompleteStatus(
        pinCounts, 
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
    final pinCounts = state.rolls.map((r) => r.pinsDownCount).toList();
    final newFrames = state.scoringManager.calculateScores(pinCounts);
    state = state.copyWith(frames: newFrames);
  }

  /// 獲取最終分數
  int get finalScore {
    final scores = state.frames.map((f) => f.cumulativeScore).whereType<int>();
    return scores.isEmpty ? 0 : scores.last;
  }

  /// 檢查是否可以在指定格輸入
  bool canInputAtFrame(int frameIndex) {
    return frameIndex == state.currentFrameIndex;
  }

  /// 檢查當前格是否已完成
  bool isCurrentFrameComplete() {
    return state.isGameComplete || state.currentFrameIndex >= 10;
  }

  /// 檢查是否可以編輯指定格
  bool canEditFrame(int frameIndex) {
    if (frameIndex < 0 || frameIndex > 9) {
      debugPrint('[ScoringController] canEditFrame($frameIndex): Invalid frame index.');
      return false;
    }

    final pinCounts = state.rolls.map((r) => r.pinsDownCount).toList();
    int rollIndex = 0;
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        if (rollIndex < pinCounts.length && pinCounts[rollIndex] == 10) {
          rollIndex += 1; // Strike in frames 1-9
        } else {
          rollIndex += 2; // Open or Spare
        }
      }
    }
    
    final bool canEdit = rollIndex < pinCounts.length;
    debugPrint('[ScoringController] canEditFrame($frameIndex): ${canEdit ? "Yes" : "No"}. (Rolls count: ${pinCounts.length}, required index: $rollIndex)');
    return canEdit;
  }

  /// 處理球瓶選擇結果
  void processPinSelection(int frameIndex, List<bool> selectedPins) {
    if (!canInputAtFrame(frameIndex)) return;

    // selectedPins 代表本球擊倒的瓶數（不是累積）
    // 創建深度複製以避免引用問題
    final newRoll = RollRecord(pinsDown: List<bool>.from(selectedPins));

    final newRolls = List<RollRecord>.from(state.rolls)..add(newRoll);
    final newPinCounts = newRolls.map((r) => r.pinsDownCount).toList();

    // 推進到下一個輸入位置
    final advancedState = _advanceToNextInput(newPinCounts);
    
    // 計算新的分數和完成狀態
    final newFrames = state.scoringManager.calculateScores(newPinCounts);
    final isComplete = _checkGameCompleteStatus(
      newPinCounts, 
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
      final roll = rolls[frame10StartIndex];
      if (roll == 10) { // Strike
        frame10StartIndex += 1;
      } else {
        frame10StartIndex += 2;
      }
      currentFrameIdx += 1;
    }

    if (frame10StartIndex >= rolls.length) {
      return false; // 還沒到第10格
    }

    final frame10Rolls = rolls.sublist(frame10StartIndex);

    if (frame10Rolls.isEmpty) return false;

    // 第一球是Strike
    if (frame10Rolls[0] == 10) {
      return frame10Rolls.length >= 3;
    }
    
    // 不是Strike
    if (frame10Rolls.length >= 2) {
      // Spare
      if (frame10Rolls[0] + frame10Rolls[1] == 10) {
        return frame10Rolls.length >= 3;
      }
      // Open
      return frame10Rolls.length >= 2;
    }
    
    return false;
  }
  
  /// 復原上一球
  void undoLastRoll() {
    if (state.rolls.isEmpty) {
      return;
    }
    
    final newRolls = List<RollRecord>.from(state.rolls)..removeLast();
    final newPinCounts = newRolls.map((r) => r.pinsDownCount).toList();

    // 如果沒有剩餘投球記錄，遊戲未完成
    final isComplete = newRolls.isEmpty ? false : _checkGameCompleteStatus(
      newPinCounts, 
      0, // 會在 _advanceToNextInput 中重新計算
      0
    );

    // Recalculate everything
    final advancedState = _advanceToNextInput(newPinCounts);
    final newFrames = state.scoringManager.calculateScores(newPinCounts);
    final finalIsComplete = newRolls.isEmpty ? false : _checkGameCompleteStatus(
      newPinCounts, 
      advancedState.currentFrameIndex, 
      advancedState.currentRollInFrame
    );
    
    state = state.copyWith(
      rolls: newRolls,
      frames: newFrames,
      currentFrameIndex: advancedState.currentFrameIndex,
      currentRollInFrame: advancedState.currentRollInFrame,
      isGameComplete: finalIsComplete,
    );
  }

  /// 切換編輯模式
  void toggleEditMode() {
    state = state.copyWith(isEditMode: !state.isEditMode);
    debugPrint('[ScoringController] Toggled edit mode. isEditMode is now: ${state.isEditMode}');
  }

  /// 編輯指定格的分數
  Future<void> editFrame(int frameIndex, List<int> newRollsForFrame) async {
    if (!state.isEditMode) return;
    
    debugPrint('[ScoringController] editFrame($frameIndex) called with rolls: $newRollsForFrame');

    // For simplicity, we are rebuilding the entire roll history.
    // A more optimized approach might directly manipulate the list.
    final originalPinCounts = state.rolls.map((r) => r.pinsDownCount).toList();

    List<int> newPinCounts = [];
    int rollIndex = 0;

    // Copy rolls up to the frame being edited
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        if (rollIndex < originalPinCounts.length && originalPinCounts[rollIndex] == 10) { // Strike
          newPinCounts.add(originalPinCounts[rollIndex]);
          rollIndex++;
        } else {
          if (rollIndex < originalPinCounts.length) newPinCounts.add(originalPinCounts[rollIndex]);
          if (rollIndex + 1 < originalPinCounts.length) newPinCounts.add(originalPinCounts[rollIndex + 1]);
          rollIndex += 2;
        }
      }
    }
    
    // Add the new rolls for the edited frame
    newPinCounts.addAll(newRollsForFrame);

    // This reconstruction of RollRecord is naive. It assumes pin layout which is what we are trying to fix.
    // However, editing is complex. For now, we accept this limitation.
    // A proper solution requires a way to input pin details for edits too.
    final newRolls = newPinCounts.map((count) => RollRecord(pinsDown: List.generate(10, (i) => i < count))).toList();

    // Recalculate state from the new list of rolls
    final advancedState = _advanceToNextInput(newPinCounts);
    final newFrames = state.scoringManager.calculateScores(newPinCounts);
    final isComplete = _checkGameCompleteStatus(newPinCounts, advancedState.currentFrameIndex, advancedState.currentRollInFrame);

    state = state.copyWith(
      rolls: newRolls,
      frames: newFrames,
      currentFrameIndex: advancedState.currentFrameIndex,
      currentRollInFrame: advancedState.currentRollInFrame,
      isGameComplete: isComplete,
      isEditMode: false, // Exit edit mode after edit
    );
    debugPrint('[ScoringController] Exiting edit mode after editFrame.');
  }

  /// 計算全倒數
  int countStrikes() {
    int strikes = 0;
    // 只計算前9格的Strike，第10格的X不算作傳統意義上的Strike計數
    int rollIndex = 0;
    for (int i = 0; i < 9; i++) {
      if (rollIndex >= state.rolls.length) break;
      
      if (state.rolls[rollIndex].pinsDownCount == 10) {
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

      if (state.rolls[rollIndex].pinsDownCount < 10) {
        if (state.rolls[rollIndex].pinsDownCount + state.rolls[rollIndex + 1].pinsDownCount == 10) {
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
  final String scoringMethod;
  final List<int>? initialRolls; // Kept as int for now, as it's from GameRecord
  final String gameId;
  
  ScoringControllerParams({
    required this.scoringMethod,
    this.initialRolls,
    required this.gameId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScoringControllerParams &&
          runtimeType == other.runtimeType &&
          scoringMethod == other.scoringMethod &&
          gameId == other.gameId &&
          const ListEquality().equals(initialRolls, other.initialRolls);

  @override
  int get hashCode => scoringMethod.hashCode ^ gameId.hashCode ^ const ListEquality().hash(initialRolls);
}

/// Provider for ScoringController
final scoringControllerProvider = StateNotifierProvider.autoDispose.family<ScoringController, ScoringState, ScoringControllerParams>(
  (ref, params) {
    // The `initialRolls` from GameRecord is List<int>. We need to convert it to List<RollRecord>.
    // This is a naive conversion, as we don't have the pin data. This is a known limitation
    // when loading old games. New games will store proper data if we save it.
    final initialRollRecords = params.initialRolls
        ?.map((count) => RollRecord(pinsDown: List.generate(10, (i) => i < count)))
        .toList();

    return ScoringController(
      scoringMethod: params.scoringMethod,
      initialRolls: initialRollRecords,
    );
  },
); 