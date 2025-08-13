import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/edit_layout_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/shared/widgets/dialogs/app_base_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

/// Arsenal 專用的球卡組件，基於 UnifiedBallCard 但針對 My Arsenal 需求定制
class ArsenalSpecificBallCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final brandPalette = getBrandTonalPalette(brandName, theme);
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
              onTap: isSelectionMode 
                  ? onTap 
                  : () => _showArsenalActionDialog(context, arsenalBallInstance, ref),
              onLongPress: isSelectionMode ? null : onTap,
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
                              child: _buildBallImage(),
                            ),
                          ),
                           // 移除圖上方 Note；恢復原設計
                          // 移除無意義的 Arsenal indicator
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
                            ballName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Core & Cover Types in one line (修正顯示)
                          Text(
                            _buildCoreAndCoverText(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // 只顯示 Brand Tag，移除 Region
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
                                  brandName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brandColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // 移除 Region Tag
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Note（恢復資訊區顯示）
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Note: ' + ((arsenalBallInstance.notes ?? '').trim().isNotEmpty ? (arsenalBallInstance.notes ?? '').trim() : 'No Note'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Layout 行（單行、省略）
                          Text(
                            'Layout: ' + arsenalBallInstance.layoutDisplayString,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[300],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // 移除 RG, Diff, MB 數據塊顯示
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Selection mode indicator (移除 favorite button，Arsenal 不需要)
          if (isSelectionMode && isSelected) ...[
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
        width: 120,
        height: 120,
        placeholder: (context, url) => Container(
          width: 120,
          height: 120,
          color: Colors.grey.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white54,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: 120,
          height: 120,
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
        width: 120,
        height: 120,
        color: Colors.grey.withOpacity(0.3),
        child: const Icon(
          Icons.sports_baseball,
          color: Colors.white54,
          size: 35,
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
          AppStandardButton(
            text: 'Edit My Layout',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            customColor: Colors.white,
            width: double.infinity,
            onPressed: () async {
              Navigator.of(context).pop();
              final result = await showEditLayoutDialog(context, arsenalInstance);
              if (result != null && result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Layout updated successfully: ${result['layoutType']}'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 12),
          AppStandardButton(
            text: 'View Details',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            customColor: Colors.white,
            width: double.infinity,
            onPressed: () {
              Navigator.of(context).pop();
              showArsenalBallDetails(context, arsenalInstance);
            },
          ),
          const SizedBox(height: 12),
          AppStandardButton(
            text: 'Add Note',
            height: DialogDefaults.buttonHeight,
            fontSize: DialogDefaults.buttonFontSize,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            customColor: Colors.white,
            width: double.infinity,
            onPressed: () async {
              Navigator.of(context).pop();
              await _showEditNoteDialog(context, arsenalInstance, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showEditNoteDialog(BuildContext context, UserArsenalInstance instance, WidgetRef ref) async {
    final controller = TextEditingController(text: instance.notes ?? '');
    await ArsenalDialog.show<void>(
      context: context,
      title: 'Add Note',
      barrierDismissible: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            maxLength: 20,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              counterStyle: const TextStyle(color: Colors.grey),
              hintText: 'Enter note (max 20 chars)',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.black.withOpacity(0.6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(color: BrandColors.accentColorDark, width: 2),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppStandardButton(
                  text: 'Cancel',
                  height: DialogDefaults.buttonHeight,
                  outlineColor: Colors.white.withOpacity(0.6),
                  foregroundColor: Colors.white.withOpacity(0.9),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppStandardButton(
                  text: 'Save',
                  height: DialogDefaults.buttonHeight,
                  isPrimary: true,
                  customColor: BrandColors.accentColorDark,
                  whiteForeground: true,
                  onPressed: () async {
                    final text = controller.text.trim();
                    Navigator.of(context).pop();
                    final auth = ref.read(authControllerProvider);
                    if (auth.hasValue && auth.value != null) {
                      final userId = auth.value!.id;
                      await ref.read(newArsenalControllerProvider.notifier).updateNotes(instance.id, text, userId);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}