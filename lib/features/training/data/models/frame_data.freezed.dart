// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'frame_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FrameData _$FrameDataFromJson(Map<String, dynamic> json) {
  return _FrameData.fromJson(json);
}

/// @nodoc
mixin _$FrameData {
  int get frameNumber => throw _privateConstructorUsedError; // 1-10
  int get ball1 => throw _privateConstructorUsedError;
  int get ball2 => throw _privateConstructorUsedError;
  int? get ball3 => throw _privateConstructorUsedError;

  /// Serializes this FrameData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FrameData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FrameDataCopyWith<FrameData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FrameDataCopyWith<$Res> {
  factory $FrameDataCopyWith(FrameData value, $Res Function(FrameData) then) =
      _$FrameDataCopyWithImpl<$Res, FrameData>;
  @useResult
  $Res call({int frameNumber, int ball1, int ball2, int? ball3});
}

/// @nodoc
class _$FrameDataCopyWithImpl<$Res, $Val extends FrameData>
    implements $FrameDataCopyWith<$Res> {
  _$FrameDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FrameData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameNumber = null,
    Object? ball1 = null,
    Object? ball2 = null,
    Object? ball3 = freezed,
  }) {
    return _then(_value.copyWith(
      frameNumber: null == frameNumber
          ? _value.frameNumber
          : frameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      ball1: null == ball1
          ? _value.ball1
          : ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      ball2: null == ball2
          ? _value.ball2
          : ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      ball3: freezed == ball3
          ? _value.ball3
          : ball3 // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FrameDataImplCopyWith<$Res>
    implements $FrameDataCopyWith<$Res> {
  factory _$$FrameDataImplCopyWith(
          _$FrameDataImpl value, $Res Function(_$FrameDataImpl) then) =
      __$$FrameDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int frameNumber, int ball1, int ball2, int? ball3});
}

/// @nodoc
class __$$FrameDataImplCopyWithImpl<$Res>
    extends _$FrameDataCopyWithImpl<$Res, _$FrameDataImpl>
    implements _$$FrameDataImplCopyWith<$Res> {
  __$$FrameDataImplCopyWithImpl(
      _$FrameDataImpl _value, $Res Function(_$FrameDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of FrameData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frameNumber = null,
    Object? ball1 = null,
    Object? ball2 = null,
    Object? ball3 = freezed,
  }) {
    return _then(_$FrameDataImpl(
      frameNumber: null == frameNumber
          ? _value.frameNumber
          : frameNumber // ignore: cast_nullable_to_non_nullable
              as int,
      ball1: null == ball1
          ? _value.ball1
          : ball1 // ignore: cast_nullable_to_non_nullable
              as int,
      ball2: null == ball2
          ? _value.ball2
          : ball2 // ignore: cast_nullable_to_non_nullable
              as int,
      ball3: freezed == ball3
          ? _value.ball3
          : ball3 // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FrameDataImpl implements _FrameData {
  const _$FrameDataImpl(
      {required this.frameNumber, this.ball1 = 0, this.ball2 = 0, this.ball3});

  factory _$FrameDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$FrameDataImplFromJson(json);

  @override
  final int frameNumber;
// 1-10
  @override
  @JsonKey()
  final int ball1;
  @override
  @JsonKey()
  final int ball2;
  @override
  final int? ball3;

  @override
  String toString() {
    return 'FrameData(frameNumber: $frameNumber, ball1: $ball1, ball2: $ball2, ball3: $ball3)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FrameDataImpl &&
            (identical(other.frameNumber, frameNumber) ||
                other.frameNumber == frameNumber) &&
            (identical(other.ball1, ball1) || other.ball1 == ball1) &&
            (identical(other.ball2, ball2) || other.ball2 == ball2) &&
            (identical(other.ball3, ball3) || other.ball3 == ball3));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, frameNumber, ball1, ball2, ball3);

  /// Create a copy of FrameData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FrameDataImplCopyWith<_$FrameDataImpl> get copyWith =>
      __$$FrameDataImplCopyWithImpl<_$FrameDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FrameDataImplToJson(
      this,
    );
  }
}

abstract class _FrameData implements FrameData {
  const factory _FrameData(
      {required final int frameNumber,
      final int ball1,
      final int ball2,
      final int? ball3}) = _$FrameDataImpl;

  factory _FrameData.fromJson(Map<String, dynamic> json) =
      _$FrameDataImpl.fromJson;

  @override
  int get frameNumber; // 1-10
  @override
  int get ball1;
  @override
  int get ball2;
  @override
  int? get ball3;

  /// Create a copy of FrameData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FrameDataImplCopyWith<_$FrameDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
