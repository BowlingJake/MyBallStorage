import 'package:bowlingarsenal_app/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/widgets/arsenal_ball_card.dart';
import 'package:bowlingarsenal_app/widgets/empty_bag_widget.dart';
import 'package:flutter/material.dart';

/// 球的 GridView Widget
class BallGridWidget extends StatelessWidget {
  const BallGridWidget({required this.balls, super.key});
  final List<ArsenalBall> balls;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child:
          balls.isEmpty
              ? const EmptyBagWidget()
              : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: balls.length,
                itemBuilder:
                    (context, index) => ArsenalBallCard(ball: balls[index]),
              ),
    );
  }
}
