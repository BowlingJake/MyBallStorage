import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/training_recap.dart';
import 'training_recap_border_container.dart';

/// Header區域元件
/// 
/// 顯示強資訊：使用者名稱、訓練標題、平均分
/// 顯示中資訊：擲球風格、慣用手、地點、時間、油圖（依附在強資訊下）
class TrainingRecapHeaderSection extends StatelessWidget {
  const TrainingRecapHeaderSection({
    super.key,
    required this.recap,
    this.bowlerHandStyle,
    this.bowlerHandedness,
  });

  final TrainingRecap recap;
  final String? bowlerHandStyle;  // e.g., "Two-Handed", "One-Handed"
  final String? bowlerHandedness; // e.g., "Right", "Left"

  @override
  Widget build(BuildContext context) {
    return TrainingRecapBorderContainer(
      borderType: BorderType.primary,
      height: TrainingRecapSizes.headerHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: TrainingRecapSizes.spacingL,
        vertical: TrainingRecapSizes.spacingM,
      ),
      child: Row(
        children: [
          // 左側：使用者資訊 + 訓練詳情
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 強資訊：使用者名稱 + 中資訊：風格標籤
                Row(
                  children: [
                    Text(
                      recap.bowlerName,
                      style: const TextStyle(
                        fontSize: 16, // 從18減至16
                        fontWeight: FontWeight.bold,
                        color: TrainingRecapColors.strongText,
                      ),
                    ),
                    if (bowlerHandStyle != null && bowlerHandedness != null) ...[
                      const SizedBox(width: TrainingRecapSizes.spacingM),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: TrainingRecapColors.gameTitle.withOpacity(0.6),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${bowlerHandStyle!.split('-')[0]}-H, $bowlerHandedness',
                          style: const TextStyle(
                            fontSize: 11,
                            color: TrainingRecapColors.mediumText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // 強資訊：訓練標題 + 中資訊：地點等資訊
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recap.sessionTitle,
                      style: const TextStyle(
                        fontSize: 13, // 從14減至13
                        fontWeight: FontWeight.w600,
                        color: TrainingRecapColors.strongText,
                      ),
                    ),
                    Text(
                      '${recap.bowlingCenter} • ${recap.oilPattern}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: TrainingRecapColors.weakText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(width: TrainingRecapSizes.spacingM),
          
          // 右側：平均分速覽
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                recap.statistics.average.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 18, // 從20減至18
                  fontWeight: FontWeight.bold,
                  color: TrainingRecapColors.strongText,
                ),
              ),
              const Text(
                'AVG',
                style: TextStyle(
                  fontSize: 10,
                  color: TrainingRecapColors.weakText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}