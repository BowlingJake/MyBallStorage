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
import 'package:bowlingarsenal_app/features/training/widgets/components/ball_selection_section.dart';
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
  late final PinSelectionController _pinController; // Add controller

  @override
  void initState() {
    super.initState();
    _selectedBalls = widget.game.ballsUsed ?? (widget.game.ballUsed != null ? [widget.game.ballUsed!] : []);
    _pinController = PinSelectionController(); // Initialize controller
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
    
    final scoringController = ref.read(scoringControllerProvider(controllerParams).notifier);

    // Editing logic now simplified to just collect pin counts,
    // as the controller's editFrame expects List<int> for now.

    final List<bool>? firstBallState = await showDialog<List<bool>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PinSelectionDialog(
        controller: _pinController,
        isFirstRoll: true,
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