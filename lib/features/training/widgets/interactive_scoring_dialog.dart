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
import 'package:bowlingarsenal_app/shared/widgets/common/ball_selection_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedBalls = widget.game.ballsUsed ?? (widget.game.ballUsed != null ? [widget.game.ballUsed!] : []);
  }
  
  @override
  Widget build(BuildContext context) {
    final initialRolls = _reconstructRollsFromGame(widget.game);
    
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: initialRolls,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: BallSelectionWidget(
                            initialBalls: _selectedBalls,
                            onBallsSelected: (balls) {
                              setState(() {
                                _selectedBalls = balls;
                              });
                            },
                            accentColor: scoringColor,
                          ),
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
    if (game.score == 0 || game.frameScores.isEmpty) {
      return null;
    }
    
    if (DateTime.now().difference(game.timestamp).inMinutes < 5) {
      if (game.score == 0) {
        return null;
      }
    }
    return null;
  }

  Future<void> _onFrameTapped(BuildContext context, WidgetRef ref, int frameIndex) async {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _reconstructRollsFromGame(widget.game),
      gameId: widget.game.id,
    );
    
    final scoringState = ref.read(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    if (scoringState.isGameComplete && !scoringState.isEditMode) return;
    
    if (scoringState.isEditMode) {
      if (!scoringController.canEditFrame(frameIndex)) {
        return;
      }
      await _editFrame(context, ref, frameIndex);
      return;
    }
    
    if (!scoringController.canInputAtFrame(frameIndex)) {
      return;
    }

    final selectedPinsDown = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimplePinsDownSelector(
        maxPins: 10,
        initialPinsDown: 0,
      ),
    );

    if (selectedPinsDown != null) {
      scoringController.processPinSelection(frameIndex, selectedPinsDown);
      HapticFeedback.lightImpact();
    }
  }

  void _onUndo(WidgetRef ref) {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _reconstructRollsFromGame(widget.game),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    scoringController.undoLastRoll();
    HapticFeedback.selectionClick();
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _reconstructRollsFromGame(widget.game),
      gameId: widget.game.id,
    );
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);
    final scoringState = ref.read(scoringControllerProvider(controllerParams));

    final updatedGame = GameRecord(
      id: widget.game.id,
      gameNumber: widget.game.gameNumber,
      score: scoringController.finalScore,
      frameScores: scoringState.frames.map((f) => f.cumulativeScore).toList(),
      strikes: scoringController.countStrikes(),
      spares: scoringController.countSpares(),
      notes: widget.game.notes,
      timestamp: widget.game.timestamp,
      ballUsed: _selectedBalls.isNotEmpty ? _selectedBalls.first : null,
      ballsUsed: _selectedBalls.isNotEmpty ? _selectedBalls : null,
    );

    widget.onGameSaved?.call(updatedGame);
    Navigator.of(context).pop();
  }

  void _onToggleEdit(BuildContext context, WidgetRef ref) {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _reconstructRollsFromGame(widget.game),
      gameId: widget.game.id,
    );
    
    ref.read(scoringControllerProvider(controllerParams).notifier).toggleEditMode();
  }

  Future<void> _editFrame(BuildContext context, WidgetRef ref, int frameIndex) async {
    final controllerParams = ScoringControllerParams(
      scoringMethod: widget.scoringMethod,
      initialRolls: _reconstructRollsFromGame(widget.game),
      gameId: widget.game.id,
    );
    
    final scoringState = ref.read(scoringControllerProvider(controllerParams));
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    int rollStartIndex = 0;
    for (int i = 0; i < frameIndex; i++) {
      if (i < 9) {
        if (rollStartIndex < scoringState.rolls.length && scoringState.rolls[rollStartIndex] == 10) {
          rollStartIndex += 1;
        } else {
          rollStartIndex += 2;
        }
      } else {
        break;
      }
    }
    
    if (rollStartIndex >= scoringState.rolls.length) {
      return;
    }
    
    final currentFirstBall = scoringState.rolls[rollStartIndex];
    final hasSecondBall = rollStartIndex + 1 < scoringState.rolls.length && currentFirstBall < 10;
    final currentSecondBall = hasSecondBall ? scoringState.rolls[rollStartIndex + 1] : 0;
    
    final newFirstBall = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimplePinsDownSelector(
        maxPins: 10,
        initialPinsDown: currentFirstBall,
      ),
    );

    if (newFirstBall == null) return;

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

    scoringController.editFrame(frameIndex, newFirstBall, newSecondBall);
  }
} 