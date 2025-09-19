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
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';

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
            // Favorites entry
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              onPressed: () => context.go('/favorites'),
              tooltip: 'My Favorites',
            ),
            // Selection mode toggle button
            Consumer(
              builder: (context, ref, child) {
                final uiState = ref.watch(ballLibraryUIServiceProvider);
                final isInSelectionMode = uiState.selectionMode != BallLibrarySelectionMode.none;

                return IconButton(
                  icon: Icon(
                    isInSelectionMode ? Icons.close : Icons.checklist,
                    color: isInSelectionMode ? Colors.redAccent : Colors.white,
                  ),
                  onPressed: () {
                    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);
                    if (isInSelectionMode) {
                      uiService.exitSelectionMode();
                    } else {
                      uiService.toggleComparisonMode(); // 進入選擇模式
                    }
                  },
                  tooltip: isInSelectionMode ? 'Cancel Selection' : 'Select Balls',
                );
              },
            ),
            // Filter/Sort entry
            Consumer(
              builder: (context, ref, child) {
                final stateAsync = ref.watch(ballLibraryControllerProvider);
                final uiSvc = ref.read(ballLibraryUIServiceProvider.notifier);
                return IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white),
                  onPressed: () {
                    final state = stateAsync.value;
                    if (state == null) return;
                    uiSvc.showFilterSortMenu(context: context, libraryState: state);
                  },
                  tooltip: 'Filter & Sort',
                );
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await ref.read(ballLibraryControllerProvider.notifier).forceRefresh();
          },
          child: Column(
            children: const [
              BallLibraryControls(),
              Expanded(child: BallLibraryContent()),
            ],
          ),
        ),
        // Bottom Action Bar for Selection Mode
        bottomNavigationBar: Consumer(
          builder: (context, ref, child) {
            final uiState = ref.watch(ballLibraryUIServiceProvider);
            final isInSelectionMode = uiState.selectionMode != BallLibrarySelectionMode.none;

            if (isInSelectionMode) {
              return _buildSelectionBottomBar(context, ref, uiState);
            } else {
              return ModernBottomNavigation(
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
              );
            }
          },
        ),
      ),
    );
  }

  /// 建立選擇模式的底部操作欄
  Widget _buildSelectionBottomBar(BuildContext context, WidgetRef ref, BallLibraryUIState uiState) {
    final selectedCount = uiState.selectedBallIds.length;
    final canCompare = selectedCount == 2;
    final canAddToArsenal = selectedCount > 0;
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 選擇計數顯示
            Text(
              'Selected $selectedCount ball${selectedCount != 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            // 操作按鈕
            Row(
              children: [
                // 比較按鈕 (次要功能)
                Expanded(
                  child: AppStandardButton.secondary(
                    text: 'Compare',
                    icon: Icons.compare_arrows,
                    height: 40,
                    enabled: canCompare,
                    onPressed: () {
                      if (!canCompare) return;
                      uiService.showComparison(context: context);
                      uiService.exitSelectionMode();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // 加入球包按鈕 (主要功能)
                Expanded(
                  child: AppStandardButton(
                    text: 'Add to Arsenal',
                    icon: Icons.add_circle_outline,
                    height: 40,
                    enabled: canAddToArsenal,
                    onPressed: () {
                      if (!canAddToArsenal) return;
                      uiService.showAddToArsenalConfirmation(context: context);
                      uiService.exitSelectionMode();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}