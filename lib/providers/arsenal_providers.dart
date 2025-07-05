import 'package:bowlingarsenal_app/data/repositories/mock_arsenal_repository.dart';
import 'package:bowlingarsenal_app/models/arsenal_ball.dart';
import 'package:bowlingarsenal_app/models/ball_bag_type.dart';
import 'package:bowlingarsenal_app/repositories/arsenal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 0);
final selectedBagTypeProvider = StateProvider<BallBagType>(
  (ref) => BallBagType.all,
);

/// 提供 ArsenalRepository 的實例
final arsenalRepositoryProvider = Provider<ArsenalRepository>((ref) {
  return MockArsenalRepository();
});

/// Notifier class for managing the user's arsenal of bowling balls.
class UserArsenalNotifier extends AsyncNotifier<List<ArsenalBall>> {
  @override
  Future<List<ArsenalBall>> build() async {
    final repository = ref.watch(arsenalRepositoryProvider);
    return repository.getUserArsenal();
  }

  /// Adds a new ball to the user's arsenal with optimistic update.
  Future<void> addBall(ArsenalBall newBall) async {
    // Get the repository instance
    final repository = ref.read(arsenalRepositoryProvider);

    // Optimistic update: Add the new ball to the current state immediately.
    state = await state.when(
      data: (balls) => AsyncData([...balls, newBall]),
      error: (e, s) => AsyncError(e, s),
      loading: () => const AsyncLoading(),
    );

    try {
      // Call the repository to add the ball.
      await repository.addBallToArsenal(newBall);
    } catch (e, s) {
      // If the API call fails, revert the state.
      state = await state.when(
        data: (balls) {
          // Remove the ball that was added optimistically.
          final revertedBalls = balls.where((b) => b.name != newBall.name).toList();
          return AsyncData(revertedBalls);
        },
        error: (e, s) => AsyncError(e, s),
        loading: () => const AsyncLoading(),
      );
      // Re-throw the error to be handled by the UI if needed.
      throw Exception('Failed to add ball: $e');
    }
  }
}

/// Provider for the user's arsenal, using AsyncNotifier for data mutations.
final userBallsProvider =
    AsyncNotifierProvider<UserArsenalNotifier, List<ArsenalBall>>(
  UserArsenalNotifier.new,
);

/// 根據選擇的球袋類型過濾保齡球列表
final filteredBallsProvider = Provider<List<ArsenalBall>>((ref) {
  final userBallsAsyncValue = ref.watch(userBallsProvider);
  final selectedBagType = ref.watch(selectedBagTypeProvider);

  return userBallsAsyncValue.when(
    data: (allBalls) {
      if (selectedBagType == BallBagType.all) {
        return allBalls;
      }
      return allBalls.where((ball) => ball.bagType == selectedBagType).toList();
    },
    loading: () => [], // 加載中返回空列表
    error: (error, stack) => [], // 錯誤時返回空列表
  );
}); 