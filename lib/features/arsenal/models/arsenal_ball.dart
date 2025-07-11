import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/models/ball_bag_type.dart';

part 'arsenal_ball.freezed.dart';
part 'arsenal_ball.g.dart';

@freezed
class ArsenalBall with _$ArsenalBall {
  const factory ArsenalBall({
    required String name,
    required String core,
    required String cover,
    required String layout,
    required String imagePath,
    required String brand,
    required DateTime dateAdded,
    required BallBagType bagType,
  }) = _ArsenalBall;

  factory ArsenalBall.fromJson(Map<String, dynamic> json) => _$ArsenalBallFromJson(json);
}
