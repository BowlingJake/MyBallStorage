import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/favorites/presentation/widgets/favorite_button_widget.dart';
import 'package:core_theme/core_theme.dart';
import 'package:bowlingarsenal_app/utils/color_utils.dart';
import 'package:bowlingarsenal_app/utils/app_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 統一的球卡組件，可同時支援 BowlingBall 和 UserArsenalInstance
class UnifiedBallCard extends ConsumerWidget {
  const UnifiedBallCard({
    this.bowlingBall,
    this.arsenalBallInstance,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.showFavoriteButton = true,
    this.extraInfo,
    super.key,
  }) : assert(bowlingBall != null || arsenalBallInstance != null, 'Either bowlingBall or arsenalBallInstance must be provided');
  
  final BowlingBall? bowlingBall;
  final UserArsenalInstance? arsenalBallInstance;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  final bool showFavoriteButton;
  final Widget? extraInfo; // 額外資訊，如 arsenal 的 games used 等

  // 統一的數據獲取方法
  String get ballName => bowlingBall?.name ?? arsenalBallInstance?.displayName ?? '';
  String get brandName => bowlingBall?.brand ?? arsenalBallInstance?.brandName ?? '';
  String get imageUrl => bowlingBall?.imageUrl ?? arsenalBallInstance?.effectiveImageUrl ?? '';
  double? get rg => bowlingBall?.rg ?? arsenalBallInstance?.bowlingBall?.rg;
  double? get diff => bowlingBall?.diff ?? arsenalBallInstance?.bowlingBall?.diff;
  double? get mbDiff => bowlingBall?.mbDiff ?? arsenalBallInstance?.bowlingBall?.mbDiff;
  String? get coreType => bowlingBall?.core ?? arsenalBallInstance?.bowlingBall?.coreType;
  String? get coverstockType => bowlingBall?.coverstockType ?? arsenalBallInstance?.bowlingBall?.coverstockType;
  String? get coverstock => bowlingBall?.coverstock ?? arsenalBallInstance?.bowlingBall?.coverstock;
  String? get region => bowlingBall?.region;
  int get ballId {
    if (bowlingBall != null) {
      return bowlingBall!.id;
    }
    if (arsenalBallInstance != null) {
      return arsenalBallInstance!.ballId;
    }
    return 0;
  }

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
              onTap: isSelectionMode ? onTap : null,
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
                          // Arsenal instance number
                          if (arsenalBallInstance != null)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: brandColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    'A', // Arsenal indicator
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
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
                            ballName,
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
                            _buildCoreAndCoverText(),
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
                                  brandName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: brandColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Region Tag (if available)
                              if (region != null && region!.isNotEmpty)
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
                                    region!,
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
                          // Extra info (like games used for arsenal)
                          if (extraInfo != null) ...[
                            extraInfo!,
                            const SizedBox(height: 8),
                          ],
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
                                        rg?.toStringAsFixed(3) ?? 'N/A',
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
                                        diff?.toStringAsFixed(3) ?? 'N/A',
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
                                        (mbDiff == null || mbDiff == 0) 
                                            ? 'N/A' 
                                            : mbDiff!.toStringAsFixed(3),
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
          // Selection mode indicator or favorite button
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
                    : const SizedBox.shrink())
                : (showFavoriteButton && bowlingBall != null 
                    ? CompactFavoriteButton(ball: bowlingBall!)
                    : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }

  Widget _buildBallImage() {
    return imageUrl.isNotEmpty && imageUrl != 'https://via.placeholder.com/150'
        ? Image.network(
            imageUrl,
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
          );
  }

  String _buildCoreAndCoverText() {
    final parts = <String>[];
    
    if (coreType != null) {
      parts.add(getCoreCategory(coreType!));
    } else if (bowlingBall?.core != null) {
      parts.add(getCoreCategory(bowlingBall!.core!));
    }
    
    if (coverstockType != null) {
      parts.add(coverstockType!);
    } else if (coverstock != null) {
      parts.add(coverstock!);
    } else {
      parts.add('Unknown');
    }
    
    return parts.join(' | ');
  }
}