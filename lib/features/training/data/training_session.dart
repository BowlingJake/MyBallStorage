// lib/features/training/data/training_session.dart
class TrainingSession {

  TrainingSession({
    required this.id,
    required this.title,
    required this.date,
    required this.center,
    required this.isHousePattern, required this.scoringMethod, // 新增計分方式, required this.createdAt, this.oilPatternName,
    this.oilPatternLength,
  });
  final String id;
  final String title;
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final String scoringMethod; // 新增計分方式
  final DateTime createdAt;
} 