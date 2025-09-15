import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bowlingarsenal_app/features/training/logic/scoring_controller.dart';
import 'package:bowlingarsenal_app/features/training/logic/scoring/scoring_strategy.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/features/training/models/roll_record.dart';
import 'package:bowlingarsenal_app/features/training/data/models/frame_data.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/scoring_dialog_content.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/scoring_dialog_footer.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/scoring_dialog_header.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/components/ball_selection_section.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/pin_selection_dialog.dart';
import 'package:core_theme/core_theme.dart';

/// 互動式計分對話框
/// 
/// 整合計分表格、pin selector和計分模式切換的完整計分體驗
class InteractiveScoringDialog extends ConsumerStatefulWidget {
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
  ConsumerState<InteractiveScoringDialog> createState() => _InteractiveScoringDialogState();
}

class _InteractiveScoringDialogState extends ConsumerState<InteractiveScoringDialog> {
  late List<BallInfo> _selectedBalls;
  late final PinSelectionController _pinController;
  List<RollRecord>? _initialRolls;
  bool _isLoadingRolls = true;

  @override
  void initState() {
    super.initState();
    _selectedBalls = widget.game.ballsUsed ?? (widget.game.ballUsed != null ? [widget.game.ballUsed!] : []);
    _pinController = PinSelectionController();
    
    // 非同步載入 rolls
    _loadInitialRolls();
  }

  Future<void> _loadInitialRolls() async {
    try {
      _initialRolls = await _reconstructRollsFromGameAsync(widget.game, ref);
    } catch (e) {
      print('Error loading initial rolls: $e');
      _initialRolls = null;
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRolls = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoadingRolls) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('載入遊戲資料...'),
            ],
          ),
        ),
      );
    }
    
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    final scoringState = ref.watch(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    final scoringColor = scoringState.scoringManager.currentMode == ScoringMode.traditional
        ? BrandColors.traditionalScoringColor
        : BrandColors.currentScoringColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scoringColor.withOpacity(0.3)),
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
                  gameNumber: widget.game.gameNumber,
                  onClose: () => Navigator.of(context).pop(),
                  accentColor: scoringColor,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ScoringDialogContent(
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
                        BallSelectionSection(
                          selectedBalls: _selectedBalls,
                          accentColor: scoringColor,
                          onSelectionChanged: (updatedBalls) {
                            setState(() {
                              _selectedBalls = updatedBalls;
                            });
                          },
                        ),
                      ],
                    ),
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

  List<int>? _reconstructRollsFromGame(GameRecord game) {
    // 這個方法需要從 TrainingController 獲取完整的 Game 資料
    // 因為 GameRecord 沒有個別 frame 欄位
    // 我們暫時返回 null，讓對話框從空白開始，稍後會修復
    return null;
  }

  Future<List<RollRecord>?> _reconstructRollsFromGameAsync(GameRecord game, WidgetRef ref) async {
    try {
      // 從 TrainingController 獲取完整的 Game 資料
      final trainingController = ref.read(trainingControllerProvider.notifier);
      final fullGame = await trainingController.getGameById(game.id);
      
      if (fullGame == null) return null;

      // 從個別 frame 欄位重建 RollRecord 列表
      final rolls = <RollRecord>[];
      
      for (int frameNumber = 1; frameNumber <= 10; frameNumber++) {
        final frameData = fullGame.getFrame(frameNumber);
        
        if (frameData.ball1 == 0 && frameData.ball2 == 0 && frameData.ball3 == null) {
          // 這一格沒有資料，停止重建
          break;
        }

        if (frameNumber < 10) {
          // 前 9 格
          if (frameData.ball1 == 10) {
            // Strike
            rolls.add(RollRecord(
              pinsDown: List.generate(10, (i) => true), // 所有球瓶都倒
            ));
          } else {
            // 第一球
            rolls.add(RollRecord(
              pinsDown: List.generate(10, (i) => i < frameData.ball1),
            ));
            
            // 第二球（如果有的話）
            if (frameData.ball2 > 0) {
              // 第二球只顯示新擊倒的球瓶數量
              // 簡單的方法：創建一個只有 frameData.ball2 個 true 的陣列
              rolls.add(RollRecord(
                pinsDown: List.generate(10, (i) => i < frameData.ball2),
              ));
            }
          }
        } else {
          // 第 10 格
          // 第一球
          rolls.add(RollRecord(
            pinsDown: List.generate(10, (i) => i < frameData.ball1),
          ));
          
          // 第二球
          if (frameData.ball2 > 0) {
            // 第10格的第二球邏輯
            if (frameData.ball1 == 10) {
              // 第一球是 strike，第二球重新開始（新的一組10個球瓶）
              rolls.add(RollRecord(
                pinsDown: List.generate(10, (i) => i < frameData.ball2),
              ));
            } else {
              // 第一球不是 strike，第二球是同一組球瓶的剩餘部分
              rolls.add(RollRecord(
                pinsDown: List.generate(10, (i) => i < frameData.ball2),
              ));
            }
          }
          
          // 第三球
          if (frameData.ball3 != null && frameData.ball3! > 0) {
            rolls.add(RollRecord(
              pinsDown: List.generate(10, (i) => i < frameData.ball3!),
            ));
          }
        }
      }
      
      return rolls.isEmpty ? null : rolls;
    } catch (e) {
      print('Error reconstructing rolls: $e');
      return null;
    }
  }

  /// 將 RollRecord 列表轉換為 int 列表 (for ScoringController)
  List<int>? _convertRollRecordsToInts(List<RollRecord>? rollRecords) {
    if (rollRecords == null || rollRecords.isEmpty) return null;
    
    return rollRecords.map((roll) => roll.pinsDown.where((p) => p).length).toList();
  }

  Future<void> _onFrameTapped(BuildContext context, WidgetRef ref, int frameIndex) async {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    final scoringState = ref.read(scoringControllerProvider(controllerParams));

    debugPrint('[ScoringDialog] _onFrameTapped: Frame $frameIndex tapped. isEditMode is ${scoringState.isEditMode}');
    
    if (scoringState.isGameComplete && !scoringState.isEditMode) {
       debugPrint('[ScoringDialog] Game is complete and not in edit mode. Returning.');
      return;
    }
    
    if (scoringState.isEditMode) {
      final canEdit = scoringController.canEditFrame(frameIndex);
      debugPrint('[ScoringDialog] In edit mode. canEditFrame($frameIndex) returned $canEdit.');
      if (!canEdit) {
        return;
      }
      await _editFrame(context, ref, frameIndex);
      return;
    }
    
    if (!scoringController.canInputAtFrame(frameIndex)) {
      debugPrint('[ScoringDialog] Not in edit mode, and cannot input at frame $frameIndex. Returning.');
      return;
    }

    // --- REFACTORED LOGIC FOR NORMAL SCORING ---
    final isFirstRoll = scoringState.currentRollInFrame == 0;
    List<bool>? initialPinStateForSecondRoll;

    if (!isFirstRoll) {
      // It's the second roll. We need to find the pin state from the first roll of this frame.
      final rolls = scoringState.rolls;
      if (rolls.isNotEmpty) {
        // The last roll in the state is the first roll of the current frame.
        final firstRollOfFrame = rolls.last;
        // 創建深度複製以避免引用問題
        initialPinStateForSecondRoll = List<bool>.from(firstRollOfFrame.pinsDown);
      }
    }
    
    final List<bool>? pinState = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PinSelectionDialog(
        controller: _pinController,
        isFirstRoll: isFirstRoll,
        initialPinState: initialPinStateForSecondRoll,
        frameNumber: frameIndex + 1, // Convert 0-based to 1-based
      ),
    );

    if (pinState != null) {
      // The controller now handles the full pin state directly.
      scoringController.processPinSelection(frameIndex, pinState);
      HapticFeedback.lightImpact();
    }
  }

  void _onUndo(WidgetRef ref) {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    scoringController.undoLastRoll();
    HapticFeedback.selectionClick();
  }

  Future<void> _onSave(BuildContext context, WidgetRef ref) async {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    final scoringState = ref.read(scoringControllerProvider(controllerParams));

    // 提取 frame 資料
    final frameData = _extractFrameDataFromRolls(scoringState.rolls);
    
    try {
      // 直接使用 TrainingController 更新遊戲，包括 frame 資料
      final trainingController = ref.read(trainingControllerProvider.notifier);
      
      // 計算當前的 frame 和完成狀態
      final currentFrame = _calculateCurrentFrame(frameData);
      final isCompleted = _isGameCompleted(frameData, scoringState);
      
      final success = await trainingController.updateGameWithFrameData(
        gameId: widget.game.id,
        totalScore: scoringController.finalScore,
        frameScores: scoringState.frames.map((f) => f.cumulativeScore ?? 0).toList(),
        strikes: scoringController.countStrikes(),
        spares: scoringController.countSpares(),
        notes: widget.game.notes,
        ballsUsed: _selectedBalls.map((ball) => {
          'id': ball.id,
          'name': ball.name,
          'brand': ball.brand,
          'brandColor': ball.brandColor,
          'imagePath': ball.imagePath,
        }).toList(),
        frameData: frameData,
        currentFrame: currentFrame,
        isCompleted: isCompleted,
        scoringMode: widget.scoringMethod,
      );
      
      if (success) {
        // 創建更新的 GameRecord 以供回調使用
        final updatedGame = GameRecord(
          id: widget.game.id,
          gameNumber: widget.game.gameNumber,
          score: scoringController.finalScore,
          frameScores: scoringState.frames.map((f) => f.cumulativeScore ?? 0).toList(),
          strikes: scoringController.countStrikes(),
          spares: scoringController.countSpares(),
          notes: widget.game.notes,
          timestamp: widget.game.timestamp,
          ballUsed: _selectedBalls.isNotEmpty ? _selectedBalls.first : null,
          ballsUsed: _selectedBalls.isNotEmpty ? _selectedBalls : null,
        );
        
        widget.onGameSaved?.call(updatedGame);
        Navigator.of(context).pop();
      } else {
        // 顯示錯誤訊息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('儲存失敗，請稍後再試'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // 顯示錯誤訊息
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('儲存錯誤: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// 從 rolls 中提取個別 frame 的球數資料
  Map<String, int> _extractFrameDataFromRolls(List<RollRecord> rolls) {
    final frameData = <String, int>{};
    var rollIndex = 0;

    for (var frameNumber = 1; frameNumber <= 10; frameNumber++) {
      if (rollIndex >= rolls.length) break;

      final ball1Key = 'frame${frameNumber}Ball1';
      final ball2Key = 'frame${frameNumber}Ball2';
      final ball3Key = 'frame${frameNumber}Ball3';

      if (frameNumber < 10) {
        // 前 9 格
        final roll1 = rolls[rollIndex];
        frameData[ball1Key] = roll1.pinsDown.where((p) => p).length;
        rollIndex++;

        if (roll1.pinsDown.where((p) => p).length < 10 && rollIndex < rolls.length) {
          final roll2 = rolls[rollIndex];
          final roll2Pins = roll2.pinsDown.where((p) => p).length;
          final ball1Pins = frameData[ball1Key]!;
          
          // 計算第二球的分數，確保在合理範圍內
          if (roll2Pins >= ball1Pins) {
            // roll2 是累加的情況
            frameData[ball2Key] = roll2Pins - ball1Pins;
          } else {
            // roll2 是單獨的情況，直接使用
            frameData[ball2Key] = roll2Pins;
          }
          
          // 確保第二球分數不超過剩餘球瓶數
          final maxBall2 = 10 - ball1Pins;
          if (frameData[ball2Key]! > maxBall2) {
            frameData[ball2Key] = maxBall2;
          }
          
          // 確保不為負數
          if (frameData[ball2Key]! < 0) {
            frameData[ball2Key] = 0;
          }
          
          rollIndex++;
        } else {
          frameData[ball2Key] = 0;
        }
      } else {
        // 第 10 格
        final roll1 = rolls[rollIndex];
        frameData[ball1Key] = roll1.pinsDown.where((p) => p).length;
        rollIndex++;

        if (rollIndex < rolls.length) {
          final roll2 = rolls[rollIndex];
          if (frameData[ball1Key]! == 10) {
            // 第一球是 strike，第二球重新計算
            frameData[ball2Key] = roll2.pinsDown.where((p) => p).length;
          } else {
            // 第一球不是 strike，第二球是新擊倒的
            final roll2Pins = roll2.pinsDown.where((p) => p).length;
            final ball1Pins = frameData[ball1Key]!;
            
            if (roll2Pins >= ball1Pins) {
              // roll2 是累加的情況
              frameData[ball2Key] = roll2Pins - ball1Pins;
            } else {
              // roll2 是單獨的情況，直接使用
              frameData[ball2Key] = roll2Pins;
            }
            
            // 第10格第二球的特殊邏輯：如果第一球不是strike，總和不能超過10
            final maxBall2 = 10 - ball1Pins;
            if (frameData[ball2Key]! > maxBall2) {
              frameData[ball2Key] = maxBall2;
            }
            
            // 確保不為負數
            if (frameData[ball2Key]! < 0) {
              frameData[ball2Key] = 0;
            }
          }
          rollIndex++;

          if (rollIndex < rolls.length) {
            final roll3 = rolls[rollIndex];
            if (frameData[ball1Key]! == 10 || (frameData[ball1Key]! + frameData[ball2Key]!) == 10) {
              frameData[ball3Key] = roll3.pinsDown.where((p) => p).length;
              rollIndex++;
            }
          }
        }
      }
    }

    // 添加調試資訊
    print('Extracted frame data: $frameData');
    
    // 驗證所有 frame 資料的合理性
    for (int frame = 1; frame <= 10; frame++) {
      final ball1Key = 'frame${frame}Ball1';
      final ball2Key = 'frame${frame}Ball2';
      final ball3Key = 'frame${frame}Ball3';
      
      final ball1 = frameData[ball1Key] ?? 0;
      final ball2 = frameData[ball2Key] ?? 0;
      final ball3 = frameData[ball3Key];
      
      // 檢查第1和第2球
      if (ball1 < 0 || ball1 > 10) {
        print('⚠️ Frame $frame Ball1 out of range: $ball1');
        frameData[ball1Key] = ball1.clamp(0, 10);
      }
      
      if (ball2 < 0 || ball2 > 10) {
        print('⚠️ Frame $frame Ball2 out of range: $ball2');
        frameData[ball2Key] = ball2.clamp(0, 10);
      }
      
      // 檢查前9格的總和
      if (frame < 10 && ball1 < 10 && (ball1 + ball2) > 10) {
        print('⚠️ Frame $frame total exceeds 10: ball1=$ball1, ball2=$ball2');
        frameData[ball2Key] = 10 - ball1;
      }
      
      // 檢查第10格的第3球
      if (frame == 10 && ball3 != null) {
        if (ball3 < 0 || ball3 > 10) {
          print('⚠️ Frame 10 Ball3 out of range: $ball3');
          frameData[ball3Key] = ball3.clamp(0, 10);
        }
      }
    }
    
    print('Validated frame data: $frameData');
    return frameData;
  }

  /// 計算當前的 frame（下一個要填的 frame）
  int _calculateCurrentFrame(Map<String, int> frameData) {
    for (int frame = 1; frame <= 10; frame++) {
      final ball1Key = 'frame${frame}Ball1';
      final ball2Key = 'frame${frame}Ball2';
      
      final ball1 = frameData[ball1Key] ?? 0;
      final ball2 = frameData[ball2Key] ?? 0;
      
      if (frame < 10) {
        // 前9格：如果第一球為0或者（不是strike且第二球為0），則這是當前格
        if (ball1 == 0) {
          return frame;
        } else if (ball1 < 10 && ball2 == 0) {
          return frame;
        }
      } else {
        // 第10格：複雜的邏輯
        final ball3Key = 'frame10Ball3';
        final ball3 = frameData[ball3Key];
        
        if (ball1 == 0) {
          return 10;
        } else if (ball1 == 10) {
          // 第一球是strike，需要兩個獎勵球
          if (ball2 == 0) return 10;
          if (ball3 == null) return 10;
          // 如果三球都有了，遊戲結束，返回10
          return 10;
        } else {
          // 第一球不是strike
          if (ball2 == 0) return 10;
          if (ball1 + ball2 == 10) {
            // Spare，需要獎勵球
            if (ball3 == null) return 10;
          }
          // 遊戲完成，返回10
          return 10;
        }
      }
    }
    
    return 10; // 預設最後一格
  }

  /// 判斷遊戲是否完成
  bool _isGameCompleted(Map<String, int> frameData, ScoringState scoringState) {
    // 首先檢查ScoringController的判斷
    if (scoringState.isGameComplete) {
      return true;
    }
    
    // 手動檢查第10格是否完成
    final frame10Ball1 = frameData['frame10Ball1'] ?? 0;
    final frame10Ball2 = frameData['frame10Ball2'] ?? 0;
    
    // 檢查前9格是否都有資料
    bool allPreviousFramesComplete = true;
    for (int frame = 1; frame <= 9; frame++) {
      final ball1 = frameData['frame${frame}Ball1'] ?? 0;
      final ball2 = frameData['frame${frame}Ball2'] ?? 0;
      
      if (ball1 == 0 && ball2 == 0) {
        allPreviousFramesComplete = false;
        break;
      }
      
      // 如果第一球不是strike且第二球為0，表示這格未完成
      if (ball1 < 10 && ball2 == 0) {
        allPreviousFramesComplete = false;
        break;
      }
    }
    
    // 如果前9格未完成，整個遊戲未完成
    if (!allPreviousFramesComplete) {
      return false;
    }
    
    // 檢查第10格的完成狀態 (Current 計分模式：沒有獎勵球)
    if (frame10Ball1 == 0) {
      // 第10格還沒開始
      return false;
    } else if (frame10Ball1 == 10) {
      // Current 模式：第10格Strike，遊戲直接結束，不需要獎勵球
      return true;
    } else {
      // 第一球不是strike，需要第二球
      if (frame10Ball2 == 0) {
        // 第二球還沒投
        return false;
      } else {
        // Current 模式：第10格有兩球（無論是否Spare），遊戲結束
        return true;
      }
    }
  }

  void _onToggleEdit(BuildContext context, WidgetRef ref) {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    ref.read(scoringControllerProvider(controllerParams).notifier).toggleEditMode();
  }

  Future<void> _editFrame(BuildContext context, WidgetRef ref, int frameIndex) async {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _convertRollRecordsToInts(_initialRolls),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    // Editing logic now simplified to just collect pin counts,
    // as the controller's editFrame expects List<int> for now.

    final List<bool>? firstBallState = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PinSelectionDialog(
        controller: _pinController,
        isFirstRoll: true,
        frameNumber: frameIndex + 1, // Convert 0-based to 1-based
      ),
    );

    if (firstBallState == null) return;
    final int firstBallPins = firstBallState.where((p) => p).length;

    final List<int> newRollsForFrame = [firstBallPins];

    if (firstBallPins < 10) {
      final List<bool>? secondBallState = await showDialog<List<bool>>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => PinSelectionDialog(
          controller: _pinController,
          initialPinState: firstBallState,
          isFirstRoll: false,
          frameNumber: frameIndex + 1, // Convert 0-based to 1-based
        ),
      );
      
      if (secondBallState == null) return;
      
      final int totalPinsDown = secondBallState.where((p) => p).length;
      final int secondBallPins = totalPinsDown - firstBallPins;
      newRollsForFrame.add(secondBallPins);
    }

    await scoringController.editFrame(frameIndex, newRollsForFrame);
  }
} 