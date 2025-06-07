import 'ball_bag_type.dart';

class ArsenalBall {
  final String name;
  final String core;
  final String cover;
  final String layout;
  final String imagePath;
  final String brand;
  final DateTime dateAdded;
  final BallBagType bagType;

  const ArsenalBall({
    required this.name,
    required this.core,
    required this.cover,
    required this.layout,
    required this.imagePath,
    required this.brand,
    required this.dateAdded,
    required this.bagType,
  });
}
