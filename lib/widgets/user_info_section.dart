import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui'; // For ImageFilter.blur

class UserInfoSection extends StatelessWidget {
  final String userName;
  final String location;
  final String? userPhotoUrl;

  const UserInfoSection({
    Key? key,
    this.userName = 'Jake Cheng',
    this.location = 'Taipei, Taiwan',
    this.userPhotoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Container(
      height: 120,
      child: Stack(
        children: [
          // 1. 背景光暈和點綴
          Positioned(
            top: 10,
            left: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 900.ms).scale(begin: Offset(0.5, 0.5)),

          // 2. 主要的玻璃擬態卡片
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ).animate().slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOut).fadeIn(),

          // 3. 內容
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                          shadows: [
                            Shadow(blurRadius: 8, color: accentColor.withOpacity(0.5))
                          ]
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.1),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Iconsax.location, size: 16, color: Colors.white.withOpacity(0.7)),
                          const SizedBox(width: 6),
                          Text(
                            location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),

                  // 右側頭像
                  _buildUserAvatar(theme, accentColor)
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .scale(begin: Offset(0.7, 0.7), curve: Curves.elasticOut),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme, Color accentColor) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(0.6),
            Colors.white.withOpacity(0.1),
          ],
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
      child: userPhotoUrl != null
          ? ClipOval(
              child: Image.network(
                userPhotoUrl!,
                fit: BoxFit.cover,
                width: 64,
                height: 64,
              ),
            )
          : Center(
              child: Icon(
                Iconsax.user,
                color: Colors.white.withOpacity(0.9),
                size: 32,
              ),
            ),
    );
  }
} 