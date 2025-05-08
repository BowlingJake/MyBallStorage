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

  Future<void> _handleFrameTap(int frameIndex) async {
    // 檢查是否為當前可投球的局
    if (frameIndex != _scoreData.currentFrameIndex) return;

    // 獲取當前局
    final Frame currentFrame = _scoreData.frames[frameIndex];
    
    // 如果是第二球，使用第一球後站立的瓶位作為初始狀態
    final Set<int> initialPinsDown = currentFrame.rolls.isEmpty 
        ? const {} // 第一球：所有瓶位站立
        : {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.difference(currentFrame.rolls[0].pinsStandingAfterThrow!); // 第二球：使用第一球後倒下的瓶位

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
        _checkAndAdvanceFrame(frameIndex);

        // 重新計算分數
        _scoreData.calculateScores();
      });
    }
  }

  String _getDisplayScore(int pinsDown, int frameIndex) {
    final Frame currentFrame = _scoreData.frames[frameIndex];
    
    if (pinsDown == 10) return "X"; // Strike
    
    if (currentFrame.rolls.length > 1) {
      final int previousPins = currentFrame.rolls[0].pinsDown;
      if (previousPins + pinsDown == 10) return "/"; // Spare
    }
    
    return pinsDown.toString();
  }

  void _checkAndAdvanceFrame(int frameIndex) {
    final Frame currentFrame = _scoreData.frames[frameIndex];
    
    if (frameIndex == 9) { // 第10局
      if (currentFrame.rolls.length == 3 || 
          (currentFrame.rolls.length == 2 && 
           currentFrame.rolls[0].pinsDown + currentFrame.rolls[1].pinsDown < 10)) {
        currentFrame.isComplete = true;
        _scoreData.isGameOver = true;
      }
    } else { // 前9局
      if (currentFrame.rolls.length == 2 || currentFrame.rolls[0].pinsDown == 10) {
        currentFrame.isComplete = true;
        _scoreData.currentFrameIndex++;
        _scoreData.pinsStanding = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}; // 重置瓶位
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
                child: ScoreFrameWidget(
                  frameNumber: index + 1,
                  isTenthFrame: isTenth,
                  ball1Score: frame.rolls.isNotEmpty ? frame.rolls[0].displayScore : null,
                  ball2Score: frame.rolls.length > 1 ? frame.rolls[1].displayScore : null,
                  ball3Score: isTenth && frame.rolls.length > 2 ? frame.rolls[2].displayScore : null,
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