import 'dart:developer';

import 'package:bowlingarsenal_app/shared/providers/providers.dart';
import 'package:bowlingarsenal_app/shared/enums.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_list_view.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_page_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyTrainingPage extends ConsumerWidget {
  const MyTrainingPage({super.key});

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
    );
  }
}
