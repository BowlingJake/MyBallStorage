// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SortCriterion {
  SortField get field => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;

  /// Create a copy of SortCriterion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SortCriterionCopyWith<SortCriterion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SortCriterionCopyWith<$Res> {
  factory $SortCriterionCopyWith(
          SortCriterion value, $Res Function(SortCriterion) then) =
      _$SortCriterionCopyWithImpl<$Res, SortCriterion>;
  @useResult
  $Res call({SortField field, bool ascending});
}

/// @nodoc
class _$SortCriterionCopyWithImpl<$Res, $Val extends SortCriterion>
    implements $SortCriterionCopyWith<$Res> {
  _$SortCriterionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SortCriterion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? ascending = null,
  }) {
    return _then(_value.copyWith(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as SortField,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SortCriterionImplCopyWith<$Res>
    implements $SortCriterionCopyWith<$Res> {
  factory _$$SortCriterionImplCopyWith(
          _$SortCriterionImpl value, $Res Function(_$SortCriterionImpl) then) =
      __$$SortCriterionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SortField field, bool ascending});
}

/// @nodoc
class __$$SortCriterionImplCopyWithImpl<$Res>
    extends _$SortCriterionCopyWithImpl<$Res, _$SortCriterionImpl>
    implements _$$SortCriterionImplCopyWith<$Res> {
  __$$SortCriterionImplCopyWithImpl(
      _$SortCriterionImpl _value, $Res Function(_$SortCriterionImpl) _then)
      : super(_value, _then);

  /// Create a copy of SortCriterion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? field = null,
    Object? ascending = null,
  }) {
    return _then(_$SortCriterionImpl(
      field: null == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as SortField,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SortCriterionImpl extends _SortCriterion {
  const _$SortCriterionImpl(
      {this.field = SortField.name, this.ascending = true})
      : super._();

  @override
  @JsonKey()
  final SortField field;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'SortCriterion(field: $field, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SortCriterionImpl &&
            (identical(other.field, field) || other.field == field) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(runtimeType, field, ascending);

  /// Create a copy of SortCriterion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SortCriterionImplCopyWith<_$SortCriterionImpl> get copyWith =>
      __$$SortCriterionImplCopyWithImpl<_$SortCriterionImpl>(this, _$identity);
}

abstract class _SortCriterion extends SortCriterion {
  const factory _SortCriterion({final SortField field, final bool ascending}) =
      _$SortCriterionImpl;
  const _SortCriterion._() : super._();

  @override
  SortField get field;
  @override
  bool get ascending;

  /// Create a copy of SortCriterion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SortCriterionImplCopyWith<_$SortCriterionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BallFilters {
  String? get brand => throw _privateConstructorUsedError;
  String? get core => throw _privateConstructorUsedError;
  String? get coverstock => throw _privateConstructorUsedError;

  /// Create a copy of BallFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallFiltersCopyWith<BallFilters> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallFiltersCopyWith<$Res> {
  factory $BallFiltersCopyWith(
          BallFilters value, $Res Function(BallFilters) then) =
      _$BallFiltersCopyWithImpl<$Res, BallFilters>;
  @useResult
  $Res call({String? brand, String? core, String? coverstock});
}

/// @nodoc
class _$BallFiltersCopyWithImpl<$Res, $Val extends BallFilters>
    implements $BallFiltersCopyWith<$Res> {
  _$BallFiltersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? core = freezed,
    Object? coverstock = freezed,
  }) {
    return _then(_value.copyWith(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      core: freezed == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as String?,
      coverstock: freezed == coverstock
          ? _value.coverstock
          : coverstock // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BallFiltersImplCopyWith<$Res>
    implements $BallFiltersCopyWith<$Res> {
  factory _$$BallFiltersImplCopyWith(
          _$BallFiltersImpl value, $Res Function(_$BallFiltersImpl) then) =
      __$$BallFiltersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? brand, String? core, String? coverstock});
}

/// @nodoc
class __$$BallFiltersImplCopyWithImpl<$Res>
    extends _$BallFiltersCopyWithImpl<$Res, _$BallFiltersImpl>
    implements _$$BallFiltersImplCopyWith<$Res> {
  __$$BallFiltersImplCopyWithImpl(
      _$BallFiltersImpl _value, $Res Function(_$BallFiltersImpl) _then)
      : super(_value, _then);

  /// Create a copy of BallFilters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? core = freezed,
    Object? coverstock = freezed,
  }) {
    return _then(_$BallFiltersImpl(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      core: freezed == core
          ? _value.core
          : core // ignore: cast_nullable_to_non_nullable
              as String?,
      coverstock: freezed == coverstock
          ? _value.coverstock
          : coverstock // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BallFiltersImpl extends _BallFilters {
  const _$BallFiltersImpl({this.brand, this.core, this.coverstock}) : super._();

  @override
  final String? brand;
  @override
  final String? core;
  @override
  final String? coverstock;

  @override
  String toString() {
    return 'BallFilters(brand: $brand, core: $core, coverstock: $coverstock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallFiltersImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.core, core) || other.core == core) &&
            (identical(other.coverstock, coverstock) ||
                other.coverstock == coverstock));
  }

  @override
  int get hashCode => Object.hash(runtimeType, brand, core, coverstock);

  /// Create a copy of BallFilters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallFiltersImplCopyWith<_$BallFiltersImpl> get copyWith =>
      __$$BallFiltersImplCopyWithImpl<_$BallFiltersImpl>(this, _$identity);
}

abstract class _BallFilters extends BallFilters {
  const factory _BallFilters(
      {final String? brand,
      final String? core,
      final String? coverstock}) = _$BallFiltersImpl;
  const _BallFilters._() : super._();

  @override
  String? get brand;
  @override
  String? get core;
  @override
  String? get coverstock;

  /// Create a copy of BallFilters
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallFiltersImplCopyWith<_$BallFiltersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BallLibraryState {
  List<BowlingBall> get allBalls => throw _privateConstructorUsedError;
  List<BowlingBall> get filteredBalls => throw _privateConstructorUsedError;
  String get searchText => throw _privateConstructorUsedError;
  BallFilters get filters => throw _privateConstructorUsedError;
  SortCriterion get sortCriterion =>
      throw _privateConstructorUsedError; // 預設ID排序
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isLoadingMore => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get totalCount => throw _privateConstructorUsedError;
  bool get hasMoreData => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallLibraryStateCopyWith<BallLibraryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallLibraryStateCopyWith<$Res> {
  factory $BallLibraryStateCopyWith(
          BallLibraryState value, $Res Function(BallLibraryState) then) =
      _$BallLibraryStateCopyWithImpl<$Res, BallLibraryState>;
  @useResult
  $Res call(
      {List<BowlingBall> allBalls,
      List<BowlingBall> filteredBalls,
      String searchText,
      BallFilters filters,
      SortCriterion sortCriterion,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int pageSize,
      int totalCount,
      bool hasMoreData,
      String? error});

  $BallFiltersCopyWith<$Res> get filters;
  $SortCriterionCopyWith<$Res> get sortCriterion;
}

/// @nodoc
class _$BallLibraryStateCopyWithImpl<$Res, $Val extends BallLibraryState>
    implements $BallLibraryStateCopyWith<$Res> {
  _$BallLibraryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allBalls = null,
    Object? filteredBalls = null,
    Object? searchText = null,
    Object? filters = null,
    Object? sortCriterion = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasMoreData = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      allBalls: null == allBalls
          ? _value.allBalls
          : allBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      filteredBalls: null == filteredBalls
          ? _value.filteredBalls
          : filteredBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as BallFilters,
      sortCriterion: null == sortCriterion
          ? _value.sortCriterion
          : sortCriterion // ignore: cast_nullable_to_non_nullable
              as SortCriterion,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreData: null == hasMoreData
          ? _value.hasMoreData
          : hasMoreData // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BallFiltersCopyWith<$Res> get filters {
    return $BallFiltersCopyWith<$Res>(_value.filters, (value) {
      return _then(_value.copyWith(filters: value) as $Val);
    });
  }

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SortCriterionCopyWith<$Res> get sortCriterion {
    return $SortCriterionCopyWith<$Res>(_value.sortCriterion, (value) {
      return _then(_value.copyWith(sortCriterion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BallLibraryStateImplCopyWith<$Res>
    implements $BallLibraryStateCopyWith<$Res> {
  factory _$$BallLibraryStateImplCopyWith(_$BallLibraryStateImpl value,
          $Res Function(_$BallLibraryStateImpl) then) =
      __$$BallLibraryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BowlingBall> allBalls,
      List<BowlingBall> filteredBalls,
      String searchText,
      BallFilters filters,
      SortCriterion sortCriterion,
      bool isLoading,
      bool isLoadingMore,
      int currentPage,
      int pageSize,
      int totalCount,
      bool hasMoreData,
      String? error});

  @override
  $BallFiltersCopyWith<$Res> get filters;
  @override
  $SortCriterionCopyWith<$Res> get sortCriterion;
}

/// @nodoc
class __$$BallLibraryStateImplCopyWithImpl<$Res>
    extends _$BallLibraryStateCopyWithImpl<$Res, _$BallLibraryStateImpl>
    implements _$$BallLibraryStateImplCopyWith<$Res> {
  __$$BallLibraryStateImplCopyWithImpl(_$BallLibraryStateImpl _value,
      $Res Function(_$BallLibraryStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allBalls = null,
    Object? filteredBalls = null,
    Object? searchText = null,
    Object? filters = null,
    Object? sortCriterion = null,
    Object? isLoading = null,
    Object? isLoadingMore = null,
    Object? currentPage = null,
    Object? pageSize = null,
    Object? totalCount = null,
    Object? hasMoreData = null,
    Object? error = freezed,
  }) {
    return _then(_$BallLibraryStateImpl(
      allBalls: null == allBalls
          ? _value._allBalls
          : allBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      filteredBalls: null == filteredBalls
          ? _value._filteredBalls
          : filteredBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as BallFilters,
      sortCriterion: null == sortCriterion
          ? _value.sortCriterion
          : sortCriterion // ignore: cast_nullable_to_non_nullable
              as SortCriterion,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      totalCount: null == totalCount
          ? _value.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMoreData: null == hasMoreData
          ? _value.hasMoreData
          : hasMoreData // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BallLibraryStateImpl extends _BallLibraryState {
  const _$BallLibraryStateImpl(
      {final List<BowlingBall> allBalls = const [],
      final List<BowlingBall> filteredBalls = const [],
      this.searchText = '',
      this.filters = const BallFilters(),
      this.sortCriterion = const SortCriterion(field: SortField.id),
      this.isLoading = false,
      this.isLoadingMore = false,
      this.currentPage = 0,
      this.pageSize = 50,
      this.totalCount = 0,
      this.hasMoreData = false,
      this.error})
      : _allBalls = allBalls,
        _filteredBalls = filteredBalls,
        super._();

  final List<BowlingBall> _allBalls;
  @override
  @JsonKey()
  List<BowlingBall> get allBalls {
    if (_allBalls is EqualUnmodifiableListView) return _allBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allBalls);
  }

  final List<BowlingBall> _filteredBalls;
  @override
  @JsonKey()
  List<BowlingBall> get filteredBalls {
    if (_filteredBalls is EqualUnmodifiableListView) return _filteredBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredBalls);
  }

  @override
  @JsonKey()
  final String searchText;
  @override
  @JsonKey()
  final BallFilters filters;
  @override
  @JsonKey()
  final SortCriterion sortCriterion;
// 預設ID排序
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int totalCount;
  @override
  @JsonKey()
  final bool hasMoreData;
  @override
  final String? error;

  @override
  String toString() {
    return 'BallLibraryState(allBalls: $allBalls, filteredBalls: $filteredBalls, searchText: $searchText, filters: $filters, sortCriterion: $sortCriterion, isLoading: $isLoading, isLoadingMore: $isLoadingMore, currentPage: $currentPage, pageSize: $pageSize, totalCount: $totalCount, hasMoreData: $hasMoreData, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallLibraryStateImpl &&
            const DeepCollectionEquality().equals(other._allBalls, _allBalls) &&
            const DeepCollectionEquality()
                .equals(other._filteredBalls, _filteredBalls) &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.sortCriterion, sortCriterion) ||
                other.sortCriterion == sortCriterion) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMoreData, hasMoreData) ||
                other.hasMoreData == hasMoreData) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allBalls),
      const DeepCollectionEquality().hash(_filteredBalls),
      searchText,
      filters,
      sortCriterion,
      isLoading,
      isLoadingMore,
      currentPage,
      pageSize,
      totalCount,
      hasMoreData,
      error);

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallLibraryStateImplCopyWith<_$BallLibraryStateImpl> get copyWith =>
      __$$BallLibraryStateImplCopyWithImpl<_$BallLibraryStateImpl>(
          this, _$identity);
}

abstract class _BallLibraryState extends BallLibraryState {
  const factory _BallLibraryState(
      {final List<BowlingBall> allBalls,
      final List<BowlingBall> filteredBalls,
      final String searchText,
      final BallFilters filters,
      final SortCriterion sortCriterion,
      final bool isLoading,
      final bool isLoadingMore,
      final int currentPage,
      final int pageSize,
      final int totalCount,
      final bool hasMoreData,
      final String? error}) = _$BallLibraryStateImpl;
  const _BallLibraryState._() : super._();

  @override
  List<BowlingBall> get allBalls;
  @override
  List<BowlingBall> get filteredBalls;
  @override
  String get searchText;
  @override
  BallFilters get filters;
  @override
  SortCriterion get sortCriterion; // 預設ID排序
  @override
  bool get isLoading;
  @override
  bool get isLoadingMore;
  @override
  int get currentPage;
  @override
  int get pageSize;
  @override
  int get totalCount;
  @override
  bool get hasMoreData;
  @override
  String? get error;

  /// Create a copy of BallLibraryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallLibraryStateImplCopyWith<_$BallLibraryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
