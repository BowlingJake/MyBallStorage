import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/edit_layout_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
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
    final brandPalette = getBrandTonalPalette(instance.brandName, theme);
    final brandColor = brandPalette[400]!;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 球的圖片 (圓形) - 放大
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: ClipOval(
                        child: _buildBallImage(100),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // 球名（可能超出時自動縮小）
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          instance.displayName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // 品牌
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        instance.brandName,
                        style: TextStyle(
                          fontSize: 14,
                          color: brandColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Core & Cover
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        _buildCoreAndCoverText(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Note（單行，保留標頭，無資料顯示 No Note），高亮顯示（無外框）
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Note: ' + ((instance.notes ?? '').isNotEmpty ? instance.notes! : 'No Note'),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Layout
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        instance.layoutDisplayString,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 3),
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

  Future<void> _showEditNoteDialog(BuildContext context, UserArsenalInstance instance, WidgetRef ref) async {
    final controller = TextEditingController(text: instance.notes ?? '');
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (ctx) => Dialog(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Add Note',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
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
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: BrandColors.accentColorDark, width: 2),
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
                        height: 36,
                        outlineColor: Colors.white,
                        foregroundColor: Colors.white,
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppStandardButton(
                        text: 'Save',
                        height: 36,
                        isPrimary: true,
                        customColor: BrandColors.accentColorDark,
                        whiteForeground: true,
                        onPressed: () async {
                          final text = controller.text.trim();
                          Navigator.of(ctx).pop();
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
          ),
        ),
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
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[600]!,
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 球名標題
                      Text(
                        arsenalInstance.displayName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      
                      // 三個垂直置中按鈕
                      Column(
                        children: [
                          AppStandardButton(
                            text: 'Edit My Layout',
                            height: 36,
                            fontSize: 14,
                            customColor: Colors.white,
                            width: double.infinity,
                            onPressed: () async {
                              Navigator.of(dialogContext).pop();
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
                            height: 36,
                            fontSize: 14,
                            customColor: Colors.white,
                            width: double.infinity,
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              showArsenalBallDetails(context, arsenalInstance);
                            },
                          ),
                          const SizedBox(height: 12),
                          AppStandardButton(
                            text: 'Add Note',
                            height: 36,
                            fontSize: 14,
                            customColor: Colors.white,
                            width: double.infinity,
                            onPressed: () async {
                              Navigator.of(dialogContext).pop();
                              await _showEditNoteDialog(context, arsenalInstance, ref);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 右上角關閉按鈕
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}