class TrainingRecord {
  final String id;
  final DateTime date;
  final String centerName;
  final String oilPattern;
  // 之後可以加入更多數據，例如總分、好球數等
  // final int totalScore;
  // final int strikes;

  TrainingRecord({
    required this.id,
    required this.date,
    required this.centerName,
    required this.oilPattern,
    // this.totalScore = 0,
    // this.strikes = 0,
  });
} 