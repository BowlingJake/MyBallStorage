import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:glass_kit/glass_kit.dart'; // 暫時註解掉有問題的插件

class UserInfoSection extends StatelessWidget {
  final String userName;
  final String location;
  final String? userPhotoUrl;

  const UserInfoSection({
    Key? key,
    this.userName = '打保齡遊戲玩國',
    this.location = '@Location',
    this.userPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        // 更大的圓角
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.85),
            theme.colorScheme.primary.withOpacity(0.7),
            theme.colorScheme.secondary.withOpacity(0.6),
            theme.colorScheme.primary.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.4, 0.7, 1.0],
        ),
        boxShadow: [
          // 主要陰影
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 3,
          ),
          // 深層陰影
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -5,
          ),
          // 內部光暈
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 背景裝飾圓圈
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          
          // 主要內容
          Padding(
            padding: const EdgeInsets.all(20), // 減少 padding
            child: Row(
              children: [
                // 左側用戶資訊
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 問候語
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Hi, ',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: userName,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: -0.2),
                      
                      const SizedBox(height: 4), // 非常緊密的間距
                      
                      // 位置資訊
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.location_on_outlined,
                              color: Colors.white.withOpacity(0.9),
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                              fontSize: 13,
                            ),
                          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 12), // 縮緊與頭像的間距
                
                // 用戶頭像
                _buildUserAvatar(theme).animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 增強的用戶頭像
  Widget _buildUserAvatar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(-2, -2),
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 2,
          ),
        ),
        child: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.white,
          backgroundImage: userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
          child: userPhotoUrl == null
              ? Icon(
                  Icons.person,
                  size: 30,
                  color: theme.colorScheme.primary,
                )
              : null,
        ),
      ),
    );
  }
} 