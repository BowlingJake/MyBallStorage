import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/arsenal_action_buttons.dart';
import '../widgets/arsenal_ball_card.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);

/// Mock data for the arsenal grid.
final userBallsProvider = Provider<List<ArsenalBall>>((ref) => [
      const ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
      ),
      const ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
      ),
      const ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
      ),
      const ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
      ),
    ]);

/// A simple page showing the user's arsenal.
class MyArsenalPage extends ConsumerWidget {
  const MyArsenalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomIndexProvider);

    final balls = ref.watch(userBallsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Arsenal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ArsenalActionButtons(
              onAddPressed: () {},
              onAnalyzePressed: () {},
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: balls.length,
                itemBuilder: (context, index) =>
                    ArsenalBallCard(ball: balls[index]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) =>
            ref.read(bottomIndexProvider.notifier).state = index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Arsenal'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
