import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/features/training/controllers/scoring_controller.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_content.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_footer.dart';
import 'package:bowlingarsenal_app/features/training/widgets/components/scoring_dialog_header.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/simple_pins_down_selector.dart';
import 'package:core_theme/core_theme.dart';

/// 互動式計分對話框
/// 
/// 整合計分表格、pin selector和計分模式切換的完整計分體驗
class InteractiveScoringDialog extends ConsumerWidget {
  const InteractiveScoringDialog({
    required this.game,
    required this.scoringMethod,
    super.key,
    this.onGameSaved,
  });
  
  final GameRecord game;
  final String scoringMethod;
  final Function(GameRecord)? onGameSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 從現有遊戲資料中重建投球記錄（如果有的話）
    final initialRolls = _reconstructRollsFromGame(game);
    
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: initialRolls,
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringState = ref.watch(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    // 根據計分模式選擇顏色
    final scoringColor = scoringState.scoringManager.currentMode == ScoringMode.traditional
        ? BrandColors.traditionalScoringColor
        : BrandColors.currentScoringColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: scoringColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: scoringColor.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Column(
              children: [
                ScoringDialogHeader(
                  gameNumber: game.gameNumber,
                  onClose: () => Navigator.of(context).pop(),
                  accentColor: scoringColor,
                ),
                Expanded(
                  child: ScoringDialogContent(
                    frames: scoringState.frames,
                    onFrameTapped: (frameIndex) => _onFrameTapped(context, ref, frameIndex),
                    onUndo: () => _onUndo(ref),
                                         onReset: null,
                    onSave: () => _onSave(context, ref),
                    canUndo: scoringState.rolls.isNotEmpty,
                                         canReset: false,
                    canSave: true,
                    accentColor: scoringColor,
                    scoringModeName: scoringState.scoringManager.currentStrategyName,
                    isEditMode: scoringState.isEditMode,
                    onToggleEdit: () => _onToggleEdit(context, ref),
                  ),
                ),
                ScoringDialogFooter(
                  rollsCount: scoringState.rolls.length,
                  totalScore: scoringController.finalScore,
                  accentColor: scoringColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 重建投球記錄從現有遊戲資料
  List<int>? _reconstructRollsFromGame(GameRecord game) {
    // 檢查是否為新遊戲（分數為0或沒有frameScores）
    if (game.score == 0 || game.frameScores.isEmpty) {
      return null; // 返回null表示新遊戲
    }
    
    // 檢查是否為剛創建的遊戲（通過檢查時間戳）
    if (DateTime.now().difference(game.timestamp).inMinutes < 5) {
      // 如果是5分鐘內創建的遊戲，且分數為0，視為新遊戲
      if (game.score == 0) {
        return null;
      }
    }
    
    // 對於已有分數的遊戲，暫時返回 null
    // 這意味著用戶將重新開始計分，但最終會替換掉原有的分數
    // 在未來可以實作完整的重建邏輯
    return null;
  }

  /// 處理點擊計分格
  Future<void> _onFrameTapped(BuildContext context, WidgetRef ref, int frameIndex) async {
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: _reconstructRollsFromGame(game),
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringState = ref.read(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    if (scoringState.isGameComplete && !scoringState.isEditMode) return;
    
    // 修改模式邏輯
    if (scoringState.isEditMode) {
      if (!scoringController.canEditFrame(frameIndex)) {
        return;
      }
      
      // 在修改模式下編輯指定格
      await _editFrame(context, ref, frameIndex);
      return;
    }
    
    // 正常模式邏輯
    // 檢查是否可以在此格輸入
    if (!scoringController.canInputAtFrame(frameIndex)) {
      return;
    }

    // 顯示數字選單
    final selectedPinsDown = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimplePinsDownSelector(
        maxPins: 10, // 簡化為固定值
        initialPinsDown: 0,
      ),
    );

    if (selectedPinsDown != null) {
      scoringController.processPinSelection(frameIndex, selectedPinsDown);
      // 觸覺回饋
      HapticFeedback.lightImpact();
    }
  }

  /// 處理撤銷操作
  void _onUndo(WidgetRef ref) {
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: _reconstructRollsFromGame(game),
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    scoringController.undoLastRoll();
    HapticFeedback.selectionClick();
  }

  /// 處理儲存操作
  void _onSave(BuildContext context, WidgetRef ref) {
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: _reconstructRollsFromGame(game),
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    final finalScore = scoringController.finalScore;
    final strikes = scoringController.countStrikes();
    final spares = scoringController.countSpares();
    final scoringState = ref.read(scoringControllerProvider(controllerParams));

    final updatedGame = GameRecord(
      id: game.id,
      gameNumber: game.gameNumber,
      score: finalScore,
      frameScores: scoringState.frames.map((f) => f.cumulativeScore).toList(),
      strikes: strikes,
      spares: spares,
      notes: game.notes,
      timestamp: game.timestamp,
      ballUsed: game.ballUsed,
    );

    onGameSaved?.call(updatedGame);
    Navigator.of(context).pop();
  }

  /// 處理切換編輯模式
  void _onToggleEdit(BuildContext context, WidgetRef ref) {
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: _reconstructRollsFromGame(game),
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    final currentEditMode = ref.read(scoringControllerProvider(controllerParams)).isEditMode;
    
    scoringController.toggleEditMode();
  }

  /// 編輯指定格的數據
  Future<void> _editFrame(BuildContext context, WidgetRef ref, int frameIndex) async {
    // 為了確保每次打開不同遊戲時使用獨立的控制器實例，將遊戲ID加入到參數中
    final controllerParams = ScoringControllerParams(
      scoringMethod: scoringMethod,
      initialRolls: _reconstructRollsFromGame(game),
      gameId: game.id, // 添加遊戲ID作為參數的一部分
    );
    
    final scoringState = ref.read(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    // 計算該格在 rolls 中的起始位置
    int rollStartIndex = 0;
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        if (rollStartIndex < scoringState.rolls.length && scoringState.rolls[rollStartIndex] == 10) {
          rollStartIndex += 1; // Strike只有一球
        } else {
          rollStartIndex += 2; // 兩球
        }
      } else {
        break;
      }
    }
    
    // 確保有足夠的數據可編輯
    if (rollStartIndex >= scoringState.rolls.length) {
      return;
    }
    
    // 取得當前格的數據
    final currentFirstBall = scoringState.rolls[rollStartIndex];
    final hasSecondBall = rollStartIndex + 1 < scoringState.rolls.length && currentFirstBall < 10;
    final currentSecondBall = hasSecondBall ? scoringState.rolls[rollStartIndex + 1] : 0;
    
    // 顯示編輯對話框 - 先編輯第一球
    final newFirstBall = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimplePinsDownSelector(
        maxPins: 10,
        initialPinsDown: currentFirstBall,
      ),
    );

    if (newFirstBall == null) return;

    // 如果第一球不是Strike，則需要編輯第二球
    int? newSecondBall;
    if (newFirstBall < 10) {
      newSecondBall = await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => SimplePinsDownSelector(
          maxPins: 10 - newFirstBall,
          initialPinsDown: hasSecondBall ? currentSecondBall : 0,
        ),
      );
      
      if (newSecondBall == null) return;
    }

    // 更新數據
    scoringController.editFrame(frameIndex, newFirstBall, newSecondBall);
  }
} 