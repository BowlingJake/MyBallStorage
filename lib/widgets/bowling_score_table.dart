import 'package:flutter/material.dart';
import 'score_game_widget.dart';
import '../models/score_data.dart';
import 'pin_selector_popup_widget.dart';

class BowlingScoreTable extends StatefulWidget {
  const BowlingScoreTable({super.key});

  @override
  State<BowlingScoreTable> createState() => _BowlingScoreTableState();
}

class _BowlingScoreTableState extends State<BowlingScoreTable> {
  late BowlingScoreData _scoreData;

  @override
  void initState() {
    super.initState();
    _scoreData = BowlingScoreData.newGame();
  }

  Future<void> _handleFrameTap(int frameIndex, {bool isEdit = false}) async {
    final Frame currentFrame = _scoreData.frames[frameIndex];
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
          initialPinsDown = {1,2,3,4,5,6,7,8,9,10}.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
        }
      } else if (currentFrame.rolls.length == 2) {
        // 第三球
        if (currentFrame.rolls[0].pinsDown == 10 || 
            (currentFrame.rolls[0].pinsDown + currentFrame.rolls[1].pinsDown == 10)) {
          // 第一球X 或 前兩球補中，第三球重置
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
      initialPinsDown = currentFrame.rolls.isEmpty
          ? {}
          : {1,2,3,4,5,6,7,8,9,10}.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
    }

    // 其餘邏輯不變
    final Set<int>? pinsHit = await showDialog<Set<int>>(
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

    if (pinsHit != null && mounted) {
      setState(() {
        // 計算擊倒的瓶數
        final int pinsDown = pinsHit.length;
        
        // 創建新的 Roll 記錄
        final Roll newRoll = Roll(
          pinsDown: pinsDown,
          pinsStandingAfterThrow: {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(pinsHit),
          displayScore: _getDisplayScore(pinsDown, frameIndex),
          pinsStandingBeforeThrow: _scoreData.pinsStanding,
        );

        // 更新當前局的記錄
        currentFrame.rolls.add(newRoll);
        
        // 更新站立的瓶數
        _scoreData.pinsStanding = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(pinsHit);

        // 檢查是否需要進入下一局
        _checkAndAdvanceFrame(frameIndex, isEdit: isEdit);

        // 重新計算分數
        _scoreData.calculateScores();
      });
    }
  }

  Future<void> _handleFrameEditTap(int frameIndex) async {
    final Frame currentFrame = _scoreData.frames[frameIndex];
    if (currentFrame.rolls.length == 1) {
      // 只輸入過第一球，直接進入第二球 pin selector
      // 不清空第一球紀錄
      Set<int> initialPinsDown;
      if (currentFrame.rolls[0].pinsDown == 10) {
        // 第一球全倒，第二球應該全部站立
        initialPinsDown = {};
      } else {
        initialPinsDown = {1,2,3,4,5,6,7,8,9,10}.difference(currentFrame.rolls[0].pinsStandingAfterThrow!);
      }
      final Set<int>? pinsHit = await showDialog<Set<int>>(
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
      if (pinsHit != null && mounted) {
        setState(() {
          final int pinsDown = pinsHit.length;
          final Roll newRoll = Roll(
            pinsDown: pinsDown,
            pinsStandingAfterThrow: {1,2,3,4,5,6,7,8,9,10}.difference(pinsHit),
            displayScore: _getDisplayScore(pinsDown, frameIndex),
            pinsStandingBeforeThrow: currentFrame.rolls[0].pinsStandingAfterThrow!,
          );
          // 修正：如果原本第一球是全倒，這次其實是要覆蓋第一球
          if (currentFrame.rolls[0].pinsDown == 10) {
            currentFrame.rolls[0] = newRoll;
          } else {
            currentFrame.rolls.add(newRoll);
          }
          _scoreData.pinsStanding = {1,2,3,4,5,6,7,8,9,10}.difference(pinsHit);
          _checkAndAdvanceFrame(frameIndex, isEdit: true);
          _scoreData.calculateScores();
        });
      }
    } else {
      // 其他情況（如有兩球或三球），清空該格，重新輸入第一球
      setState(() {
        currentFrame.rolls.clear();
        currentFrame.isComplete = false;
        _scoreData.isGameOver = false;
        if (frameIndex < 9) {
          _scoreData.pinsStanding = {1,2,3,4,5,6,7,8,9,10};
        }
      });
      await _handleFrameTap(frameIndex, isEdit: true);
      setState(() {
        _scoreData.calculateScores();
      });
    }
  }

  String _getDisplayScore(int pinsDown, int frameIndex) {
    final Frame currentFrame = _scoreData.frames[frameIndex];
    // 第一球全倒才顯示 X
    if (pinsDown == 10 && currentFrame.rolls.isEmpty) return "X";
    // 第二球補中才顯示 /
    if (currentFrame.rolls.length == 1) {
      final int previousPins = currentFrame.rolls[0].pinsDown;
      if (previousPins + pinsDown == 10) return "/";
    }
    return pinsDown.toString();
  }

  // 取得第十格顯示分數（strike 顯示 X，spare 顯示 /，其餘顯示數字）
  String? getTenthFrameDisplayScore(int ballIndex, Frame frame) {
    if (frame.rolls.length <= ballIndex) return null;
    final roll = frame.rolls[ballIndex];
    // 第一球
    if (ballIndex == 0) {
      if (roll.pinsDown == 10) return "X";
      return roll.pinsDown.toString();
    }
    // 第二球
    if (ballIndex == 1) {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls.length >= 2 && frame.rolls[0].pinsDown < 10 && frame.rolls[0].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    }
    // 第三球
    if (ballIndex == 2) {
      if (roll.pinsDown == 10) return "X";
      if (frame.rolls.length >= 3 && frame.rolls[1].pinsDown < 10 && frame.rolls[1].pinsDown + roll.pinsDown == 10) {
        return "/";
      }
      return roll.pinsDown.toString();
    }
    return roll.pinsDown.toString();
  }

  void _checkAndAdvanceFrame(int frameIndex, {bool isEdit = false}) {
    final Frame currentFrame = _scoreData.frames[frameIndex];
    if (frameIndex == 9) {
      // 第十格邏輯
      if (currentFrame.rolls.length == 1) {
        // 第一球後，什麼都不做，等第二球
        return;
      } else if (currentFrame.rolls.length == 2) {
        final int first = currentFrame.rolls[0].pinsDown;
        final int second = currentFrame.rolls[1].pinsDown;
        if (first == 10 || first + second == 10) {
          // Strike 或 Spare，允許第三球
          return;
        } else {
          // 不是Strike也不是Spare，結束
          currentFrame.isComplete = true;
          _scoreData.isGameOver = true;
        }
      } else if (currentFrame.rolls.length == 3) {
        // 三球結束
        currentFrame.isComplete = true;
        _scoreData.isGameOver = true;
      }
    } else {
      // 前九格
      if (currentFrame.rolls.length == 2 || currentFrame.rolls[0].pinsDown == 10) {
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
        // 計算每個 frame 的寬度，考慮到 10 個 frame 的總寬度
        final double availableWidth = constraints.maxWidth;
        final double frameWidth = availableWidth / 10;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              final frame = _scoreData.frames[index];
              final bool isTenth = (index == 9);
              final bool isCurrentFrame = (index == _scoreData.currentFrameIndex);

              return GestureDetector(
                onTap: isCurrentFrame ? () => _handleFrameTap(index) : null,
                onLongPress: (index < _scoreData.currentFrameIndex)
                    ? () async { await _handleFrameEditTap(index); }
                    : null,
                child: ScoreFrameWidget(
                  frameNumber: index + 1,
                  isTenthFrame: isTenth,
                  ball1Score: frame.rolls.isNotEmpty ? (isTenth ? getTenthFrameDisplayScore(0, frame) : frame.rolls[0].displayScore) : null,
                  ball2Score: frame.rolls.length > 1 ? (isTenth ? getTenthFrameDisplayScore(1, frame) : frame.rolls[1].displayScore) : null,
                  ball3Score: isTenth && frame.rolls.length > 2 ? getTenthFrameDisplayScore(2, frame) : null,
                  frameTotalScore: frame.totalScore?.toString(),
                  availableWidth: frameWidth,
                  isCurrentFrame: isCurrentFrame,
                ),
              );
            }),
          ),
        );
      },
    );
  }
} 