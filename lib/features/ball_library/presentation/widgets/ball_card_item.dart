import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/favorites/logic/favorites_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart' as up_model;
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/bag_selection_dialog.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BallCardItem extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<BallCardItem> createState() => _BallCardItemState();
}

class _BallCardItemState extends ConsumerState<BallCardItem>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _isSlideOpen = false;
  String _slideDirection = ''; // 'left' or 'right'
  static const double _actionButtonWidth = 80.0;
  double _dragStartX = 0.0;
  bool _justClosed = false; // 避免立即重新打開

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero, // 動態設定
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _openSlideLeft() {
    // 左滑顯示 Arsenal 按鈕在右側
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.27, 0), // 向左滑動
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
    setState(() {
      _isSlideOpen = true;
      _slideDirection = 'left';
    });
  }

  void _openSlideRight() {
    // 右滑顯示 Favorite 按鈕在左側
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.27, 0), // 向右滑動
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
    setState(() {
      _isSlideOpen = true;
      _slideDirection = 'right';
    });
  }

  void _closeSlide() {
    if (_isSlideOpen) {
      _slideController.reverse();
      setState(() {
        _isSlideOpen = false;
        _slideDirection = '';
        _justClosed = true;
      });

      // 短暫延遲後重置 _justClosed，避免立即重新打開
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _justClosed = false;
          });
        }
      });
    }
  }


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

    return await showBagSelectionDialog(
      context: context,
      profile: profile,
      title: 'Add to Arsenal',
      subtitle: widget.ball.name,
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

  /// 切換收藏狀態
  Future<void> _toggleFavorite(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(ballFavoriteControllerProvider(widget.ball.id).notifier)
          .toggle(widget.ball);

      final favoriteState = ref.read(ballFavoriteControllerProvider(widget.ball.id));
      if (favoriteState.hasValue) {
        final isFavorite = favoriteState.value!.isFavorite;
        TopNotification.showSuccess(
          context,
          isFavorite
              ? 'Added "${widget.ball.name}" to favorites'
              : 'Removed "${widget.ball.name}" from favorites',
        );
      }
      _closeSlide(); // 關閉滑動面板
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to update favorite: $e',
      );
      _closeSlide(); // 即使失敗也關閉滑動面板
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
        ballId: widget.ball.id,
        categoryName: categoryName,
        bagNumbers: selectedBagNumbers,
      );

      final bagCount = selectedBagNumbers.length;
      TopNotification.showSuccess(
        context,
        'Successfully added "${widget.ball.name}" to $bagCount bag${bagCount != 1 ? 's' : ''}!',
      );
      _closeSlide(); // 關閉滑動面板
      
    } catch (e) {
      TopNotification.showError(
        context,
        'Failed to add ball to arsenal: $e',
      );
      _closeSlide(); // 即使失敗也關閉滑動面板
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref; // Get ref from ConsumerState
    // 品牌色仍用於品牌標籤
    final brandPalette = getBrandTonalPalette(widget.ball.brand, widget.theme);
    final brandColor = brandPalette[400]!;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Stack(
        children: [
          // 左側背景按鈕 (右滑時顯示 Favorite)
          if (!widget.isSelectionMode && _slideDirection == 'right')
            Positioned.fill(
              child: Row(
                children: [
                  Container(
                    width: _actionButtonWidth,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _toggleFavorite(context, ref),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Favorite',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 右側背景按鈕 (左滑時顯示 Arsenal)
          if (!widget.isSelectionMode && _slideDirection == 'left')
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: _actionButtonWidth,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _showAddToArsenalConfirmation(context, ref),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Arsenal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 主卡片 (可滑動)
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onHorizontalDragStart: widget.isSelectionMode ? null : (details) {
                _dragStartX = details.globalPosition.dx;
              },
              onHorizontalDragUpdate: widget.isSelectionMode ? null : (details) {
                final deltaX = details.globalPosition.dx - _dragStartX;

                if (_isSlideOpen) {
                  // 已開啟時，只處理關閉操作
                  if ((_slideDirection == 'right' && deltaX < -30) ||
                      (_slideDirection == 'left' && deltaX > 30)) {
                    _closeSlide();
                  }
                } else if (!_justClosed) {
                  // 未開啟且沒有剛關閉時，才允許開啟
                  if (deltaX > 30) {
                    // 右滑 - 顯示 Favorite
                    _openSlideRight();
                  } else if (deltaX < -30) {
                    // 左滑 - 顯示 Arsenal
                    _openSlideLeft();
                  }
                }
              },
              onTap: _isSlideOpen ? _closeSlide : widget.onTap,
              child: _buildCard(context, brandColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Color brandColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          if (widget.isSelected)
            BoxShadow(
              color: widget.theme.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            onLongPress: widget.isSelectionMode ? null : widget.onLongPress, // 選擇模式下禁用長按
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
                            child: widget.ball.imageUrl.isNotEmpty && widget.ball.imageUrl != 'https://via.placeholder.com/150'
                                ? CachedNetworkImage(
                                    imageUrl: widget.ball.imageUrl,
                                    fit: BoxFit.cover,
                                    memCacheWidth: 256,
                                    memCacheHeight: 256,
                                    maxWidthDiskCache: 512,
                                    placeholder: (_, __) => const Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => const Icon(
                                      Icons.sports_baseball,
                                      color: Colors.white54,
                                      size: 35,
                                    ),
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
                          widget.ball.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Core & Cover Types in one line - 顯示 Type 而非 Name
                        Text(
                          '${widget.ball.coreType ?? 'Unknown Core'} | ${widget.ball.coverstockType ?? widget.ball.coverstock ?? 'Unknown Cover'}',
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
                            // Brand Tag - 保持品牌色彩
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: brandColor.withOpacity(0.2), // 保持品牌色
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: brandColor.withOpacity(0.4), // 保持品牌色
                                  width: 0.5,
                                ),
                              ),
                              child: Text(
                                widget.ball.brand,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: brandColor, // 保持品牌色
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Region Tag (if available)
                            if (widget.ball.region != null && widget.ball.region!.isNotEmpty)
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
                                  widget.ball.region!,
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
                        // Bottom: RG, Diff, MB Data - Stacked layout without boxes
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'RG',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.ball.rg?.toStringAsFixed(3) ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Diff',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.ball.diff?.toStringAsFixed(3) ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'MB',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    (widget.ball.mbDiff == null || widget.ball.mbDiff == 0)
                                        ? 'N/A'
                                        : widget.ball.mbDiff!.toStringAsFixed(3),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
          // 遮罩與置中勾勾（選擇模式且選中）
          if (widget.isSelectionMode && widget.isSelected)
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
        ],
      ),
    );
  }
} 