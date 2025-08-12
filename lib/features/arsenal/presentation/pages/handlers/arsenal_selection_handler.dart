import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_selection_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/providers/arsenal_selection_state_provider.dart';

class ArsenalSelectionHandler {
  static void toggleMoveMode(WidgetRef ref) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleMoveMode();
  }

  static void toggleRemoveMode(WidgetRef ref) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleRemoveMode();
  }

  static void exitSelectionMode(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.exitSelectionMode(arsenalState);
  }

  static bool isInSelectionMode(NewArsenalState arsenalState) {
    // Keep this as static utility since it's just a simple check
    return arsenalState.isMoveMode || arsenalState.isRemoveMode;
  }

  static int getSelectionCount(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionCount(arsenalState);
  }

  static String getSelectionModeText(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionModeText(arsenalState);
  }

  static SelectionModeColor getSelectionModeColor(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectionModeColor(arsenalState);
  }

  static void toggleInstanceForMove(WidgetRef ref, int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleInstanceForMove(instanceId);
  }

  static void toggleInstanceForRemoval(WidgetRef ref, int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.toggleInstanceForRemoval(instanceId);
  }

  static void clearSelections(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    selectionService.clearSelections(arsenalState);
  }

  static bool isInstanceSelected(WidgetRef ref, NewArsenalState arsenalState, int instanceId) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.isInstanceSelected(arsenalState, instanceId);
  }

  static Set<int> getSelectedInstances(WidgetRef ref, NewArsenalState arsenalState) {
    final selectionService = ref.read(arsenalSelectionServiceProvider.notifier);
    return selectionService.getSelectedInstances(arsenalState);
  }
}