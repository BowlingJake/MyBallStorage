import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/favorites/logic/favorites_controller.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

class FavoriteButtonWidget extends ConsumerWidget {
  const FavoriteButtonWidget({
    required this.ball,
    this.size = 24.0,
    this.iconColor,
    super.key,
  });

  final BowlingBall ball;
  final double size;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ballFavoriteAsync = ref.watch(ballFavoriteControllerProvider(ball.id));

    return ballFavoriteAsync.when(
      data: (state) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: state.isUpdating 
              ? null 
              : () async {
                  await ref
                      .read(ballFavoriteControllerProvider(ball.id).notifier)
                      .toggle(ball);
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: state.isFavorite 
                      ? Colors.red 
                      : (iconColor ?? Colors.grey[400]),
                  size: size,
                ),
                if (state.isUpdating)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: size * 0.6,
                        height: size * 0.6,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
      ),
      error: (error, stack) => Icon(
        Icons.favorite_border,
        color: Colors.grey[400],
        size: size,
      ),
    );
  }
}

/// Simplified favorite button for use in tight spaces
class CompactFavoriteButton extends ConsumerWidget {
  const CompactFavoriteButton({
    required this.ball,
    this.size = 20.0,
    super.key,
  });

  final BowlingBall ball;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 BallFavoriteController 而不是 FavoritesController
    final ballFavoriteAsync = ref.watch(ballFavoriteControllerProvider(ball.id));

    return ballFavoriteAsync.when(
      data: (state) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: state.isUpdating 
              ? null 
              : () async {
                  await ref
                      .read(ballFavoriteControllerProvider(ball.id).notifier)
                      .toggle(ball);
                },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              state.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: state.isFavorite ? Colors.red : Colors.white,
              size: size,
            ),
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.favorite_border,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}