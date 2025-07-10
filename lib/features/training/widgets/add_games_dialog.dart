import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/bowling/simple_pins_down_selector.dart';
import 'package:flutter/material.dart';

class AddGamesDialog extends StatefulWidget {
  const AddGamesDialog({
    required this.trainingId,
    required this.scoringMethod,
    super.key,
  });
  final String trainingId;
  final String scoringMethod;

  @override
  State<AddGamesDialog> createState() => _AddGamesDialogState();
}

class _AddGamesDialogState extends State<AddGamesDialog> {
  late List<Frame> frames;
  int currentFrameIndex = 0;
  late BowlingScoreData scoreData;

  @override
  void initState() {
    super.initState();
    // 初始化10格空白的計分格
    scoreData = BowlingScoreData.newGame();
    frames = scoreData.frames;
  }

  void _onFrameUpdated(Frame frame) {
    setState(() {
      frames[frame.frameNumber - 1] = frame;
      if (frame.isComplete && frame.frameNumber < 10) {
        currentFrameIndex = frame.frameNumber;
      }
      scoreData.calculateScores();
    });
  }

  Set<int> _getInitialPinsDown(Frame frame) {
    if (frame.rolls.isEmpty) {
      // 第一球，所有瓶子都站立
      return {};
    } else if (frame.rolls.length == 1) {
      // 第二球
      if (frame.rolls[0].pinsDown == 10) {
        // 第一球全倒，第二球重置
        return {};
      } else {
        // 第一球沒全倒，第二球顯示已倒的瓶子
        return {
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
        }.difference(frame.rolls[0].pinsStandingAfterThrow ?? {});
      }
    }
    return {};
  }

  void _onGameComplete() {
    scoreData.calculateScores();
    Navigator.of(context).pop(frames);
  }

  String _getDisplayScore(Frame frame, int pinsDown) {
    if (frame.rolls.isEmpty) {
      // 第一球
      return pinsDown == 10 ? 'X' : pinsDown.toString();
    } else {
      // 第二球
      if (frame.rolls[0].pinsDown < 10 &&
          frame.rolls[0].pinsDown + pinsDown == 10) {
        return '/';
      }
      return pinsDown.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final frameWidth = (screenWidth - 32) / 5; // 每行顯示5格，左右各留16的邊距

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('新增遊戲', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i < 9; i++)
                  GestureDetector(
                    onTap: () {
                      if (currentFrameIndex == i) {
                        // 計算可用的最大倒瓶數
                        int maxPins = 10;
                        if (frames[i].rolls.isNotEmpty) {
                          maxPins = 10 - frames[i].rolls[0].pinsDown;
                        }
                        
                        showDialog<int>(
                          context: context,
                          builder:
                              (context) => SimplePinsDownSelector(
                                maxPins: maxPins,
                                initialPinsDown: 0,
                              ),
                        ).then((selectedPinsDown) {
                          if (selectedPinsDown != null) {
                            setState(() {
                              // 計算站立的瓶數
                              Set<int> pinsStandingAfterThrow;
                              Set<int> pinsStandingBeforeThrow;
                              
                              if (frames[i].rolls.isEmpty) {
                                // 第一球
                                pinsStandingBeforeThrow = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
                                if (selectedPinsDown == 10) {
                                  pinsStandingAfterThrow = {};
                                } else {
                                  pinsStandingAfterThrow = {};
                                  for (int j = selectedPinsDown + 1; j <= 10; j++) {
                                    pinsStandingAfterThrow.add(j);
                                  }
                                }
                              } else {
                                // 第二球
                                pinsStandingBeforeThrow = frames[i].rolls[0].pinsStandingAfterThrow!;
                                final totalPinsDown = frames[i].rolls[0].pinsDown + selectedPinsDown;
                                if (totalPinsDown == 10) {
                                  pinsStandingAfterThrow = {};
                                } else {
                                  pinsStandingAfterThrow = {};
                                  for (int j = totalPinsDown + 1; j <= 10; j++) {
                                    pinsStandingAfterThrow.add(j);
                                  }
                                }
                              }
                              
                              final roll = Roll(
                                pinsDown: selectedPinsDown,
                                pinsStandingAfterThrow: pinsStandingAfterThrow,
                                displayScore: _getDisplayScore(
                                  frames[i],
                                  selectedPinsDown,
                                ),
                                pinsStandingBeforeThrow: pinsStandingBeforeThrow,
                              );
                              frames[i].rolls.add(roll);

                              if (frames[i].rolls.length == 2 ||
                                  (frames[i].rolls.length == 1 &&
                                      selectedPinsDown == 10)) {
                                frames[i].isComplete = true;
                                if (i < 9) {
                                  currentFrameIndex = i + 1;
                                }
                              }
                              scoreData.calculateScores();
                            });
                          }
                        });
                      }
                    },
                    child: ScoreFrameWidget(
                      frameNumber: i + 1,
                      availableWidth: frameWidth,
                      isCurrentFrame: currentFrameIndex == i,
                      ball1Score:
                          frames[i].rolls.isNotEmpty
                              ? frames[i].rolls[0].displayScore
                              : null,
                      ball2Score:
                          frames[i].rolls.length > 1
                              ? frames[i].rolls[1].displayScore
                              : null,
                      frameTotalScore: frames[i].totalScore?.toString(),
                    ),
                  ),
                TenthFrameWidget(
                  frame: frames[9],
                  isCurrentFrame: currentFrameIndex == 9,
                  availableWidth: frameWidth,
                  onFrameUpdated: _onFrameUpdated,
                  onGameComplete: _onGameComplete,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppStandardButton(
                  text: '取消',
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                AppStandardButton(
                  text: '完成',
                  onPressed: _onGameComplete,
                  isPrimary: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
