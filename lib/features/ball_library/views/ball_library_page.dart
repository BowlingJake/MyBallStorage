// my_arsenal_page.dart
import 'dart:developer';

import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/providers.dart';
import 'package:bowlingarsenal_app/features/ball_library/providers/ball_library_providers.dart';
import '../widgets/ball_detail_popout.dart';
import 'package:bowlingarsenal_app/features/arsenal/widgets/ball_list_view.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用於 SystemUiOverlayStyle
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 用於 SystemUiOverlayStyle
import 'package:go_router/go_router.dart';

import '../widgets/ball_library_controls.dart'; // 引入新的 Widget

class BallLibraryPage extends ConsumerWidget {
  const BallLibraryPage({super.key});

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) {
      return 1;
    }
    if (location.startsWith('/my-arsenal')) {
      return 2; // 修正: Arsenal 頁面對應索引 2
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    if (location.startsWith('/events')) {
      return 4; // 修正: Events 頁面對應索引 4
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final theme = Theme.of(context);
    final ballListAsync = ref.watch(ballListProvider);
    final filteredBalls = ref.watch(filteredBallListProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ProfessionalDarkBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: theme.colorScheme.onSurface,
            elevation: 0,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Ball Library',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      theme.colorScheme.outlineVariant.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: ballListAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (_) {
              return Column(
                children: [
                  const BallLibraryControls(),
                  Expanded(
                    child: BallListView(
                      bowlingBalls: filteredBalls,
                      onBallTapped: (ball) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => BowlingBallDetailWidget(ball: ball),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: ModernBottomNavigation(
            currentIndex: _calculateCurrentIndex(location),
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
                  context.go('/events');
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
