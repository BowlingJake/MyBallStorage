import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/pin_pattern_widget.dart';

class FrameRecapWidget extends StatelessWidget {
  final Frame frame;
  final int frameNumber;
  final bool isLastFrame;

  const FrameRecapWidget({
    super.key,
    required this.frame,
    required this.frameNumber,
    this.isLastFrame = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: isLastFrame ? 85 : 80, // 適應更小的高度
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(6), // 稍微小一點的圓角
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Frame 編號（縮小）
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 2), // 縮小 padding
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Text(
                frameNumber.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10, // 縮小字體
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // 分數顯示區域（加大）
            Expanded(
              flex: 3, // 增加分數顯示區域的比例
              child: _buildScoreDisplay(context),
            ),
            
            // 累計分數（縮小）
            if (frame.totalScore != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                ),
                child: Text(
                  frame.totalScore.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 9, // 縮小字體
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // 瓶子圖案顯示區域（縮小）
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(2), // 縮小 padding
                child: _buildPinPatterns(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context) {
    final theme = Theme.of(context);
    
    if (frame.rolls.isEmpty) {
      return const Center(
        child: Text(
          '-',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }

    if (isLastFrame) {
      // 第10格特殊處理
      return _buildTenthFrameScore(context);
    }

    // 一般格子 - 確保 X 和 / 清晰顯示
    return Row(
      children: [
        // 第一球
        Expanded(
          child: Center(
            child: Text(
              _getFirstBallDisplay(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14, // 增大字體確保清晰
              ),
            ),
          ),
        ),
        
        // 分隔線
        Container(
          width: 1,
          height: double.infinity,
          color: Colors.white.withOpacity(0.3),
        ),
        
        // 第二球
        Expanded(
          child: Center(
            child: Text(
              _getSecondBallDisplay(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14, // 增大字體確保清晰
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTenthFrameScore(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        for (int i = 0; i < 3; i++) ...[
          if (i > 0) Container(
            width: 1,
            height: double.infinity,
            color: Colors.white.withOpacity(0.3),
          ),
          Expanded(
            child: Center(
              child: Text(
                _getTenthFrameBallDisplay(i),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12, // 第10格字體稍小但仍清晰
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPinPatterns(BuildContext context) {
    if (frame.rolls.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: frame.rolls.map((roll) {
          final pinsDown = _calculatePinsDown(roll);
          return Container(
            margin: const EdgeInsets.only(right: 2), // 縮小間距
            child: PinPatternWidget(
              pinsDown: pinsDown,
              size: const Size(18, 14), // 縮小瓶子圖案
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getFirstBallDisplay() {
    if (frame.rolls.isEmpty) return '-';
    
    final firstRoll = frame.rolls[0];
    if (firstRoll.pinsDown == 10) {
      return 'X'; // Strike - 清晰顯示
    }
    if (firstRoll.pinsDown == 0) {
      return '-'; // Gutter ball
    }
    return firstRoll.pinsDown.toString();
  }

  String _getSecondBallDisplay() {
    if (frame.rolls.length < 2) return '-';
    
    final firstRoll = frame.rolls[0];
    final secondRoll = frame.rolls[1];
    
    if (firstRoll.pinsDown == 10) {
      return ''; // Strike，第二球沒有
    }
    
    if (firstRoll.pinsDown + secondRoll.pinsDown == 10) {
      return '/'; // Spare - 清晰顯示
    }
    
    if (secondRoll.pinsDown == 0) {
      return '-'; // Gutter ball
    }
    
    return secondRoll.pinsDown.toString();
  }

  String _getTenthFrameBallDisplay(int ballIndex) {
    if (ballIndex >= frame.rolls.length) return '-';
    
    final roll = frame.rolls[ballIndex];
    
    if (roll.pinsDown == 10) {
      return 'X'; // Strike
    }
    
    if (roll.pinsDown == 0) {
      return '-'; // Gutter ball
    }
    
    // 檢查是否為 Spare
    if (ballIndex > 0 && ballIndex < frame.rolls.length) {
      final previousRoll = frame.rolls[ballIndex - 1];
      if (previousRoll.pinsDown < 10 && previousRoll.pinsDown + roll.pinsDown == 10) {
        return '/'; // Spare
      }
    }
    
    return roll.pinsDown.toString();
  }

  Set<int> _calculatePinsDown(Roll roll) {
    // 計算哪些瓶子被擊倒
    final standingBefore = roll.pinsStandingBeforeThrow;
    final standingAfter = roll.pinsStandingAfterThrow ?? <int>{};
    
    return standingBefore.difference(standingAfter);
  }
} 