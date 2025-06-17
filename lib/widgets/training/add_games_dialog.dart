import 'package:flutter/material.dart';
import '../score_game_widget.dart';
import '../tenth_frame_widget.dart';
import '../pin_selector_popup_widget.dart';
import '../../models/score_data.dart';

class AddGamesDialog extends StatefulWidget {
  final String trainingId;
  final String scoringMethod;

  const AddGamesDialog({
    Key? key,
    required this.trainingId,
    required this.scoringMethod,
  }) : super(key: key);

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
        return {1,2,3,4,5,6,7,8,9,10}.difference(frame.rolls[0].pinsStandingAfterThrow ?? {});
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
      return pinsDown == 10 ? "X" : pinsDown.toString();
    } else {
      // 第二球
      if (frame.rolls[0].pinsDown < 10 && frame.rolls[0].pinsDown + pinsDown == 10) {
        return "/";
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
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '新增遊戲',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (int i = 0; i < 9; i++)
                  GestureDetector(
                    onTap: () {
                      if (currentFrameIndex == i) {
                        showDialog(
                          context: context,
                          builder: (context) => PinSelectorPopupWidget(
                            initialPinsDown: _getInitialPinsDown(frames[i]),
                            pinStandingAssetPath: 'assets/images/pin_standing.svg',
                            pinFallenAssetPath: 'assets/images/pin_fallen.svg',
                          ),
                        ).then((pinsHit) {
                          if (pinsHit != null) {
                            setState(() {
                              final pinsDown = pinsHit.length;
                              final roll = Roll(
                                pinsDown: pinsDown,
                                pinsStandingAfterThrow: {1,2,3,4,5,6,7,8,9,10}.difference(pinsHit),
                                displayScore: _getDisplayScore(frames[i], pinsDown),
                                pinsStandingBeforeThrow: frames[i].rolls.isEmpty ? 
                                  {1,2,3,4,5,6,7,8,9,10} : 
                                  frames[i].rolls.last.pinsStandingAfterThrow ?? {},
                              );
                              frames[i].rolls.add(roll);
                              
                              if (frames[i].rolls.length == 2 || (frames[i].rolls.length == 1 && pinsDown == 10)) {
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
                      ball1Score: frames[i].rolls.isNotEmpty ? frames[i].rolls[0].displayScore : null,
                      ball2Score: frames[i].rolls.length > 1 ? frames[i].rolls[1].displayScore : null,
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onGameComplete,
                  child: Text('完成'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 