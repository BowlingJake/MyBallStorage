import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/favorites/data/favorites_repository.dart';
import 'package:bowlingarsenal_app/features/favorites/logic/favorites_state.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'favorites_controller.g.dart';

/// Provider for FavoritesRepository
@riverpod
FavoritesRepository favoritesRepository(FavoritesRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return FavoritesRepository(supabase);
}

/// AsyncNotifier for managing favorites state
@riverpod
class FavoritesController extends _$FavoritesController {
  @override
  Future<FavoritesState> build() async {
    return await _loadFavoriteIdsFast();
  }

  /// Fast path: load only favorite IDs for quick UI (e.g., library hearts)
  Future<FavoritesState> _loadFavoriteIdsFast() async {
    try {
      final repository = ref.read(favoritesRepositoryProvider);
      final ids = await repository.getFavoriteBallIds();
      final ballIds = ids.toSet();

      return FavoritesState(
        favoriteBalls: const [],
        favoriteBallIds: ballIds,
        isLoading: false,
      );
    } catch (e) {
      return FavoritesState(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Full load: fetch complete ball objects for favorites page
  Future<void> loadFavoriteBallsFull() async {
    try {
      final repository = ref.read(favoritesRepositoryProvider);
      final balls = await repository.getFavoriteBalls();
      final ballIds = balls.map((b) => b.id).toSet();
      final current = state.value;
      state = AsyncValue.data(FavoritesState(
        favoriteBalls: balls,
        favoriteBallIds: ballIds,
        isLoading: false,
        error: current?.error,
      ));
    } catch (e) {
      // keep IDs if available
      final current = state.value;
      state = AsyncValue.data(FavoritesState(
        favoriteBalls: current?.favoriteBalls ?? const [],
        favoriteBallIds: current?.favoriteBallIds ?? {},
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  /// Add ball to favorites
  Future<void> addToFavorites(BowlingBall ball) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    state = AsyncValue.data(currentState.copyWith(
      isUpdating: true,
      favoriteBallIds: {...currentState.favoriteBallIds, ball.id},
      favoriteBalls: currentState.favoriteBalls.any((b) => b.id == ball.id)
          ? currentState.favoriteBalls
          : [...currentState.favoriteBalls, ball],
    ));

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      await repository.addToFavorites(ball.id);

      // Keep optimistic state, just clear updating
      final latest = state.value;
      state = AsyncValue.data((latest ?? currentState).copyWith(
        isUpdating: false,
      ));
    } catch (e) {
      // Revert optimistic update on error
      state = AsyncValue.data(currentState.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }

  /// Remove ball from favorites
  /// Note: This method only removes from backend, UI will remain unchanged
  /// until refresh() is called or controller is rebuilt
  Future<void> removeFromFavorites(int ballId) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Show updating state but keep the list unchanged
    final updatedBalls = currentState.favoriteBalls.where((b) => b.id != ballId).toList();
    state = AsyncValue.data(currentState.copyWith(
      isUpdating: true,
      favoriteBalls: updatedBalls,
    ));

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      await repository.removeFromFavorites(ballId);

      // Only remove from favoriteBallIds for internal tracking
      // but keep favoriteBalls list unchanged for UI display
      final updatedIds = Set<int>.from(currentState.favoriteBallIds)
        ..remove(ballId);

      final latest = state.value;
      state = AsyncValue.data((latest ?? currentState).copyWith(
        isUpdating: false,
        favoriteBallIds: updatedIds,
      ));
    } catch (e) {
      // Revert optimistic update on error
      state = AsyncValue.data(currentState.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }

  /// Toggle favorite status of a ball
  Future<void> toggleFavorite(BowlingBall ball) async {
    final currentState = state.value;
    if (currentState == null) return;

    final isFavorite = currentState.favoriteBallIds.contains(ball.id);
    if (isFavorite) {
      await removeFromFavorites(ball.id);
    } else {
      await addToFavorites(ball);
    }
  }

  /// Refresh favorites from server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadFavoriteIdsFast());
    // Also load full ball data for favorites page
    await loadFavoriteBallsFull();
  }
}

/// Provider for checking if a specific ball is favorite
@riverpod
class BallFavoriteController extends _$BallFavoriteController {
  @override
  Future<BallFavoriteState> build(int ballId) async {
    // Listen to the main favorites controller to stay in sync
    ref.listen(favoritesControllerProvider, (previous, next) {
      // When favorites list changes, check if this ball's status has changed
      next.whenData((favoritesState) {
        final currentState = state.value;
        if (currentState != null) {
          final isFavoriteInList = favoritesState.favoriteBallIds.contains(ballId);
          if (currentState.isFavorite != isFavoriteInList) {
            // Update state to match the main favorites list
            state = AsyncValue.data(currentState.copyWith(
              isFavorite: isFavoriteInList,
            ));
          }
        }
      });
    });

    return await _checkFavoriteStatus(ballId);
  }

  Future<BallFavoriteState> _checkFavoriteStatus(int ballId) async {
    try {
      final repository = ref.read(favoritesRepositoryProvider);
      final isFavorite = await repository.isFavorite(ballId);

      return BallFavoriteState(isFavorite: isFavorite);
    } catch (e) {
      return BallFavoriteState(error: e.toString());
    }
  }

  /// Toggle favorite status
  Future<void> toggle(BowlingBall ball) async {
    final currentState = state.value;
    if (currentState == null) return;

    // Optimistic update
    state = AsyncValue.data(currentState.copyWith(
      isUpdating: true,
      isFavorite: !currentState.isFavorite,
    ));

    try {
      final repository = ref.read(favoritesRepositoryProvider);
      
      if (currentState.isFavorite) {
        await repository.removeFromFavorites(ball.id);
        // 同步更新主清單（樂觀）：立即移除
        await ref.read(favoritesControllerProvider.notifier).removeFromFavorites(ball.id);
      } else {
        await repository.addToFavorites(ball.id);
        // 同步更新主清單（樂觀）：立即加入
        await ref.read(favoritesControllerProvider.notifier).addToFavorites(ball);
      }

      // Update state after successful operation
      state = AsyncValue.data(currentState.copyWith(
        isUpdating: false,
        isFavorite: !currentState.isFavorite,
      ));
    } catch (e) {
      // Revert optimistic update on error
      state = AsyncValue.data(currentState.copyWith(
        isUpdating: false,
        error: e.toString(),
      ));
    }
  }
}