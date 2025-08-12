import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/handlers/arsenal_bag_handler.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/common/view_mode_toggle.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/lists/arsenal_grid_view.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/lists/arsenal_list_view.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/states/arsenal_empty_state.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/widgets/states/arsenal_error_state.dart';

class ArsenalContentSection extends ConsumerWidget {
  const ArsenalContentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arsenalState = ref.watch(newArsenalControllerProvider);
    final filteredBallsAsync = ref.watch(filteredArsenalInstancesProvider);
    
    if (arsenalState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (arsenalState.error != null) {
      return ArsenalErrorState(
        error: arsenalState.error!,
        onRetry: () => ref.refresh(newArsenalControllerProvider),
      );
    }

    return filteredBallsAsync.when(
      data: (filteredBalls) => _buildLoadedContent(arsenalState, filteredBalls),
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (e, st) => ArsenalErrorState(
        error: e.toString(),
        onRetry: () => ref.refresh(filteredArsenalInstancesProvider),
      ),
    );
  }

  Widget _buildLoadedContent(NewArsenalState state, List<UserArsenalInstance> filteredBalls) {
    if (filteredBalls.isEmpty) {
      return const ArsenalEmptyState();
    }

    return Column(
      children: [
        // Main content based on view mode
        Expanded(
          child: state.viewMode == ArsenalViewMode.grid
              ? ArsenalGridView(instances: filteredBalls)
              : ArsenalListView(
                  instances: filteredBalls,
                  extraInfoBuilder: (instance) => _buildListExtraInfo(instance),
                ),
        ),
      ],
    );
  }

  bool _hasActiveFilters(WidgetRef ref, NewArsenalState arsenalState) {
    return ArsenalBagHandler.hasActiveFilters(ref, arsenalState);
  }

  // Removed local filtering; using filteredArsenalInstancesProvider from controller

  Widget _buildListExtraInfo(UserArsenalInstance instance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Layout: ${instance.layoutDisplayString}',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          'Games Used: ${instance.gamesUsed}',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}