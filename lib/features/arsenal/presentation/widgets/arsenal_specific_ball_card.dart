import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/edit_layout_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/shared/services/bag_color_service.dart';

/// Arsenal 專用的球卡組件，基於 UnifiedBallCard 但針對 My Arsenal 需求定制
class ArsenalSpecificBallCard extends ConsumerStatefulWidget {
  const ArsenalSpecificBallCard({
    required this.arsenalBallInstance,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.extraInfo,
    super.key,
  });
  
  final UserArsenalInstance arsenalBallInstance;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  final Widget? extraInfo; // 額外資訊，如 arsenal 的 games used 等

  // 統一的數據獲取方法
  String get ballName => arsenalBallInstance.displayName;
  String get brandName => arsenalBallInstance.brandName;
  String get imageUrl => arsenalBallInstance.effectiveImageUrl;
  BowlingBall? get bowlingBall => arsenalBallInstance.bowlingBall;
  int get ballId => arsenalBallInstance.ballId;

  @override
  ConsumerState<ArsenalSpecificBallCard> createState() => _ArsenalSpecificBallCardState();
}

class _ArsenalSpecificBallCardState extends ConsumerState<ArsenalSpecificBallCard>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  bool _isSlideOpen = false;
  String _slideDirection = ''; // 'left' or 'right'
  static const double _actionButtonWidth = 80.0;
  double _dragStartX = 0.0;
  bool _justClosed = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
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
    // 左滑顯示 Remove 按鈕在右側
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
    // 右滑顯示 Move/Add to bag 按鈕在左側
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

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _justClosed = false;
          });
        }
      });
    }
  }

  String get ballName => widget.arsenalBallInstance.displayName;
  String get brandName => widget.arsenalBallInstance.brandName;
  String get imageUrl => widget.arsenalBallInstance.effectiveImageUrl;
  BowlingBall? get bowlingBall => widget.arsenalBallInstance.bowlingBall;
  int get ballId => widget.arsenalBallInstance.ballId;

  @override
  Widget build(BuildContext context) {
    // 主要色用於外框
    final primaryColor = widget.theme.brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;

    // 品牌色仍用於品牌標籤
    final brandPalette = getBrandTonalPalette(brandName, widget.theme);
    final brandColor = brandPalette[400]!;

    // 檢查是否在主球袋 (All My Arsenal)
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final isInMainBag = arsenalState.selectedBagNumber == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Stack(
        children: [
          // 左側背景按鈕 (右滑時顯示 Move/Add to bag)
          if (!widget.isSelectionMode && _slideDirection == 'right')
            Positioned.fill(
              child: Row(
                children: [
                  Container(
                    width: _actionButtonWidth,
                    decoration: BoxDecoration(
                      color: isInMainBag ? const Color(0xFF4CAF50) : const Color(0xFF00BCD4), // 主球袋用綠色，子球袋用藍色
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          // 直接進入移動/添加操作
                          _handleMoveOrAddToBag(context);
                          _closeSlide();
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 1.5708, // 90度 (π/2 弧度)
                              child: Icon(
                                isInMainBag ? Icons.add : Iconsax.convert,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isInMainBag ? 'Add from\nLibrary' : 'Move',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 右側背景按鈕 (左滑時顯示 Remove)
          if (!widget.isSelectionMode && _slideDirection == 'left')
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: _actionButtonWidth,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          // 直接進入移除操作
                          _handleRemove(context);
                          _closeSlide();
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.trash,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Remove',
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
              // 主袋：保留左滑 Remove，移除右滑 Add
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
                    // 右滑 - 主袋禁用、子袋仍可 Move/Add；這裡關掉主袋右滑
                    if (!isInMainBag) {
                      _openSlideRight();
                    }
                  } else if (deltaX < -30) {
                    // 左滑 - 顯示 Remove
                    _openSlideLeft();
                  }
                }
              },
              onTap: (!_isSlideOpen)
                  ? (widget.isSelectionMode ? widget.onTap : () => _showArsenalActionDialog(context, widget.arsenalBallInstance, ref))
                  : _closeSlide,
              child: _buildCard(context, brandColor),
            ),
          ),
        ],
      ),
    );
  }

  // 處理移動或添加到球袋的操作
  void _handleMoveOrAddToBag(BuildContext context) {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final isInMainBag = arsenalState.selectedBagNumber == 1;

    if (isInMainBag) {
      // 在主球袋時，使用既有的 "Add from Library" 功能
      ArsenalActions.showAddToCurrentBag(
        context: context,
        ref: ref,
      );
    } else {
      // 在特定球袋時，顯示移動選項
      _handleMoveAction(context);
    }
  }

  // 處理移除操作
  void _handleRemove(BuildContext context) {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final isInMainBag = arsenalState.selectedBagNumber == 1;

    if (isInMainBag) {
      // 在主球袋時，詢問是要從所有球袋移除還是從 Arsenal 完全刪除
      _handleRemoveAction(context);
    } else {
      // 在特定球袋時，詢問是要從此球袋移除還是從所有球袋移除
      _handleRemoveAction(context);
    }
  }


  // 處理移動操作
  void _handleMoveAction(BuildContext context) async {
    final arsenalState = ref.read(newArsenalControllerProvider);
    final isInMainBag = arsenalState.selectedBagNumber == 1;

    // 設置當前球為選中狀態進行移動操作
    if (isInMainBag) {
      // 在主球袋：添加到其他球袋
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(widget.arsenalBallInstance.id);

      // 使用統一的袋子顏色來源
      final bagColors = BagColorService.getAllBagColors();

      await ArsenalActions.showMoveSelected(
        context: context,
        ref: ref,
        bagColors: bagColors,
      );

      // 清除選中狀態
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(widget.arsenalBallInstance.id);
    } else {
      // 在子球袋：移動到其他球袋
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(widget.arsenalBallInstance.id);

      // 使用統一的袋子顏色來源
      final bagColors = BagColorService.getAllBagColors();

      await ArsenalActions.showMoveSelected(
        context: context,
        ref: ref,
        bagColors: bagColors,
      );

      // 清除選中狀態
      ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(widget.arsenalBallInstance.id);
    }
  }

  // 處理移除操作
  Future<void> _handleRemoveAction(BuildContext context) async {
    // 設置當前球為選中狀態進行移除操作
    ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(widget.arsenalBallInstance.id);

    await ArsenalActions.confirmRemoveSelected(
      context: context,
      ref: ref,
    );

    // 清除選中狀態
    ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(widget.arsenalBallInstance.id);
  }


  Widget _buildCard(BuildContext context, Color brandColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1E1E1E), // 比主背景稍亮的背景色
        boxShadow: widget.isSelected
            ? [
                // 選中時的陰影效果
                BoxShadow(
                  color: widget.theme.primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                // 正常狀態的細微陰影
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Stack(
        children: [
          InkWell(
            onLongPress: widget.isSelectionMode ? null : widget.onLongPress,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Left: 縮小的圓形球具圖片
                  SizedBox(
                    width: 80, // 縮小球的照片
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: ClipOval(
                        child: _buildBallImage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20), // 增加間距
                  // Right: 重新設計的文字層級
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 球名 - 最重要，最亮白色，Semibold
                        Text(
                          ballName,
                          style: const TextStyle(
                            fontSize: 18, // 保持主要標題大小
                            fontWeight: FontWeight.w600, // Semibold
                            color: Color(0xFFFFFFFF), // 最亮的白色
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // 品牌名稱 - 放在球名下方
                        Text(
                          brandName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: brandColor,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // 球屬性 - 次要描述，淺灰色，小一點
                        Text(
                          _buildCoreAndCoverText(),
                          style: const TextStyle(
                            fontSize: 12, // 比球名小6pt
                            fontWeight: FontWeight.w400, // Normal weight
                            color: Color(0xFF9CA3AF), // 淺灰色，降低視覺優先級
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),

                        // 底部信息 - Layout，未設定時顯示紅色
                        Text(
                          'Layout: ${widget.arsenalBallInstance.layoutDisplayString}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: widget.arsenalBallInstance.layoutDisplayString == 'Layout Not Set'
                                ? const Color(0xFFEF4444) // 紅色提醒
                                : const Color(0xFFFFFFFF), // 已設定時用亮白色
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Selection mode indicator（移除任何 icon 顯示的依賴，保持勾勾即可）
          if (widget.isSelectionMode && widget.isSelected) ...[
            // overlay layer
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            // centered check icon
            const Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: BrandColors.accentColorDark,
                    size: 42,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBallImage() {
    if (imageUrl.isNotEmpty && imageUrl != 'https://via.placeholder.com/150') {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: 80, // 更新為縮小後的尺寸
        height: 80,
        placeholder: (context, url) => Container(
          width: 80,
          height: 80,
          color: Colors.grey.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 80,
          height: 80,
          color: Colors.grey.withOpacity(0.3),
          child: const Icon(
            Icons.sports_baseball,
            color: Colors.white54,
            size: 30, // 縮小圖標大小
          ),
        ),
      );
    } else {
      return Container(
        width: 80,
        height: 80,
        color: Colors.grey.withOpacity(0.3),
        child: const Icon(
          Icons.sports_baseball,
          color: Colors.white54,
          size: 30,
        ),
      );
    }
  }

  String _buildCoreAndCoverText() {
    final parts = <String>[];
    
    
    // 使用與 UnifiedBallCard 完全相同的邏輯
    // Core 部分 - 注意：UnifiedBallCard 使用 bowlingBall?.core (擴展屬性)
    String? coreType = bowlingBall?.core; // 使用擴展屬性，不是 coreType 欄位
    if (coreType != null) {
      parts.add(getCoreCategory(coreType));
    }
    
    // Cover 部分 - 按照 UnifiedBallCard 的順序  
    String? coverstockType = bowlingBall?.coverstockType;
    if (coverstockType != null) {
      parts.add(coverstockType);
    } else if (bowlingBall?.coverstock != null) {
      parts.add(bowlingBall!.coverstock!);
    } else {
      parts.add('Unknown');
    }
    
    
    if (parts.isEmpty) {
      return 'No core/cover info';
    }
    
    return parts.join(' | ');
  }

  /// 顯示 Arsenal 操作選擇對話框
  void _showArsenalActionDialog(BuildContext context, UserArsenalInstance arsenalInstance, WidgetRef ref) {
    ArsenalDialog.show<void>(
      context: context,
      title: arsenalInstance.displayName,
      barrierDismissible: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppStandardButton.primaryOutlined(
            text: 'Edit My Layout',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            width: double.infinity,
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await showEditLayoutDialog(context, arsenalInstance);
              if (result != null && result['success'] == true) {
                TopNotification.showSuccess(
                  context,
                  'Layout updated successfully: ${result['layoutType']}',
                );
              }
            },
          ),
          const SizedBox(height: 12),
          AppStandardButton.primaryOutlined(
            text: 'View Details',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              showArsenalBallDetails(context, arsenalInstance);
            },
          ),
        ],
      ),
    );
  }

}