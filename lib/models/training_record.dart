// 球具簡化資訊（用於訓練記錄）
class BallInfo {
  final String id;
  final String name;
  final String brand;
  final String brandColor; // 品牌主色
  
  const BallInfo({
    required this.id,
    required this.name,
    required this.brand,
    required this.brandColor,
  });
}

// 單局記錄模型
class GameRecord {
  final String id;
  final int gameNumber; // 第幾局
  final int score;
  final List<int> frameScores; // 每一格的分數
  final int strikes;
  final int spares;
  final String? notes; // 備註
  final DateTime timestamp;
  final BallInfo? ballUsed; // 使用的球具資訊

  GameRecord({
    required this.id,
    required this.gameNumber,
    required this.score,
    required this.frameScores,
    required this.strikes,
    required this.spares,
    this.notes,
    required this.timestamp,
    this.ballUsed, // 新增球具參數
  });

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      id: json['id'] ?? '',
      gameNumber: json['gameNumber'] ?? 1,
      score: json['score'] ?? 0,
      frameScores: List<int>.from(json['frameScores'] ?? []),
      strikes: json['strikes'] ?? 0,
      spares: json['spares'] ?? 0,
      notes: json['notes'],
      timestamp: DateTime.parse(json['timestamp']),
      ballUsed: json['ballUsed'] != null 
        ? BallInfo(
            id: json['ballUsed']['id'] ?? '',
            name: json['ballUsed']['name'] ?? '',
            brand: json['ballUsed']['brand'] ?? '',
            brandColor: json['ballUsed']['brandColor'] ?? '#000000',
          )
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameNumber': gameNumber,
      'score': score,
      'frameScores': frameScores,
      'strikes': strikes,
      'spares': spares,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
      'ballUsed': ballUsed != null 
        ? {
            'id': ballUsed!.id,
            'name': ballUsed!.name,
            'brand': ballUsed!.brand,
            'brandColor': ballUsed!.brandColor,
          }
        : null,
    };
  }
}

// 訓練日摘要模型
class TrainingDaySummary {
  final String id;
  final String title; // 新增標題字段
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final String scoringMethod;
  final List<GameRecord> games;
  final DateTime createdAt;

  TrainingDaySummary({
    required this.id,
    required this.title, // 新增標題字段
    required this.date,
    required this.center,
    this.oilPatternName,
    this.oilPatternLength,
    required this.isHousePattern,
    required this.scoringMethod,
    required this.games,
    required this.createdAt,
  });

  // 計算摘要統計
  int get totalGames => games.length;
  
  int get averageScore => games.isEmpty 
    ? 0 
    : (games.map((g) => g.score).reduce((a, b) => a + b) / games.length).round();
  
  int get highestScore => games.isEmpty 
    ? 0 
    : games.map((g) => g.score).reduce((a, b) => a > b ? a : b);
  
  int get lowestScore => games.isEmpty 
    ? 0 
    : games.map((g) => g.score).reduce((a, b) => a < b ? a : b);
  
  int get totalStrikes => games.map((g) => g.strikes).fold(0, (a, b) => a + b);
  
  int get totalSpares => games.map((g) => g.spares).fold(0, (a, b) => a + b);
  
  double get strikePercentage => totalGames == 0 
    ? 0.0 
    : (totalStrikes / (totalGames * 10)) * 100;
  
  double get sparePercentage => totalGames == 0 
    ? 0.0 
    : (totalSpares / (totalGames * 10)) * 100;

  // 獲取所有使用的球具及其使用的局數
  Map<BallInfo, List<int>> get equipmentUsage {
    final Map<BallInfo, List<int>> usage = {};
    
    for (final game in games) {
      if (game.ballUsed != null) {
        // 使用球具的 ID 作為 key 來避免重複
        final existingBall = usage.keys.firstWhere(
          (ball) => ball.id == game.ballUsed!.id,
          orElse: () => game.ballUsed!,
        );
        
        if (usage.containsKey(existingBall)) {
          usage[existingBall]!.add(game.gameNumber);
        } else {
          usage[game.ballUsed!] = [game.gameNumber];
        }
      }
    }
    
    return usage;
  }

  // 獲取主要使用的球具（使用最多局數的）
  BallInfo? get primaryBall {
    final usage = equipmentUsage;
    if (usage.isEmpty) return null;
    
    return usage.entries
        .reduce((a, b) => a.value.length > b.value.length ? a : b)
        .key;
  }

  String get oilPatternDisplay {
    if (isHousePattern) {
      return 'House Pattern';
    } else if (oilPatternName?.isNotEmpty == true || oilPatternLength?.isNotEmpty == true) {
      final name = oilPatternName ?? '';
      final length = oilPatternLength ?? '';
      if (name.isNotEmpty && length.isNotEmpty) {
        return '$name (${length}ft)';
      } else if (name.isNotEmpty) {
        return name;
      } else if (length.isNotEmpty) {
        return '${length}ft';
      }
    }
    return 'Custom Pattern';
  }

  factory TrainingDaySummary.fromJson(Map<String, dynamic> json) {
    return TrainingDaySummary(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Training Session', // 默認標題
      date: DateTime.parse(json['date']),
      center: json['center'] ?? '',
      oilPatternName: json['oilPatternName'],
      oilPatternLength: json['oilPatternLength'],
      isHousePattern: json['isHousePattern'] ?? true,
      scoringMethod: json['scoringMethod'] ?? 'Standard',
      games: (json['games'] as List?)
          ?.map((game) => GameRecord.fromJson(game))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title, // 新增標題到 JSON
      'date': date.toIso8601String(),
      'center': center,
      'oilPatternName': oilPatternName,
      'oilPatternLength': oilPatternLength,
      'isHousePattern': isHousePattern,
      'scoringMethod': scoringMethod,
      'games': games.map((game) => game.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// 舊的訓練記錄模型（向後兼容）
class TrainingRecord {
  final String id;
  final String title;
  final DateTime date;
  final int score;
  final String notes;
  final String? imageUrl;

  TrainingRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.score,
    required this.notes,
    this.imageUrl,
  });

  factory TrainingRecord.fromJson(Map<String, dynamic> json) {
    return TrainingRecord(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date']),
      score: json['score'] ?? 0,
      notes: json['notes'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'score': score,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }
} 