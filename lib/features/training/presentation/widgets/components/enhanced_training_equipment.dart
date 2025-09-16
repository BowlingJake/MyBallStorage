import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/tags/oval_tag.dart';
import 'package:flutter/material.dart';

/// 增強版球具管理組件 - Phase 1 實現
class EnhancedTrainingEquipment extends StatefulWidget {
  const EnhancedTrainingEquipment({
    required this.summary,
    required this.theme,
    super.key,
  });

  final TrainingDaySummary summary;
  final ThemeData theme;

  @override
  State<EnhancedTrainingEquipment> createState() => _EnhancedTrainingEquipmentState();
}

class _EnhancedTrainingEquipmentState extends State<EnhancedTrainingEquipment> {
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 標題與編輯按鈕
        _buildHeader(),

        const SizedBox(height: 16),

        if (widget.summary.games.isEmpty)
          _buildEmptyState()
        else
          _buildEquipmentContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Equipment Usage',
          style: widget.theme.textTheme.titleMedium?.copyWith(
            color: widget.theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.summary.games.isNotEmpty)
          AppStandardButton(
            text: _isEditMode ? 'Done' : 'Edit Equipment',
            icon: _isEditMode ? Icons.check : Icons.edit,
            height: 32,
            fontSize: 12,
            onPressed: () => setState(() => _isEditMode = !_isEditMode),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_baseball_outlined,
            size: 48,
            color: widget.theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Games Recorded Yet',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start playing games to track your equipment usage',
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentContent() {
    return Column(
      children: [
        // 球具使用概覽
        _buildEquipmentOverview(),

        const SizedBox(height: 16),

        // 每局詳細球具使用
        _buildGameByGameEquipment(),

        if (_isEditMode) ...[
          const SizedBox(height: 16),
          _buildEditInstructions(),
        ],
      ],
    );
  }

  Widget _buildEquipmentOverview() {
    final equipmentUsage = widget.summary.equipmentUsage;

    if (equipmentUsage.isEmpty) {
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
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 20,
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No equipment has been assigned to games yet. Use the edit mode to assign balls to your games.',
                style: widget.theme.textTheme.bodyMedium?.copyWith(
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Equipment Summary',
            style: widget.theme.textTheme.titleSmall?.copyWith(
              color: widget.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: equipmentUsage.entries.map((entry) {
              final ball = entry.key;
              final games = entry.value;

              // 計算該球的統計
              final ballStats = _calculateBallStats(ball, games);

              return _buildBallSummaryCard(ball, games, ballStats);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBallSummaryCard(BallInfo ball, List<int> games, BallStats stats) {
    Color brandColor;
    try {
      brandColor = Color(int.parse(ball.brandColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      brandColor = widget.theme.colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: brandColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: brandColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ball.name,
            style: widget.theme.textTheme.bodyMedium?.copyWith(
              color: brandColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ball.brand,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),

          // 使用統計
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sports_baseball,
                size: 14,
                color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${games.length} games',
                style: widget.theme.textTheme.bodySmall?.copyWith(
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),

          if (stats.averageScore > 0) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics,
                  size: 14,
                  color: widget.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  'Avg: ${stats.averageScore.toStringAsFixed(0)}',
                  style: widget.theme.textTheme.bodySmall?.copyWith(
                    color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameByGameEquipment() {
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
            'Game-by-Game Equipment',
            style: widget.theme.textTheme.titleSmall?.copyWith(
              color: widget.theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Column(
            children: widget.summary.games.asMap().entries.map((entry) {
              final gameIndex = entry.key;
              final game = entry.value;

              return _buildGameEquipmentRow(gameIndex, game);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGameEquipmentRow(int gameIndex, GameRecord game) {
    final hasEquipment = game.ballUsed != null || (game.ballsUsed?.isNotEmpty == true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // 局數
          Container(
            width: 60,
            child: Text(
              'Game ${game.gameNumber}',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // 球具資訊
          Expanded(
            child: hasEquipment
                ? _buildGameEquipmentInfo(game)
                : _buildNoEquipmentInfo(),
          ),

          // 編輯按鈕（編輯模式下）
          if (_isEditMode)
            _buildGameEditButton(gameIndex, game),
        ],
      ),
    );
  }

  Widget _buildGameEquipmentInfo(GameRecord game) {
    // 優先使用新的 ballsUsed，如果沒有則使用舊的 ballUsed
    final balls = game.ballsUsed?.isNotEmpty == true
        ? game.ballsUsed!
        : (game.ballUsed != null ? [game.ballUsed!] : <BallInfo>[]);

    if (balls.isEmpty) {
      return _buildNoEquipmentInfo();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: balls.map((ball) {
        Color brandColor;
        try {
          brandColor = Color(int.parse(ball.brandColor.replaceFirst('#', '0xFF')));
        } catch (e) {
          brandColor = widget.theme.colorScheme.primary;
        }

        return OvalTag(
          text: ball.name,
          color: brandColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          horizontalPadding: 8,
          verticalPadding: 4,
          borderWidth: 1.0,
          backgroundOpacity: 0.1,
        );
      }).toList(),
    );
  }

  Widget _buildNoEquipmentInfo() {
    return Text(
      'No equipment assigned',
      style: widget.theme.textTheme.bodySmall?.copyWith(
        color: widget.theme.colorScheme.onSurface.withOpacity(0.5),
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildGameEditButton(int gameIndex, GameRecord game) {
    return AppStandardButton(
      text: 'Edit',
      icon: Icons.edit,
      height: 28,
      fontSize: 11,
      onPressed: () => _editGameEquipment(gameIndex, game),
    );
  }

  Widget _buildEditInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: widget.theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Click "Edit" next to any game to assign or change equipment. You can select multiple balls for each game.',
              style: widget.theme.textTheme.bodyMedium?.copyWith(
                color: widget.theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 輔助方法
  BallStats _calculateBallStats(BallInfo ball, List<int> gameNumbers) {
    final relevantGames = widget.summary.games.where(
      (game) => gameNumbers.contains(game.gameNumber)
    ).toList();

    if (relevantGames.isEmpty) {
      return BallStats(averageScore: 0, totalGames: 0);
    }

    final totalScore = relevantGames.fold<int>(0, (sum, game) => sum + game.score);
    final averageScore = totalScore / relevantGames.length;

    return BallStats(
      averageScore: averageScore,
      totalGames: relevantGames.length,
    );
  }

  void _editGameEquipment(int gameIndex, GameRecord game) {
    // TODO: 實現球具選擇對話框
    // 這裡應該從用戶的 Arsenal 中選擇球具
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Equipment editing dialog coming soon!'),
      ),
    );
  }
}

class BallStats {
  const BallStats({
    required this.averageScore,
    required this.totalGames,
  });

  final double averageScore;
  final int totalGames;
}