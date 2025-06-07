import 'package:flutter/material.dart';
import '../models/arsenal_ball.dart';
import 'arsenal_ball_card.dart';
import 'empty_bag_widget.dart';

/// 球的 GridView Widget
class BallGridWidget extends StatelessWidget {
  final List<ArsenalBall> balls;

  const BallGridWidget({
    super.key,
    required this.balls,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: balls.isEmpty
          ? const EmptyBagWidget()
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: balls.length,
              itemBuilder: (context, index) => ArsenalBallCard(ball: balls[index]),
            ),
    );
  }
} 