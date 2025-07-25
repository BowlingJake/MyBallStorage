import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:bowlingarsenal_app/features/training/models/training_recap.dart';
import 'package:bowlingarsenal_app/features/training/models/score_data.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/frame_recap_widget.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class TrainingRecapPage extends ConsumerStatefulWidget {
  final TrainingRecap recap;

  const TrainingRecapPage({
    super.key,
    required this.recap,
  });

  @override
  ConsumerState<TrainingRecapPage> createState() => _TrainingRecapPageState();
}

class _TrainingRecapPageState extends ConsumerState<TrainingRecapPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: _buildAppBar(context, theme),
      body: Column(
        children: [
          // 固定的 Header 區域（不會捲動）
          Container(
            padding: const EdgeInsets.all(12.0),
            child: _buildRecapHeader(context),
          ),
          
          // 可捲動的遊戲列表區域
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: widget.recap.games.length + 1, // +1 for bottom actions
              itemBuilder: (context, index) {
                if (index == widget.recap.games.length) {
                  // 最後一項是底部按鈕
                  return _buildBottomActions(context);
                }
                return _buildGameCard(
                  context, 
                  widget.recap.games[index], 
                  index + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '${widget.recap.sessionTitle} Recap',
        style: theme.textTheme.headlineSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildRecapHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // 左側：基本資訊
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.recap.bowlerName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.recap.bowlingCenter,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.recap.oilPattern,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 12),
        
        // 右側：統計資訊（重新設計以避免 overflow）
        Expanded(
          flex: 2, // 加長窗格
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                // AVG 在上方
                Text(
                  '${widget.recap.statistics.average.toStringAsFixed(1)}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28, // 稍微小一點
                  ),
                ),
                Text(
                  'AVG',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                
                // STR% 和 SPR% 在下方（水平排列）
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${widget.recap.statistics.strikePercentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'STRIKE%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${widget.recap.statistics.sparePercentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'SPARE%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameCard(BuildContext context, BowlingScoreData game, int gameNumber) {
    final theme = Theme.of(context);
    final totalScore = game.frames.lastWhere(
      (frame) => frame.totalScore != null,
      orElse: () => Frame.empty(10),
    ).totalScore ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // 進一步縮小垂直間距
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // 遊戲標題和總分（進一步縮小）
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // 進一步縮小
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Game $gameNumber Ball Used: xxxx',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12, // 進一步縮小字體
                  ),
                ),
                Text(
                  totalScore.toString(),
                  style: theme.textTheme.headlineSmall?.copyWith( // 縮小總分字體
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // 10格橫向排列（進一步優化空間）
          Container(
            height: 85, // 進一步縮小高度
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8), // 進一步縮小
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final spacing = 3.0; // 進一步縮小間距
                final totalSpacing = spacing * 9;
                final frameWidth = (availableWidth - totalSpacing) / 10;
                final adjustedFrameWidth = frameWidth.clamp(32.0, 70.0); // 進一步調整寬度範圍
                
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final frame = index < game.frames.length 
                        ? game.frames[index] 
                        : Frame.empty(index + 1);
                    
                    return Container(
                      width: index == 9 ? adjustedFrameWidth * 1.2 : adjustedFrameWidth,
                      margin: EdgeInsets.only(right: index < 9 ? spacing : 0),
                      child: FrameRecapWidget(
                        frame: frame,
                        frameNumber: index + 1,
                        isLastFrame: index == 9,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: AppStandardButton(
              text: 'Save to JB',
              icon: Iconsax.save_2,
              isPrimary: true,
              onPressed: () {
                // TODO: 實作儲存到 JB 功能
                _handleSaveToJB();
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppStandardButton(
              text: 'Exit',
              icon: Iconsax.close_circle,
              isPrimary: false,
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSaveToJB() {
    // TODO: 實作儲存功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save to JB functionality coming soon'),
      ),
    );
  }
} 