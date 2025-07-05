import 'package:bowlingarsenal_app/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/models/ball_bag_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);
final selectedBagTypeProvider = StateProvider<BallBagType>(
  (ref) => BallBagType.all,
);

/// Mock data for the arsenal grid.
final userBallsProvider = Provider<List<ArsenalBall>>(
  (ref) => [
    ArsenalBall(
      name: 'Jackal EXJ',
      core: 'Predator V2',
      cover: 'Propulsion HVH Hybrid Reactive',
      layout: '4x4x2',
      imagePath: 'assets/images/Jackal EXJ.jpg',
      brand: 'Motiv',
      dateAdded: DateTime(2024, 1, 15),
      bagType: BallBagType.competition,
    ),
    ArsenalBall(
      name: 'Phaze II',
      core: 'R2S Pearl',
      cover: 'R2S Pearl Reactive',
      layout: '5x3x3',
      imagePath: 'assets/images/Jackal EXJ.jpg',
      brand: 'Storm',
      dateAdded: DateTime(2024, 2, 20),
      bagType: BallBagType.competition,
    ),
    ArsenalBall(
      name: 'IQ Tour',
      core: 'C3 Centripetal Control Core',
      cover: 'R2S Solid Reactive',
      layout: '4.5x4x2',
      imagePath: 'assets/images/Jackal EXJ.jpg',
      brand: 'Storm',
      dateAdded: DateTime(2024, 3, 10),
      bagType: BallBagType.practice,
    ),
    ArsenalBall(
      name: 'Hustle Ink',
      core: 'VTC-P18',
      cover: 'VTC-S19 Solid Reactive',
      layout: '5x4x3',
      imagePath: 'assets/images/Jackal EXJ.jpg',
      brand: 'Roto Grip',
      dateAdded: DateTime(2024, 1, 5),
      bagType: BallBagType.practice,
    ),
    ArsenalBall(
      name: 'Code Black',
      core: 'RAD4 Core',
      cover: 'HK22 Solid Reactive',
      layout: '4.5x3.5x3',
      imagePath: 'assets/images/Jackal EXJ.jpg',
      brand: 'Motiv',
      dateAdded: DateTime(2024, 4, 2),
      bagType: BallBagType.competition,
    ),
  ],
);

/// Filter balls based on selected bag type
final filteredBallsProvider = Provider<List<ArsenalBall>>((ref) {
  final allBalls = ref.watch(userBallsProvider);
  final selectedBagType = ref.watch(selectedBagTypeProvider);

  if (selectedBagType == BallBagType.all) {
    return allBalls;
  }

  return allBalls.where((ball) => ball.bagType == selectedBagType).toList();
}); 