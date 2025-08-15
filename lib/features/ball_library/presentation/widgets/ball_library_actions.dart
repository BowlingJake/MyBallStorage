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
            // 移除 customColor: Colors.white，讓按鈕使用金色默認樣式
            // 當 isComparisonMode 為 true 時，使用金色填滿；否則使用次要顏色
            customColor: isComparisonMode 
                ? null // 使用默認金色
                : (Theme.of(context).brightness == Brightness.dark
                    ? BrandColors.secondaryColorDark
                    : BrandColors.secondaryColorLight),
            backgroundColor: isComparisonMode 
                ? null // 使用默認金色填滿
                : Colors.transparent,
            foregroundColor: isComparisonMode 
                ? null // 使用默認黑色前景
                : (Theme.of(context).brightness == Brightness.dark
                    ? BrandColors.secondaryColorDark
                    : BrandColors.secondaryColorLight),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppStandardButton(
            text: 'Add to Arsenal',
            icon: Icons.add_circle_outline,
            height: 36,
            fontSize: 12,
            onPressed: uiService.toggleAddToArsenalMode,
            // 移除 customColor: Colors.white，讓按鈕使用金色默認樣式
            customColor: isAddToArsenalMode 
                ? null // 使用默認金色
                : (Theme.of(context).brightness == Brightness.dark
                    ? BrandColors.secondaryColorDark
                    : BrandColors.secondaryColorLight),
            backgroundColor: isAddToArsenalMode 
                ? null // 使用默認金色填滿
                : Colors.transparent,
            foregroundColor: isAddToArsenalMode 
                ? null // 使用默認黑色前景
                : (Theme.of(context).brightness == Brightness.dark
                    ? BrandColors.secondaryColorDark
                    : BrandColors.secondaryColorLight),
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
            // 主要動作按鈕 - 使用默認金色填滿樣式
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
            // 次要動作按鈕 - 使用次要顏色樣式
            customColor: Theme.of(context).brightness == Brightness.dark
                ? BrandColors.secondaryColorDark
                : BrandColors.secondaryColorLight,
            backgroundColor: Colors.transparent,
            onPressed: hasSelection 
                ? uiService.resetSelection 
                : uiService.exitSelectionMode,
          ),
        ),
      ],
    );
  }
}