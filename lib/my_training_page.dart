import 'dart:developer';

import 'package:bowlingarsenal_app/ball_library_page.dart';
import 'package:bowlingarsenal_app/providers/training_providers.dart';
import 'package:bowlingarsenal_app/shared/enums.dart';
import 'package:bowlingarsenal_app/widgets/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/professional_dark_background.dart';
import 'package:bowlingarsenal_app/widgets/training/training_list_view.dart';
import 'package:bowlingarsenal_app/widgets/training/training_page_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTrainingPage extends ConsumerWidget {
  const MyTrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(trainingTabProvider);

    return ProfessionalDarkBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: const CustomScrollView(
          slivers: [
            TrainingPageAppBar(),
            TrainingListView(),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentTab.index,
          onTap: (index) => _onBottomNavTapped(context, index, ref),
        ),
      ),
    );
  }

  void _onBottomNavTapped(BuildContext context, int index, WidgetRef ref) {
    final tab = BottomNavTab.values[index];
    final notifier = ref.read(trainingTabProvider.notifier);

    // Update the state regardless of the navigation action
    notifier.state = tab;

    switch (tab) {
      case BottomNavTab.home:
        context.go('/');
        break;
      case BottomNavTab.library:
        context.go('/library');
        break;
      case BottomNavTab.add:
        // The add button on the bottom nav might need a new home for its logic,
        // potentially a global service or a new provider.
        // For now, let's log it.
        if (kDebugMode) {
          print('Add button on BottomNav tapped. Logic needs relocation.');
        }
        break;
      case BottomNavTab.training:
        // Already on the training page, do nothing.
        break;
      case BottomNavTab.profile:
        if (kDebugMode) {
          log('Profile button tapped in Training');
        }
        break;
    }
  }
}
