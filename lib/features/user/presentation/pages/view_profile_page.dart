import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/shared/models/user_profile.dart';
import 'package:iconsax/iconsax.dart';

class ViewProfilePage extends ConsumerWidget {
  const ViewProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.edit),
              onPressed: () => context.go('/edit_profile'),
              tooltip: 'Edit Profile',
            ),
          ],
        ),
        body: Container(
          color: Colors.black.withOpacity(0.4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 使用者頭像和基本資訊
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 60, color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userProfile?.nickname ?? 'No Name Set',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (userProfile?.location.isNotEmpty == true)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userProfile!.location,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 打球資訊區塊
                _buildInfoSection(
                  theme,
                  'Bowling Information',
                  [
                    if (userProfile?.hand.isNotEmpty == true)
                      _InfoItem(label: 'Dominant Hand', value: userProfile!.hand),
                    if (userProfile?.bowlingStyle.isNotEmpty == true)
                      _InfoItem(label: 'Bowling Style', value: userProfile!.bowlingStyle),
                    if (userProfile?.pap.isNotEmpty == true)
                      _InfoItem(label: 'PAP', value: userProfile!.pap),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // 常用球館區塊
                if (userProfile?.favoriteCenters.isNotEmpty == true)
                  _buildListSection(
                    theme,
                    'Favorite Bowling Centers',
                    userProfile!.favoriteCenters,
                  ),
                
                const SizedBox(height: 24),
                
                // 常用油圖區塊
                if (userProfile?.favoriteOilPatterns.isNotEmpty == true)
                  _buildListSection(
                    theme,
                    'Favorite Oil Patterns',
                    userProfile!.favoriteOilPatterns,
                  ),
                
                const SizedBox(height: 32),
                
                // 編輯按鈕
                Center(
                  child: SizedBox(
                    width: 200,
                    child: AppStandardButton(
                      onPressed: () => context.go('/edit_profile'),
                      text: 'Edit Profile',
                      isPrimary: true,
                      height: 50,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, String title, List<_InfoItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  '${item.label}: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildListSection(ThemeData theme, String title, List<dynamic> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  '• ',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Expanded(
                  child: Text(
                    _formatItemText(item),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _formatItemText(dynamic item) {
    if (item is String) {
      return item;
    } else if (item is OilPattern) {
      if (item.lengthInFeet.isNotEmpty) {
        return '${item.name} (${item.lengthInFeet} Ft)';
      } else {
        return item.name;
      }
    }
    return item.toString();
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem({required this.label, required this.value});
} 