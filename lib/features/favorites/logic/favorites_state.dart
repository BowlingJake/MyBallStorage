import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState({
    @Default([]) List<BowlingBall> favoriteBalls,
    @Default({}) Set<int> favoriteBallIds,
    @Default(false) bool isLoading,
    @Default(false) bool isUpdating,
    String? error,
  }) = _FavoritesState;
}

/// State for individual ball favorite status
@freezed
class BallFavoriteState with _$BallFavoriteState {
  const factory BallFavoriteState({
    @Default(false) bool isFavorite,
    @Default(false) bool isUpdating,
    String? error,
  }) = _BallFavoriteState;
}