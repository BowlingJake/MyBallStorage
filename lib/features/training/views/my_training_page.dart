import 'dart:developer';

import 'package:bowlingarsenal_app/providers/providers.dart';
import 'package:bowlingarsenal_app/shared/enums.dart';
import 'package:bowlingarsenal_app/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_list_view.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_page_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTrainingPage extends ConsumerWidget {
  const MyTrainingPage({super.key});

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library') || location.startsWith('/my-arsenal')) {
      return 1;
    }
    if (location.startsWith('/training')) {
      return 3;
    }
    if (location.startsWith('/settings')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

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
          currentIndex: _calculateCurrentIndex(location),
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/library');
                break;
              case 3:
                context.go('/training');
                break;
              case 4:
                context.go('/settings');
                break;
            }
          },
        ),
      ),
    );
  }
}
