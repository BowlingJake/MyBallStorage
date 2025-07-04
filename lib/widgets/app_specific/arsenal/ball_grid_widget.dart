import 'package:bowlingarsenal_app/widgets/app_specific/arsenal/empty_bag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:bowlingarsenal_app/viewmodels/my_arsenal_viewmodel.dart';

/// 球的 GridView Widget
class BallGridWidget extends ConsumerWidget {
  const BallGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final balls = ref.watch(filteredBallsProvider);
    final balls = []; // Placeholder

    if (balls.isEmpty) {
      return const EmptyBagWidget();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: balls.length,
      itemBuilder: (context, index) {
        final ball = balls[index];
        return const SizedBox();
        // return ArsenalBallCard(ball: ball);
      },
    );
  }
}
