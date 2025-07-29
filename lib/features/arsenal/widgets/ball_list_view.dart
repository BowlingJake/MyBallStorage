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

class BallListView extends StatelessWidget {
  const BallListView({
    required this.bowlingBalls,
    this.onBallTapped,
    this.onBallLongPress,
    super.key,
  });

  final List<BowlingBall> bowlingBalls;
  final Function(BowlingBall)? onBallTapped;
  final Function(BowlingBall)? onBallLongPress;

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
          itemCount: balls.length,
          itemBuilder: (context, index) {
            final ball = balls[index];
            return BallCardItem(
              ball: ball,
              theme: Theme.of(context),
              onTap: () {
                onBallTapped?.call(ball);
                // print('Tapped on ${ball.name}');
              },
              onLongPress: () {
                onBallLongPress?.call(ball);
                // print('Long pressed on ${ball.name}');
              },
            );
          },
        ),
      ],
    );
  }
}

