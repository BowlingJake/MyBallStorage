// 檔案路徑： user_info_section.dart

import 'package:bowlingarsenal_app/shared/widgets/common/cards/standard_app_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart'; // 1. 導入 Dialog
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // 2. 導入 GoRouter
import 'package:iconsax/iconsax.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';

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
    final bowlingStyle = userProfile.bowlingStyle;
    final hand = userProfile.hand;
    
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final userProfile = ref.watch(userProfileProvider);

    // 從 userProfile 取得資料，如果沒有則使用預設值
    final userName = userProfile?.nickname.isNotEmpty == true 
        ? userProfile!.nickname 
        : 'Tap to set profile';
    final location = userProfile?.location.isNotEmpty == true 
        ? userProfile!.location 
        : 'Set your location';

    return InkWell(
      onTap: () => _showProfileActions(context),
      borderRadius: BorderRadius.circular(16),
      child: StandardAppCard(
        constraints: constraints,
        enableGlow: false,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Iconsax.location, size: 16, color: Colors.white.withOpacity(0.7)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.7)
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // 第三行顯示打球資訊（移除外層括號）
                  if (userProfile != null && (userProfile.hand.isNotEmpty || userProfile.bowlingStyle.isNotEmpty))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _formatUserInfo(userProfile),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            _buildUserAvatar(theme, accentColor),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme, Color accentColor) {
    // ... (此處程式碼保持不變)
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accentColor.withOpacity(0.6), Colors.white.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
      child: userPhotoUrl != null
          ? ClipOval(child: Image.network(userPhotoUrl!, fit: BoxFit.cover, width: 52, height: 52))
          : Center(child: Icon(Iconsax.user, color: Colors.white.withOpacity(0.9), size: 28)),
    );
  }
}