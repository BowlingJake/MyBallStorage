// 檔案路徑： user_info_section.dart

import 'package:bowlingarsenal_app/shared/widgets/common/cards/standard_app_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart'; // 1. 導入 Dialog
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // 2. 導入 GoRouter
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';

class UserInfoSection extends ConsumerWidget {
  const UserInfoSection({
    super.key,
    this.userPhotoUrl,
    this.constraints,
  });
  
  final String? userPhotoUrl;
  final BoxConstraints? constraints;

  // 觸發 Dialog 的方法
  Future<void> _showProfileActions(BuildContext context) async {
    // 呼叫我們升級後的 Dialog 函式
    final result = await showAppConfirmationDialog(
      context: context,
      title: 'Profile',
      content: const Text('Do you want to view or edit your profile?', textAlign: TextAlign.center),
      confirmText: 'Edit',
      cancelText: 'View',
    );
    
    if (result == true) {
      context.go('/edit_profile');
    } else if (result == false) {
      context.go('/view_profile');
    }
  }

  String _formatUserInfo(userProfile) {
    final bowlingStyle = userProfile.style ?? '';
    final hand = userProfile.dominateHand ?? '';
    
    if (bowlingStyle.isNotEmpty && hand.isNotEmpty) {
      // 提取手的類型 (Left 或 Right)
      final handType = hand.contains('Left') ? 'Left' : 'Right';
      return '$bowlingStyle($handType)';
    } else if (bowlingStyle.isNotEmpty) {
      return bowlingStyle;
    } else if (hand.isNotEmpty) {
      return hand;
    }
    
    return '';
  }

  String _buildLocationString(userProfile) {
    if (userProfile == null) return 'Set your location';
    
    final country = userProfile.country ?? '';
    final city = userProfile.city ?? '';
    
    if (country.isEmpty && city.isEmpty) return 'Set your location';
    if (country.isEmpty) return city;
    if (city.isEmpty) return country;
    return '$city, $country';
  }

  Widget? _getCountryFlag(userProfile) {
    if (userProfile?.country == null || userProfile.country.isEmpty) {
      return null;
    }
    
    // 嘗試找到對應的國家對象來獲取國旗
    try {
      final country = Countries.findByCode(userProfile.country) ?? 
                     Countries.all.firstWhere(
                       (country) => country.name.toLowerCase() == userProfile.country.toLowerCase(),
                       orElse: () => throw StateError('Country not found'),
                     );
      
      return Text(
        country.flag,
        style: const TextStyle(fontSize: 16),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final userProfileState = ref.watch(userProfileControllerProvider);
    final userProfile = userProfileState.profile;

    // 首次載入時讀取用戶資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final supabase = ref.read(supabaseClientProvider);
      final userId = supabase.auth.currentUser?.id;
      
      if (userId != null && userProfile == null && !userProfileState.isLoading) {
        ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
      }
    });

    // 從 userProfile 取得資料，如果沒有則使用預設值
    final userName = userProfile?.nickname?.isNotEmpty == true 
        ? userProfile!.nickname! 
        : 'Tap to set profile';
    
    // 組合位置資訊
    final location = _buildLocationString(userProfile);
    final userPhotoUrl = userProfile?.avatarUrl;
    

    return InkWell(
      onTap: () => _showProfileActions(context),
      borderRadius: BorderRadius.circular(16),
      child: StandardAppCard(
        constraints: constraints,
        enableGlow: false,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // 左側頭像
            _buildUserAvatar(theme, accentColor, userPhotoUrl),
            // 右側文字內容
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // 國旗icon
                      if (_getCountryFlag(userProfile) != null) ...[
                        _getCountryFlag(userProfile)!,
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // 第三行顯示打球資訊
                  if (userProfile != null && ((userProfile.dominateHand?.isNotEmpty == true) || (userProfile.style?.isNotEmpty == true)))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _formatUserInfo(userProfile),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme, Color accentColor, String? avatarUrl) {
    // 檢查是否有有效的頭像URL
    final hasValidAvatar = avatarUrl != null && 
        avatarUrl.isNotEmpty && 
        !avatarUrl.contains('localhost') && 
        avatarUrl.startsWith('http');
    
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.5), Colors.white.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
      ),
      child: hasValidAvatar
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  // 如果圖片載入失敗，顯示icon
                  return Center(
                    child: Icon(
                      Iconsax.user,
                      color: Colors.white.withOpacity(0.9),
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Icon(
                Iconsax.user,
                color: Colors.white.withOpacity(0.9),
                size: 50,
              ),
            ),
    );
  }
}