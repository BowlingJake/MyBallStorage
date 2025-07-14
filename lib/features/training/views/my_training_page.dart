import 'package:bowlingarsenal_app/shared/widgets/common/navigation/scaffold_with_bottom_nav_bar.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_list_view.dart';
import 'package:bowlingarsenal_app/features/training/widgets/training_page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTrainingPage extends ConsumerWidget {
  const MyTrainingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ScaffoldWithBottomNavBar(
      body: CustomScrollView(
        slivers: [
          TrainingPageAppBar(),
          TrainingListView(),
        ],
      ),
    );
  }
}
