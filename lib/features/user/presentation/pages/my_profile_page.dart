import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/features/user/presentation/widgets/profile_info_card.dart';

/// My Profile Page
/// 用戶個人資料頁面，包含頂部和底部導航
class MyProfilePage extends ConsumerStatefulWidget {
  const MyProfilePage({super.key});

  @override
  ConsumerState<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends ConsumerState<MyProfilePage> {
  
  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0; // Home 或其他頁面（包含 my-profile）
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateCurrentIndex(location);
    final theme = Theme.of(context);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'My Profile',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: theme.colorScheme.onSurface,
            onPressed: () => context.go('/'),
            tooltip: 'Back to Home',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: theme.colorScheme.onSurface,
              onPressed: () => context.go('/edit_profile'),
              tooltip: 'Edit Profile',
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // 頂部用戶信息卡片
              ProfileInfoCard(),
              // TODO: 更多個人資料內容
            ],
          ),
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/library');
                break;
              case 2:
                context.go('/my-arsenal');
                break;
              case 3:
                context.go('/training');
                break;
              case 4:
                context.go('/tournament');
                break;
            }
          },
        ),
      ),
    );
  }
}