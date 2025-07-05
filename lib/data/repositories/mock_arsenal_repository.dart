import 'package:bowlingarsenal_app/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/models/ball_bag_type.dart';
import 'package:bowlingarsenal_app/repositories/arsenal_repository.dart';

/// 模擬的 Arsenal Repository 實作
/// 用於在決定真實資料庫前提供假數據支援
class MockArsenalRepository implements ArsenalRepository {
  @override
  Future<List<ArsenalBall>> getUserArsenal() async {
    // 模擬 1 秒的網路延遲
    await Future.delayed(const Duration(seconds: 1));
    
    // 返回模擬的保齡球數據
    return [
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
    ];
  }

  @override
  Future<void> addBallToArsenal(ArsenalBall ball) async {
    print('Adding ball: ${ball.name}');
  }

  @override
  Future<void> updateBallInArsenal(ArsenalBall ball) async {
    print('Updating ball: ${ball.name}');
  }

  @override
  Future<void> removeBallFromArsenal(String ballId) async {
    print('Removing ball with ID: $ballId');
  }
} 