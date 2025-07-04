import 'package:bowlingarsenal_app/widgets/standard_app_card.dart'; // 導入新的標準卡片
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    // 使用新的標準卡片作為基底
    return StandardAppCard(
      constraints: constraints,
      enableGlow: false, // 關閉光暈效果，讓卡片完全透明
      // 移除卡片預設的垂直邊距，因為外部容器會處理
      margin: EdgeInsets.zero,
      // 增加內部 padding 以提供足夠的呼吸空間
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左側資訊
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Iconsax.location,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 右側頭像
          _buildUserAvatar(theme, accentColor),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme, Color accentColor) {
    // 保持頭像原有的精緻設計，它與新卡片風格是協調的
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: accentColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child:
          userPhotoUrl != null
              ? ClipOval(
                child: Image.network(
                  userPhotoUrl!,
                  fit: BoxFit.cover,
                  width: 52,
                  height: 52,
                ),
              )
              : Center(
                child: Icon(
                  Iconsax.user,
                  color: Colors.white.withOpacity(0.9),
                  size: 28,
                ),
              ),
    );
  }
}
