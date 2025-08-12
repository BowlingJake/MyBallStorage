import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/controllers/arsenal_actions.dart';

class ArsenalDialogHandler {
  static void showMoreOptionsBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
    required NewArsenalState arsenalState,
  }) {
    final canMove = (arsenalState.selectedBagNumber ?? 1) != 1;
    ArsenalActions.openMoreOptionsSheet(
      context: context,
      ref: ref,
      activeFilterCount: arsenalState.filters.activeFilterCount,
      sortOption: arsenalState.sortOption,
      canMove: canMove,
    );
  }

  static void showAddToCurrentBag({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalActions.showAddToCurrentBag(
      context: context,
      ref: ref,
    );
  }

  static void showMoveSelected({
    required BuildContext context,
    required WidgetRef ref,
    required List<Color> bagColors,
  }) {
    ArsenalActions.showMoveSelected(
      context: context,
      ref: ref,
      bagColors: bagColors,
    );
  }

  static void confirmRemoveSelected({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ArsenalActions.confirmRemoveSelected(
      context: context,
      ref: ref,
    );
  }
}