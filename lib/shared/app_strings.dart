/// 應用程式字串常數
/// 統一管理所有用戶顯示的文字，便於本地化和維護
class AppStrings {
  // 訓練頁面相關
  static const String myTraining = 'My Training';
  static const String selectedItems = '已選擇 {count} 項';
  static const String selectAll = '全選';
  static const String cancelSelection = '取消全選';
  static const String startYourBowlingJourney = 'Start Your Bowling Journey';
  static const String recordYourTrainingSessions = 'Record your training sessions\nTrack your progress';
  static const String addTrainingRecord = 'Add Training Record';
  
  // 訓練記錄操作
  static const String trainingRecordCreated = '訓練記錄「{title}」已建立！';
  static const String trainingRecordUpdated = '訓練記錄已更新！';
  static const String trainingDayDeleted = 'Training day deleted';
  static const String trainingDaysDeleted = '{count} training day{plural} deleted';
  
  // 遊戲操作
  static const String gameAddedSuccess = '第 {count} 局已新增成功！';
  static const String gameDeleted = '遊戲已刪除';
  static const String deleteGame = '刪除遊戲';
  static const String confirmDeleteGame = '確定要刪除第{gameNumber}局嗎？此操作無法復原。';
  
  // 刪除確認對話框
  static const String deleteTrainingDay = 'Delete Training Day';
  static const String deleteTrainingDays = 'Delete Training Days';
  static const String confirmDeleteTrainingDay = 'Are you sure you want to delete this training day? This action cannot be undone.';
  static const String confirmDeleteMultipleTrainingDays = 'Are you sure you want to delete {count} training day{plural} with {games} total games? This action cannot be undone.';
  
  // 通用按鈕
  static const String cancel = '取消';
  static const String delete = '刪除';
  static const String confirm = '確定';
  static const String save = '儲存';
  static const String edit = '編輯';
  
  // 底部導航
  static const String home = '首頁';
  static const String library = '球具庫';
  static const String add = '新增';
  static const String training = '訓練';
  static const String profile = '個人';
  
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