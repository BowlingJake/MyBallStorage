// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FavoritesState {
  List<BowlingBall> get favoriteBalls => throw _privateConstructorUsedError;
  Set<int> get favoriteBallIds => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritesStateCopyWith<FavoritesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesStateCopyWith<$Res> {
  factory $FavoritesStateCopyWith(
          FavoritesState value, $Res Function(FavoritesState) then) =
      _$FavoritesStateCopyWithImpl<$Res, FavoritesState>;
  @useResult
  $Res call(
      {List<BowlingBall> favoriteBalls,
      Set<int> favoriteBallIds,
      bool isLoading,
      bool isUpdating,
      String? error});
}

/// @nodoc
class _$FavoritesStateCopyWithImpl<$Res, $Val extends FavoritesState>
    implements $FavoritesStateCopyWith<$Res> {
  _$FavoritesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteBalls = null,
    Object? favoriteBallIds = null,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      favoriteBalls: null == favoriteBalls
          ? _value.favoriteBalls
          : favoriteBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      favoriteBallIds: null == favoriteBallIds
          ? _value.favoriteBallIds
          : favoriteBallIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavoritesStateImplCopyWith<$Res>
    implements $FavoritesStateCopyWith<$Res> {
  factory _$$FavoritesStateImplCopyWith(_$FavoritesStateImpl value,
          $Res Function(_$FavoritesStateImpl) then) =
      __$$FavoritesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BowlingBall> favoriteBalls,
      Set<int> favoriteBallIds,
      bool isLoading,
      bool isUpdating,
      String? error});
}

/// @nodoc
class __$$FavoritesStateImplCopyWithImpl<$Res>
    extends _$FavoritesStateCopyWithImpl<$Res, _$FavoritesStateImpl>
    implements _$$FavoritesStateImplCopyWith<$Res> {
  __$$FavoritesStateImplCopyWithImpl(
      _$FavoritesStateImpl _value, $Res Function(_$FavoritesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? favoriteBalls = null,
    Object? favoriteBallIds = null,
    Object? isLoading = null,
    Object? isUpdating = null,
    Object? error = freezed,
  }) {
    return _then(_$FavoritesStateImpl(
      favoriteBalls: null == favoriteBalls
          ? _value._favoriteBalls
          : favoriteBalls // ignore: cast_nullable_to_non_nullable
              as List<BowlingBall>,
      favoriteBallIds: null == favoriteBallIds
          ? _value._favoriteBallIds
          : favoriteBallIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FavoritesStateImpl implements _FavoritesState {
  const _$FavoritesStateImpl(
      {final List<BowlingBall> favoriteBalls = const [],
      final Set<int> favoriteBallIds = const {},
      this.isLoading = false,
      this.isUpdating = false,
      this.error})
      : _favoriteBalls = favoriteBalls,
        _favoriteBallIds = favoriteBallIds;

  final List<BowlingBall> _favoriteBalls;
  @override
  @JsonKey()
  List<BowlingBall> get favoriteBalls {
    if (_favoriteBalls is EqualUnmodifiableListView) return _favoriteBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteBalls);
  }

  final Set<int> _favoriteBallIds;
  @override
  @JsonKey()
  Set<int> get favoriteBallIds {
    if (_favoriteBallIds is EqualUnmodifiableSetView) return _favoriteBallIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_favoriteBallIds);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  final String? error;

  @override
  String toString() {
    return 'FavoritesState(favoriteBalls: $favoriteBalls, favoriteBallIds: $favoriteBallIds, isLoading: $isLoading, isUpdating: $isUpdating, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._favoriteBalls, _favoriteBalls) &&
            const DeepCollectionEquality()
                .equals(other._favoriteBallIds, _favoriteBallIds) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_favoriteBalls),
      const DeepCollectionEquality().hash(_favoriteBallIds),
      isLoading,
      isUpdating,
      error);

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesStateImplCopyWith<_$FavoritesStateImpl> get copyWith =>
      __$$FavoritesStateImplCopyWithImpl<_$FavoritesStateImpl>(
          this, _$identity);
}

abstract class _FavoritesState implements FavoritesState {
  const factory _FavoritesState(
      {final List<BowlingBall> favoriteBalls,
      final Set<int> favoriteBallIds,
      final bool isLoading,
      final bool isUpdating,
      final String? error}) = _$FavoritesStateImpl;

  @override
  List<BowlingBall> get favoriteBalls;
  @override
  Set<int> get favoriteBallIds;
  @override
  bool get isLoading;
  @override
  bool get isUpdating;
  @override
  String? get error;

  /// Create a copy of FavoritesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritesStateImplCopyWith<_$FavoritesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BallFavoriteState {
  bool get isFavorite => throw _privateConstructorUsedError;
  bool get isUpdating => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of BallFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BallFavoriteStateCopyWith<BallFavoriteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BallFavoriteStateCopyWith<$Res> {
  factory $BallFavoriteStateCopyWith(
          BallFavoriteState value, $Res Function(BallFavoriteState) then) =
      _$BallFavoriteStateCopyWithImpl<$Res, BallFavoriteState>;
  @useResult
  $Res call({bool isFavorite, bool isUpdating, String? error});
}

/// @nodoc
class _$BallFavoriteStateCopyWithImpl<$Res, $Val extends BallFavoriteState>
    implements $BallFavoriteStateCopyWith<$Res> {
  _$BallFavoriteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BallFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFavorite = null,
    Object? isUpdating = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BallFavoriteStateImplCopyWith<$Res>
    implements $BallFavoriteStateCopyWith<$Res> {
  factory _$$BallFavoriteStateImplCopyWith(_$BallFavoriteStateImpl value,
          $Res Function(_$BallFavoriteStateImpl) then) =
      __$$BallFavoriteStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isFavorite, bool isUpdating, String? error});
}

/// @nodoc
class __$$BallFavoriteStateImplCopyWithImpl<$Res>
    extends _$BallFavoriteStateCopyWithImpl<$Res, _$BallFavoriteStateImpl>
    implements _$$BallFavoriteStateImplCopyWith<$Res> {
  __$$BallFavoriteStateImplCopyWithImpl(_$BallFavoriteStateImpl _value,
      $Res Function(_$BallFavoriteStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BallFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFavorite = null,
    Object? isUpdating = null,
    Object? error = freezed,
  }) {
    return _then(_$BallFavoriteStateImpl(
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _value.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BallFavoriteStateImpl implements _BallFavoriteState {
  const _$BallFavoriteStateImpl(
      {this.isFavorite = false, this.isUpdating = false, this.error});

  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  final String? error;

  @override
  String toString() {
    return 'BallFavoriteState(isFavorite: $isFavorite, isUpdating: $isUpdating, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BallFavoriteStateImpl &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFavorite, isUpdating, error);

  /// Create a copy of BallFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BallFavoriteStateImplCopyWith<_$BallFavoriteStateImpl> get copyWith =>
      __$$BallFavoriteStateImplCopyWithImpl<_$BallFavoriteStateImpl>(
          this, _$identity);
}

abstract class _BallFavoriteState implements BallFavoriteState {
  const factory _BallFavoriteState(
      {final bool isFavorite,
      final bool isUpdating,
      final String? error}) = _$BallFavoriteStateImpl;

  @override
  bool get isFavorite;
  @override
  bool get isUpdating;
  @override
  String? get error;

  /// Create a copy of BallFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BallFavoriteStateImplCopyWith<_$BallFavoriteStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
