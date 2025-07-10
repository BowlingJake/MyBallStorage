import 'dart:convert';
import 'dart:developer';

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 負責讀取保齡球 JSON 資料的 Service
class BallDataService {
  List<BowlingBall>? _cachedBalls;

  Future<List<BowlingBall>> loadBallData() async {
    if (_cachedBalls != null) {
      return _cachedBalls!;
    }

    try {
      final response = await rootBundle.loadString(
        'assets/bowling_ball_data.json',
      );
      final List<dynamic> data = json.decode(response);

      final balls = data.map((e) => BowlingBall.fromJson(e)).toList();
      _cachedBalls = balls;
      return balls;
    } catch (e, stackTrace) {
      log(
        'Failed to load or parse ball data.',
        error: e,
        stackTrace: stackTrace,
        name: 'BallDataService',
      );
      // 在生產環境中，你可能希望回傳一個空列表或重新拋出一個更具體的錯誤
      return [];
    }
  }
}
