import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bowlingarsenal_app/features/training/data/models/game.dart';

part 'frame_data.freezed.dart';
part 'frame_data.g.dart';

/// 單一 Frame 的資料結構
@freezed
class FrameData with _$FrameData {
  const factory FrameData({
    required int frameNumber, // 1-10
    @Default(0) int ball1,
    @Default(0) int ball2,
    int? ball3, // 只有第10格可能有第3球
  }) = _FrameData;

  factory FrameData.fromJson(Map<String, dynamic> json) => _$FrameDataFromJson(json);
}

/// 擴充 Game 模型的輔助方法
extension GameFrameExtension on Game {
  /// 將新的個別欄位轉換為 FrameData 列表
  List<FrameData> get frames => [
    FrameData(frameNumber: 1, ball1: frame1Ball1, ball2: frame1Ball2),
    FrameData(frameNumber: 2, ball1: frame2Ball1, ball2: frame2Ball2),
    FrameData(frameNumber: 3, ball1: frame3Ball1, ball2: frame3Ball2),
    FrameData(frameNumber: 4, ball1: frame4Ball1, ball2: frame4Ball2),
    FrameData(frameNumber: 5, ball1: frame5Ball1, ball2: frame5Ball2),
    FrameData(frameNumber: 6, ball1: frame6Ball1, ball2: frame6Ball2),
    FrameData(frameNumber: 7, ball1: frame7Ball1, ball2: frame7Ball2),
    FrameData(frameNumber: 8, ball1: frame8Ball1, ball2: frame8Ball2),
    FrameData(frameNumber: 9, ball1: frame9Ball1, ball2: frame9Ball2),
    FrameData(frameNumber: 10, ball1: frame10Ball1, ball2: frame10Ball2, ball3: frame10Ball3),
  ];

  /// 更新特定 frame 的資料
  Game updateFrame(int frameNumber, FrameData frameData) {
    switch (frameNumber) {
      case 1: return copyWith(frame1Ball1: frameData.ball1, frame1Ball2: frameData.ball2);
      case 2: return copyWith(frame2Ball1: frameData.ball1, frame2Ball2: frameData.ball2);
      case 3: return copyWith(frame3Ball1: frameData.ball1, frame3Ball2: frameData.ball2);
      case 4: return copyWith(frame4Ball1: frameData.ball1, frame4Ball2: frameData.ball2);
      case 5: return copyWith(frame5Ball1: frameData.ball1, frame5Ball2: frameData.ball2);
      case 6: return copyWith(frame6Ball1: frameData.ball1, frame6Ball2: frameData.ball2);
      case 7: return copyWith(frame7Ball1: frameData.ball1, frame7Ball2: frameData.ball2);
      case 8: return copyWith(frame8Ball1: frameData.ball1, frame8Ball2: frameData.ball2);
      case 9: return copyWith(frame9Ball1: frameData.ball1, frame9Ball2: frameData.ball2);
      case 10: return copyWith(
        frame10Ball1: frameData.ball1, 
        frame10Ball2: frameData.ball2, 
        frame10Ball3: frameData.ball3,
      );
      default: return this;
    }
  }

  /// 獲取特定 frame 的資料
  FrameData getFrame(int frameNumber) {
    return frames[frameNumber - 1];
  }
}