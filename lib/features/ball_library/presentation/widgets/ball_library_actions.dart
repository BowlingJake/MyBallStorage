import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_ui_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/buttons/app_standard_button.dart';
import 'package:core_theme/core_theme.dart';

/// Ball Library Actions Widget
/// Handles mode selection buttons and selection mode actions
class BallLibraryActions extends ConsumerWidget {
  const BallLibraryActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(ballLibraryUIServiceProvider);
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);
    final isInSelectionMode = uiState.selectionMode != BallLibrarySelectionMode.none;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: isInSelectionMode
          ? _buildSelectionActionButtons(context, ref, uiState, uiService)
          : _buildModeSelectionButtons(context, ref, uiService),
    );
  }

  /// Build mode selection buttons (Comparison / Add to Arsenal)
  Widget _buildModeSelectionButtons(
    BuildContext context,
    WidgetRef ref,
    BallLibraryUIService uiService,
  ) {
    final uiState = ref.watch(ballLibraryUIServiceProvider);
    final isComparisonMode = uiState.selectionMode == BallLibrarySelectionMode.comparison;
    final isAddToArsenalMode = uiState.selectionMode == BallLibrarySelectionMode.addToArsenal;
    
    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: 'Ball Comparison',
            icon: Icons.compare_arrows,
            height: 36,
            fontSize: 12,
            onPressed: uiService.toggleComparisonMode,
            customColor: Colors.white,
            isPrimary: isComparisonMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Add to Arsenal',
            icon: Icons.add_circle_outline,
            height: 36,
            fontSize: 12,
            customColor: Colors.white,
            onPressed: uiService.toggleAddToArsenalMode,
            isPrimary: isAddToArsenalMode,
          ),
        ),
      ],
    );
  }

  /// Build selection mode action buttons (Confirm / Reset)
  Widget _buildSelectionActionButtons(
    BuildContext context,
    WidgetRef ref,
    BallLibraryUIState uiState,
    BallLibraryUIService uiService,
  ) {
    final selectedCount = uiState.selectedBallIds.length;
    final hasSelection = selectedCount > 0;
    final isComparison = uiState.selectionMode == BallLibrarySelectionMode.comparison;
    final canCompare = isComparison && selectedCount == 2;
    final canAddToArsenal = !isComparison && selectedCount > 0;

    return Row(
      children: [
        Expanded(
          child: AppStandardButton(
            text: isComparison ? 'Compare' : 'Add',
            icon: isComparison ? Icons.check : Icons.add,
            height: 36,
            fontSize: 12,
            outlineColor: Colors.white.withOpacity(0.6),
            foregroundColor: Colors.white.withOpacity(0.9),
            enabled: isComparison ? canCompare : canAddToArsenal,
            onPressed: () {
              if (isComparison) {
                uiService.showComparison(context: context);
              } else {
                uiService.showAddToArsenalConfirmation(context: context);
              }
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: hasSelection ? 'Reset' : 'Exit',
            icon: hasSelection ? Icons.refresh : Icons.close,
            height: 36,
            fontSize: 12,
            onPressed: hasSelection 
                ? uiService.resetSelection 
                : uiService.exitSelectionMode,
          ),
        ),
      ],
    );
  }
}