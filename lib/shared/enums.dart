enum TournamentType { open, championship }

// Enum for Open tournament format
enum OpenTournamentFormat { mq, classic }

// 底部導航標籤枚舉
enum BottomNavTab {
  home, // 0 - 首頁
  library, // 1 - 球具庫
  add, // 2 - 新增按鈕
  training, // 3 - 訓練頁面
  profile, // 4 - 個人頁面
}

// BottomNavTab 的擴展方法
extension BottomNavTabExtension on BottomNavTab {
  int get index {
    switch (this) {
      case BottomNavTab.home:
        return 0;
      case BottomNavTab.library:
        return 1;
      case BottomNavTab.add:
        return 2;
      case BottomNavTab.training:
        return 3;
      case BottomNavTab.profile:
        return 4;
    }
  }

  String get label {
    switch (this) {
      case BottomNavTab.home:
        return '首頁';
      case BottomNavTab.library:
        return '球具庫';
      case BottomNavTab.add:
        return '新增';
      case BottomNavTab.training:
        return '訓練';
      case BottomNavTab.profile:
        return '個人';
    }
  }
}
