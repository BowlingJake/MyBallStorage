import 'package:bowlingarsenal_app/controllers/training_controller.dart';
import 'package:bowlingarsenal_app/models/training_record.dart';
import 'package:bowlingarsenal_app/widgets/training/training_day_summary_card.dart';
import 'package:bowlingarsenal_app/widgets/training/training_empty_state.dart';
import 'package:flutter/material.dart';

class TrainingListView extends StatelessWidget {

  const TrainingListView({
    required this.controller, required this.onCreateRecord, required this.onAddGame, required this.onEditRecord, required this.onDeleteDay, required this.onGameTap, required this.onGameDelete, super.key,
  });
  final TrainingController controller;
  final VoidCallback onCreateRecord;
  final Function(String dayId) onAddGame;
  final Function(String dayId) onEditRecord;
  final Function(String dayId) onDeleteDay;
  final Function(GameRecord game) onGameTap;
  final Function(GameRecord game) onGameDelete;

  @override
  Widget build(BuildContext context) {
    if (!controller.hasTrainingData) {
      return SliverFillRemaining(
        child: Center(
          child: TrainingEmptyState(
            onAddRecord: onCreateRecord,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final day = controller.trainingDays[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TrainingDaySummaryCard(
              key: ValueKey(day.id), // 添加唯一 key 避免重建動畫問題
              summary: day,
              isSelectionMode: controller.isSelectionMode,
              isSelected: controller.isDaySelected(day.id),
              onSelectionChanged: (selected) => controller.toggleDaySelection(day.id),
              onAddGame: () => onAddGame(day.id),
              onEdit: () => onEditRecord(day.id),
              onDelete: () => onDeleteDay(day.id),
              onGameTap: onGameTap,
              onGameDelete: onGameDelete,
            ),
          );
        },
        childCount: controller.trainingDays.length,
      ),
    );
  }
} 