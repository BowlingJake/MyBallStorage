// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError; // 球袋名稱設定 (1-9)
  @JsonKey(name: 'bag_1_name')
  String get bag1Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_2_name')
  String? get bag2Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_3_name')
  String? get bag3Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_4_name')
  String? get bag4Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_5_name')
  String? get bag5Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_6_name')
  String? get bag6Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_7_name')
  String? get bag7Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_8_name')
  String? get bag8Name => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_9_name')
  String? get bag9Name => throw _privateConstructorUsedError; // 球袋開通狀態 (1-9)
  @JsonKey(name: 'bag_1_unlocked')
  bool get bag1Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_2_unlocked')
  bool get bag2Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_3_unlocked')
  bool get bag3Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_4_unlocked')
  bool get bag4Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_5_unlocked')
  bool get bag5Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_6_unlocked')
  bool get bag6Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_7_unlocked')
  bool get bag7Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_8_unlocked')
  bool get bag8Unlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'bag_9_unlocked')
  bool get bag9Unlocked => throw _privateConstructorUsedError; // 個人資料
  String? get nickname =>
      throw _privateConstructorUsedError; // bowler's name (display name)
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError; // 頭像URL
  String? get country => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'dominate_hand')
  String? get dominateHand => throw _privateConstructorUsedError;
  String? get style => throw _privateConstructorUsedError; // bowling style
  @JsonKey(name: 'PAP_integer')
  int? get papInteger => throw _privateConstructorUsedError;
  @JsonKey(name: 'PAP_fraction')
  String? get papFraction => throw _privateConstructorUsedError;
  @JsonKey(name: 'PAP_direction')
  int? get papDirection =>
      throw _privateConstructorUsedError; // 0=none, 1=up, -1=down
  @JsonKey(name: 'PAP_drift_integer')
  int? get papDriftInteger => throw _privateConstructorUsedError;
  @JsonKey(name: 'PAP_drift_fraction')
  String? get papDriftFraction => throw _privateConstructorUsedError; // 其他用戶設定
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      String? username,
      @JsonKey(name: 'bag_1_name') String bag1Name,
      @JsonKey(name: 'bag_2_name') String? bag2Name,
      @JsonKey(name: 'bag_3_name') String? bag3Name,
      @JsonKey(name: 'bag_4_name') String? bag4Name,
      @JsonKey(name: 'bag_5_name') String? bag5Name,
      @JsonKey(name: 'bag_6_name') String? bag6Name,
      @JsonKey(name: 'bag_7_name') String? bag7Name,
      @JsonKey(name: 'bag_8_name') String? bag8Name,
      @JsonKey(name: 'bag_9_name') String? bag9Name,
      @JsonKey(name: 'bag_1_unlocked') bool bag1Unlocked,
      @JsonKey(name: 'bag_2_unlocked') bool bag2Unlocked,
      @JsonKey(name: 'bag_3_unlocked') bool bag3Unlocked,
      @JsonKey(name: 'bag_4_unlocked') bool bag4Unlocked,
      @JsonKey(name: 'bag_5_unlocked') bool bag5Unlocked,
      @JsonKey(name: 'bag_6_unlocked') bool bag6Unlocked,
      @JsonKey(name: 'bag_7_unlocked') bool bag7Unlocked,
      @JsonKey(name: 'bag_8_unlocked') bool bag8Unlocked,
      @JsonKey(name: 'bag_9_unlocked') bool bag9Unlocked,
      String? nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? country,
      String? city,
      @JsonKey(name: 'dominate_hand') String? dominateHand,
      String? style,
      @JsonKey(name: 'PAP_integer') int? papInteger,
      @JsonKey(name: 'PAP_fraction') String? papFraction,
      @JsonKey(name: 'PAP_direction') int? papDirection,
      @JsonKey(name: 'PAP_drift_integer') int? papDriftInteger,
      @JsonKey(name: 'PAP_drift_fraction') String? papDriftFraction,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? username = freezed,
    Object? bag1Name = null,
    Object? bag2Name = freezed,
    Object? bag3Name = freezed,
    Object? bag4Name = freezed,
    Object? bag5Name = freezed,
    Object? bag6Name = freezed,
    Object? bag7Name = freezed,
    Object? bag8Name = freezed,
    Object? bag9Name = freezed,
    Object? bag1Unlocked = null,
    Object? bag2Unlocked = null,
    Object? bag3Unlocked = null,
    Object? bag4Unlocked = null,
    Object? bag5Unlocked = null,
    Object? bag6Unlocked = null,
    Object? bag7Unlocked = null,
    Object? bag8Unlocked = null,
    Object? bag9Unlocked = null,
    Object? nickname = freezed,
    Object? avatarUrl = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? dominateHand = freezed,
    Object? style = freezed,
    Object? papInteger = freezed,
    Object? papFraction = freezed,
    Object? papDirection = freezed,
    Object? papDriftInteger = freezed,
    Object? papDriftFraction = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      bag1Name: null == bag1Name
          ? _value.bag1Name
          : bag1Name // ignore: cast_nullable_to_non_nullable
              as String,
      bag2Name: freezed == bag2Name
          ? _value.bag2Name
          : bag2Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag3Name: freezed == bag3Name
          ? _value.bag3Name
          : bag3Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag4Name: freezed == bag4Name
          ? _value.bag4Name
          : bag4Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag5Name: freezed == bag5Name
          ? _value.bag5Name
          : bag5Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag6Name: freezed == bag6Name
          ? _value.bag6Name
          : bag6Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag7Name: freezed == bag7Name
          ? _value.bag7Name
          : bag7Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag8Name: freezed == bag8Name
          ? _value.bag8Name
          : bag8Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag9Name: freezed == bag9Name
          ? _value.bag9Name
          : bag9Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag1Unlocked: null == bag1Unlocked
          ? _value.bag1Unlocked
          : bag1Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag2Unlocked: null == bag2Unlocked
          ? _value.bag2Unlocked
          : bag2Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag3Unlocked: null == bag3Unlocked
          ? _value.bag3Unlocked
          : bag3Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag4Unlocked: null == bag4Unlocked
          ? _value.bag4Unlocked
          : bag4Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag5Unlocked: null == bag5Unlocked
          ? _value.bag5Unlocked
          : bag5Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag6Unlocked: null == bag6Unlocked
          ? _value.bag6Unlocked
          : bag6Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag7Unlocked: null == bag7Unlocked
          ? _value.bag7Unlocked
          : bag7Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag8Unlocked: null == bag8Unlocked
          ? _value.bag8Unlocked
          : bag8Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag9Unlocked: null == bag9Unlocked
          ? _value.bag9Unlocked
          : bag9Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      dominateHand: freezed == dominateHand
          ? _value.dominateHand
          : dominateHand // ignore: cast_nullable_to_non_nullable
              as String?,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String?,
      papInteger: freezed == papInteger
          ? _value.papInteger
          : papInteger // ignore: cast_nullable_to_non_nullable
              as int?,
      papFraction: freezed == papFraction
          ? _value.papFraction
          : papFraction // ignore: cast_nullable_to_non_nullable
              as String?,
      papDirection: freezed == papDirection
          ? _value.papDirection
          : papDirection // ignore: cast_nullable_to_non_nullable
              as int?,
      papDriftInteger: freezed == papDriftInteger
          ? _value.papDriftInteger
          : papDriftInteger // ignore: cast_nullable_to_non_nullable
              as int?,
      papDriftFraction: freezed == papDriftFraction
          ? _value.papDriftFraction
          : papDriftFraction // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'user_id') String userId,
      String? username,
      @JsonKey(name: 'bag_1_name') String bag1Name,
      @JsonKey(name: 'bag_2_name') String? bag2Name,
      @JsonKey(name: 'bag_3_name') String? bag3Name,
      @JsonKey(name: 'bag_4_name') String? bag4Name,
      @JsonKey(name: 'bag_5_name') String? bag5Name,
      @JsonKey(name: 'bag_6_name') String? bag6Name,
      @JsonKey(name: 'bag_7_name') String? bag7Name,
      @JsonKey(name: 'bag_8_name') String? bag8Name,
      @JsonKey(name: 'bag_9_name') String? bag9Name,
      @JsonKey(name: 'bag_1_unlocked') bool bag1Unlocked,
      @JsonKey(name: 'bag_2_unlocked') bool bag2Unlocked,
      @JsonKey(name: 'bag_3_unlocked') bool bag3Unlocked,
      @JsonKey(name: 'bag_4_unlocked') bool bag4Unlocked,
      @JsonKey(name: 'bag_5_unlocked') bool bag5Unlocked,
      @JsonKey(name: 'bag_6_unlocked') bool bag6Unlocked,
      @JsonKey(name: 'bag_7_unlocked') bool bag7Unlocked,
      @JsonKey(name: 'bag_8_unlocked') bool bag8Unlocked,
      @JsonKey(name: 'bag_9_unlocked') bool bag9Unlocked,
      String? nickname,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String? country,
      String? city,
      @JsonKey(name: 'dominate_hand') String? dominateHand,
      String? style,
      @JsonKey(name: 'PAP_integer') int? papInteger,
      @JsonKey(name: 'PAP_fraction') String? papFraction,
      @JsonKey(name: 'PAP_direction') int? papDirection,
      @JsonKey(name: 'PAP_drift_integer') int? papDriftInteger,
      @JsonKey(name: 'PAP_drift_fraction') String? papDriftFraction,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? username = freezed,
    Object? bag1Name = null,
    Object? bag2Name = freezed,
    Object? bag3Name = freezed,
    Object? bag4Name = freezed,
    Object? bag5Name = freezed,
    Object? bag6Name = freezed,
    Object? bag7Name = freezed,
    Object? bag8Name = freezed,
    Object? bag9Name = freezed,
    Object? bag1Unlocked = null,
    Object? bag2Unlocked = null,
    Object? bag3Unlocked = null,
    Object? bag4Unlocked = null,
    Object? bag5Unlocked = null,
    Object? bag6Unlocked = null,
    Object? bag7Unlocked = null,
    Object? bag8Unlocked = null,
    Object? bag9Unlocked = null,
    Object? nickname = freezed,
    Object? avatarUrl = freezed,
    Object? country = freezed,
    Object? city = freezed,
    Object? dominateHand = freezed,
    Object? style = freezed,
    Object? papInteger = freezed,
    Object? papFraction = freezed,
    Object? papDirection = freezed,
    Object? papDriftInteger = freezed,
    Object? papDriftFraction = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      bag1Name: null == bag1Name
          ? _value.bag1Name
          : bag1Name // ignore: cast_nullable_to_non_nullable
              as String,
      bag2Name: freezed == bag2Name
          ? _value.bag2Name
          : bag2Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag3Name: freezed == bag3Name
          ? _value.bag3Name
          : bag3Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag4Name: freezed == bag4Name
          ? _value.bag4Name
          : bag4Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag5Name: freezed == bag5Name
          ? _value.bag5Name
          : bag5Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag6Name: freezed == bag6Name
          ? _value.bag6Name
          : bag6Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag7Name: freezed == bag7Name
          ? _value.bag7Name
          : bag7Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag8Name: freezed == bag8Name
          ? _value.bag8Name
          : bag8Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag9Name: freezed == bag9Name
          ? _value.bag9Name
          : bag9Name // ignore: cast_nullable_to_non_nullable
              as String?,
      bag1Unlocked: null == bag1Unlocked
          ? _value.bag1Unlocked
          : bag1Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag2Unlocked: null == bag2Unlocked
          ? _value.bag2Unlocked
          : bag2Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag3Unlocked: null == bag3Unlocked
          ? _value.bag3Unlocked
          : bag3Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag4Unlocked: null == bag4Unlocked
          ? _value.bag4Unlocked
          : bag4Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag5Unlocked: null == bag5Unlocked
          ? _value.bag5Unlocked
          : bag5Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag6Unlocked: null == bag6Unlocked
          ? _value.bag6Unlocked
          : bag6Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag7Unlocked: null == bag7Unlocked
          ? _value.bag7Unlocked
          : bag7Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag8Unlocked: null == bag8Unlocked
          ? _value.bag8Unlocked
          : bag8Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      bag9Unlocked: null == bag9Unlocked
          ? _value.bag9Unlocked
          : bag9Unlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      dominateHand: freezed == dominateHand
          ? _value.dominateHand
          : dominateHand // ignore: cast_nullable_to_non_nullable
              as String?,
      style: freezed == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as String?,
      papInteger: freezed == papInteger
          ? _value.papInteger
          : papInteger // ignore: cast_nullable_to_non_nullable
              as int?,
      papFraction: freezed == papFraction
          ? _value.papFraction
          : papFraction // ignore: cast_nullable_to_non_nullable
              as String?,
      papDirection: freezed == papDirection
          ? _value.papDirection
          : papDirection // ignore: cast_nullable_to_non_nullable
              as int?,
      papDriftInteger: freezed == papDriftInteger
          ? _value.papDriftInteger
          : papDriftInteger // ignore: cast_nullable_to_non_nullable
              as int?,
      papDriftFraction: freezed == papDriftFraction
          ? _value.papDriftFraction
          : papDriftFraction // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {this.id,
      @JsonKey(name: 'user_id') required this.userId,
      this.username,
      @JsonKey(name: 'bag_1_name') this.bag1Name = 'All My Arsenal',
      @JsonKey(name: 'bag_2_name') this.bag2Name,
      @JsonKey(name: 'bag_3_name') this.bag3Name,
      @JsonKey(name: 'bag_4_name') this.bag4Name,
      @JsonKey(name: 'bag_5_name') this.bag5Name,
      @JsonKey(name: 'bag_6_name') this.bag6Name,
      @JsonKey(name: 'bag_7_name') this.bag7Name,
      @JsonKey(name: 'bag_8_name') this.bag8Name,
      @JsonKey(name: 'bag_9_name') this.bag9Name,
      @JsonKey(name: 'bag_1_unlocked') this.bag1Unlocked = true,
      @JsonKey(name: 'bag_2_unlocked') this.bag2Unlocked = false,
      @JsonKey(name: 'bag_3_unlocked') this.bag3Unlocked = false,
      @JsonKey(name: 'bag_4_unlocked') this.bag4Unlocked = false,
      @JsonKey(name: 'bag_5_unlocked') this.bag5Unlocked = false,
      @JsonKey(name: 'bag_6_unlocked') this.bag6Unlocked = false,
      @JsonKey(name: 'bag_7_unlocked') this.bag7Unlocked = false,
      @JsonKey(name: 'bag_8_unlocked') this.bag8Unlocked = false,
      @JsonKey(name: 'bag_9_unlocked') this.bag9Unlocked = false,
      this.nickname,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      this.country,
      this.city,
      @JsonKey(name: 'dominate_hand') this.dominateHand,
      this.style,
      @JsonKey(name: 'PAP_integer') this.papInteger,
      @JsonKey(name: 'PAP_fraction') this.papFraction,
      @JsonKey(name: 'PAP_direction') this.papDirection,
      @JsonKey(name: 'PAP_drift_integer') this.papDriftInteger,
      @JsonKey(name: 'PAP_drift_fraction') this.papDriftFraction,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String? id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String? username;
// 球袋名稱設定 (1-9)
  @override
  @JsonKey(name: 'bag_1_name')
  final String bag1Name;
  @override
  @JsonKey(name: 'bag_2_name')
  final String? bag2Name;
  @override
  @JsonKey(name: 'bag_3_name')
  final String? bag3Name;
  @override
  @JsonKey(name: 'bag_4_name')
  final String? bag4Name;
  @override
  @JsonKey(name: 'bag_5_name')
  final String? bag5Name;
  @override
  @JsonKey(name: 'bag_6_name')
  final String? bag6Name;
  @override
  @JsonKey(name: 'bag_7_name')
  final String? bag7Name;
  @override
  @JsonKey(name: 'bag_8_name')
  final String? bag8Name;
  @override
  @JsonKey(name: 'bag_9_name')
  final String? bag9Name;
// 球袋開通狀態 (1-9)
  @override
  @JsonKey(name: 'bag_1_unlocked')
  final bool bag1Unlocked;
  @override
  @JsonKey(name: 'bag_2_unlocked')
  final bool bag2Unlocked;
  @override
  @JsonKey(name: 'bag_3_unlocked')
  final bool bag3Unlocked;
  @override
  @JsonKey(name: 'bag_4_unlocked')
  final bool bag4Unlocked;
  @override
  @JsonKey(name: 'bag_5_unlocked')
  final bool bag5Unlocked;
  @override
  @JsonKey(name: 'bag_6_unlocked')
  final bool bag6Unlocked;
  @override
  @JsonKey(name: 'bag_7_unlocked')
  final bool bag7Unlocked;
  @override
  @JsonKey(name: 'bag_8_unlocked')
  final bool bag8Unlocked;
  @override
  @JsonKey(name: 'bag_9_unlocked')
  final bool bag9Unlocked;
// 個人資料
  @override
  final String? nickname;
// bowler's name (display name)
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
// 頭像URL
  @override
  final String? country;
  @override
  final String? city;
  @override
  @JsonKey(name: 'dominate_hand')
  final String? dominateHand;
  @override
  final String? style;
// bowling style
  @override
  @JsonKey(name: 'PAP_integer')
  final int? papInteger;
  @override
  @JsonKey(name: 'PAP_fraction')
  final String? papFraction;
  @override
  @JsonKey(name: 'PAP_direction')
  final int? papDirection;
// 0=none, 1=up, -1=down
  @override
  @JsonKey(name: 'PAP_drift_integer')
  final int? papDriftInteger;
  @override
  @JsonKey(name: 'PAP_drift_fraction')
  final String? papDriftFraction;
// 其他用戶設定
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(id: $id, userId: $userId, username: $username, bag1Name: $bag1Name, bag2Name: $bag2Name, bag3Name: $bag3Name, bag4Name: $bag4Name, bag5Name: $bag5Name, bag6Name: $bag6Name, bag7Name: $bag7Name, bag8Name: $bag8Name, bag9Name: $bag9Name, bag1Unlocked: $bag1Unlocked, bag2Unlocked: $bag2Unlocked, bag3Unlocked: $bag3Unlocked, bag4Unlocked: $bag4Unlocked, bag5Unlocked: $bag5Unlocked, bag6Unlocked: $bag6Unlocked, bag7Unlocked: $bag7Unlocked, bag8Unlocked: $bag8Unlocked, bag9Unlocked: $bag9Unlocked, nickname: $nickname, avatarUrl: $avatarUrl, country: $country, city: $city, dominateHand: $dominateHand, style: $style, papInteger: $papInteger, papFraction: $papFraction, papDirection: $papDirection, papDriftInteger: $papDriftInteger, papDriftFraction: $papDriftFraction, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.bag1Name, bag1Name) ||
                other.bag1Name == bag1Name) &&
            (identical(other.bag2Name, bag2Name) ||
                other.bag2Name == bag2Name) &&
            (identical(other.bag3Name, bag3Name) ||
                other.bag3Name == bag3Name) &&
            (identical(other.bag4Name, bag4Name) ||
                other.bag4Name == bag4Name) &&
            (identical(other.bag5Name, bag5Name) ||
                other.bag5Name == bag5Name) &&
            (identical(other.bag6Name, bag6Name) ||
                other.bag6Name == bag6Name) &&
            (identical(other.bag7Name, bag7Name) ||
                other.bag7Name == bag7Name) &&
            (identical(other.bag8Name, bag8Name) ||
                other.bag8Name == bag8Name) &&
            (identical(other.bag9Name, bag9Name) ||
                other.bag9Name == bag9Name) &&
            (identical(other.bag1Unlocked, bag1Unlocked) ||
                other.bag1Unlocked == bag1Unlocked) &&
            (identical(other.bag2Unlocked, bag2Unlocked) ||
                other.bag2Unlocked == bag2Unlocked) &&
            (identical(other.bag3Unlocked, bag3Unlocked) ||
                other.bag3Unlocked == bag3Unlocked) &&
            (identical(other.bag4Unlocked, bag4Unlocked) ||
                other.bag4Unlocked == bag4Unlocked) &&
            (identical(other.bag5Unlocked, bag5Unlocked) ||
                other.bag5Unlocked == bag5Unlocked) &&
            (identical(other.bag6Unlocked, bag6Unlocked) ||
                other.bag6Unlocked == bag6Unlocked) &&
            (identical(other.bag7Unlocked, bag7Unlocked) ||
                other.bag7Unlocked == bag7Unlocked) &&
            (identical(other.bag8Unlocked, bag8Unlocked) ||
                other.bag8Unlocked == bag8Unlocked) &&
            (identical(other.bag9Unlocked, bag9Unlocked) ||
                other.bag9Unlocked == bag9Unlocked) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.dominateHand, dominateHand) ||
                other.dominateHand == dominateHand) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.papInteger, papInteger) ||
                other.papInteger == papInteger) &&
            (identical(other.papFraction, papFraction) ||
                other.papFraction == papFraction) &&
            (identical(other.papDirection, papDirection) ||
                other.papDirection == papDirection) &&
            (identical(other.papDriftInteger, papDriftInteger) ||
                other.papDriftInteger == papDriftInteger) &&
            (identical(other.papDriftFraction, papDriftFraction) ||
                other.papDriftFraction == papDriftFraction) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        username,
        bag1Name,
        bag2Name,
        bag3Name,
        bag4Name,
        bag5Name,
        bag6Name,
        bag7Name,
        bag8Name,
        bag9Name,
        bag1Unlocked,
        bag2Unlocked,
        bag3Unlocked,
        bag4Unlocked,
        bag5Unlocked,
        bag6Unlocked,
        bag7Unlocked,
        bag8Unlocked,
        bag9Unlocked,
        nickname,
        avatarUrl,
        country,
        city,
        dominateHand,
        style,
        papInteger,
        papFraction,
        papDirection,
        papDriftInteger,
        papDriftFraction,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
          {final String? id,
          @JsonKey(name: 'user_id') required final String userId,
          final String? username,
          @JsonKey(name: 'bag_1_name') final String bag1Name,
          @JsonKey(name: 'bag_2_name') final String? bag2Name,
          @JsonKey(name: 'bag_3_name') final String? bag3Name,
          @JsonKey(name: 'bag_4_name') final String? bag4Name,
          @JsonKey(name: 'bag_5_name') final String? bag5Name,
          @JsonKey(name: 'bag_6_name') final String? bag6Name,
          @JsonKey(name: 'bag_7_name') final String? bag7Name,
          @JsonKey(name: 'bag_8_name') final String? bag8Name,
          @JsonKey(name: 'bag_9_name') final String? bag9Name,
          @JsonKey(name: 'bag_1_unlocked') final bool bag1Unlocked,
          @JsonKey(name: 'bag_2_unlocked') final bool bag2Unlocked,
          @JsonKey(name: 'bag_3_unlocked') final bool bag3Unlocked,
          @JsonKey(name: 'bag_4_unlocked') final bool bag4Unlocked,
          @JsonKey(name: 'bag_5_unlocked') final bool bag5Unlocked,
          @JsonKey(name: 'bag_6_unlocked') final bool bag6Unlocked,
          @JsonKey(name: 'bag_7_unlocked') final bool bag7Unlocked,
          @JsonKey(name: 'bag_8_unlocked') final bool bag8Unlocked,
          @JsonKey(name: 'bag_9_unlocked') final bool bag9Unlocked,
          final String? nickname,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          final String? country,
          final String? city,
          @JsonKey(name: 'dominate_hand') final String? dominateHand,
          final String? style,
          @JsonKey(name: 'PAP_integer') final int? papInteger,
          @JsonKey(name: 'PAP_fraction') final String? papFraction,
          @JsonKey(name: 'PAP_direction') final int? papDirection,
          @JsonKey(name: 'PAP_drift_integer') final int? papDriftInteger,
          @JsonKey(name: 'PAP_drift_fraction') final String? papDriftFraction,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String? get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String? get username; // 球袋名稱設定 (1-9)
  @override
  @JsonKey(name: 'bag_1_name')
  String get bag1Name;
  @override
  @JsonKey(name: 'bag_2_name')
  String? get bag2Name;
  @override
  @JsonKey(name: 'bag_3_name')
  String? get bag3Name;
  @override
  @JsonKey(name: 'bag_4_name')
  String? get bag4Name;
  @override
  @JsonKey(name: 'bag_5_name')
  String? get bag5Name;
  @override
  @JsonKey(name: 'bag_6_name')
  String? get bag6Name;
  @override
  @JsonKey(name: 'bag_7_name')
  String? get bag7Name;
  @override
  @JsonKey(name: 'bag_8_name')
  String? get bag8Name;
  @override
  @JsonKey(name: 'bag_9_name')
  String? get bag9Name; // 球袋開通狀態 (1-9)
  @override
  @JsonKey(name: 'bag_1_unlocked')
  bool get bag1Unlocked;
  @override
  @JsonKey(name: 'bag_2_unlocked')
  bool get bag2Unlocked;
  @override
  @JsonKey(name: 'bag_3_unlocked')
  bool get bag3Unlocked;
  @override
  @JsonKey(name: 'bag_4_unlocked')
  bool get bag4Unlocked;
  @override
  @JsonKey(name: 'bag_5_unlocked')
  bool get bag5Unlocked;
  @override
  @JsonKey(name: 'bag_6_unlocked')
  bool get bag6Unlocked;
  @override
  @JsonKey(name: 'bag_7_unlocked')
  bool get bag7Unlocked;
  @override
  @JsonKey(name: 'bag_8_unlocked')
  bool get bag8Unlocked;
  @override
  @JsonKey(name: 'bag_9_unlocked')
  bool get bag9Unlocked; // 個人資料
  @override
  String? get nickname; // bowler's name (display name)
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl; // 頭像URL
  @override
  String? get country;
  @override
  String? get city;
  @override
  @JsonKey(name: 'dominate_hand')
  String? get dominateHand;
  @override
  String? get style; // bowling style
  @override
  @JsonKey(name: 'PAP_integer')
  int? get papInteger;
  @override
  @JsonKey(name: 'PAP_fraction')
  String? get papFraction;
  @override
  @JsonKey(name: 'PAP_direction')
  int? get papDirection; // 0=none, 1=up, -1=down
  @override
  @JsonKey(name: 'PAP_drift_integer')
  int? get papDriftInteger;
  @override
  @JsonKey(name: 'PAP_drift_fraction')
  String? get papDriftFraction; // 其他用戶設定
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BagInfo _$BagInfoFromJson(Map<String, dynamic> json) {
  return _BagInfo.fromJson(json);
}

/// @nodoc
mixin _$BagInfo {
  int get number => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isUnlocked => throw _privateConstructorUsedError;

  /// Serializes this BagInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BagInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BagInfoCopyWith<BagInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BagInfoCopyWith<$Res> {
  factory $BagInfoCopyWith(BagInfo value, $Res Function(BagInfo) then) =
      _$BagInfoCopyWithImpl<$Res, BagInfo>;
  @useResult
  $Res call({int number, String name, bool isUnlocked});
}

/// @nodoc
class _$BagInfoCopyWithImpl<$Res, $Val extends BagInfo>
    implements $BagInfoCopyWith<$Res> {
  _$BagInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BagInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? name = null,
    Object? isUnlocked = null,
  }) {
    return _then(_value.copyWith(
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BagInfoImplCopyWith<$Res> implements $BagInfoCopyWith<$Res> {
  factory _$$BagInfoImplCopyWith(
          _$BagInfoImpl value, $Res Function(_$BagInfoImpl) then) =
      __$$BagInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int number, String name, bool isUnlocked});
}

/// @nodoc
class __$$BagInfoImplCopyWithImpl<$Res>
    extends _$BagInfoCopyWithImpl<$Res, _$BagInfoImpl>
    implements _$$BagInfoImplCopyWith<$Res> {
  __$$BagInfoImplCopyWithImpl(
      _$BagInfoImpl _value, $Res Function(_$BagInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BagInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? name = null,
    Object? isUnlocked = null,
  }) {
    return _then(_$BagInfoImpl(
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BagInfoImpl implements _BagInfo {
  const _$BagInfoImpl(
      {required this.number, required this.name, required this.isUnlocked});

  factory _$BagInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BagInfoImplFromJson(json);

  @override
  final int number;
  @override
  final String name;
  @override
  final bool isUnlocked;

  @override
  String toString() {
    return 'BagInfo(number: $number, name: $name, isUnlocked: $isUnlocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BagInfoImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, number, name, isUnlocked);

  /// Create a copy of BagInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BagInfoImplCopyWith<_$BagInfoImpl> get copyWith =>
      __$$BagInfoImplCopyWithImpl<_$BagInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BagInfoImplToJson(
      this,
    );
  }
}

abstract class _BagInfo implements BagInfo {
  const factory _BagInfo(
      {required final int number,
      required final String name,
      required final bool isUnlocked}) = _$BagInfoImpl;

  factory _BagInfo.fromJson(Map<String, dynamic> json) = _$BagInfoImpl.fromJson;

  @override
  int get number;
  @override
  String get name;
  @override
  bool get isUnlocked;

  /// Create a copy of BagInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BagInfoImplCopyWith<_$BagInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
