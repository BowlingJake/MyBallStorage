// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_layout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BallLayout _$BallLayoutFromJson(Map<String, dynamic> json) {
  return _BallLayout.fromJson(json);
}

/// @nodoc
mixin _$BallLayout {
  String get layoutId => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // Layout measurements (in inches)
  double get pinToPap => throw _privateConstructorUsedError; // Pin到PAP距離
  double get papToMb => throw _privateConstructorUsedError; // PAP到MB距離
  double get psaAngle => throw _privateConstructorUsedError; // PSA角度 (度)
  double get valAngle => throw _privateConstructorUsedError; // VAL角度 (度)
// Layout classification
  LayoutType get layoutType =>
      throw _privateConstructorUsedError; // Additional layout information
  String? get layoutImage => throw _privateConstructorUsedError; // 鑽法圖片URL或本地路徑
  String? get drillerName => throw _privateConstructorUsedError; // 鑽球師名稱
  DateTime? get drilledDate => throw _privateConstructorUsedError; // 鑽球日期
  String? get notes => throw _privateConstructorUsedError; // 備註
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BallLayout to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallLayoutCopyWith<BallLayout> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallLayoutCopyWith<$Res> {
  factory $BallLayoutCopyWith(
          BallLayout value, $Res Function(BallLayout) then) =
      _$BallLayoutCopyWithImpl<$Res, BallLayout>;
  @useResult
  $Res call(
      {String layoutId,
      String userId,
      double pinToPap,
      double papToMb,
      double psaAngle,
      double valAngle,
      LayoutType layoutType,
      String? layoutImage,
      String? drillerName,
      DateTime? drilledDate,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BallLayoutCopyWithImpl<$Res, $Val extends BallLayout>
    implements $BallLayoutCopyWith<$Res> {
  _$BallLayoutCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? layoutId = null,
    Object? userId = null,
    Object? pinToPap = null,
    Object? papToMb = null,
    Object? psaAngle = null,
    Object? valAngle = null,
    Object? layoutType = null,
    Object? layoutImage = freezed,
    Object? drillerName = freezed,
    Object? drilledDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      layoutId: null == layoutId
          ? _value.layoutId
          : layoutId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pinToPap: null == pinToPap
          ? _value.pinToPap
          : pinToPap // ignore: cast_nullable_to_non_nullable
              as double,
      papToMb: null == papToMb
          ? _value.papToMb
          : papToMb // ignore: cast_nullable_to_non_nullable
              as double,
      psaAngle: null == psaAngle
          ? _value.psaAngle
          : psaAngle // ignore: cast_nullable_to_non_nullable
              as double,
      valAngle: null == valAngle
          ? _value.valAngle
          : valAngle // ignore: cast_nullable_to_non_nullable
              as double,
      layoutType: null == layoutType
          ? _value.layoutType
          : layoutType // ignore: cast_nullable_to_non_nullable
              as LayoutType,
      layoutImage: freezed == layoutImage
          ? _value.layoutImage
          : layoutImage // ignore: cast_nullable_to_non_nullable
              as String?,
      drillerName: freezed == drillerName
          ? _value.drillerName
          : drillerName // ignore: cast_nullable_to_non_nullable
              as String?,
      drilledDate: freezed == drilledDate
          ? _value.drilledDate
          : drilledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BallLayoutImplCopyWith<$Res>
    implements $BallLayoutCopyWith<$Res> {
  factory _$$BallLayoutImplCopyWith(
          _$BallLayoutImpl value, $Res Function(_$BallLayoutImpl) then) =
      __$$BallLayoutImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String layoutId,
      String userId,
      double pinToPap,
      double papToMb,
      double psaAngle,
      double valAngle,
      LayoutType layoutType,
      String? layoutImage,
      String? drillerName,
      DateTime? drilledDate,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BallLayoutImplCopyWithImpl<$Res>
    extends _$BallLayoutCopyWithImpl<$Res, _$BallLayoutImpl>
    implements _$$BallLayoutImplCopyWith<$Res> {
  __$$BallLayoutImplCopyWithImpl(
      _$BallLayoutImpl _value, $Res Function(_$BallLayoutImpl) _then)
      : super(_value, _then);

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? layoutId = null,
    Object? userId = null,
    Object? pinToPap = null,
    Object? papToMb = null,
    Object? psaAngle = null,
    Object? valAngle = null,
    Object? layoutType = null,
    Object? layoutImage = freezed,
    Object? drillerName = freezed,
    Object? drilledDate = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BallLayoutImpl(
      layoutId: null == layoutId
          ? _value.layoutId
          : layoutId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pinToPap: null == pinToPap
          ? _value.pinToPap
          : pinToPap // ignore: cast_nullable_to_non_nullable
              as double,
      papToMb: null == papToMb
          ? _value.papToMb
          : papToMb // ignore: cast_nullable_to_non_nullable
              as double,
      psaAngle: null == psaAngle
          ? _value.psaAngle
          : psaAngle // ignore: cast_nullable_to_non_nullable
              as double,
      valAngle: null == valAngle
          ? _value.valAngle
          : valAngle // ignore: cast_nullable_to_non_nullable
              as double,
      layoutType: null == layoutType
          ? _value.layoutType
          : layoutType // ignore: cast_nullable_to_non_nullable
              as LayoutType,
      layoutImage: freezed == layoutImage
          ? _value.layoutImage
          : layoutImage // ignore: cast_nullable_to_non_nullable
              as String?,
      drillerName: freezed == drillerName
          ? _value.drillerName
          : drillerName // ignore: cast_nullable_to_non_nullable
              as String?,
      drilledDate: freezed == drilledDate
          ? _value.drilledDate
          : drilledDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BallLayoutImpl implements _BallLayout {
  const _$BallLayoutImpl(
      {required this.layoutId,
      required this.userId,
      this.pinToPap = 0.0,
      this.papToMb = 0.0,
      this.psaAngle = 0.0,
      this.valAngle = 0.0,
      this.layoutType = LayoutType.control,
      this.layoutImage,
      this.drillerName,
      this.drilledDate,
      this.notes,
      required this.createdAt,
      this.updatedAt});

  factory _$BallLayoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$BallLayoutImplFromJson(json);

  @override
  final String layoutId;
  @override
  final String userId;
// Layout measurements (in inches)
  @override
  @JsonKey()
  final double pinToPap;
// Pin到PAP距離
  @override
  @JsonKey()
  final double papToMb;
// PAP到MB距離
  @override
  @JsonKey()
  final double psaAngle;
// PSA角度 (度)
  @override
  @JsonKey()
  final double valAngle;
// VAL角度 (度)
// Layout classification
  @override
  @JsonKey()
  final LayoutType layoutType;
// Additional layout information
  @override
  final String? layoutImage;
// 鑽法圖片URL或本地路徑
  @override
  final String? drillerName;
// 鑽球師名稱
  @override
  final DateTime? drilledDate;
// 鑽球日期
  @override
  final String? notes;
// 備註
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BallLayout(layoutId: $layoutId, userId: $userId, pinToPap: $pinToPap, papToMb: $papToMb, psaAngle: $psaAngle, valAngle: $valAngle, layoutType: $layoutType, layoutImage: $layoutImage, drillerName: $drillerName, drilledDate: $drilledDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallLayoutImpl &&
            (identical(other.layoutId, layoutId) ||
                other.layoutId == layoutId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pinToPap, pinToPap) ||
                other.pinToPap == pinToPap) &&
            (identical(other.papToMb, papToMb) || other.papToMb == papToMb) &&
            (identical(other.psaAngle, psaAngle) ||
                other.psaAngle == psaAngle) &&
            (identical(other.valAngle, valAngle) ||
                other.valAngle == valAngle) &&
            (identical(other.layoutType, layoutType) ||
                other.layoutType == layoutType) &&
            (identical(other.layoutImage, layoutImage) ||
                other.layoutImage == layoutImage) &&
            (identical(other.drillerName, drillerName) ||
                other.drillerName == drillerName) &&
            (identical(other.drilledDate, drilledDate) ||
                other.drilledDate == drilledDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      layoutId,
      userId,
      pinToPap,
      papToMb,
      psaAngle,
      valAngle,
      layoutType,
      layoutImage,
      drillerName,
      drilledDate,
      notes,
      createdAt,
      updatedAt);

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallLayoutImplCopyWith<_$BallLayoutImpl> get copyWith =>
      __$$BallLayoutImplCopyWithImpl<_$BallLayoutImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BallLayoutImplToJson(
      this,
    );
  }
}

abstract class _BallLayout implements BallLayout {
  const factory _BallLayout(
      {required final String layoutId,
      required final String userId,
      final double pinToPap,
      final double papToMb,
      final double psaAngle,
      final double valAngle,
      final LayoutType layoutType,
      final String? layoutImage,
      final String? drillerName,
      final DateTime? drilledDate,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$BallLayoutImpl;

  factory _BallLayout.fromJson(Map<String, dynamic> json) =
      _$BallLayoutImpl.fromJson;

  @override
  String get layoutId;
  @override
  String get userId; // Layout measurements (in inches)
  @override
  double get pinToPap; // Pin到PAP距離
  @override
  double get papToMb; // PAP到MB距離
  @override
  double get psaAngle; // PSA角度 (度)
  @override
  double get valAngle; // VAL角度 (度)
// Layout classification
  @override
  LayoutType get layoutType; // Additional layout information
  @override
  String? get layoutImage; // 鑽法圖片URL或本地路徑
  @override
  String? get drillerName; // 鑽球師名稱
  @override
  DateTime? get drilledDate; // 鑽球日期
  @override
  String? get notes; // 備註
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallLayoutImplCopyWith<_$BallLayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
