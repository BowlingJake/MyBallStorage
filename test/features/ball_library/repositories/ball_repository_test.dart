import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_repository.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/ball_data_service.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

// Mock classes
class MockBallDataService extends Mock implements BallDataService {}

void main() {
  group('BallDataRepository', () {
    late BallRepository repository;
    late MockBallDataService mockService;

    // 測試數據
    final testBalls = [
      const BowlingBall(
        id: '1',
        name: 'Storm Phaze II',
        brand: 'Storm',
        core: 'R2S Core',
        coverstock: 'R2S Pearl Reactive',
        coverstockName: 'R2S Pearl',
        factoryFinish: '1500 Grit Polish',
        releaseDate: '2018',
        rg: 2.49,
        diff: 0.051,
      ),
      const BowlingBall(
        id: '2',
        name: 'Motiv Jackal EXJ',
        brand: 'Motiv',
        core: 'Predator V2',
        coverstock: 'Propulsion HVH Hybrid Reactive',
        coverstockName: 'Propulsion HVH',
        factoryFinish: '4000 Grit',
        releaseDate: '2023',
        rg: 2.48,
        diff: 0.053,
      ),
      const BowlingBall(
        id: '3',
        name: 'Storm IQ Tour',
        brand: 'Storm',
        core: 'C3 Core',
        coverstock: 'R2S Solid Reactive',
        coverstockName: 'R2S Solid',
        factoryFinish: '3000 Grit',
        releaseDate: '2015',
        rg: 2.50,
        diff: 0.049,
      ),
    ];

    setUp(() {
      mockService = MockBallDataService();
      repository = BallDataRepository(mockService);
    });

    group('getAllBalls', () {
      test('returns all balls from service', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getAllBalls();

        // Assert
        expect(result, equals(testBalls));
        verify(() => mockService.loadBallData()).called(1);
      });

      test('handles service errors gracefully', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => repository.getAllBalls(), throwsA(isA<Exception>()));
      });
    });

    group('getBallsByBrand', () {
      test('filters balls by brand case-insensitively', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getBallsByBrand('storm');

        // Assert
        expect(result.length, equals(2));
        expect(result.every((ball) => ball.brand.toLowerCase() == 'storm'), isTrue);
        verify(() => mockService.loadBallData()).called(1);
      });

      test('returns empty list for non-existent brand', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getBallsByBrand('NonExistent');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('searchBallsByName', () {
      test('searches balls by name case-insensitively', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.searchBallsByName('phaze');

        // Assert
        expect(result.length, equals(1));
        expect(result.first.name, contains('Phaze'));
        verify(() => mockService.loadBallData()).called(1);
      });

      test('returns partial matches', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.searchBallsByName('Storm');

        // Assert
        expect(result.length, equals(2));
        expect(result.every((ball) => ball.name.contains('Storm')), isTrue);
      });
    });

    group('getAllBrands', () {
      test('returns unique brands sorted alphabetically', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getAllBrands();

        // Assert
        expect(result, equals(['Motiv', 'Storm']));
        verify(() => mockService.loadBallData()).called(1);
      });
    });

    group('getBallById', () {
      test('returns ball with matching ID', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getBallById('2');

        // Assert
        expect(result, isNotNull);
        expect(result!.id, equals('2'));
        expect(result.name, equals('Motiv Jackal EXJ'));
      });

      test('returns null for non-existent ID', () async {
        // Arrange
        when(() => mockService.loadBallData()).thenAnswer((_) async => testBalls);

        // Act
        final result = await repository.getBallById('999');

        // Assert
        expect(result, isNull);
      });
    });

    group('clearCache', () {
      test('clearCache method exists and can be called', () {
        // Act & Assert
        expect(() => repository.clearCache(), returnsNormally);
      });
    });
  });
} 