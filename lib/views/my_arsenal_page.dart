import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/arsenal_ball.dart';
import '../models/ball_bag_type.dart';
import '../widgets/action_button_pair.dart';
import '../widgets/bag_selector_widget.dart';
import '../widgets/ball_grid_widget.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);
final selectedBagTypeProvider = StateProvider<BallBagType>((ref) => BallBagType.all);

/// Mock data for the arsenal grid.
final userBallsProvider = Provider<List<ArsenalBall>>((ref) => [
      ArsenalBall(
        name: 'Jackal EXJ',
        core: 'Predator V2',
        cover: 'Propulsion HVH',
        layout: '4x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 1, 15),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'Phaze II',
        core: 'R2S Pearl',
        cover: 'Hybrid Reactive',
        layout: '5x3x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 2, 20),
        bagType: BallBagType.competition,
      ),
      ArsenalBall(
        name: 'IQ Tour',
        core: 'C3 Centripetal Control Core',
        cover: 'R2S Solid',
        layout: '4.5x4x2',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Storm',
        dateAdded: DateTime(2024, 3, 10),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Hustle Ink',
        core: 'VTC-P18',
        cover: 'VTC-S19',
        layout: '5x4x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Roto Grip',
        dateAdded: DateTime(2024, 1, 5),
        bagType: BallBagType.practice,
      ),
      ArsenalBall(
        name: 'Code Black',
        core: 'RAD4 Core',
        cover: 'HK22 Solid',
        layout: '4.5x3.5x3',
        imagePath: 'assets/images/Jackal EXJ.jpg',
        brand: 'Motiv',
        dateAdded: DateTime(2024, 4, 2),
        bagType: BallBagType.competition,
      ),
    ]);

/// Filter balls based on selected bag type
final filteredBallsProvider = Provider<List<ArsenalBall>>((ref) {
  final allBalls = ref.watch(userBallsProvider);
  final selectedBagType = ref.watch(selectedBagTypeProvider);
  
  if (selectedBagType == BallBagType.all) {
    return allBalls;
  }
  
  return allBalls.where((ball) => ball.bagType == selectedBagType).toList();
});

/// A simple page showing the user's arsenal.
class MyArsenalPage extends ConsumerWidget {
  const MyArsenalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomIndexProvider);
    final selectedBagType = ref.watch(selectedBagTypeProvider);
    final balls = ref.watch(filteredBallsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Arsenal'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 1,
      ),
            body: Column(
        children: [
          // Bag selector dropdown
          BagSelectorWidget(
            selectedBagType: selectedBagType,
            onChanged: (BallBagType? value) {
              if (value != null) {
                ref.read(selectedBagTypeProvider.notifier).state = value;
              }
            },
          ),
          const SizedBox(height: 8),
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ActionButtonPair(
              primaryButtonText: 'Add from Library',
              secondaryButtonText: 'Analyze Chart',
              onPrimaryPressed: () {},
              onSecondaryPressed: () {},
            ),
          ),
          const SizedBox(height: 16),
          // Balls grid
          Expanded(
            child: BallGridWidget(balls: balls),
          ),
        ],
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
