import 'dart:convert';

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 負責讀取保齡球 JSON 資料的 Service
class BallDataService {
  static List<BowlingBall>? _cachedBalls;

  static Future<List<BowlingBall>> loadBallData() async {
    if (_cachedBalls != null) {
      return _cachedBalls!;
    }
    final response = await rootBundle.loadString(
      'assets/bowling_ball_data.json',
    );
    final List<dynamic> data = json.decode(response);

    final balls = data.map((e) => BowlingBall.fromJson(e)).toList();
    _cachedBalls = balls;
    return balls;
  }
}
