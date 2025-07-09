import 'package:bowlingarsenal_app/models/score_data.dart';
import 'package:bowlingarsenal_app/widgets/bowling/simple_pins_down_selector.dart';
import 'package:bowlingarsenal_app/widgets/bowling/score_game_widget.dart';
import 'package:bowlingarsenal_app/widgets/bowling/tenth_frame_widget.dart';
import 'package:flutter/material.dart';

class EditableBowlingScoreTable extends StatefulWidget {
  const EditableBowlingScoreTable({
    required this.scoreData,
    required this.modifiedFrames,
    required this.onCellEdit,
    super.key,
    this.width,
  });
  final BowlingScoreData scoreData;
  final Set<int> modifiedFrames;
  final void Function(int frameIndex) onCellEdit;
  final double? width;

  @override
  _EditableBowlingScoreTableState createState() =>
      _EditableBowlingScoreTableState();
}

class _EditableBowlingScoreTableState extends State<EditableBowlingScoreTable> {
  Future<void> _editFrame(BuildContext context, int frameIdx) async {
    final frame = widget.scoreData.frames[frameIdx];
    if (frame.rolls.isEmpty) return;
    
    final originalRolls = List<Roll>.from(frame.rolls);
    final wasComplete = frame.isComplete;
    frame.rolls.clear();
    frame.isComplete = false;
    
    // 計算最大可選擇的倒瓶數（第一球總是10）
    const maxPins = 10;
    
    final selectedPinsDown = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return SimplePinsDownSelector(
          maxPins: maxPins,
          initialPinsDown: 0,
        );
      },
    );
    
    if (selectedPinsDown != null) {
      // 計算倒瓶後剩餘的瓶數
      Set<int> pinsStandingAfterThrow;
      if (selectedPinsDown == 10) {
        pinsStandingAfterThrow = {};
      } else {
        pinsStandingAfterThrow = {};
        for (int i = selectedPinsDown + 1; i <= 10; i++) {
          pinsStandingAfterThrow.add(i);
        }
      }
      
      final newRoll = Roll(
        pinsDown: selectedPinsDown,
        pinsStandingAfterThrow: pinsStandingAfterThrow,
        displayScore: selectedPinsDown == 10 ? 'X' : selectedPinsDown.toString(),
        pinsStandingBeforeThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
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
                ball1Score:
                    frame.rolls.isNotEmpty ? frame.rolls[0].displayScore : null,
                ball2Score:
                    frame.rolls.length > 1 ? frame.rolls[1].displayScore : null,
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
                  color:
                      widget.modifiedFrames.contains(9)
                          ? Colors.red
                          : Colors.transparent,
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
