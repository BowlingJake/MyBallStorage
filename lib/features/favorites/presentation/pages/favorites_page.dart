import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/favorites/logic/favorites_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_card_item.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up;
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/bag_selection_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Refresh favorites data when entering the page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoritesControllerProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/library'),
          ),
          title: const Text(
            'Favorite Balls',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showAddAllToArsenalConfirmation(context, ref),
              tooltip: 'Add All to Arsenal',
            ),
          ],
        ),
        body: favoritesAsync.when(
          data: (state) {
            return Column(
              children: [
                // 為AppBar留出空間
                SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight + 16),
                
                // 球列表或空狀態
                Expanded(
                  child: state.favoriteBalls.isEmpty
                      ? _buildEmptyState(context)
                      : _buildFavoritesList(state.favoriteBalls),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading favorites: $error',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(favoritesControllerProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.grey[400],
            size: 80,
          ),
          const SizedBox(height: 24),
          Text(
            'No Favorite Balls Yet',
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start adding balls to your favorites\nby tapping the heart icon',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go('/library'),
            icon: const Icon(Icons.search),
            label: const Text('Browse Ball Library'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<BowlingBall> balls) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: balls.length,
        itemBuilder: (context, index) {
          final ball = balls[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: BallCardItem(
              ball: ball,
              theme: Theme.of(context),
              onTap: () => _showBallDetail(context, ball),
              onLongPress: () => _showRemoveConfirmation(context, ref, ball),
            ),
          );
        },
      ),
    );
  }

  /// 顯示加入所有favorite球到Arsenal的確認對話框
  Future<void> _showAddAllToArsenalConfirmation(BuildContext context, WidgetRef ref) async {
    final favoritesAsync = ref.read(favoritesControllerProvider);
    if (!favoritesAsync.hasValue || favoritesAsync.value == null) return;
    
    final favoriteCount = favoritesAsync.value!.favoriteBalls.length;
    if (favoriteCount == 0) {
      TopNotification.showError(
        context,
        'No favorite balls to add to arsenal',
      );
      return;
    }

    // Use common bag selection dialog instead of simple confirmation
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      TopNotification.showError(context, 'Please log in to add balls to arsenal');
      return;
    }
    final userId = authState.value!.id;
    final repo = ref.read(userProfileRepositoryProvider);
    final up.UserProfile? maybeProfile = await repo.getUserProfile(userId);
    final up.UserProfile profile = maybeProfile ?? await repo.saveUserProfile(
      up.UserProfile(
        userId: userId,
        bag1Name: 'All My Arsenal',
        bag1Unlocked: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    final selectedBagNumbers = await showBagSelectionDialog(
      context: context,
      profile: profile,
      title: 'Add All to Arsenal',
      subtitle: '$favoriteCount selected',
    );

    if (selectedBagNumbers != null && selectedBagNumbers.isNotEmpty) {
      await _addAllFavoritesToArsenal(context, ref, selectedBagNumbers);
    }
  }

  /// 將所有favorite球加入Arsenal
  Future<void> _addAllFavoritesToArsenal(BuildContext context, WidgetRef ref, List<int> selectedBagNumbers) async {
    try {
      // Get user ID
      final authState = ref.read(authControllerProvider);
      if (!authState.hasValue || authState.value == null) {
        TopNotification.showError(
          context,
          'Please log in to add balls to arsenal',
        );
        return;
      }
      final userId = authState.value!.id;

      // Initialize arsenal and get categories
      await ref.read(newArsenalControllerProvider.notifier).initialize(userId);
      final arsenalState = ref.read(newArsenalControllerProvider);
      
      // Use "My Balls" as default category, or create it if no categories exist
      String categoryName = 'My Balls';
      if (arsenalState.userCategories.isNotEmpty) {
        categoryName = arsenalState.userCategories.first;
      }

      final favoritesState = ref.read(favoritesControllerProvider);
      if (!favoritesState.hasValue) return;

      final favoriteBalls = favoritesState.value!.favoriteBalls;
      
      // Add each favorite ball to selected bags
      for (final ball in favoriteBalls) {
        try {
          await ref.read(newArsenalControllerProvider.notifier).addBallFromLibraryToMultipleBags(
                userId: userId,
                ballId: ball.id,
                categoryName: categoryName,
                bagNumbers: selectedBagNumbers,
              );
        } catch (e) {
          // ignore individual errors and continue
        }
      }
      
      final favoriteCount = favoriteBalls.length;
      TopNotification.showSuccess(
        context,
        'Successfully added $favoriteCount favorite ball${favoriteCount != 1 ? 's' : ''} to arsenal!',
      );
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add favorite balls to arsenal: $e',
      );
    }
  }

  void _showBallDetail(BuildContext context, BowlingBall ball) {
    showDialog<void>(
      context: context,
      builder: (context) => BowlingBallDetailWidget(ball: ball),
    );
  }

  void _showRemoveConfirmation(BuildContext context, WidgetRef ref, BowlingBall ball) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Remove from Favorites',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Remove "${ball.name}" from your favorites?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(favoritesControllerProvider.notifier).removeFromFavorites(ball.id);
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}