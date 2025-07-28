import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import 'package:bowlingarsenal_app/features/training/models/training_recap.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/training_recap_border_container.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/training_recap_game_card.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/training_recap_header_section.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/recap/training_recap_stats_section.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

/// Training Recap頁面 - 顯示訓練回顧資訊
class TrainingRecapPage extends ConsumerStatefulWidget {
  /// 建構函數
  const TrainingRecapPage({
    required this.recap,
    super.key,
  });

  /// 訓練回顧數據
  final TrainingRecap recap;

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
      body: SafeArea(
        child: Column(
          children: [
            // Header區域 - 使用者資訊與訓練標題
            Container(
              padding: const EdgeInsets.all(TrainingRecapSizes.spacingM),
              child: TrainingRecapHeaderSection(
                recap: widget.recap,
                bowlerHandStyle: 'Two-Handed', // TODO(dev): 從真實數據獲取
                bowlerHandedness: 'Right', // TODO(dev): 從真實數據獲取
              ),
            ),
            
            // 統計區域 - 平均分、Strike%、Spare%
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: TrainingRecapSizes.spacingM,),
              child: TrainingRecapStatsSection(
                statistics: widget.recap.statistics,
              ),
            ),
            
            const SizedBox(height: TrainingRecapSizes.spacingS),
            
            // 遊戲列表區域 - 動態高度
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: TrainingRecapSizes.spacingM,
                  vertical: TrainingRecapSizes.spacingS,
                ),
                itemCount: widget.recap.games.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: TrainingRecapSizes.spacingXS,
                ),
                itemBuilder: (context, index) {
                  return TrainingRecapGameCard(
                    game: widget.recap.games[index],
                    gameNumber: index + 1,
                    ballName: 'Storm Phaze II', // TODO(dev): 從真實數據獲取球名
                  );
                },
              ),
            ),
            
            // 底部按鈕區域 - 固定在底部
            Padding(
              padding: const EdgeInsets.all(TrainingRecapSizes.spacingM),
              child: _buildBottomActions(context),
            ),
          ],
        ),
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



  Widget _buildBottomActions(BuildContext context) {
    return TrainingRecapBorderContainer(
      borderType: BorderType.tertiary,
      padding: const EdgeInsets.symmetric(
        horizontal: TrainingRecapSizes.spacingL,
        vertical: TrainingRecapSizes.spacingM,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppStandardButton(
              text: 'Save to JB',
              icon: Iconsax.save_2,
              isPrimary: true,
              onPressed: _handleSaveToJB,
            ),
          ),
          const SizedBox(width: TrainingRecapSizes.spacingL),
          Expanded(
            child: AppStandardButton(
              text: 'Exit',
              icon: Iconsax.close_circle,
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSaveToJB() {
    // TODO(dev): 實作儲存功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save to JB functionality coming soon'),
      ),
    );
  }
}