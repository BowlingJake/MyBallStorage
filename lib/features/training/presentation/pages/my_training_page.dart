import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/features/training/logic/training_controller.dart';
import 'package:bowlingarsenal_app/features/training/presentation/widgets/training_list_view.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/navigation/modern_bottom_navigation.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/professional_dark_background.dart';

class MyTrainingPage extends ConsumerStatefulWidget {
  const MyTrainingPage({super.key});
  
  @override
  ConsumerState<MyTrainingPage> createState() => _MyTrainingPageState();
}

class _MyTrainingPageState extends ConsumerState<MyTrainingPage> {
  @override
  void initState() {
    super.initState();
    // 頁面載入時重新整理資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(trainingControllerProvider.notifier).refreshTrainingData();
    });
  }

  int _calculateCurrentIndex(String location) {
    if (location.startsWith('/library')) return 1;
    if (location.startsWith('/my-arsenal')) return 2;
    if (location.startsWith('/training')) return 3;
    if (location.startsWith('/tournament')) return 4;
    return 0;
  }

  void _navigateToIndex(BuildContext context, int index) {
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
            'My Training',
            style: theme.textTheme.titleLarge?.copyWith(
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
              icon: const Icon(Icons.history),
              color: theme.colorScheme.onSurface,
              onPressed: () => context.go('/training/history'),
              tooltip: 'Training History',
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: const CustomScrollView(
          slivers: [
            TrainingListView(),
          ],
        ),
        bottomNavigationBar: ModernBottomNavigation(
          currentIndex: currentIndex,
          onTap: (index) => _navigateToIndex(context, index),
        ),
      ),
    );
  }

}
