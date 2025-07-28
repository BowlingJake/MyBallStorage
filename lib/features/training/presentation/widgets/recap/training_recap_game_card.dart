import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'training_recap_border_container.dart';
import 'training_recap_score_display.dart';
import 'training_recap_pin_indicator.dart';

/// Game卡片元件 - 38px高度的極簡設計
/// 
/// 包含：
/// - 強資訊：局數、分數序列、總分
/// - 弱資訊：導瓶圖示（可選）
class TrainingRecapGameCard extends StatelessWidget {
  const TrainingRecapGameCard({
    super.key,
    required this.game,
    required this.gameNumber,
    this.ballName,
    this.showPinIndicator = true,
  });

  final BowlingScoreData game;
  final int gameNumber;
  final String? ballName;
  final bool showPinIndicator;

  @override
  Widget build(BuildContext context) {
    final totalScore = _getTotalScore();
    
    return TrainingRecapBorderContainer(
      borderType: BorderType.secondary,
      height: TrainingRecapSizes.gameCardHeight,
      margin: const EdgeInsets.symmetric(vertical: TrainingRecapSizes.spacingXS),
      padding: const EdgeInsets.symmetric(
        horizontal: TrainingRecapSizes.spacingM,
        vertical: TrainingRecapSizes.spacingS,
      ),
      child: Column(
        children: [
          // 分數行 (20px)
          SizedBox(
            height: TrainingRecapSizes.scoreRowHeight,
            child: Row(
              children: [
                // 局數 (強資訊)
                SizedBox(
                  width: 20,
                  child: Text(
                    gameNumber.toString(),
                    style: const TextStyle(
                      fontSize: 14, // 從16減至14
                      fontWeight: FontWeight.bold,
                      color: TrainingRecapColors.strongText,
                    ),
                  ),
                ),
                const SizedBox(width: TrainingRecapSizes.spacingM),
                
                // 分數序列 (強資訊)
                Expanded(
                  child: TrainingRecapScoreDisplay(game: game),
                ),
                
                // 總分 (強資訊)
                Text(
                  totalScore.toString(),
                  style: const TextStyle(
                    fontSize: 16, // 從18減至16
                    fontWeight: FontWeight.bold,
                    color: TrainingRecapColors.strongText,
                  ),
                ),
              ],
            ),
          ),
          
          // 導瓶指示器行 (8px) - 弱資訊，可選顯示
          if (showPinIndicator)
            SizedBox(
              height: TrainingRecapSizes.pinRowHeight,
              child: Padding(
                padding: const EdgeInsets.only(left: 32), // 對齊分數序列
                child: TrainingRecapPinIndicator(game: game),
              ),
            ),
        ],
      ),
    );
  }

  int _getTotalScore() {
    return game.frames.lastWhere(
      (frame) => frame.totalScore != null,
      orElse: () => Frame.empty(10),
    ).totalScore ?? 0;
  }
}