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
    state = AsyncValue.data(currentState.copyWith(
      isUpdating: true,
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
  }
}

/// Provider for checking if a specific ball is favorite
@riverpod
class BallFavoriteController extends _$BallFavoriteController {
  @override
  Future<BallFavoriteState> build(int ballId) async {
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
        // When removing from favorites, don't auto-refresh the main list
        // Let the user manually refresh or re-enter the page
      } else {
        await repository.addToFavorites(ball.id);
        // When adding to favorites, refresh the main list immediately
        ref.invalidate(favoritesControllerProvider);
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