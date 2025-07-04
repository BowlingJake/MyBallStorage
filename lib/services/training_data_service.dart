import 'package:bowlingarsenal_app/models/training_record.dart';

/// 訓練數據服務
/// 負責處理所有與訓練記錄相關的數據操作
class TrainingDataService {
  final List<TrainingDaySummary> _trainingDays = [];

  // 獲取所有訓練日
  List<TrainingDaySummary> get trainingDays => List.unmodifiable(_trainingDays);

  // 是否有訓練記錄
  bool get hasTrainingData => _trainingDays.isNotEmpty;

  // 創建新的訓練記錄
  String createTrainingDay({
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    String? oilPatternLength,
  }) {
    final id = 'day_${DateTime.now().millisecondsSinceEpoch}';
    final newDay = TrainingDaySummary(
      id: id,
      title: title,
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
      games: [],
      createdAt: DateTime.now(),
    );

    _trainingDays.insert(0, newDay); // 新記錄插入到最前面
    return id;
  }

  // 更新訓練記錄
  bool updateTrainingDay(
    String dayId, {
    required String title,
    required DateTime date,
    required String center,
    required bool isHousePattern,
    required String scoringMethod,
    required String inputMethod,
    String? oilPatternName,
    String? oilPatternLength,
  }) {
    final dayIndex = _trainingDays.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return false;

    final existingDay = _trainingDays[dayIndex];
    final updatedDay = TrainingDaySummary(
      id: existingDay.id,
      title: title,
      date: date,
      center: center,
      oilPatternName: oilPatternName,
      oilPatternLength: oilPatternLength,
      isHousePattern: isHousePattern,
      scoringMethod: scoringMethod,
      inputMethod: inputMethod,
      games: existingDay.games,
      createdAt: existingDay.createdAt,
    );

    _trainingDays[dayIndex] = updatedDay;
    return true;
  }

  // 刪除訓練日
  bool deleteTrainingDay(String dayId) {
    final dayIndex = _trainingDays.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return false;

    _trainingDays.removeAt(dayIndex);
    return true;
  }

  // 批量刪除訓練日
  int deleteTrainingDays(Set<String> dayIds) {
    final initialCount = _trainingDays.length;
    _trainingDays.removeWhere((day) => dayIds.contains(day.id));
    return initialCount - _trainingDays.length;
  }

  // 新增遊戲到指定訓練日
  bool addGameToDay(String dayId, GameRecord game) {
    final dayIndex = _trainingDays.indexWhere((d) => d.id == dayId);
    if (dayIndex == -1) return false;

    final existingDay = _trainingDays[dayIndex];
    final updatedGames = <GameRecord>[...existingDay.games, game];

    final updatedDay = TrainingDaySummary(
      id: existingDay.id,
      title: existingDay.title,
      date: existingDay.date,
      center: existingDay.center,
      oilPatternName: existingDay.oilPatternName,
      oilPatternLength: existingDay.oilPatternLength,
      isHousePattern: existingDay.isHousePattern,
      scoringMethod: existingDay.scoringMethod,
      inputMethod: existingDay.inputMethod,
      games: updatedGames,
      createdAt: existingDay.createdAt,
    );

    _trainingDays[dayIndex] = updatedDay;
    return true;
  }

  // 更新遊戲記錄
  bool updateGameInDay(GameRecord updatedGame) {
    for (var dayIndex = 0; dayIndex < _trainingDays.length; dayIndex++) {
      final dayGames = _trainingDays[dayIndex].games;
      final gameIndex = dayGames.indexWhere((g) => g.id == updatedGame.id);

      if (gameIndex != -1) {
        final updatedGames = <GameRecord>[...dayGames];
        updatedGames[gameIndex] = updatedGame;

        final existingDay = _trainingDays[dayIndex];
        final updatedDay = TrainingDaySummary(
          id: existingDay.id,
          title: existingDay.title,
          date: existingDay.date,
          center: existingDay.center,
          oilPatternName: existingDay.oilPatternName,
          oilPatternLength: existingDay.oilPatternLength,
          isHousePattern: existingDay.isHousePattern,
          scoringMethod: existingDay.scoringMethod,
          inputMethod: existingDay.inputMethod,
          games: updatedGames,
          createdAt: existingDay.createdAt,
        );

        _trainingDays[dayIndex] = updatedDay;
        return true;
      }
    }
    return false;
  }

  // 從訓練日中移除遊戲
  bool removeGameFromDay(GameRecord gameToRemove) {
    for (var dayIndex = 0; dayIndex < _trainingDays.length; dayIndex++) {
      final dayGames = _trainingDays[dayIndex].games;
      final gameIndex = dayGames.indexWhere((g) => g.id == gameToRemove.id);

      if (gameIndex != -1) {
        final updatedGames = <GameRecord>[...dayGames];
        updatedGames.removeAt(gameIndex);

        // 重新編號剩餘的遊戲
        for (var i = 0; i < updatedGames.length; i++) {
          updatedGames[i] = GameRecord(
            id: updatedGames[i].id,
            gameNumber: i + 1,
            score: updatedGames[i].score,
            frameScores: updatedGames[i].frameScores,
            strikes: updatedGames[i].strikes,
            spares: updatedGames[i].spares,
            notes: updatedGames[i].notes,
            timestamp: updatedGames[i].timestamp,
            ballUsed: updatedGames[i].ballUsed,
          );
        }

        final existingDay = _trainingDays[dayIndex];
        final updatedDay = TrainingDaySummary(
          id: existingDay.id,
          title: existingDay.title,
          date: existingDay.date,
          center: existingDay.center,
          oilPatternName: existingDay.oilPatternName,
          oilPatternLength: existingDay.oilPatternLength,
          isHousePattern: existingDay.isHousePattern,
          scoringMethod: existingDay.scoringMethod,
          inputMethod: existingDay.inputMethod,
          games: updatedGames,
          createdAt: existingDay.createdAt,
        );

        _trainingDays[dayIndex] = updatedDay;
        return true;
      }
    }
    return false;
  }

  // 獲取指定訓練日
  TrainingDaySummary? getTrainingDay(String dayId) {
    try {
      return _trainingDays.firstWhere((d) => d.id == dayId);
    } catch (e) {
      return null;
    }
  }

  // 獲取下一個遊戲編號
  int getNextGameNumber(String dayId) {
    final day = getTrainingDay(dayId);
    return day != null ? day.games.length + 1 : 1;
  }
}
