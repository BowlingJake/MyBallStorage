import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_ui_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_library_controls.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_library_actions.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/widgets/ball_library_content.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_app_bar.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/notifications/top_notification.dart';

/// Refactored Ball Library Page - Clean and Component-based Architecture
/// 
/// This page has been refactored from 822 lines to <100 lines by:
/// - Creating BallLibraryUIService for unified state management
/// - Splitting into focused components
/// - Removing duplicate logic and code
class BallLibraryPage extends ConsumerStatefulWidget {
  const BallLibraryPage({super.key});

  @override
  ConsumerState<BallLibraryPage> createState() => _BallLibraryPageState();
}

class _BallLibraryPageState extends ConsumerState<BallLibraryPage> {
  @override
  void initState() {
    super.initState();
    // Check if we should auto-enable add to arsenal mode from URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForAutoAddMode();
    });
  }

  void _checkForAutoAddMode() {
    final location = GoRouterState.of(context).uri.toString();
    if (location.contains('addToArsenal=true')) {
      ref.read(ballLibraryUIServiceProvider.notifier).toggleAddToArsenalMode();
    }
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _calculateCurrentIndex(location);
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        appBar: AppBarConfigs.ballLibrary(
          title: uiService.getAppBarTitle(),
          onBackPressed: () => context.go('/'),
          actions: [
            // Force refresh button (debug)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.redAccent),
              onPressed: () async {
                try {
                  TopNotification.showSuccess(context, 'Clearing cache and refreshing...');
                  await ref.read(ballLibraryControllerProvider.notifier).forceRefresh();
                  TopNotification.showSuccess(context, 'Data refreshed successfully!');
                } catch (e) {
                  TopNotification.showError(context, 'Failed to refresh: $e');
                }
              },
              tooltip: 'Force Refresh Data (Clear Cache)',
            ),
            // Favorites button
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              onPressed: () => context.go('/favorites'),
              tooltip: 'My Favorites',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search, Filter, Sort Controls
            const BallLibraryControls(),
            
            // Action Buttons (Comparison/Add to Arsenal or Selection Actions)
            const BallLibraryActions(),
            
            // Main Content (Ball List or Empty State)
            const Expanded(
              child: BallLibraryContent(),
            ),
          ],
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