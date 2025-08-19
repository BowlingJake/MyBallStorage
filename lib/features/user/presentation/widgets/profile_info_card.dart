import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/features/user/data/models/user_profile.dart';
import 'package:bowlingarsenal_app/shared/models/country_model.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:iconsax/iconsax.dart';

/// Profile Info Card Widget
/// 頂部用戶信息卡片組件，遵循3層架構原則
class ProfileInfoCard extends ConsumerStatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  ConsumerState<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends ConsumerState<ProfileInfoCard> {
  @override
  void initState() {
    super.initState();
    // 在組件初始化時載入用戶資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserProfile();
    });
  }

  void _loadUserProfile() {
    final authState = ref.read(authControllerProvider);
    if (authState.hasValue && authState.value != null) {
      final userId = authState.value!.id;
      ref.read(userProfileControllerProvider.notifier).loadUserProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProfileState = ref.watch(userProfileControllerProvider);
    
    // 主要色彩：使用主題的primary色彩
    final primaryColor = theme.colorScheme.primary;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: userProfileState.isLoading
            ? _buildLoadingState()
            : userProfileState.profile != null
                ? _buildProfileContent(userProfileState.profile!)
                : _buildEmptyState(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const SizedBox(
      height: 120,
      child: Center(
        child: Text(
          'Please complete your profile',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile) {
    return Row(
      children: [
        // 左側：用戶頭像
        _buildUserAvatar(profile),
        const SizedBox(width: 20),
        // 右側：用戶信息（四層）
        Expanded(
          child: _buildUserInfo(profile),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(UserProfile profile) {
    // 檢查是否有有效的頭像URL
    final hasValidAvatar = profile.avatarUrl != null && 
        profile.avatarUrl!.isNotEmpty && 
        !profile.avatarUrl!.contains('localhost') && 
        profile.avatarUrl!.startsWith('http');

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: hasValidAvatar
            ? Image.network(
                profile.avatarUrl!,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildAvatarLoading();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: const Icon(
        Iconsax.user,
        color: Colors.black,
        size: 36,
      ),
    );
  }

  Widget _buildAvatarLoading() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 第一層：用戶姓名（大字體）
        _buildUserName(profile),
        const SizedBox(height: 8),
        
        // 第二層：所在位置
        _buildLocation(profile),
        const SizedBox(height: 6),
        
        // 第三層：慣用手及風格
        _buildHandAndStyle(profile),
        const SizedBox(height: 6),
        
        // 第四層：球手PAP
        _buildPAP(profile),
      ],
    );
  }

  Widget _buildUserName(UserProfile profile) {
    final displayName = profile.nickname?.isNotEmpty == true 
        ? profile.nickname! 
        : profile.username ?? 'Bowler';
        
    return Text(
      displayName,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation(UserProfile profile) {
    if (profile.country == null && profile.city == null) {
      return const Text(
        'Location not set',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      );
    }

    // 取得國旗
    Widget? flagWidget;
    if (profile.country != null && profile.country!.isNotEmpty) {
      final country = Countries.findByCode(profile.country!) ?? 
                     Countries.all.where((c) => 
                       c.name.toLowerCase() == profile.country!.toLowerCase()).firstOrNull;
      if (country != null) {
        flagWidget = Text(
          country.flag,
          style: const TextStyle(fontSize: 16),
        );
      }
    }

    // 組合位置文字
    String locationText = '';
    if (profile.city?.isNotEmpty == true) {
      locationText += profile.city!;
    }
    if (profile.country?.isNotEmpty == true) {
      if (locationText.isNotEmpty) locationText += ', ';
      locationText += profile.country!;
    }

    return Row(
      children: [
        if (flagWidget != null) ...[
          flagWidget,
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            locationText.isNotEmpty ? locationText : 'Location not set',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHandAndStyle(UserProfile profile) {
    final handText = profile.dominateHand != null 
        ? (profile.dominateHand == 'Left Hand' ? 'Left' : 'Right')
        : null;
    final styleText = profile.style;

    if (handText == null && styleText == null) {
      return const Text(
        'Hand & Style not set',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      );
    }

    String combinedText = '';
    if (handText != null) {
      combinedText += '$handText Hand';
    }
    if (styleText != null && styleText.isNotEmpty) {
      if (combinedText.isNotEmpty) combinedText += ' • ';
      combinedText += styleText;
    }

    return Text(
      combinedText,
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPAP(UserProfile profile) {
    // 檢查是否有PAP數據
    final hasMainPAP = profile.papInteger != null || 
                      profile.papFraction?.isNotEmpty == true;
    final hasDriftPAP = profile.papDriftInteger != null || 
                       profile.papDriftFraction?.isNotEmpty == true;

    if (!hasMainPAP && !hasDriftPAP) {
      return const Text(
        'PAP not measured',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
      );
    }

    String papText = '';
    
    // 主要PAP
    if (hasMainPAP) {
      if (profile.papInteger != null) {
        papText += '${profile.papInteger}"';
      }
      if (profile.papFraction?.isNotEmpty == true) {
        papText += ' ${profile.papFraction!}';
      }
      
      // PAP方向
      if (profile.papDirection != null) {
        if (profile.papDirection == 1) {
          papText += ' ↑';
        } else if (profile.papDirection == -1) {
          papText += ' ↓';
        }
      }
    }

    // Drift PAP (分數格式)
    if (hasDriftPAP) {
      if (papText.isNotEmpty) {
        papText += ' ';
      }
      if (profile.papDriftInteger != null || profile.papDriftFraction?.isNotEmpty == true) {
        if (profile.papDriftInteger != null && profile.papDriftInteger! > 0) {
          papText += '${profile.papDriftInteger!}';
        }
        if (profile.papDriftFraction?.isNotEmpty == true) {
          if (profile.papDriftInteger != null && profile.papDriftInteger! > 0) {
            papText += ' ';
          }
          papText += '${profile.papDriftFraction!}';
        }
      }
    }

    return Text(
      papText.isNotEmpty ? papText : 'PAP not measured',
      style: const TextStyle(
        color: Colors.black54,
        fontSize: 14,
        fontFamily: 'monospace', // 使用等寬字體使數字對齊
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}