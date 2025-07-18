// 檔案路徑： user_info_section.dart

import 'package:bowlingarsenal_app/shared/widgets/common/cards/standard_app_card.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/dialogs/confirmation_dialog.dart'; // 1. 導入 Dialog
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // 2. 導入 GoRouter
import 'package:iconsax/iconsax.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({
    super.key,
    this.userName = 'Jake Cheng',
    this.location = 'Taipei, Taiwan',
    this.userPhotoUrl,
    this.constraints,
  });
  final String userName;
  final String location;
  final String? userPhotoUrl;
  final BoxConstraints? constraints;

  // 觸發 Dialog 的方法
  void _showProfileActions(BuildContext context) {
    // 呼叫我們升級後的 Dialog 函式
    showAppConfirmationDialog(
      context: context,
      title: 'Profile',
      content: const Text('Do you want to view or edit your profile?', textAlign: TextAlign.center),
      confirmText: 'Edit',
      onConfirm: () {
        context.go('/edit_profile');
      },
      cancelText: 'View',
      onCancel: () {
        // 現在 onCancel 是有效的了！
        Navigator.of(context).pop(); // 先關閉 Dialog
        // TODO: 實作進入 "View Profile" 頁面的邏輯
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Iconsax.location, size: 16, color: Colors.white.withOpacity(0.7)),
                    const SizedBox(width: 6),
                    Text(
                      location,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ],
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