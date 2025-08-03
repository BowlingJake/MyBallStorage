import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_ball_detail_dialog.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/edit_layout_dialog.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:core_theme/core_theme.dart';

/// Grid 專用的 Arsenal 球卡組件
class ArsenalGridCard extends ConsumerWidget {
  const ArsenalGridCard({
    required this.instance,
    super.key,
  });

  final UserArsenalInstance instance;

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
          color: brandColor.withOpacity(0.6),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () => _showArsenalActionDialog(context, instance),
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
              
              // 球名
              Text(
                instance.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              
              // 品牌
              Text(
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
              const SizedBox(height: 4),
              
              // Core & Cover
              Text(
                _buildCoreAndCoverText(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              
              // Layout
              Text(
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
              const SizedBox(height: 3),
              
              // Games Used
              Text(
                'Games Used: ${instance.gamesUsed}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 建構球圖片
  Widget _buildBallImage(double size) {
    final imageUrl = instance.effectiveImageUrl;
    
    if (imageUrl.isNotEmpty && imageUrl != 'https://via.placeholder.com/150') {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size,
            color: Colors.grey.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white54,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
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
        },
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
  void _showArsenalActionDialog(BuildContext context, UserArsenalInstance arsenalInstance) {
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
                      
                      // 兩個平行按鈕
                      Row(
                        children: [
                          // 左側按鈕：Edit My Layout
                          Expanded(
                            child: AppStandardButton(
                              text: 'Edit My Layout',
                              height: 40,
                              fontSize: 14,
                              customColor: Colors.white,
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
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // 右側按鈕：View Details
                          Expanded(
                            child: AppStandardButton(
                              text: 'View Details',
                              height: 40,
                              fontSize: 14,
                              customColor: Colors.white,
                              isPrimary: true,
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                showArsenalBallDetails(context, arsenalInstance);
                              },
                            ),
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