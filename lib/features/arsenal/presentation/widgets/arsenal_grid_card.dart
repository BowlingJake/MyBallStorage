import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/edit_layout_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:core_theme/core_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

/// Grid 專用的 Arsenal 球卡組件
class ArsenalGridCard extends ConsumerWidget {
  const ArsenalGridCard({
    required this.instance,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  final UserArsenalInstance instance;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // 主要色用於外框
    final primaryColor = theme.brightness == Brightness.dark
        ? BrandColors.accentColorDark
        : BrandColors.accentColorLight;
    
    // 品牌色仍用於品牌標籤
    final brandPalette = getBrandTonalPalette(instance.brandName, theme);
    final brandColor = brandPalette[400]!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF1E1E1E), // 比主背景稍亮的背景色
        // 移除所有邊框
        boxShadow: isSelected
            ? [
                // 選中時的陰影效果
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
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
          // Content with tap handling (fill the card to keep centered layout)
          Positioned.fill(
            child: InkWell(
            onTap: isSelectionMode 
                ? onTap 
                : () => _showArsenalActionDialog(context, instance, ref),
            borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 球的圖片 (圓形) - 縮小
                    Container(
                      width: 80, // 縮小球的照片
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: ClipOval(
                        child: _buildBallImage(80),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 球名 - 最重要，最亮白色，Semibold
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        instance.displayName,
                        style: const TextStyle(
                          fontSize: 16, // 主要標題大小
                          fontWeight: FontWeight.w600, // Semibold
                          color: Color(0xFFFFFFFF), // 最亮的白色
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1, // 限制為單行
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 品牌名稱 - 放在球名下方
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        instance.brandName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: brandColor, // 保持品牌色彩
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 球屬性 - 次要描述，淺灰色，小一點
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        _buildCoreAndCoverText(),
                        style: const TextStyle(
                          fontSize: 12, // 比球名小4pt
                          fontWeight: FontWeight.w400, // Normal weight
                          color: Color(0xFF9CA3AF), // 淺灰色，降低視覺優先級
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1, // 限制為單行
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Layout - 最小優先級，未設定時顯示紅色
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        instance.layoutDisplayString,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: instance.layoutDisplayString == 'Layout Not Set'
                              ? const Color(0xFFEF4444) // 紅色提醒
                              : const Color(0xFFFFFFFF), // 已設定時用亮白色
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1, // 限制為單行
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSelectionMode && isSelected) ...[
            // Semi-transparent white overlay
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0x40FFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ),
            // Centered check icon with app accent color
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


  /// 建構球圖片
  Widget _buildBallImage(double size) {
    final imageUrl = instance.effectiveImageUrl;
    
    if (imageUrl.isNotEmpty && imageUrl != 'https://via.placeholder.com/150') {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: Colors.grey.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          color: Colors.grey.withOpacity(0.3),
          child: const Icon(
            Icons.sports_baseball,
            color: Colors.white54,
            size: 35,
          ),
        ),
      );
    } else {
      return Container(
        width: size,
        height: size,
        color: Colors.grey.withOpacity(0.3),
        child: const Icon(
          Icons.sports_baseball,
          color: Colors.white54,
          size: 35,
        ),
      );
    }
  }

  /// 建構 Core 和 Cover 文字
  String _buildCoreAndCoverText() {
    final parts = <String>[];
    final bowlingBall = instance.bowlingBall;
    
    // Core 部分 - 使用 coreType 欄位
    String? coreType = bowlingBall?.coreType;
    if (coreType != null) {
      parts.add(getCoreCategory(coreType));
    }
    
    // Cover 部分  
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