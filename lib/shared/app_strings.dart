/// 應用程式字串常數
/// 統一管理所有用戶顯示的文字，便於本地化和維護
class AppStrings {
  // 訓練頁面相關
  static const String myTraining = 'My Training';
  static const String selectedItems = '{count} items selected';
  static const String selectAll = 'Select All';
  static const String cancelSelection = 'Cancel Selection';
  static const String startYourBowlingJourney = 'Start Your Bowling Journey';
  static const String recordYourTrainingSessions =
      'Record your training sessions\nTrack your progress';
  static const String addTrainingRecord = 'Add Training Record';

  // 訓練記錄操作
  static const String trainingRecordCreated = 'Training record "{title}" created!';
  static const String trainingRecordUpdated = 'Training record updated!';
  static const String trainingRecordDeleted = 'Training record deleted';
  static const String trainingRecordsDeleted = '{count} training records deleted';
  static const String trainingDayDeleted = 'Training day deleted';
  static const String trainingDaysDeleted =
      '{count} training day{plural} deleted';

  // 遊戲操作
  static const String gameAddedSuccess = 'Game {count} added successfully!';
  static const String gameDeleted = 'Game deleted';
  static const String deleteGame = 'Delete Game';
  static const String confirmDeleteGame = 'Are you sure you want to delete Game {gameNumber}? This action cannot be undone.';

  // 刪除確認對話框
  static const String deleteTrainingDay = 'Delete Training Day';
  static const String deleteTrainingDays = 'Delete Training Days';
  static const String confirmDeleteTrainingDay =
      'Are you sure you want to delete this training day? This action cannot be undone.';
  static const String confirmDeleteMultipleTrainingDays =
      'Are you sure you want to delete {count} training day{plural} with {games} total games? This action cannot be undone.';

  // 通用按鈕
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String edit = 'Edit';

  // 底部導航
  static const String home = 'Home';
  static const String library = 'Library';
  static const String add = 'Add';
  static const String training = 'Training';
  static const String profile = 'Profile';

  // 工具方法：處理複數形式
  static String formatSelectedItems(int count) {
    return selectedItems.replaceAll('{count}', count.toString());
  }

  static String formatTrainingRecordCreated(String title) {
    return trainingRecordCreated.replaceAll('{title}', title);
  }

  static String formatGameAddedSuccess(int count) {
    return gameAddedSuccess.replaceAll('{count}', count.toString());
  }

  static String formatConfirmDeleteGame(int gameNumber) {
    return confirmDeleteGame.replaceAll('{gameNumber}', gameNumber.toString());
  }

  static String formatConfirmDeleteMultiple(int count, int games) {
    final plural = count > 1 ? 's' : '';
    return confirmDeleteMultipleTrainingDays
        .replaceAll('{count}', count.toString())
        .replaceAll('{plural}', plural)
        .replaceAll('{games}', games.toString());
  }

  static String formatTrainingDaysDeleted(int count) {
    final plural = count > 1 ? 's' : '';
    return trainingDaysDeleted
        .replaceAll('{count}', count.toString())
        .replaceAll('{plural}', plural);
  }
}
