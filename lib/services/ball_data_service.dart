import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/bowling_ball.dart';

/// 負責讀取保齡球 JSON 資料的 Service
class BallDataService {
  static Future<List<BowlingBall>> loadBallData() async {
    final String response = await rootBundle.loadString('assets/bowling_ball_data.json');
    final List<dynamic> data = json.decode(response);

    return data.map((e) => BowlingBall.fromJson(e)).toList();
  }
}
