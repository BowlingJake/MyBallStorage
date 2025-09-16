import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
import 'package:flutter/material.dart';

/// 增強版訓練統計組件 - Phase 1 實現
class EnhancedTrainingStats extends StatefulWidget {
  const EnhancedTrainingStats({
    required this.summary,
    required this.theme,
    super.key,
  });

  final TrainingDaySummary summary;
  final ThemeData theme;

  @override
  State<EnhancedTrainingStats> createState() => _EnhancedTrainingStatsState();
}

class _EnhancedTrainingStatsState extends State<EnhancedTrainingStats> {
  bool _showDetailedStats = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 基本統計卡片
        _buildBasicStats(),

        const SizedBox(height: 16),

        // 展開/收合按鈕
        _buildExpandButton(),

        if (_showDetailedStats) ...[
          const SizedBox(height: 16),
          // 詳細統計
          _buildDetailedStats(),

          const SizedBox(height: 16),
          // Frame-by-Frame 分析
          _buildFrameAnalysis(),

          const SizedBox(height: 16),
          // 表現評估
          _buildPerformanceEvaluation(),
        ],
      ],
    );
  }

  Widget _buildBasicStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // 第一行：總局數、平均分、最高分
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.sports_baseball,
                  'GAMES',
                  '${widget.summary.totalGames}',
                  widget.theme.colorScheme.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.analytics,
                  'AVG',
                  '${widget.summary.averageScore}',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.trending_up,
                  'HIGH',
                  '${widget.summary.highestScore}',
                  Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 第二行：Strike率、Spare率、失誤率
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  Icons.gps_fixed,
                  'STR',
                  '${widget.summary.strikePercentage.toStringAsFixed(1)}%',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.radio_button_unchecked,
                  'SPR',
                  '${widget.summary.sparePercentage.toStringAsFixed(1)}%',
                  Colors.purple,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  Icons.trending_down,
                  'MISS',
                  '${_calculateMissPercentage().toStringAsFixed(1)}%',
                  Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandButton() {
    return Center(
      child: GestureDetector(
        onTap: () => setState(() => _showDetailedStats = !_showDetailedStats),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.theme.colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showDetailedStats ? Icons.expand_less : Icons.expand_more,
                color: widget.theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _showDetailedStats ? 'Hide Details' : 'Show Details',
                style: widget.theme.textTheme.bodyMedium?.copyWith(
                  color: widget.theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Statistics',
            style: widget.theme.textTheme.titleSmall?.copyWith(
              color: widget.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // 分數分佈
          Row(
            children: [
              Expanded(
                child: _buildDetailStatItem(
                  'Lowest Score',
                  '${widget.summary.lowestScore}',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildDetailStatItem(
                  'Score Range',
                  '${widget.summary.highestScore - widget.summary.lowestScore}',
                  Colors.cyan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Strike 和 Spare 總數
          Row(
            children: [
              Expanded(
                child: _buildDetailStatItem(
                  'Total Strikes',
                  '${widget.summary.totalStrikes}',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildDetailStatItem(
                  'Total Spares',
                  '${widget.summary.totalSpares}',
                  Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 第一球平均擊倒數
          _buildDetailStatItem(
            'First Ball Average',
            '${_calculateFirstBallAverage().toStringAsFixed(1)} pins',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildFrameAnalysis() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frame-by-Frame Analysis',
            style: widget.theme.textTheme.titleSmall?.copyWith(
              color: widget.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Frame 性能分析
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(10, (frameIndex) {
              final framePerf = _analyzeFramePerformance(frameIndex);
              return _buildFramePerformanceChip(frameIndex + 1, framePerf);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceEvaluation() {
    final evaluation = _evaluatePerformance();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: evaluation.color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                evaluation.icon,
                color: evaluation.color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Performance Evaluation',
                style: widget.theme.textTheme.titleSmall?.copyWith(
                  color: evaluation.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          OvalTag(
            text: evaluation.level,
            color: evaluation.color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            horizontalPadding: 12,
            verticalPadding: 6,
            borderWidth: 1.5,
            backgroundOpacity: 0.1,
          ),

          const SizedBox(height: 8),

          Text(
            evaluation.feedback,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: widget.theme.textTheme.titleMedium?.copyWith(
            color: widget.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: widget.theme.textTheme.bodySmall?.copyWith(
            color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailStatItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFramePerformanceChip(int frameNumber, FramePerformance perf) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: perf.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: perf.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'F$frameNumber',
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: perf.color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
          Text(
            '${perf.avgScore.toStringAsFixed(1)}',
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // 計算功能方法
  double _calculateMissPercentage() {
    if (widget.summary.totalGames == 0) return 0.0;

    final totalFrames = widget.summary.totalGames * 10;
    final successfulFrames = widget.summary.totalStrikes + widget.summary.totalSpares;
    final missedFrames = totalFrames - successfulFrames;

    return (missedFrames / totalFrames) * 100;
  }

  double _calculateFirstBallAverage() {
    if (widget.summary.games.isEmpty) return 0.0;

    // 這裡需要從 frameScores 中計算第一球平均
    // 簡化計算：假設 Strike = 10, Spare 的第一球平均約 6-7
    final totalStrikes = widget.summary.totalStrikes;
    final totalSpares = widget.summary.totalSpares;
    final totalFrames = widget.summary.totalGames * 10;

    // 估算：Strike = 10, Spare 平均第一球 = 6.5, 失誤平均第一球 = 4
    final strikeFirstBall = totalStrikes * 10;
    final spareFirstBall = totalSpares * 6.5;
    final missFirstBall = (totalFrames - totalStrikes - totalSpares) * 4;

    return (strikeFirstBall + spareFirstBall + missFirstBall) / totalFrames;
  }

  FramePerformance _analyzeFramePerformance(int frameIndex) {
    if (widget.summary.games.isEmpty) {
      return FramePerformance(avgScore: 0, color: Colors.grey);
    }

    // 計算該格的平均分數
    double totalScore = 0;
    int validGames = 0;

    for (final game in widget.summary.games) {
      if (game.frameScores.length > frameIndex) {
        totalScore += game.frameScores[frameIndex];
        validGames++;
      }
    }

    final avgScore = validGames > 0 ? totalScore / validGames : 0;

    // 根據平均分數決定顏色
    Color color;
    if (avgScore >= 20) {
      color = Colors.green;
    } else if (avgScore >= 15) {
      color = Colors.orange;
    } else if (avgScore >= 10) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }

    return FramePerformance(avgScore: avgScore.toDouble(), color: color);
  }

  PerformanceEvaluation _evaluatePerformance() {
    final avgScore = widget.summary.averageScore;
    final strikeRate = widget.summary.strikePercentage;

    if (avgScore >= 180 && strikeRate >= 50) {
      return PerformanceEvaluation(
        level: 'Excellent',
        color: Colors.green,
        icon: Icons.emoji_events,
        feedback: 'Outstanding performance! You\'re bowling at a professional level.',
      );
    } else if (avgScore >= 150 && strikeRate >= 30) {
      return PerformanceEvaluation(
        level: 'Good',
        color: Colors.blue,
        icon: Icons.thumb_up,
        feedback: 'Solid bowling! Focus on increasing strike consistency.',
      );
    } else if (avgScore >= 120 && strikeRate >= 20) {
      return PerformanceEvaluation(
        level: 'Average',
        color: Colors.orange,
        icon: Icons.trending_up,
        feedback: 'Good foundation. Work on spare conversion and strike accuracy.',
      );
    } else {
      return PerformanceEvaluation(
        level: 'Developing',
        color: Colors.red,
        icon: Icons.school,
        feedback: 'Keep practicing! Focus on consistency and spare conversion.',
      );
    }
  }
}

class FramePerformance {
  const FramePerformance({required this.avgScore, required this.color});
  final double avgScore;
  final Color color;
}

class PerformanceEvaluation {
  const PerformanceEvaluation({
    required this.level,
    required this.color,
    required this.icon,
    required this.feedback,
  });
  final String level;
  final Color color;
  final IconData icon;
  final String feedback;
}