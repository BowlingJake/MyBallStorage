import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import '../../../models/training_record.dart';

/// Enhanced Stats Display with Professional Dark Tech Style
/// 具有專業深色科技風格的增強統計顯示
class EnhancedStatsDisplay extends StatelessWidget {
  final TrainingDaySummary summary;
  final ThemeData theme;

  const EnhancedStatsDisplay({
    Key? key,
    required this.summary,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // 標題
          _buildTitle(),
          
          SizedBox(height: 20),
          
          // 主要統計
          _buildMainStats(),
          
          SizedBox(height: 16),
          
          // 詳細統計
          _buildDetailedStats(),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.3);
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          Iconsax.chart_21,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 8),
        Text(
          'Performance Analytics',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMainStats() {
    return Row(
      children: [
        // 平均分
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.chart_2,
            label: 'Average',
            value: summary.averageScore.toStringAsFixed(1),
            color: theme.colorScheme.primary,
          ),
        ),
        
        SizedBox(width: 12),
        
        // 最高分
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.arrow_up,
            label: 'Highest',
            value: '${summary.highestScore}',
            color: Colors.green,
          ),
        ),
        
        SizedBox(width: 12),
        
        // 最低分
        Expanded(
          child: _buildStatCard(
            icon: Iconsax.arrow_down,
            label: 'Lowest',
            value: '${summary.lowestScore}',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Column(
      children: [
        // Strike和Spare百分比
        Row(
          children: [
            Expanded(
              child: _buildPercentageBar(
                'Strike %',
                summary.strikePercentage,
                Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildPercentageBar(
                'Spare %',
                summary.sparePercentage,
                Colors.blue,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // 總計統計
        _buildTotalStats(),
      ],
    );
  }

  Widget _buildPercentageBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
                     // 總Strikes
           Expanded(
             child: _buildTotalStatItem(
               Iconsax.direct_up,
               '${summary.totalStrikes}',
               'Total Strikes',
               Colors.green,
             ),
           ),
          
          // 總Spares
          Expanded(
            child: _buildTotalStatItem(
              Iconsax.arrow_circle_right,
              '${summary.totalSpares}',
              'Total Spares',
              Colors.blue,
            ),
          ),
          
          // 總局數
          Expanded(
            child: _buildTotalStatItem(
              Iconsax.game,
              '${summary.totalGames}',
              'Total Games',
              theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white70,
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
} 