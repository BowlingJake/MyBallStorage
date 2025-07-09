import 'package:bowlingarsenal_app/models/score_data.dart';
import 'package:bowlingarsenal_app/widgets/bowling/simple_pins_down_selector.dart';
import 'package:bowlingarsenal_app/widgets/bowling/score_game_widget.dart';
import 'package:bowlingarsenal_app/widgets/bowling/tenth_frame_widget.dart';
import 'package:flutter/material.dart';

class BowlingScoreTable extends StatefulWidget {
  const BowlingScoreTable({super.key, this.scoreData, this.onScoreChanged});
  final BowlingScoreData? scoreData;
  final void Function(BowlingScoreData data)? onScoreChanged;

  @override
  State<BowlingScoreTable> createState() => _BowlingScoreTableState();
}

class _BowlingScoreTableState extends State<BowlingScoreTable> {
  late BowlingScoreData _scoreData;

  @override
  void initState() {
    super.initState();
    _scoreData = widget.scoreData ?? BowlingScoreData.newGame();
  }

  void _updateAndNotify() {
    setState(() {});
    if (widget.onScoreChanged != null) {
      widget.onScoreChanged!(_scoreData);
    }
  }

  Future<void> _handleFrameTap(int frameIndex, {bool isEdit = false}) async {
    final currentFrame = _scoreData.frames[frameIndex];
    Set<int> initialPinsDown;

    if (frameIndex == 9) {
      // 第十格特殊邏輯
      if (currentFrame.rolls.isEmpty) {
        // 第一球，10瓶全站立
        initialPinsDown = {};
      } else if (currentFrame.rolls.length == 1) {
        // 第二球
        if (currentFrame.rolls[0].pinsDown == 10) {
          // 第一球全倒，第二球重置
          initialPinsDown = {};
        } else {
          // 第一球沒全倒，第二球剩下的瓶
          initialPinsDown = {
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
          }.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
        }
      } else if (currentFrame.rolls.length == 2) {
        // 第三球
        if (currentFrame.rolls[0].pinsDown == 10) {
          // 第一球全倒，第三球重置
          initialPinsDown = {};
        } else if (currentFrame.rolls[0].pinsDown +
                currentFrame.rolls[1].pinsDown ==
            10) {
          // 前兩球補中，第三球重置
          initialPinsDown = {};
        } else {
          // 不應該有第三球
          return;
        }
      } else {
        // 已經三球，不能再投
        return;
      }
    } else {
      // 前九格
      initialPinsDown =
          currentFrame.rolls.isEmpty
              ? {}
              : {
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
              }.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
    }

    // 計算可用的最大倒瓶數
    int maxPins = 10;
    if (frameIndex < 9 && currentFrame.rolls.isNotEmpty) {
      // 第1-9格第二球
      maxPins = 10 - currentFrame.rolls[0].pinsDown;
    } else if (frameIndex == 9 && currentFrame.rolls.isNotEmpty) {
      // 第10格邏輯
      if (currentFrame.rolls.length == 1 && currentFrame.rolls[0].pinsDown < 10) {
        maxPins = 10 - currentFrame.rolls[0].pinsDown;
      }
      // 其他情況保持 maxPins = 10
    }

    // 顯示數字選單
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

    if (selectedPinsDown != null && mounted) {
      setState(() {
        // 計算站立的瓶數
        Set<int> pinsStandingAfterThrow;
        Set<int> pinsStandingBeforeThrow;
        
        if (currentFrame.rolls.isEmpty) {
          // 第一球
          pinsStandingBeforeThrow = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
          if (selectedPinsDown == 10) {
            pinsStandingAfterThrow = {};
          } else {
            // 簡化處理：假設倒的是前 selectedPinsDown 個瓶
            pinsStandingAfterThrow = {};
            for (int i = selectedPinsDown + 1; i <= 10; i++) {
              pinsStandingAfterThrow.add(i);
            }
          }
        } else {
          // 第二球或之後
          if (frameIndex < 9) {
            // 第1-9格第二球
            pinsStandingBeforeThrow = currentFrame.rolls[0].pinsStandingAfterThrow!;
            pinsStandingAfterThrow = {};
            final totalPinsDown = currentFrame.rolls[0].pinsDown + selectedPinsDown;
            if (totalPinsDown < 10) {
              for (int i = totalPinsDown + 1; i <= 10; i++) {
                pinsStandingAfterThrow.add(i);
              }
            }
          } else {
            // 第10格邏輯
            pinsStandingBeforeThrow = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
            if (selectedPinsDown == 10) {
              pinsStandingAfterThrow = {};
            } else {
              pinsStandingAfterThrow = {};
              for (int i = selectedPinsDown + 1; i <= 10; i++) {
                pinsStandingAfterThrow.add(i);
              }
            }
          }
        }

        // 創建新的 Roll 記錄
        final newRoll = Roll(
          pinsDown: selectedPinsDown,
          pinsStandingAfterThrow: pinsStandingAfterThrow,
          displayScore: _getDisplayScore(selectedPinsDown, frameIndex),
          pinsStandingBeforeThrow: pinsStandingBeforeThrow,
        );

        // 更新當前局的記錄
        currentFrame.rolls.add(newRoll);

        // 更新站立的瓶數
        _scoreData.pinsStanding = pinsStandingAfterThrow;

        // 檢查是否需要進入下一局
        _checkAndAdvanceFrame(frameIndex, isEdit: isEdit);

        // 重新計算分數
        _scoreData.calculateScores();
      });
      _updateAndNotify();
    }
  }

  Future<void> _handleFrameEditTap(int frameIndex) async {
    final currentFrame = _scoreData.frames[frameIndex];
    if (currentFrame.rolls.length == 1) {
      // 只輸入過第一球，直接進入第二球 pin selector
      // 不清空第一球紀錄
      Set<int> initialPinsDown;
      if (currentFrame.rolls[0].pinsDown == 10) {
        // 第一球全倒，第二球應該全部站立
        initialPinsDown = {};
      } else {
        initialPinsDown = {
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
        }.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
      }
      // 計算可用的最大倒瓶數
      int maxPins = 10;
      if (currentFrame.rolls[0].pinsDown < 10) {
        maxPins = 10 - currentFrame.rolls[0].pinsDown;
      }
      
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
      if (selectedPinsDown != null && mounted) {
        setState(() {
          // 計算站立的瓶數
          Set<int> pinsStandingAfterThrow;
          
          if (currentFrame.rolls[0].pinsDown == 10) {
            // 第一球全倒的情況
            if (selectedPinsDown == 10) {
              pinsStandingAfterThrow = {};
            } else {
              pinsStandingAfterThrow = {};
              for (int i = selectedPinsDown + 1; i <= 10; i++) {
                pinsStandingAfterThrow.add(i);
              }
            }
          } else {
            // 第一球不是全倒的情況
            final totalPinsDown = currentFrame.rolls[0].pinsDown + selectedPinsDown;
            if (totalPinsDown == 10) {
              pinsStandingAfterThrow = {};
            } else {
              pinsStandingAfterThrow = {};
              for (int i = totalPinsDown + 1; i <= 10; i++) {
                pinsStandingAfterThrow.add(i);
              }
            }
          }
          
          final newRoll = Roll(
            pinsDown: selectedPinsDown,
            pinsStandingAfterThrow: pinsStandingAfterThrow,
            displayScore: _getDisplayScore(selectedPinsDown, frameIndex),
            pinsStandingBeforeThrow:
                currentFrame.rolls[0].pinsStandingAfterThrow!,
          );
          // 修正：如果原本第一球是全倒，這次其實是要覆蓋第一球
          if (currentFrame.rolls[0].pinsDown == 10) {
            currentFrame.rolls[0] = newRoll;
          } else {
            currentFrame.rolls.add(newRoll);
          }
          _scoreData.pinsStanding = pinsStandingAfterThrow;
          _checkAndAdvanceFrame(frameIndex, isEdit: true);
          _scoreData.calculateScores();
        });
        if (widget.onScoreChanged != null) {
          widget.onScoreChanged!(_scoreData);
        }
      }
    } else {
      // 其他情況（如有兩球或三球），清空該格，重新輸入第一球
      setState(() {
        currentFrame.rolls.clear();
        currentFrame.isComplete = false;
        _scoreData.isGameOver = false;
        if (frameIndex < 9) {
          _scoreData.pinsStanding = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        }
      });
      await _handleFrameTap(frameIndex, isEdit: true);
      setState(() {
        _scoreData.calculateScores();
      });
      if (widget.onScoreChanged != null) {
        widget.onScoreChanged!(_scoreData);
      }
    }
  }

  String _getDisplayScore(int pinsDown, int frameIndex) {
    final currentFrame = _scoreData.frames[frameIndex];
    // 第一球全倒才顯示 X
    if (pinsDown == 10 && currentFrame.rolls.isEmpty) return 'X';
    // 第二球補中才顯示 /
    if (currentFrame.rolls.length == 1) {
      final previousPins = currentFrame.rolls[0].pinsDown;
      if (previousPins + pinsDown == 10) return '/';
    }
    return pinsDown.toString();
  }

  // 取得第十格顯示分數（strike 顯示 X，spare 顯示 /，其餘顯示數字）
  String? getTenthFrameDisplayScore(int ballIndex, Frame frame) {
    if (frame.rolls.length <= ballIndex) return null;
    final roll = frame.rolls[ballIndex];

    // 第一球
    if (ballIndex == 0) {
      if (roll.pinsDown == 10) return 'X';
      return roll.pinsDown.toString();
    }

    // 第二球
    if (ballIndex == 1) {
      if (roll.pinsDown == 10) return 'X';
      if (frame.rolls[0].pinsDown < 10 &&
          frame.rolls[0].pinsDown + roll.pinsDown == 10) {
        return '/';
      }
      return roll.pinsDown.toString();
    }

    // 第三球
    if (ballIndex == 2) {
      // 如果第一球是全倒，第三球可以顯示
      if (frame.rolls[0].pinsDown == 10) {
        if (roll.pinsDown == 10) return 'X';
        if (frame.rolls[1].pinsDown < 10 &&
            frame.rolls[1].pinsDown + roll.pinsDown == 10) {
          return '/';
        }
        return roll.pinsDown.toString();
      }
      // 如果前兩球補中，第三球可以顯示
      else if (frame.rolls[0].pinsDown + frame.rolls[1].pinsDown == 10) {
        if (roll.pinsDown == 10) return 'X';
        return roll.pinsDown.toString();
      }
      // 其他情況不應該有第三球
      return null;
    }

    return roll.pinsDown.toString();
  }

  void _checkAndAdvanceFrame(int frameIndex, {bool isEdit = false}) {
    final currentFrame = _scoreData.frames[frameIndex];
    if (frameIndex == 9) {
      // 第十格邏輯
      if (currentFrame.rolls.length == 1) {
        // 第一球後，什麼都不做，等第二球
        return;
      } else if (currentFrame.rolls.length == 2) {
        final first = currentFrame.rolls[0].pinsDown;
        final second = currentFrame.rolls[1].pinsDown;
        if (first == 10 || first + second == 10) {
          // Strike 或 Spare，允許第三球
          return;
        } else {
          // 不是Strike也不是Spare，結束
          currentFrame.isComplete = true;
          _scoreData.isGameOver = true;
          _scoreData.currentFrameIndex = -1; // 設置為 -1 表示沒有當前格
        }
      } else if (currentFrame.rolls.length == 3) {
        // 三球結束
        currentFrame.isComplete = true;
        _scoreData.isGameOver = true;
        _scoreData.currentFrameIndex = -1; // 設置為 -1 表示沒有當前格
      }
    } else {
      // 前九格
      if (currentFrame.rolls.length == 2 ||
          currentFrame.rolls[0].pinsDown == 10) {
        currentFrame.isComplete = true;
        if (!isEdit) {
          _scoreData.currentFrameIndex++;
        }
        _scoreData.pinsStanding = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final frameWidth = availableWidth / 10;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(9, (index) {
              final frame = _scoreData.frames[index];
              final isCurrentFrame = (index == _scoreData.currentFrameIndex);

              return GestureDetector(
                onTap: isCurrentFrame ? () => _handleFrameTap(index) : null,
                child: ScoreFrameWidget(
                  frameNumber: index + 1,
                  ball1Score:
                      frame.rolls.isNotEmpty
                          ? frame.rolls[0].displayScore
                          : null,
                  ball2Score:
                      frame.rolls.length > 1
                          ? frame.rolls[1].displayScore
                          : null,
                  frameTotalScore: frame.totalScore?.toString(),
                  availableWidth: frameWidth,
                  isCurrentFrame: isCurrentFrame,
                ),
              );
            })..add(
              TenthFrameWidget(
                frame: _scoreData.frames[9],
                isCurrentFrame: (9 == _scoreData.currentFrameIndex),
                availableWidth: frameWidth,
                onFrameUpdated: (frame) {
                  setState(() {
                    _scoreData.calculateScores();
                    // 如果第十格完成，設置遊戲結束，但不設置 currentFrameIndex
                    if (frame.isComplete) {
                      _scoreData.isGameOver = true;
                    }
                  });
                  if (widget.onScoreChanged != null) {
                    widget.onScoreChanged!(_scoreData);
                  }
                },
                onGameComplete: () {
                  setState(() {
                    _scoreData.isGameOver = true;
                    _scoreData.currentFrameIndex = -1; // 遊戲結束，取消高亮
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
