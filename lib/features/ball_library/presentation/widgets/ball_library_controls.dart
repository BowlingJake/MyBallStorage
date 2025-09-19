import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_ui_service.dart';
import 'package:bowlingarsenal_app/shared/widgets/common/simple_search_controls.dart';

/// Ball Library Controls Widget
/// Handles search, filter, and sort controls
class BallLibraryControls extends ConsumerWidget {
  const BallLibraryControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ballLibraryAsync = ref.watch(ballLibraryControllerProvider);
    final uiService = ref.read(ballLibraryUIServiceProvider.notifier);

    return ballLibraryAsync.when(
      data: (state) => SimpleSearchControls(
        searchHint: 'Search balls...',
        onSearchChanged: (text) {
          ref.read(ballLibraryControllerProvider.notifier).updateSearchText(text);
        },
        // 隱藏本區域的 Filter/Sort，改到 AppBar 動作鍵
        showSortButton: false,
        onFilterTap: null,
        onSortTap: null,
        filterCount: state.filters.activeFilterCount,
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// 專用於 const 參數位置的 no-op（轉發在外部使用）
void _noop(String _) {}