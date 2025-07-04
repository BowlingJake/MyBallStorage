import 'dart:convert';

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:flutter/services.dart' show rootBundle;

/// 負責讀取保齡球 JSON 資料的 Service
class BallDataService {
  static Future<List<BowlingBall>> loadBallData() async {
    final response = await rootBundle.loadString('assets/bowling_ball_data.json');
    final List<dynamic> data = json.decode(response);

    return data.map((e) => BowlingBall.fromJson(e)).toList();
  }
}
