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
  @JsonKey(name: 'layout_id')
  String get layoutId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId =>
      throw _privateConstructorUsedError; // Layout measurements (in inches)
  @JsonKey(name: 'pin_to_pap')
  double get pinToPap => throw _privateConstructorUsedError; // Pin到PAP距離
  @JsonKey(name: 'pap_to_mb')
  double get papToMb => throw _privateConstructorUsedError; // PAP到MB距離
  @JsonKey(name: 'psa_angle')
  double get psaAngle => throw _privateConstructorUsedError; // PSA角度 (度)
  @JsonKey(name: 'val_angle')
  double get valAngle => throw _privateConstructorUsedError; // VAL角度 (度)
// Layout classification
  @JsonKey(name: 'layout_type')
  LayoutType get layoutType =>
      throw _privateConstructorUsedError; // Additional layout information
  @JsonKey(name: 'layout_image')
  String? get layoutImage => throw _privateConstructorUsedError; // 鑽法圖片URL或本地路徑
  @JsonKey(name: 'driller_name')
  String? get drillerName => throw _privateConstructorUsedError; // 鑽球師名稱
  @JsonKey(name: 'drilled_date')
  DateTime? get drilledDate => throw _privateConstructorUsedError; // 鑽球日期
  String? get notes => throw _privateConstructorUsedError; // 備註
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
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
      {@JsonKey(name: 'layout_id') String layoutId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'pin_to_pap') double pinToPap,
      @JsonKey(name: 'pap_to_mb') double papToMb,
      @JsonKey(name: 'psa_angle') double psaAngle,
      @JsonKey(name: 'val_angle') double valAngle,
      @JsonKey(name: 'layout_type') LayoutType layoutType,
      @JsonKey(name: 'layout_image') String? layoutImage,
      @JsonKey(name: 'driller_name') String? drillerName,
      @JsonKey(name: 'drilled_date') DateTime? drilledDate,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
      {@JsonKey(name: 'layout_id') String layoutId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'pin_to_pap') double pinToPap,
      @JsonKey(name: 'pap_to_mb') double papToMb,
      @JsonKey(name: 'psa_angle') double psaAngle,
      @JsonKey(name: 'val_angle') double valAngle,
      @JsonKey(name: 'layout_type') LayoutType layoutType,
      @JsonKey(name: 'layout_image') String? layoutImage,
      @JsonKey(name: 'driller_name') String? drillerName,
      @JsonKey(name: 'drilled_date') DateTime? drilledDate,
      String? notes,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
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
      {@JsonKey(name: 'layout_id') required this.layoutId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'pin_to_pap') this.pinToPap = 0.0,
      @JsonKey(name: 'pap_to_mb') this.papToMb = 0.0,
      @JsonKey(name: 'psa_angle') this.psaAngle = 0.0,
      @JsonKey(name: 'val_angle') this.valAngle = 0.0,
      @JsonKey(name: 'layout_type') this.layoutType = LayoutType.control,
      @JsonKey(name: 'layout_image') this.layoutImage,
      @JsonKey(name: 'driller_name') this.drillerName,
      @JsonKey(name: 'drilled_date') this.drilledDate,
      this.notes,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$BallLayoutImpl.fromJson(Map<String, dynamic> json) =>
      _$$BallLayoutImplFromJson(json);

  @override
  @JsonKey(name: 'layout_id')
  final String layoutId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
// Layout measurements (in inches)
  @override
  @JsonKey(name: 'pin_to_pap')
  final double pinToPap;
// Pin到PAP距離
  @override
  @JsonKey(name: 'pap_to_mb')
  final double papToMb;
// PAP到MB距離
  @override
  @JsonKey(name: 'psa_angle')
  final double psaAngle;
// PSA角度 (度)
  @override
  @JsonKey(name: 'val_angle')
  final double valAngle;
// VAL角度 (度)
// Layout classification
  @override
  @JsonKey(name: 'layout_type')
  final LayoutType layoutType;
// Additional layout information
  @override
  @JsonKey(name: 'layout_image')
  final String? layoutImage;
// 鑽法圖片URL或本地路徑
  @override
  @JsonKey(name: 'driller_name')
  final String? drillerName;
// 鑽球師名稱
  @override
  @JsonKey(name: 'drilled_date')
  final DateTime? drilledDate;
// 鑽球日期
  @override
  final String? notes;
// 備註
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
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
          {@JsonKey(name: 'layout_id') required final String layoutId,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'pin_to_pap') final double pinToPap,
          @JsonKey(name: 'pap_to_mb') final double papToMb,
          @JsonKey(name: 'psa_angle') final double psaAngle,
          @JsonKey(name: 'val_angle') final double valAngle,
          @JsonKey(name: 'layout_type') final LayoutType layoutType,
          @JsonKey(name: 'layout_image') final String? layoutImage,
          @JsonKey(name: 'driller_name') final String? drillerName,
          @JsonKey(name: 'drilled_date') final DateTime? drilledDate,
          final String? notes,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$BallLayoutImpl;

  factory _BallLayout.fromJson(Map<String, dynamic> json) =
      _$BallLayoutImpl.fromJson;

  @override
  @JsonKey(name: 'layout_id')
  String get layoutId;
  @override
  @JsonKey(name: 'user_id')
  String get userId; // Layout measurements (in inches)
  @override
  @JsonKey(name: 'pin_to_pap')
  double get pinToPap; // Pin到PAP距離
  @override
  @JsonKey(name: 'pap_to_mb')
  double get papToMb; // PAP到MB距離
  @override
  @JsonKey(name: 'psa_angle')
  double get psaAngle; // PSA角度 (度)
  @override
  @JsonKey(name: 'val_angle')
  double get valAngle; // VAL角度 (度)
// Layout classification
  @override
  @JsonKey(name: 'layout_type')
  LayoutType get layoutType; // Additional layout information
  @override
  @JsonKey(name: 'layout_image')
  String? get layoutImage; // 鑽法圖片URL或本地路徑
  @override
  @JsonKey(name: 'driller_name')
  String? get drillerName; // 鑽球師名稱
  @override
  @JsonKey(name: 'drilled_date')
  DateTime? get drilledDate; // 鑽球日期
  @override
  String? get notes; // 備註
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of BallLayout
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallLayoutImplCopyWith<_$BallLayoutImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
