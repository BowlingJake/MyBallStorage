import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_grid_card.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

class ArsenalGridView extends ConsumerWidget {
  const ArsenalGridView({super.key, required this.instances});

  final List<UserArsenalInstance> instances;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Builder(
        builder: (context) {
          final media = MediaQuery.of(context);
          final double bottomExtra = media.padding.bottom + kBottomNavigationBarHeight + 48; // actions(≈36)+spacing
          return GridView.builder(
            padding: EdgeInsets.fromLTRB(8, 16, 8, bottomExtra),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          // 稍微增加高度，避免內容溢出
          childAspectRatio: 0.92,
        ),
        itemCount: instances.length,
        itemBuilder: (context, index) {
          final instance = instances[index];
          final isSelectedForRemoval = arsenalState.selectedForRemoval.contains(instance.id);
          final isSelectedForMove = arsenalState.selectedForMove.contains(instance.id);
          final isSelected = isSelectedForRemoval || isSelectedForMove;
          return ArsenalGridCard(
            instance: instance,
            isSelectionMode: arsenalState.isRemoveMode || arsenalState.isMoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
                : arsenalState.isMoveMode
                    ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(instance.id)
                    : null,
          );
        },
          );
        },
      ),
    );
  }
}

