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

    return _buildLoadedContent(arsenalState, ref);
  }

  Widget _buildLoadedContent(NewArsenalState state, WidgetRef ref) {
    final filteredBalls = _getFilteredBalls(state);
    
    if (filteredBalls.isEmpty) {
      return const ArsenalEmptyState();
    }

    return Column(
      children: [
        // View mode toggle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const ViewModeToggle(),
            ],
          ),
        ),
        
        // Main content based on view mode
        Expanded(
          child: state.viewMode == ArsenalViewMode.grid
              ? ArsenalGridView(instances: filteredBalls)
              : ArsenalListView(
                  instances: filteredBalls,
                  extraInfoBuilder: (instance) => const SizedBox.shrink(),
                ),
        ),
      ],
    );
  }

  bool _hasActiveFilters(WidgetRef ref, NewArsenalState arsenalState) {
    return ArsenalBagHandler.hasActiveFilters(ref, arsenalState);
  }

  List<UserArsenalInstance> _getFilteredBalls(NewArsenalState state) {
    // For now, return all instances - this logic should be moved to the controller
    return state.allInstances;
  }
}