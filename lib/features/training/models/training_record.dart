// 球具簡化資訊（用於訓練記錄）
class BallInfo {
  // 品牌主色

  const BallInfo({
    required this.id,
    required this.name,
    required this.brand,
    required this.brandColor,
    this.imagePath,
  });
  final String id;
  final String name;
  final String brand;
  final String brandColor;
  final String? imagePath;
}

// 單局記錄模型
class GameRecord {
  // 使用的球具資訊

  GameRecord({
    required this.id,
    required this.gameNumber,
    required this.score,
    required this.frameScores,
    required this.strikes,
    required this.spares,
    required this.timestamp,
    this.notes,
    this.ballUsed,     // 保留舊屬性以向後相容
    this.ballsUsed,    // 新增: 支持多個球具
  });

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    // 處理多球資訊
    List<BallInfo>? ballsUsedList;
    if (json['ballsUsed'] != null) {
      ballsUsedList = (json['ballsUsed'] as List)
          .map((ballData) => BallInfo(
                id: ballData['id'] ?? '',
                name: ballData['name'] ?? '',
                brand: ballData['brand'] ?? '',
                brandColor: ballData['brandColor'] ?? '#000000',
                imagePath: ballData['imagePath'],
              ))
          .toList();
    }

    return GameRecord(
      id: json['id'] ?? '',
      gameNumber: json['gameNumber'] ?? 1,
      score: json['score'] ?? 0,
      frameScores: List<int>.from(json['frameScores'] ?? []),
      strikes: json['strikes'] ?? 0,
      spares: json['spares'] ?? 0,
      notes: json['notes'],
      timestamp: DateTime.parse(json['timestamp']),
      ballUsed:
          json['ballUsed'] != null
              ? BallInfo(
                id: json['ballUsed']['id'] ?? '',
                name: json['ballUsed']['name'] ?? '',
                brand: json['ballUsed']['brand'] ?? '',
                brandColor: json['ballUsed']['brandColor'] ?? '#000000',
                imagePath: json['ballUsed']['imagePath'],
              )
              : null,
      ballsUsed: ballsUsedList,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'gameNumber': gameNumber,
      'score': score,
      'frameScores': frameScores,
      'strikes': strikes,
      'spares': spares,
      'timestamp': timestamp.toIso8601String(),
    };
    
    if (notes != null) {
      data['notes'] = notes;
    }
    
    // 為了向後兼容，同時寫入 ballUsed 和 ballsUsed
    if (ballsUsed != null && ballsUsed!.isNotEmpty) {
      // 將第一個球具寫入舊的 `ballUsed` 欄位
      data['ballUsed'] = {
        'id': ballsUsed!.first.id,
        'name': ballsUsed!.first.name,
        'brand': ballsUsed!.first.brand,
        'brandColor': ballsUsed!.first.brandColor,
        'imagePath': ballsUsed!.first.imagePath,
      };
      
      // 將所有球具寫入新的 `ballsUsed` 欄位
      data['ballsUsed'] = ballsUsed!.map((ball) => {
        'id': ball.id,
        'name': ball.name,
        'brand': ball.brand,
        'brandColor': ball.brandColor,
        'imagePath': ball.imagePath,
      }).toList();
    } else if (ballUsed != null) {
      // 如果只有舊的單一球具數據，也寫入兩個欄位
       data['ballUsed'] = {
        'id': ballUsed!.id,
        'name': ballUsed!.name,
        'brand': ballUsed!.brand,
        'brandColor': ballUsed!.brandColor,
        'imagePath': ballUsed!.imagePath,
      };
      data['ballsUsed'] = [{
        'id': ballUsed!.id,
        'name': ballUsed!.name,
        'brand': ballUsed!.brand,
        'brandColor': ballUsed!.brandColor,
        'imagePath': ballUsed!.imagePath,
      }];
    }
    
    return data;
  }
  
  final String id;
  final int gameNumber; // 第幾局
  final int score;
  final List<int> frameScores; // 每一格的分數
  final int strikes;
  final int spares;
  final String? notes; // 備註
  final DateTime timestamp;
  final BallInfo? ballUsed;    // 舊屬性，單一球具
  final List<BallInfo>? ballsUsed; // 新屬性，支持多個球具
  
  // 向後相容：返回主要使用的球具
  BallInfo? get primaryBallUsed => ballsUsed?.isNotEmpty == true ? ballsUsed!.first : ballUsed;
}

// 訓練日摘要模型
class TrainingDaySummary {
  TrainingDaySummary({
    required this.id,
    required this.title, // 新增標題字段
    required this.date,
    required this.center,
    required this.isHousePattern,
    required this.scoringMethod,
    required this.inputMethod,
    required this.games,
    required this.createdAt,
    this.oilPatternName,
    this.oilPatternLength,
  });

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
      inputMethod: json['inputMethod'] ?? 'simple', // 預設為 simple
      games:
          (json['games'] as List?)
              ?.map((game) => GameRecord.fromJson(game))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  final String id;
  final String title; // 新增標題字段
  final DateTime date;
  final String center;
  final String? oilPatternName;
  final String? oilPatternLength;
  final bool isHousePattern;
  final String scoringMethod;
  final String inputMethod; // 新增：輸入方式 (simple/advanced)
  final List<GameRecord> games;
  final DateTime createdAt;

  TrainingDaySummary copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? center,
    String? oilPatternName,
    String? oilPatternLength,
    bool? isHousePattern,
    String? scoringMethod,
    String? inputMethod,
    List<GameRecord>? games,
    DateTime? createdAt,
  }) {
    return TrainingDaySummary(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      center: center ?? this.center,
      oilPatternName: oilPatternName ?? this.oilPatternName,
      oilPatternLength: oilPatternLength ?? this.oilPatternLength,
      isHousePattern: isHousePattern ?? this.isHousePattern,
      scoringMethod: scoringMethod ?? this.scoringMethod,
      inputMethod: inputMethod ?? this.inputMethod,
      games: games ?? this.games,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // 計算摘要統計
  int get totalGames => games.length;

  int get averageScore =>
      games.isEmpty
          ? 0
          : (games.map((g) => g.score).reduce((a, b) => a + b) / games.length)
              .round();

  int get highestScore =>
      games.isEmpty
          ? 0
          : games.map((g) => g.score).reduce((a, b) => a > b ? a : b);

  int get lowestScore =>
      games.isEmpty
          ? 0
          : games.map((g) => g.score).reduce((a, b) => a < b ? a : b);

  int get totalStrikes => games.map((g) => g.strikes).fold(0, (a, b) => a + b);

  int get totalSpares => games.map((g) => g.spares).fold(0, (a, b) => a + b);

  double get strikePercentage =>
      totalGames == 0 ? 0.0 : (totalStrikes / (totalGames * 10)) * 100;

  double get sparePercentage =>
      totalGames == 0 ? 0.0 : (totalSpares / (totalGames * 10)) * 100;

  // 獲取所有使用的球具及其使用的局數
  Map<BallInfo, List<int>> get equipmentUsage {
    final usage = <BallInfo, List<int>>{};

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
    } else if (oilPatternName?.isNotEmpty == true ||
        oilPatternLength?.isNotEmpty == true) {
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
      'inputMethod': inputMethod,
      'games': games.map((game) => game.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// 舊的訓練記錄模型（向後兼容）
class TrainingRecord {
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
  final String id;
  final String title;
  final DateTime date;
  final int score;
  final String notes;
  final String? imageUrl;

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
