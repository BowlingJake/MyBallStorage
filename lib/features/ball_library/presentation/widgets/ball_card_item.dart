import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BallCardItem extends ConsumerWidget {
  const BallCardItem({
    required this.ball,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
    super.key,
  });
  
  final BowlingBall ball;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;


  /// 顯示加入Arsenal確認對話框
  Future<void> _showAddToArsenalConfirmation(BuildContext context, WidgetRef ref) async {
    final result = await showAppConfirmationDialog(
      context: context,
      title: 'Add to Arsenal',
      message: 'Do you want to add this ball to your arsenal?',
      confirmText: 'Yes',
      cancelText: 'No',
    );

    if (result == true) {
      await _addBallToArsenal(context, ref);
    }
  }

  /// 將球加入Arsenal
  Future<void> _addBallToArsenal(BuildContext context, WidgetRef ref) async {
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

      // Add ball to arsenal
      await ref.read(newArsenalControllerProvider.notifier).addBallFromLibrary(
        userId: userId,
        ballId: ball.id,
        categoryName: categoryName,
      );
      
      TopNotification.showSuccess(
        context,
        'Successfully added "${ball.name}" to arsenal!',
      );
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add ball to arsenal: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandPalette = getBrandTonalPalette(ball.brand, theme);
    final brandColor = brandPalette[400]!;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.black.withOpacity(0.8),
              border: Border.all(
                color: isSelected 
                    ? theme.primaryColor.withOpacity(0.8)
                    : brandColor.withOpacity(0.6),
                width: isSelected ? 3.0 : 1.5,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              onTap: isSelectionMode ? onTap : null, // 在選擇模式下允許點擊
              onLongPress: isSelectionMode ? null : onTap, // 在選擇模式下禁用長按
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left: Ball Image (Circular)
                    SizedBox(
                      width: 120, // Fixed square width
                      height: 120, // Fixed square height
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: ClipOval(
                          child: ball.imageUrl.isNotEmpty && ball.imageUrl != 'https://via.placeholder.com/150'
                              ? Image.network(
                                  ball.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.sports_baseball,
                                      color: Colors.white54,
                                      size: 35,
                                    );
                                  },
                                )
                              : const Icon(
                                  Icons.sports_baseball,
                                  color: Colors.white54,
                                  size: 35,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right: Information Column
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top: Ball Name
                          Text(
                            ball.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Core & Cover Types in one line
                          Text(
                            '${getCoreCategory(ball.core)} | ${ball.coverstockType ?? ball.coverstock ?? 'Unknown'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Brand & Region Tags
                          Row(
                            children: [
                              // Brand Tag
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: brandColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: brandColor.withOpacity(0.4),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  ball.brand,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brandColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Region Tag (if available)
                              if (ball.region != null && ball.region!.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.4),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    ball.region!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Bottom: RG, Diff, MB Data Blocks
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'RG',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: brandColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ball.rg?.toStringAsFixed(3) ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Diff',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: brandColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        ball.diff?.toStringAsFixed(3) ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'MB',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: brandColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        (ball.mbDiff == null || ball.mbDiff == 0) 
                                            ? 'N/A' 
                                            : ball.mbDiff!.toStringAsFixed(3),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 選擇模式指示器或愛心按鈕
          Positioned(
            top: 8,
            right: 8,
            child: isSelectionMode
                ? (isSelected 
                    ? Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    : const SizedBox.shrink()) // 未選中時不顯示任何icon
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CompactFavoriteButton(ball: ball),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => _showAddToArsenalConfirmation(context, ref),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
} 