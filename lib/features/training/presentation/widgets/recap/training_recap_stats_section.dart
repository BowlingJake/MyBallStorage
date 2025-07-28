import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/training/models/training_recap.dart';
import 'training_recap_border_container.dart';

/// 統計區域元件
/// 
/// 顯示強資訊：平均分、全倒率、Spare率
/// 使用金色突出數字，白色淡化標籤
class TrainingRecapStatsSection extends StatelessWidget {
  const TrainingRecapStatsSection({
    super.key,
    required this.statistics,
  });

  final RecapStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return TrainingRecapBorderContainer(
      borderType: BorderType.tertiary,
      height: TrainingRecapSizes.statsHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: TrainingRecapSizes.spacingL,
        vertical: TrainingRecapSizes.spacingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            value: statistics.average.toStringAsFixed(0),
            label: 'AVERAGE',
            color: TrainingRecapColors.strike, // 金色突出
          ),
          _buildStatItem(
            value: '${statistics.strikePercentage.toStringAsFixed(0)}%',
            label: 'STRIKE%',
            color: TrainingRecapColors.strike, // 金色突出
          ),
          _buildStatItem(
            value: '${statistics.sparePercentage.toStringAsFixed(0)}%',
            label: 'SPARE%',
            color: TrainingRecapColors.spare, // 藍綠色
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18, // 從20減至18
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9, // 從10減至9
            fontWeight: FontWeight.w300,
            color: TrainingRecapColors.weakText,
          ),
        ),
      ],
    );
  }
}