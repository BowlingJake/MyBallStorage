import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// Mock data for testing the Arsenal UI components
class MockArsenalTestData {
  static const String mockUserId = 'test_user_123';
  
  static List<ArsenalBallInstance> getMockArsenalBalls() {
    return [
      // Ball 1: Storm PhAZE II - High-end performance ball
      ArsenalBallInstance(
        instanceId: 'test_instance_1',
        ballId: 'storm_phaze_ii',
        userId: mockUserId,
        nickname: 'My Go-To Strike Ball',
        addedDate: DateTime(2024, 1, 15),
        purchaseDate: DateTime(2024, 1, 10),
        bagCategoryId: 'competition_$mockUserId',
        gamesUsed: 45,
        instanceNumber: 1,
        notes: 'Excellent for medium-heavy oil patterns',
        layout: BallLayout(
          layoutId: 'layout_1',
          userId: mockUserId,
          pinToPap: 4.5,
          papToMb: 3.25,
          psaAngle: 45.0,
          layoutType: LayoutType.aggressive,
          notes: 'Aggressive layout for heavy oil',
          createdAt: DateTime(2024, 1, 15),
        ),
        bowlingBall: BowlingBall(
          id: 1,
          name: 'PhAZE II',
          brand: 'Storm',
          coreName: 'R2S Pearl',
          coreType: 'Asymmetric',
          coverstockType: 'Reactive Pearl',
          coverstockName: 'R2S Pearl Reactive',
          imageUrl: 'https://via.placeholder.com/150/1E88E5/FFFFFF?text=PhAZE+II',
          rg: 2.49,
          diff: 0.051,
          mbDiff: 0.015,
          region: 'Global',
          createdAt: DateTime(2024, 1, 1).toIso8601String(),
        ),
        isCustomBall: false,
      ),

      // Ball 2: Motiv Jackal Ghost - Strong control ball  
      ArsenalBallInstance(
        instanceId: 'test_instance_2',
        ballId: 'motiv_jackal_ghost',
        userId: mockUserId,
        nickname: '',
        addedDate: DateTime(2024, 2, 20),
        purchaseDate: DateTime(2024, 2, 18),
        bagCategoryId: 'competition_$mockUserId',
        gamesUsed: 32,
        instanceNumber: 1,
        notes: 'Great control on transition shots',
        layout: BallLayout(
          layoutId: 'layout_2',
          userId: mockUserId,
          pinToPap: 5.0,
          papToMb: 4.0,
          psaAngle: 30.0,
          layoutType: LayoutType.control,
          notes: 'Control layout for versatility',
          createdAt: DateTime(2024, 2, 20),
        ),
        bowlingBall: BowlingBall(
          id: 2,
          name: 'Jackal Ghost',
          brand: 'Motiv',
          coreName: 'Predator V2',
          coreType: 'Asymmetric',
          coverstockType: 'Reactive Solid',
          coverstockName: 'Coercion MFS Solid',
          imageUrl: 'https://via.placeholder.com/150/7CB342/FFFFFF?text=Jackal+Ghost',
          rg: 2.48,
          diff: 0.054,
          mbDiff: 0.017,
          region: 'Global',
          createdAt: DateTime(2024, 1, 1).toIso8601String(),
        ),
        isCustomBall: false,
      ),

      // Ball 3: Roto Grip Hustle Ink - Entry level practice ball
      ArsenalBallInstance(
        instanceId: 'test_instance_3',
        ballId: 'rotogrip_hustle_ink',
        userId: mockUserId,
        nickname: 'Practice Partner',
        addedDate: DateTime(2024, 3, 10),
        purchaseDate: DateTime(2024, 3, 8),
        bagCategoryId: 'practice_$mockUserId',
        gamesUsed: 78,
        instanceNumber: 2, // Second ball of this type
        notes: 'Perfect for dry lanes and spare shooting',
        layout: BallLayout(
          layoutId: 'layout_3',
          userId: mockUserId,
          pinToPap: 4.0,
          papToMb: 3.5,
          psaAngle: 50.0,
          layoutType: LayoutType.straight,
          notes: 'Straight layout for control and spares',
          createdAt: DateTime(2024, 3, 10),
        ),
        bowlingBall: BowlingBall(
          id: 3,
          name: 'Hustle Ink',
          brand: 'Roto Grip',
          coreName: 'VTC-P18',
          coreType: 'Symmetric',
          coverstockType: 'Reactive Solid',
          coverstockName: 'VTC-S19 Solid',
          imageUrl: 'https://via.placeholder.com/150/E53935/FFFFFF?text=Hustle+Ink',
          rg: 2.53,
          diff: 0.030,
          mbDiff: null, // Symmetric ball doesn't have MB differential
          region: 'Global',
          createdAt: DateTime(2024, 1, 1).toIso8601String(),
        ),
        isCustomBall: false,
      ),
    ];
  }

  static List<BagCategory> getMockCategories() {
    return DefaultBagCategories.createForUser(mockUserId);
  }
}