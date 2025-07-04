import 'package:bowlingarsenal_app/models/score_data.dart';
import 'package:bowlingarsenal_app/widgets/bowling/pin_selector_popup_widget.dart';
import 'package:bowlingarsenal_app/widgets/bowling/score_game_widget.dart';
import 'package:bowlingarsenal_app/widgets/bowling/tenth_frame_widget.dart';
import 'package:flutter/material.dart';

class EditableBowlingScoreTable extends StatefulWidget {

  const EditableBowlingScoreTable({
    required this.scoreData, required this.modifiedFrames, required this.onCellEdit, super.key,
    this.width,
  });
  final BowlingScoreData scoreData;
  final Set<int> modifiedFrames;
  final void Function(int frameIndex) onCellEdit;
  final double? width;

  @override
  _EditableBowlingScoreTableState createState() => _EditableBowlingScoreTableState();
}

class _EditableBowlingScoreTableState extends State<EditableBowlingScoreTable> {
  Future<void> _editFrame(BuildContext context, int frameIdx) async {
    final frame = widget.scoreData.frames[frameIdx];
    if (frame.rolls.isEmpty) return;
    final initialPinsDown = <int>{};
    final originalRolls = List<Roll>.from(frame.rolls);
    final wasComplete = frame.isComplete;
    frame.rolls.clear();
    frame.isComplete = false;
    final pinsHit = await showDialog<Set<int>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinSelectorPopupWidget(
          initialPinsDown: initialPinsDown,
          pinStandingAssetPath: 'assets/images/pin_standing.svg',
          pinFallenAssetPath: 'assets/images/pin_fallen.svg',
        );
      },
    );
    if (pinsHit != null) {
      final pinsDown = pinsHit.length;
      final newRoll = Roll(
        pinsDown: pinsDown,
        pinsStandingAfterThrow: {1,2,3,4,5,6,7,8,9,10}.difference(pinsHit),
        displayScore: pinsDown == 10 ? 'X' : pinsDown.toString(),
        pinsStandingBeforeThrow: {1,2,3,4,5,6,7,8,9,10},
      );
      frame.rolls.add(newRoll);
      widget.scoreData.calculateScores();
      widget.onCellEdit(frameIdx);
    } else {
      frame.rolls.clear();
      frame.rolls.addAll(originalRolls);
      frame.isComplete = wasComplete;
      widget.scoreData.calculateScores();
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth = widget.width ?? MediaQuery.of(context).size.width;
    final frameWidth = availableWidth / 10;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(9, (index) {
          final frame = widget.scoreData.frames[index];
          final isModified = widget.modifiedFrames.contains(index);
          return GestureDetector(
            onTap: () => _editFrame(context, index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isModified ? Colors.red : Colors.transparent,
                  width: isModified ? 2 : 0,
                ),
              ),
              child: ScoreFrameWidget(
                frameNumber: index + 1,
                ball1Score: frame.rolls.isNotEmpty ? frame.rolls[0].displayScore : null,
                ball2Score: frame.rolls.length > 1 ? frame.rolls[1].displayScore : null,
                frameTotalScore: frame.totalScore?.toString(),
                availableWidth: frameWidth,
              ),
            ),
          );
        })..add(
          GestureDetector(
            onTap: () => _editFrame(context, 9),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.modifiedFrames.contains(9) ? Colors.red : Colors.transparent,
                  width: widget.modifiedFrames.contains(9) ? 2 : 0,
                ),
              ),
              child: TenthFrameWidget(
                frame: widget.scoreData.frames[9],
                isCurrentFrame: false,
                availableWidth: frameWidth,
                onFrameUpdated: (_) {},
                onGameComplete: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
} 