// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arsenal_analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArsenalAnalytics _$ArsenalAnalyticsFromJson(Map<String, dynamic> json) {
  return _ArsenalAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ArsenalAnalytics {
  String get userId => throw _privateConstructorUsedError;
  int get totalBalls => throw _privateConstructorUsedError;
  int get customBalls => throw _privateConstructorUsedError;
  Map<String, int> get brandDistribution => throw _privateConstructorUsedError;
  Map<String, int> get categoryDistribution =>
      throw _privateConstructorUsedError;
  Map<String, int> get layoutTypeDistribution =>
      throw _privateConstructorUsedError;
  RGDiffDistribution get rgDiffDistribution =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this ArsenalAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArsenalAnalyticsCopyWith<ArsenalAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArsenalAnalyticsCopyWith<$Res> {
  factory $ArsenalAnalyticsCopyWith(
          ArsenalAnalytics value, $Res Function(ArsenalAnalytics) then) =
      _$ArsenalAnalyticsCopyWithImpl<$Res, ArsenalAnalytics>;
  @useResult
  $Res call(
      {String userId,
      int totalBalls,
      int customBalls,
      Map<String, int> brandDistribution,
      Map<String, int> categoryDistribution,
      Map<String, int> layoutTypeDistribution,
      RGDiffDistribution rgDiffDistribution,
      DateTime lastUpdated});

  $RGDiffDistributionCopyWith<$Res> get rgDiffDistribution;
}

/// @nodoc
class _$ArsenalAnalyticsCopyWithImpl<$Res, $Val extends ArsenalAnalytics>
    implements $ArsenalAnalyticsCopyWith<$Res> {
  _$ArsenalAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalBalls = null,
    Object? customBalls = null,
    Object? brandDistribution = null,
    Object? categoryDistribution = null,
    Object? layoutTypeDistribution = null,
    Object? rgDiffDistribution = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBalls: null == totalBalls
          ? _value.totalBalls
          : totalBalls // ignore: cast_nullable_to_non_nullable
              as int,
      customBalls: null == customBalls
          ? _value.customBalls
          : customBalls // ignore: cast_nullable_to_non_nullable
              as int,
      brandDistribution: null == brandDistribution
          ? _value.brandDistribution
          : brandDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      categoryDistribution: null == categoryDistribution
          ? _value.categoryDistribution
          : categoryDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      layoutTypeDistribution: null == layoutTypeDistribution
          ? _value.layoutTypeDistribution
          : layoutTypeDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      rgDiffDistribution: null == rgDiffDistribution
          ? _value.rgDiffDistribution
          : rgDiffDistribution // ignore: cast_nullable_to_non_nullable
              as RGDiffDistribution,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RGDiffDistributionCopyWith<$Res> get rgDiffDistribution {
    return $RGDiffDistributionCopyWith<$Res>(_value.rgDiffDistribution,
        (value) {
      return _then(_value.copyWith(rgDiffDistribution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ArsenalAnalyticsImplCopyWith<$Res>
    implements $ArsenalAnalyticsCopyWith<$Res> {
  factory _$$ArsenalAnalyticsImplCopyWith(_$ArsenalAnalyticsImpl value,
          $Res Function(_$ArsenalAnalyticsImpl) then) =
      __$$ArsenalAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int totalBalls,
      int customBalls,
      Map<String, int> brandDistribution,
      Map<String, int> categoryDistribution,
      Map<String, int> layoutTypeDistribution,
      RGDiffDistribution rgDiffDistribution,
      DateTime lastUpdated});

  @override
  $RGDiffDistributionCopyWith<$Res> get rgDiffDistribution;
}

/// @nodoc
class __$$ArsenalAnalyticsImplCopyWithImpl<$Res>
    extends _$ArsenalAnalyticsCopyWithImpl<$Res, _$ArsenalAnalyticsImpl>
    implements _$$ArsenalAnalyticsImplCopyWith<$Res> {
  __$$ArsenalAnalyticsImplCopyWithImpl(_$ArsenalAnalyticsImpl _value,
      $Res Function(_$ArsenalAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalBalls = null,
    Object? customBalls = null,
    Object? brandDistribution = null,
    Object? categoryDistribution = null,
    Object? layoutTypeDistribution = null,
    Object? rgDiffDistribution = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$ArsenalAnalyticsImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalBalls: null == totalBalls
          ? _value.totalBalls
          : totalBalls // ignore: cast_nullable_to_non_nullable
              as int,
      customBalls: null == customBalls
          ? _value.customBalls
          : customBalls // ignore: cast_nullable_to_non_nullable
              as int,
      brandDistribution: null == brandDistribution
          ? _value._brandDistribution
          : brandDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      categoryDistribution: null == categoryDistribution
          ? _value._categoryDistribution
          : categoryDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      layoutTypeDistribution: null == layoutTypeDistribution
          ? _value._layoutTypeDistribution
          : layoutTypeDistribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      rgDiffDistribution: null == rgDiffDistribution
          ? _value.rgDiffDistribution
          : rgDiffDistribution // ignore: cast_nullable_to_non_nullable
              as RGDiffDistribution,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArsenalAnalyticsImpl implements _ArsenalAnalytics {
  const _$ArsenalAnalyticsImpl(
      {required this.userId,
      required this.totalBalls,
      required this.customBalls,
      required final Map<String, int> brandDistribution,
      required final Map<String, int> categoryDistribution,
      required final Map<String, int> layoutTypeDistribution,
      required this.rgDiffDistribution,
      required this.lastUpdated})
      : _brandDistribution = brandDistribution,
        _categoryDistribution = categoryDistribution,
        _layoutTypeDistribution = layoutTypeDistribution;

  factory _$ArsenalAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArsenalAnalyticsImplFromJson(json);

  @override
  final String userId;
  @override
  final int totalBalls;
  @override
  final int customBalls;
  final Map<String, int> _brandDistribution;
  @override
  Map<String, int> get brandDistribution {
    if (_brandDistribution is EqualUnmodifiableMapView)
      return _brandDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_brandDistribution);
  }

  final Map<String, int> _categoryDistribution;
  @override
  Map<String, int> get categoryDistribution {
    if (_categoryDistribution is EqualUnmodifiableMapView)
      return _categoryDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryDistribution);
  }

  final Map<String, int> _layoutTypeDistribution;
  @override
  Map<String, int> get layoutTypeDistribution {
    if (_layoutTypeDistribution is EqualUnmodifiableMapView)
      return _layoutTypeDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_layoutTypeDistribution);
  }

  @override
  final RGDiffDistribution rgDiffDistribution;
  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'ArsenalAnalytics(userId: $userId, totalBalls: $totalBalls, customBalls: $customBalls, brandDistribution: $brandDistribution, categoryDistribution: $categoryDistribution, layoutTypeDistribution: $layoutTypeDistribution, rgDiffDistribution: $rgDiffDistribution, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsenalAnalyticsImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalBalls, totalBalls) ||
                other.totalBalls == totalBalls) &&
            (identical(other.customBalls, customBalls) ||
                other.customBalls == customBalls) &&
            const DeepCollectionEquality()
                .equals(other._brandDistribution, _brandDistribution) &&
            const DeepCollectionEquality()
                .equals(other._categoryDistribution, _categoryDistribution) &&
            const DeepCollectionEquality().equals(
                other._layoutTypeDistribution, _layoutTypeDistribution) &&
            (identical(other.rgDiffDistribution, rgDiffDistribution) ||
                other.rgDiffDistribution == rgDiffDistribution) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalBalls,
      customBalls,
      const DeepCollectionEquality().hash(_brandDistribution),
      const DeepCollectionEquality().hash(_categoryDistribution),
      const DeepCollectionEquality().hash(_layoutTypeDistribution),
      rgDiffDistribution,
      lastUpdated);

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArsenalAnalyticsImplCopyWith<_$ArsenalAnalyticsImpl> get copyWith =>
      __$$ArsenalAnalyticsImplCopyWithImpl<_$ArsenalAnalyticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArsenalAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _ArsenalAnalytics implements ArsenalAnalytics {
  const factory _ArsenalAnalytics(
      {required final String userId,
      required final int totalBalls,
      required final int customBalls,
      required final Map<String, int> brandDistribution,
      required final Map<String, int> categoryDistribution,
      required final Map<String, int> layoutTypeDistribution,
      required final RGDiffDistribution rgDiffDistribution,
      required final DateTime lastUpdated}) = _$ArsenalAnalyticsImpl;

  factory _ArsenalAnalytics.fromJson(Map<String, dynamic> json) =
      _$ArsenalAnalyticsImpl.fromJson;

  @override
  String get userId;
  @override
  int get totalBalls;
  @override
  int get customBalls;
  @override
  Map<String, int> get brandDistribution;
  @override
  Map<String, int> get categoryDistribution;
  @override
  Map<String, int> get layoutTypeDistribution;
  @override
  RGDiffDistribution get rgDiffDistribution;
  @override
  DateTime get lastUpdated;

  /// Create a copy of ArsenalAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalAnalyticsImplCopyWith<_$ArsenalAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RGDiffDistribution _$RGDiffDistributionFromJson(Map<String, dynamic> json) {
  return _RGDiffDistribution.fromJson(json);
}

/// @nodoc
mixin _$RGDiffDistribution {
  List<BallDataPoint> get dataPoints => throw _privateConstructorUsedError;
  double get avgRG => throw _privateConstructorUsedError;
  double get avgDiff => throw _privateConstructorUsedError;
  double get minRG => throw _privateConstructorUsedError;
  double get maxRG => throw _privateConstructorUsedError;
  double get minDiff => throw _privateConstructorUsedError;
  double get maxDiff => throw _privateConstructorUsedError;

  /// Serializes this RGDiffDistribution to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RGDiffDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RGDiffDistributionCopyWith<RGDiffDistribution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RGDiffDistributionCopyWith<$Res> {
  factory $RGDiffDistributionCopyWith(
          RGDiffDistribution value, $Res Function(RGDiffDistribution) then) =
      _$RGDiffDistributionCopyWithImpl<$Res, RGDiffDistribution>;
  @useResult
  $Res call(
      {List<BallDataPoint> dataPoints,
      double avgRG,
      double avgDiff,
      double minRG,
      double maxRG,
      double minDiff,
      double maxDiff});
}

/// @nodoc
class _$RGDiffDistributionCopyWithImpl<$Res, $Val extends RGDiffDistribution>
    implements $RGDiffDistributionCopyWith<$Res> {
  _$RGDiffDistributionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RGDiffDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataPoints = null,
    Object? avgRG = null,
    Object? avgDiff = null,
    Object? minRG = null,
    Object? maxRG = null,
    Object? minDiff = null,
    Object? maxDiff = null,
  }) {
    return _then(_value.copyWith(
      dataPoints: null == dataPoints
          ? _value.dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<BallDataPoint>,
      avgRG: null == avgRG
          ? _value.avgRG
          : avgRG // ignore: cast_nullable_to_non_nullable
              as double,
      avgDiff: null == avgDiff
          ? _value.avgDiff
          : avgDiff // ignore: cast_nullable_to_non_nullable
              as double,
      minRG: null == minRG
          ? _value.minRG
          : minRG // ignore: cast_nullable_to_non_nullable
              as double,
      maxRG: null == maxRG
          ? _value.maxRG
          : maxRG // ignore: cast_nullable_to_non_nullable
              as double,
      minDiff: null == minDiff
          ? _value.minDiff
          : minDiff // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiff: null == maxDiff
          ? _value.maxDiff
          : maxDiff // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RGDiffDistributionImplCopyWith<$Res>
    implements $RGDiffDistributionCopyWith<$Res> {
  factory _$$RGDiffDistributionImplCopyWith(_$RGDiffDistributionImpl value,
          $Res Function(_$RGDiffDistributionImpl) then) =
      __$$RGDiffDistributionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BallDataPoint> dataPoints,
      double avgRG,
      double avgDiff,
      double minRG,
      double maxRG,
      double minDiff,
      double maxDiff});
}

/// @nodoc
class __$$RGDiffDistributionImplCopyWithImpl<$Res>
    extends _$RGDiffDistributionCopyWithImpl<$Res, _$RGDiffDistributionImpl>
    implements _$$RGDiffDistributionImplCopyWith<$Res> {
  __$$RGDiffDistributionImplCopyWithImpl(_$RGDiffDistributionImpl _value,
      $Res Function(_$RGDiffDistributionImpl) _then)
      : super(_value, _then);

  /// Create a copy of RGDiffDistribution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataPoints = null,
    Object? avgRG = null,
    Object? avgDiff = null,
    Object? minRG = null,
    Object? maxRG = null,
    Object? minDiff = null,
    Object? maxDiff = null,
  }) {
    return _then(_$RGDiffDistributionImpl(
      dataPoints: null == dataPoints
          ? _value._dataPoints
          : dataPoints // ignore: cast_nullable_to_non_nullable
              as List<BallDataPoint>,
      avgRG: null == avgRG
          ? _value.avgRG
          : avgRG // ignore: cast_nullable_to_non_nullable
              as double,
      avgDiff: null == avgDiff
          ? _value.avgDiff
          : avgDiff // ignore: cast_nullable_to_non_nullable
              as double,
      minRG: null == minRG
          ? _value.minRG
          : minRG // ignore: cast_nullable_to_non_nullable
              as double,
      maxRG: null == maxRG
          ? _value.maxRG
          : maxRG // ignore: cast_nullable_to_non_nullable
              as double,
      minDiff: null == minDiff
          ? _value.minDiff
          : minDiff // ignore: cast_nullable_to_non_nullable
              as double,
      maxDiff: null == maxDiff
          ? _value.maxDiff
          : maxDiff // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RGDiffDistributionImpl implements _RGDiffDistribution {
  const _$RGDiffDistributionImpl(
      {required final List<BallDataPoint> dataPoints,
      required this.avgRG,
      required this.avgDiff,
      required this.minRG,
      required this.maxRG,
      required this.minDiff,
      required this.maxDiff})
      : _dataPoints = dataPoints;

  factory _$RGDiffDistributionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RGDiffDistributionImplFromJson(json);

  final List<BallDataPoint> _dataPoints;
  @override
  List<BallDataPoint> get dataPoints {
    if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dataPoints);
  }

  @override
  final double avgRG;
  @override
  final double avgDiff;
  @override
  final double minRG;
  @override
  final double maxRG;
  @override
  final double minDiff;
  @override
  final double maxDiff;

  @override
  String toString() {
    return 'RGDiffDistribution(dataPoints: $dataPoints, avgRG: $avgRG, avgDiff: $avgDiff, minRG: $minRG, maxRG: $maxRG, minDiff: $minDiff, maxDiff: $maxDiff)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RGDiffDistributionImpl &&
            const DeepCollectionEquality()
                .equals(other._dataPoints, _dataPoints) &&
            (identical(other.avgRG, avgRG) || other.avgRG == avgRG) &&
            (identical(other.avgDiff, avgDiff) || other.avgDiff == avgDiff) &&
            (identical(other.minRG, minRG) || other.minRG == minRG) &&
            (identical(other.maxRG, maxRG) || other.maxRG == maxRG) &&
            (identical(other.minDiff, minDiff) || other.minDiff == minDiff) &&
            (identical(other.maxDiff, maxDiff) || other.maxDiff == maxDiff));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dataPoints),
      avgRG,
      avgDiff,
      minRG,
      maxRG,
      minDiff,
      maxDiff);

  /// Create a copy of RGDiffDistribution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RGDiffDistributionImplCopyWith<_$RGDiffDistributionImpl> get copyWith =>
      __$$RGDiffDistributionImplCopyWithImpl<_$RGDiffDistributionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RGDiffDistributionImplToJson(
      this,
    );
  }
}

abstract class _RGDiffDistribution implements RGDiffDistribution {
  const factory _RGDiffDistribution(
      {required final List<BallDataPoint> dataPoints,
      required final double avgRG,
      required final double avgDiff,
      required final double minRG,
      required final double maxRG,
      required final double minDiff,
      required final double maxDiff}) = _$RGDiffDistributionImpl;

  factory _RGDiffDistribution.fromJson(Map<String, dynamic> json) =
      _$RGDiffDistributionImpl.fromJson;

  @override
  List<BallDataPoint> get dataPoints;
  @override
  double get avgRG;
  @override
  double get avgDiff;
  @override
  double get minRG;
  @override
  double get maxRG;
  @override
  double get minDiff;
  @override
  double get maxDiff;

  /// Create a copy of RGDiffDistribution
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RGDiffDistributionImplCopyWith<_$RGDiffDistributionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BallDataPoint _$BallDataPointFromJson(Map<String, dynamic> json) {
  return _BallDataPoint.fromJson(json);
}

/// @nodoc
mixin _$BallDataPoint {
  String get instanceId => throw _privateConstructorUsedError;
  String get ballName => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  double get rg => throw _privateConstructorUsedError;
  double get diff => throw _privateConstructorUsedError;
  BallQuadrant get quadrant => throw _privateConstructorUsedError;

  /// Serializes this BallDataPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BallDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallDataPointCopyWith<BallDataPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallDataPointCopyWith<$Res> {
  factory $BallDataPointCopyWith(
          BallDataPoint value, $Res Function(BallDataPoint) then) =
      _$BallDataPointCopyWithImpl<$Res, BallDataPoint>;
  @useResult
  $Res call(
      {String instanceId,
      String ballName,
      String brand,
      double rg,
      double diff,
      BallQuadrant quadrant});
}

/// @nodoc
class _$BallDataPointCopyWithImpl<$Res, $Val extends BallDataPoint>
    implements $BallDataPointCopyWith<$Res> {
  _$BallDataPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = null,
    Object? ballName = null,
    Object? brand = null,
    Object? rg = null,
    Object? diff = null,
    Object? quadrant = null,
  }) {
    return _then(_value.copyWith(
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      rg: null == rg
          ? _value.rg
          : rg // ignore: cast_nullable_to_non_nullable
              as double,
      diff: null == diff
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as double,
      quadrant: null == quadrant
          ? _value.quadrant
          : quadrant // ignore: cast_nullable_to_non_nullable
              as BallQuadrant,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BallDataPointImplCopyWith<$Res>
    implements $BallDataPointCopyWith<$Res> {
  factory _$$BallDataPointImplCopyWith(
          _$BallDataPointImpl value, $Res Function(_$BallDataPointImpl) then) =
      __$$BallDataPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String instanceId,
      String ballName,
      String brand,
      double rg,
      double diff,
      BallQuadrant quadrant});
}

/// @nodoc
class __$$BallDataPointImplCopyWithImpl<$Res>
    extends _$BallDataPointCopyWithImpl<$Res, _$BallDataPointImpl>
    implements _$$BallDataPointImplCopyWith<$Res> {
  __$$BallDataPointImplCopyWithImpl(
      _$BallDataPointImpl _value, $Res Function(_$BallDataPointImpl) _then)
      : super(_value, _then);

  /// Create a copy of BallDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instanceId = null,
    Object? ballName = null,
    Object? brand = null,
    Object? rg = null,
    Object? diff = null,
    Object? quadrant = null,
  }) {
    return _then(_$BallDataPointImpl(
      instanceId: null == instanceId
          ? _value.instanceId
          : instanceId // ignore: cast_nullable_to_non_nullable
              as String,
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      rg: null == rg
          ? _value.rg
          : rg // ignore: cast_nullable_to_non_nullable
              as double,
      diff: null == diff
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as double,
      quadrant: null == quadrant
          ? _value.quadrant
          : quadrant // ignore: cast_nullable_to_non_nullable
              as BallQuadrant,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BallDataPointImpl implements _BallDataPoint {
  const _$BallDataPointImpl(
      {required this.instanceId,
      required this.ballName,
      required this.brand,
      required this.rg,
      required this.diff,
      required this.quadrant});

  factory _$BallDataPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$BallDataPointImplFromJson(json);

  @override
  final String instanceId;
  @override
  final String ballName;
  @override
  final String brand;
  @override
  final double rg;
  @override
  final double diff;
  @override
  final BallQuadrant quadrant;

  @override
  String toString() {
    return 'BallDataPoint(instanceId: $instanceId, ballName: $ballName, brand: $brand, rg: $rg, diff: $diff, quadrant: $quadrant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallDataPointImpl &&
            (identical(other.instanceId, instanceId) ||
                other.instanceId == instanceId) &&
            (identical(other.ballName, ballName) ||
                other.ballName == ballName) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.rg, rg) || other.rg == rg) &&
            (identical(other.diff, diff) || other.diff == diff) &&
            (identical(other.quadrant, quadrant) ||
                other.quadrant == quadrant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, instanceId, ballName, brand, rg, diff, quadrant);

  /// Create a copy of BallDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallDataPointImplCopyWith<_$BallDataPointImpl> get copyWith =>
      __$$BallDataPointImplCopyWithImpl<_$BallDataPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BallDataPointImplToJson(
      this,
    );
  }
}

abstract class _BallDataPoint implements BallDataPoint {
  const factory _BallDataPoint(
      {required final String instanceId,
      required final String ballName,
      required final String brand,
      required final double rg,
      required final double diff,
      required final BallQuadrant quadrant}) = _$BallDataPointImpl;

  factory _BallDataPoint.fromJson(Map<String, dynamic> json) =
      _$BallDataPointImpl.fromJson;

  @override
  String get instanceId;
  @override
  String get ballName;
  @override
  String get brand;
  @override
  double get rg;
  @override
  double get diff;
  @override
  BallQuadrant get quadrant;

  /// Create a copy of BallDataPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallDataPointImplCopyWith<_$BallDataPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
