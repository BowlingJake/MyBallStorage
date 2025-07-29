import 'package:bowlingarsenal_app/features/training/models/training_record.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_state.freezed.dart';

/// 訓練狀態類 - 使用 Freezed 不可變模式
@freezed
class TrainingState with _$TrainingState {
  const factory TrainingState({
    @Default([]) List<TrainingDaySummary> trainingDays,
    @Default(false) bool isSelectionMode,
    @Default(<String>{}) Set<String> selectedDayIds,
  }) = _TrainingState;

  const TrainingState._();

  // 計算屬性
  bool get hasTrainingData => trainingDays.isNotEmpty;
  int get selectedCount => selectedDayIds.length;
  int get totalSelectedGames => _calculateTotalSelectedGames();

  int _calculateTotalSelectedGames() {
    int totalGames = 0;
    for (final day in trainingDays) {
      if (selectedDayIds.contains(day.id)) {
        totalGames += day.totalGames;
      }
    }
    return totalGames;
  }

  // 檢查是否選中某個訓練日
  bool isDaySelected(String dayId) => selectedDayIds.contains(dayId);

  // 獲取選中訓練日的統計資訊
  Map<String, int> getSelectionStats() {
    return {
      'days': selectedDayIds.length,
      'games': totalSelectedGames,
    };
  }

  // 獲取指定訓練日
  TrainingDaySummary? getTrainingDay(String dayId) {
    return trainingDays.cast<TrainingDaySummary?>().firstWhere(
          (day) => day?.id == dayId,
          orElse: () => null,
        );
  }

  // 獲取指定訓練日的遊戲數量
  int getGameCount(String dayId) {
    final day = getTrainingDay(dayId);
    return day?.totalGames ?? 0;
  }
}