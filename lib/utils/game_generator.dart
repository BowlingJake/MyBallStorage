import 'dart:math' as math;
import 'package:bowlingarsenal_app/features/training/models/training_record.dart';

/// 遊戲數據生成器
/// 負責生成隨機的遊戲記錄和球具資訊
class GameGenerator {
  static final math.Random _random = math.Random();

  // 預設分數範圍
  static const List<int> _scoreRanges = [
    150,
    165,
    178,
    185,
    192,
    201,
    210,
    225,
    240,
    255,
  ];

  // 可用球具清單
  static const List<BallInfo> _availableBalls = [
    BallInfo(
      id: 'ball_1',
      name: 'Phaze II',
      brand: 'Storm',
      brandColor: '#FF6B35',
    ),
    BallInfo(
      id: 'ball_2',
      name: 'Purple Hammer',
      brand: 'Hammer',
      brandColor: '#8B5A96',
    ),
    BallInfo(
      id: 'ball_3',
      name: 'Idol',
      brand: 'Roto Grip',
      brandColor: '#E31F26',
    ),
    BallInfo(
      id: 'ball_4',
      name: 'Astro PhysiX',
      brand: 'Storm',
      brandColor: '#FF6B35',
    ),
    BallInfo(
      id: 'ball_5',
      name: 'Hustle Ink',
      brand: 'Roto Grip',
      brandColor: '#E31F26',
    ),
    BallInfo(
      id: 'ball_6',
      name: 'IQ Tour Emerald',
      brand: 'Storm',
      brandColor: '#FF6B35',
    ),
  ];

  // 備註模板
  static const Map<String, List<String>> _noteTemplates = {
    'excellent': [
      'Personal best today!',
      'Great improvement!',
      'Excellent performance',
      'Amazing consistency',
      'Perfect timing!',
    ],
    'good': [
      'Great improvement on strikes',
      'Consistent performance',
      'Good ball control',
      'Nice spare conversions',
      'Solid fundamentals',
    ],
    'average': [
      'Good start, need to work on 7-10 split',
      'Focus on spare conversion',
      'Working on consistency',
      'Better approach timing',
      'Need more practice on spares',
    ],
  };

  /// 創建預設遊戲記錄
  static GameRecord createDefaultGame(String dayId, int gameNumber) {
    final now = DateTime.now();

    // 生成隨機分數
    final score = _scoreRanges[_random.nextInt(_scoreRanges.length)];

    // 根據分數生成相應的統計
    final stats = _generateStats(score);

    // 生成分數明細
    final frameScores = _generateFrameScores(score);

    // 生成備註
    final notes = _generateNote(score);

    // 生成球具
    final ballUsed = _generateRandomBall();

    return GameRecord(
      id: '${dayId}_game_${now.millisecondsSinceEpoch}',
      gameNumber: gameNumber,
      score: score,
      frameScores: frameScores,
      strikes: stats['strikes']!,
      spares: stats['spares']!,
      notes: notes,
      timestamp: now,
      ballUsed: ballUsed,
    );
  }

  /// 根據分數生成相應的統計資料
  static Map<String, int> _generateStats(int score) {
    var strikes = 0;
    var spares = 0;

    if (score >= 240) {
      strikes = _random.nextInt(3) + 8; // 8-10 strikes
      spares = _random.nextInt(2); // 0-1 spares
    } else if (score >= 200) {
      strikes = _random.nextInt(3) + 5; // 5-7 strikes
      spares = _random.nextInt(3) + 1; // 1-3 spares
    } else if (score >= 170) {
      strikes = _random.nextInt(3) + 3; // 3-5 strikes
      spares = _random.nextInt(4) + 2; // 2-5 spares
    } else {
      strikes = _random.nextInt(3) + 1; // 1-3 strikes
      spares = _random.nextInt(5) + 3; // 3-7 spares
    }

    return {'strikes': strikes, 'spares': spares};
  }

  /// 生成分數明細
  static List<int> _generateFrameScores(int score) {
    final averagePerFrame = score / 10;
    return List.generate(10, (index) => averagePerFrame.round());
  }

  /// 生成隨機備註
  static String _generateNote(int score) {
    String category;
    if (score >= 200) {
      category = 'excellent';
    } else if (score >= 170) {
      category = 'good';
    } else {
      category = 'average';
    }

    final notes = _noteTemplates[category]!;
    return notes[_random.nextInt(notes.length)];
  }

  /// 生成隨機球具
  static BallInfo _generateRandomBall() {
    return _availableBalls[_random.nextInt(_availableBalls.length)];
  }

  /// 獲取所有可用球具
  static List<BallInfo> get availableBalls =>
      List.unmodifiable(_availableBalls);

  /// 根據品牌獲取球具
  static List<BallInfo> getBallsByBrand(String brand) {
    return _availableBalls.where((ball) => ball.brand == brand).toList();
  }

  /// 獲取所有品牌
  static List<String> get availableBrands {
    return _availableBalls.map((ball) => ball.brand).toSet().toList();
  }
}
