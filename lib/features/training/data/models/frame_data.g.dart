// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frame_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FrameDataImpl _$$FrameDataImplFromJson(Map<String, dynamic> json) =>
    _$FrameDataImpl(
      frameNumber: (json['frameNumber'] as num).toInt(),
      ball1: (json['ball1'] as num?)?.toInt() ?? 0,
      ball2: (json['ball2'] as num?)?.toInt() ?? 0,
      ball3: (json['ball3'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FrameDataImplToJson(_$FrameDataImpl instance) =>
    <String, dynamic>{
      'frameNumber': instance.frameNumber,
      'ball1': instance.ball1,
      'ball2': instance.ball2,
      'ball3': instance.ball3,
    };
