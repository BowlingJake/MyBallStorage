import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/arsenal_specific_ball_card.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

class ArsenalListView extends ConsumerWidget {
  const ArsenalListView({super.key, required this.instances, required this.extraInfoBuilder});

  final List<UserArsenalInstance> instances;
  final Widget Function(UserArsenalInstance) extraInfoBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Builder(
        builder: (context) {
          final media = MediaQuery.of(context);
          final double bottomExtra = media.padding.bottom + kBottomNavigationBarHeight + 48; // actions(≈36)+spacing
          return ListView.builder(
            padding: EdgeInsets.only(bottom: bottomExtra),
        itemCount: instances.length,
        itemBuilder: (context, index) {
          final instance = instances[index];
          final isSelectedForRemoval = arsenalState.selectedForRemoval.contains(instance.id);
          final isSelectedForMove = arsenalState.selectedForMove.contains(instance.id);
          final isSelected = isSelectedForRemoval || isSelectedForMove;
          return ArsenalSpecificBallCard(
            arsenalBallInstance: instance,
            theme: Theme.of(context),
            isSelectionMode: arsenalState.isRemoveMode || arsenalState.isMoveMode,
            isSelected: isSelected,
            onTap: arsenalState.isRemoveMode
                ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForRemoval(instance.id)
                : arsenalState.isMoveMode
                    ? () => ref.read(newArsenalControllerProvider.notifier).toggleInstanceForMove(instance.id)
                    : null,
            extraInfo: extraInfoBuilder(instance),
          );
        },
          );
        },
      ),
    );
  }
}

