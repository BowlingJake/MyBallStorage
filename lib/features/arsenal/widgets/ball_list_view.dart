import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bowlingarsenal_app/viewmodels/weapon_library_viewmodel.dart';
// import '../../../models/bowling_ball.dart';
import 'package:gradient_borders/gradient_borders.dart';
// import 'package:getwidget/getwidget.dart'; // GFListTile is no longer used
import 'package:bowlingarsenal_app/shared/widgets/painters/grid_painter.dart';
import 'package:bowlingarsenal_app/shared/widgets/painters/metal_texture_painter.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/shared/widgets/cards/unified_ball_card.dart';

class BallListView extends StatelessWidget {
  const BallListView({
    required this.bowlingBalls,
    this.onBallTapped,
    this.onBallLongPress,
    this.hasMoreData = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.isSelectionMode = false,
    this.selectedBallIds = const <int>{},
    this.onBallSelectionToggle,
    super.key,
  });

  final List<BowlingBall> bowlingBalls;
  final Function(BowlingBall)? onBallTapped;
  final Function(BowlingBall)? onBallLongPress;
  final bool hasMoreData;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final bool isSelectionMode;
  final Set<int> selectedBallIds;
  final Function(int)? onBallSelectionToggle;

  @override
  Widget build(BuildContext context) {
    // final balls = ref.watch(filteredBowlingBallProvider);
    final balls = bowlingBalls; // Use passed list

    if (balls.isEmpty) {
      return const Center(
        child: Text('No balls match the current filters.'),
      );
    }

    return Stack(
      children: [
        // 添加細微的點狀紋理效果
        Container(
          child: CustomPaint(
            size: Size.infinite,
            painter: MetalTexturePainter(),
          ),
        ),
        // 網格圖案
        Positioned.fill(
          child: CustomPaint(
            size: Size.infinite,
            painter: GridPainter(
              gridColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              strokeWidth: 1.2,
              spacing: 28,
            ),
          ),
        ),
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 32),
          itemCount: balls.length + (hasMoreData || isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            // 如果是最後一個項目且有更多資料，顯示載入更多按鈕
            if (index == balls.length) {
              return _buildLoadMoreItem();
            }
            
            final ball = balls[index];
            final isSelected = selectedBallIds.contains(ball.id);
            
            return UnifiedBallCard(
              bowlingBall: ball,
              theme: Theme.of(context),
              onTap: () {
                if (isSelectionMode) {
                  onBallSelectionToggle?.call(ball.id);
                } else {
                  onBallTapped?.call(ball);
                }
              },
              onLongPress: () {
                onBallLongPress?.call(ball);
              },
              isSelectionMode: isSelectionMode,
              isSelected: isSelected,
              showFavoriteButton: !isSelectionMode, // Show favorite button only when not in selection mode
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadMoreItem() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: isLoadingMore
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '載入中...',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: onLoadMore,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[600]!),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[800]?.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_more,
                      color: Colors.grey[300],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '點擊載入更多',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

