import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'training_recap_border_container.dart';

/// 超迷你導瓶指示器元件
/// 
/// 弱資訊：每球用2個極小點表示
/// - ●● = strike (兩個實心點)
/// - ○● = spare (一個空心+一個實心)  
/// - ○○ = open (兩個空心點)
/// - ● = 單球結果
class TrainingRecapPinIndicator extends StatelessWidget {
  const TrainingRecapPinIndicator({
    super.key,
    required this.game,
  });

  final BowlingScoreData game;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < 10; i++) ...[
          if (i > 0) const SizedBox(width: 4),
          _buildFrameIndicator(i),
        ],
      ],
    );
  }

  Widget _buildFrameIndicator(int frameIndex) {
    if (frameIndex >= game.frames.length) {
      return const SizedBox(width: 24);
    }

    final frame = game.frames[frameIndex];
    
    if (frame.rolls.isEmpty) {
      return const SizedBox(width: 24);
    }

    if (frameIndex == 9) {
      // 第10格特殊處理 - 最多3球
      return _buildTenthFrameIndicator(frame);
    } else {
      // 一般格子
      return _buildRegularFrameIndicator(frame);
    }
  }

  Widget _buildRegularFrameIndicator(Frame frame) {
    final firstRoll = frame.rolls[0];
    
    // Strike - 兩個實心點
    if (firstRoll.pinsDown == 10) {
      return const SizedBox(
        width: 24,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _MiniDot(filled: true),
            SizedBox(width: 1),
            _MiniDot(filled: true),
          ],
        ),
      );
    }

    // 有第二球
    if (frame.rolls.length >= 2) {
      final secondRoll = frame.rolls[1];
      final totalPins = firstRoll.pinsDown + secondRoll.pinsDown;
      
      if (totalPins == 10) {
        // Spare - 空心+實心
        return const SizedBox(
          width: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniDot(filled: false),
              SizedBox(width: 1),
              _MiniDot(filled: true),
            ],
          ),
        );
      } else {
        // Open - 兩個空心
        return const SizedBox(
          width: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniDot(filled: false),
              SizedBox(width: 1),
              _MiniDot(filled: false),
            ],
          ),
        );
      }
    }

    // 只有一球 - 單個點
    return const SizedBox(
      width: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MiniDot(filled: false),
        ],
      ),
    );
  }

  Widget _buildTenthFrameIndicator(Frame frame) {
    final rollCount = frame.rolls.length;
    
    if (rollCount == 0) {
      return const SizedBox(width: 32);
    }

    // 簡化第10格顯示 - 最多3個點
    final indicators = <Widget>[];
    
    for (int i = 0; i < rollCount && i < 3; i++) {
      if (i > 0) indicators.add(const SizedBox(width: 1));
      
      final roll = frame.rolls[i];
      final isStrike = roll.pinsDown == 10;
      final isSpare = i > 0 && 
                      frame.rolls[i-1].pinsDown < 10 && 
                      frame.rolls[i-1].pinsDown + roll.pinsDown == 10;
      
      indicators.add(_MiniDot(filled: isStrike || isSpare));
    }

    return SizedBox(
      width: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators,
      ),
    );
  }
}

/// 極小點元件 - 2px直径
class _MiniDot extends StatelessWidget {
  const _MiniDot({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? TrainingRecapColors.weakText : null,
        border: filled 
            ? null 
            : Border.all(
                color: TrainingRecapColors.weakText.withOpacity(0.6),
                width: 0.5,
              ),
      ),
    );
  }
}