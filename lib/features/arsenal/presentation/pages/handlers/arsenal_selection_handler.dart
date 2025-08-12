import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';

class ArsenalSelectionHandler {
  static void toggleMoveMode(WidgetRef ref) {
    ref.read(newArsenalControllerProvider.notifier).toggleMoveMode();
  }

  static void toggleRemoveMode(WidgetRef ref) {
    ref.read(newArsenalControllerProvider.notifier).toggleRemoveMode();
  }

  static void exitSelectionMode(WidgetRef ref, NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      toggleMoveMode(ref);
    } else if (arsenalState.isRemoveMode) {
      toggleRemoveMode(ref);
    }
  }

  static bool isInSelectionMode(NewArsenalState arsenalState) {
    return arsenalState.isMoveMode || arsenalState.isRemoveMode;
  }

  static int getSelectionCount(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      return arsenalState.selectedForMove.length;
    } else if (arsenalState.isRemoveMode) {
      return arsenalState.selectedForRemoval.length;
    }
    return 0;
  }

  static String getSelectionModeText(NewArsenalState arsenalState) {
    final count = getSelectionCount(arsenalState);
    if (arsenalState.isMoveMode) {
      return 'Confirm Move ($count)';
    } else if (arsenalState.isRemoveMode) {
      return 'Confirm Remove ($count)';
    }
    return '';
  }

  static Color getSelectionModeColor(NewArsenalState arsenalState) {
    if (arsenalState.isMoveMode) {
      return Colors.blue;
    } else if (arsenalState.isRemoveMode) {
      return Colors.red;
    }
    return Colors.grey;
  }
}