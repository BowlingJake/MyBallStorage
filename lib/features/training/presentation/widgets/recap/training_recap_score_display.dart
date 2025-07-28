import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'training_recap_border_container.dart';

/// 分數顯示元件
/// 
/// 橫向顯示10格分數，使用顏色區分：
/// - X (Strike): 金色
/// - / (Spare): 藍綠色  
/// - 數字 (Open): 白色
/// - - (Gutter): 灰色
class TrainingRecapScoreDisplay extends StatelessWidget {
  const TrainingRecapScoreDisplay({
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
          _buildFrameScore(i),
        ],
      ],
    );
  }

  Widget _buildFrameScore(int frameIndex) {
    if (frameIndex >= game.frames.length) {
      return const SizedBox(width: 24, child: Text('-'));
    }

    final frame = game.frames[frameIndex];
    
    if (frameIndex == 9) {
      // 第10格特殊處理
      return _buildTenthFrameScore(frame);
    } else {
      // 一般格子
      return _buildRegularFrameScore(frame);
    }
  }

  Widget _buildRegularFrameScore(Frame frame) {
    if (frame.rolls.isEmpty) {
      return const SizedBox(
        width: 24,
        child: Text(
          '-',
          style: TextStyle(
            fontSize: 12, // 從14減至12
            color: TrainingRecapColors.open,
          ),
        ),
      );
    }

    final firstRoll = frame.rolls[0];
    
    // Strike
    if (firstRoll.pinsDown == 10) {
      return const SizedBox(
        width: 24,
        child: Text(
          'X',
          style: TextStyle(
            fontSize: 12, // 從14減至12
            fontWeight: FontWeight.bold,
            color: TrainingRecapColors.strike, // 金色
          ),
        ),
      );
    }

    // Spare或Open
    if (frame.rolls.length >= 2) {
      final secondRoll = frame.rolls[1];
      final totalPins = firstRoll.pinsDown + secondRoll.pinsDown;
      
      if (totalPins == 10) {
        // Spare
        return SizedBox(
          width: 24,
          child: Text(
            '${_formatSingleRoll(firstRoll.pinsDown)}/',
            style: const TextStyle(
              fontSize: 12, // 從14減至12
              fontWeight: FontWeight.bold,
              color: TrainingRecapColors.spare, // 藍綠色
            ),
          ),
        );
      } else {
        // Open
        return SizedBox(
          width: 24,
          child: Text(
            '${_formatSingleRoll(firstRoll.pinsDown)}${_formatSingleRoll(secondRoll.pinsDown)}',
            style: const TextStyle(
              fontSize: 12, // 從14減至12
              color: TrainingRecapColors.strongText, // 白色
            ),
          ),
        );
      }
    }

    // 只有一球
    return SizedBox(
      width: 24,
      child: Text(
        _formatSingleRoll(firstRoll.pinsDown),
        style: const TextStyle(
          fontSize: 12, // 從14減至12
          color: TrainingRecapColors.strongText,
        ),
      ),
    );
  }

  Widget _buildTenthFrameScore(Frame frame) {
    if (frame.rolls.isEmpty) {
      return const SizedBox(
        width: 32,
        child: Text(
          '-',
          style: TextStyle(
            fontSize: 12, // 從14減至12
            color: TrainingRecapColors.open,
          ),
        ),
      );
    }

    String scoreText = '';
    Color textColor = TrainingRecapColors.strongText;
    
    // 處理第10格的多球情況
    for (int i = 0; i < frame.rolls.length && i < 3; i++) {
      final roll = frame.rolls[i];
      
      if (roll.pinsDown == 10) {
        scoreText += 'X';
        textColor = TrainingRecapColors.strike;
      } else if (i > 0 && 
                 frame.rolls[i-1].pinsDown < 10 && 
                 frame.rolls[i-1].pinsDown + roll.pinsDown == 10) {
        scoreText += '/';
        textColor = TrainingRecapColors.spare;
      } else {
        scoreText += _formatSingleRoll(roll.pinsDown);
      }
    }

    return SizedBox(
      width: 32,
      child: Text(
        scoreText,
        style: TextStyle(
          fontSize: 10, // 從12減至10，適應更多字符
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  String _formatSingleRoll(int pinsDown) {
    return pinsDown == 0 ? '-' : pinsDown.toString();
  }
}