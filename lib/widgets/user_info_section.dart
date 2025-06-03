import 'package:flutter/material.dart';

class UserInfoSection extends StatelessWidget {
  final String userName;
  final String userTitle;
  final String location;
  final String? userPhotoUrl;

  const UserInfoSection({
    Key? key,
    this.userName = '打保齡遊戲玩國',
    this.userTitle = '使用者名牌',
    this.location = '@Location',
    this.userPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // 左側使用者資訊
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ) ?? TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ) ?? TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ) ?? TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // 右側圓形照片
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.surface,
            backgroundImage: userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
            child: userPhotoUrl == null
                ? Icon(
                    Icons.person,
                    size: 35,
                    color: Theme.of(context).colorScheme.onSurface,
                  )
                : null,
          ),
        ],
      ),
    );
  }
} 