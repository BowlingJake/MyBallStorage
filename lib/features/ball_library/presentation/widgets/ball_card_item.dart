import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up_model;
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
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


  /// 顯示加入Arsenal球袋選擇對話框
  Future<void> _showAddToArsenalConfirmation(BuildContext context, WidgetRef ref) async {
    final selectedBags = await _showBagSelectionDialog(context, ref);
    
    if (selectedBags != null && selectedBags.isNotEmpty) {
      await _addBallToSelectedBags(context, ref, selectedBags);
    }
  }

  /// 顯示球袋選擇對話框
  Future<List<int>?> _showBagSelectionDialog(BuildContext context, WidgetRef ref) async {
    // Get user profile to access unlocked bags
    final authState = ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) {
      TopNotification.showError(
        context,
        'Please log in to add balls to arsenal',
      );
      return null;
    }
    
    final userId = authState.value!.id;
    // 直接透過 repository 取得或建立使用者 Profile（避免 provider autoDispose 造成的狀態丟失）
    final profile = await _fetchOrCreateUserProfile(ref, userId);
    if (profile == null) {
      TopNotification.showError(
        context,
        'Failed to load user profile',
      );
      return null;
    }

    final unlockedBags = profile.unlockedBags;

    // 使用統一的袋子顏色服務
    final bagColors = BagColorService.getAllBagColors();

    // 預設選中第一個球袋 (通常是 "All My Arsenal")
    final selectedBags = <int>{1}; // 預設選中球袋1

    return await showDialog<List<int>>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BrandColors.accentColorDark, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題區（無 icon）
                  Text(
                    'Add to Arsenal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ball.name,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select which bags to add this ball to:',
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  // 垂直袋子按鈕列表
                  ...unlockedBags.map((bagInfo) {
                    final isSelected = selectedBags.contains(bagInfo.number);
                    final bagColor = bagColors[bagInfo.number - 1];
                    final bagText = bagInfo.number == 1 ? '${bagInfo.name} (Required)' : bagInfo.name;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppStandardButton(
                        text: bagText,
                        height: 36,
                        width: double.infinity,
                        isPrimary: isSelected,
                        customColor: isSelected ? bagColor : null,
                        outlineColor: isSelected ? null : Colors.white,
                        foregroundColor: isSelected ? Colors.black : Colors.white,
                        onPressed: () {
                          if (bagInfo.number == 1) {
                            // 主球袋固定選取
                            return;
                          }
                          setState(() {
                            if (isSelected) {
                              selectedBags.remove(bagInfo.number);
                            } else {
                              selectedBags.add(bagInfo.number);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                  if (unlockedBags.length == 1) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tip: Unlock more bags in Bag Management to organize your arsenal better!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                  const SizedBox(height: 16),
                  // 底部動作列
                  Row(
                    children: [
                      Expanded(
                        child: AppStandardButton(
                          text: 'Cancel',
                          height: 36,
                          outlineColor: Colors.white.withOpacity(0.6),
                          foregroundColor: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppStandardButton(
                          text: 'Add to ${selectedBags.length} bag${selectedBags.length != 1 ? 's' : ''}',
                          height: 36,
                          isPrimary: true,
                          customColor: BrandColors.accentColorDark,
                          whiteForeground: true,
                          onPressed: () => Navigator.of(context).pop(selectedBags.toList()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<up_model.UserProfile?> _fetchOrCreateUserProfile(WidgetRef ref, String userId) async {
    try {
      final repo = ref.read(userProfileRepositoryProvider);
      var profile = await repo.getUserProfile(userId);
      if (profile != null) {
        return profile;
      }
      final newProfile = up_model.UserProfile(
        userId: userId,
        bag1Name: 'All My Arsenal',
        bag1Unlocked: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final saved = await repo.saveUserProfile(newProfile);
      return saved;
    } catch (e) {
      return null;
    }
  }

  /// 將球加入選定的球袋
  Future<void> _addBallToSelectedBags(BuildContext context, WidgetRef ref, List<int> selectedBagNumbers) async {
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

      // Add ball to selected bags using the new multi-bag functionality
      final arsenalController = ref.read(newArsenalControllerProvider.notifier);
      await arsenalController.addBallFromLibraryToMultipleBags(
        userId: userId,
        ballId: ball.id,
        categoryName: categoryName,
        bagNumbers: selectedBagNumbers,
      );
      
      final bagCount = selectedBagNumbers.length;
      TopNotification.showSuccess(
        context,
        'Successfully added "${ball.name}" to $bagCount bag${bagCount != 1 ? 's' : ''}!',
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
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
                width: 1.5,
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
              onTap: onTap, // 總是允許點擊
              onLongPress: isSelectionMode ? null : onLongPress, // 選擇模式下禁用長按
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Left: Ball Image (Circular)
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          Container(
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
                        ],
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
          // 遮罩與置中勾勾（選擇模式且選中）
          if (isSelectionMode && isSelected)
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: const [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0x40FFFFFF),
                        ),
                      ),
                      Center(
                        child: Icon(
                          Icons.check_circle,
                          color: BrandColors.accentColorDark,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // 非選擇模式：顯示愛心與加入 Arsenal
          if (!isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: Column(
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