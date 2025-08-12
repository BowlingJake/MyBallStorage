// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arsenal_core_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ArsenalCoreState {
  List<UserArsenalInstance> get allInstances =>
      throw _privateConstructorUsedError;
  List<String> get userCategories => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  int get selectedBagNumber => throw _privateConstructorUsedError;

  /// Create a copy of ArsenalCoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArsenalCoreStateCopyWith<ArsenalCoreState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArsenalCoreStateCopyWith<$Res> {
  factory $ArsenalCoreStateCopyWith(
          ArsenalCoreState value, $Res Function(ArsenalCoreState) then) =
      _$ArsenalCoreStateCopyWithImpl<$Res, ArsenalCoreState>;
  @useResult
  $Res call(
      {List<UserArsenalInstance> allInstances,
      List<String> userCategories,
      bool isLoading,
      String? error,
      String? selectedCategory,
      int selectedBagNumber});
}

/// @nodoc
class _$ArsenalCoreStateCopyWithImpl<$Res, $Val extends ArsenalCoreState>
    implements $ArsenalCoreStateCopyWith<$Res> {
  _$ArsenalCoreStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArsenalCoreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allInstances = null,
    Object? userCategories = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedCategory = freezed,
    Object? selectedBagNumber = null,
  }) {
    return _then(_value.copyWith(
      allInstances: null == allInstances
          ? _value.allInstances
          : allInstances // ignore: cast_nullable_to_non_nullable
              as List<UserArsenalInstance>,
      userCategories: null == userCategories
          ? _value.userCategories
          : userCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBagNumber: null == selectedBagNumber
          ? _value.selectedBagNumber
          : selectedBagNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArsenalCoreStateImplCopyWith<$Res>
    implements $ArsenalCoreStateCopyWith<$Res> {
  factory _$$ArsenalCoreStateImplCopyWith(_$ArsenalCoreStateImpl value,
          $Res Function(_$ArsenalCoreStateImpl) then) =
      __$$ArsenalCoreStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserArsenalInstance> allInstances,
      List<String> userCategories,
      bool isLoading,
      String? error,
      String? selectedCategory,
      int selectedBagNumber});
}

/// @nodoc
class __$$ArsenalCoreStateImplCopyWithImpl<$Res>
    extends _$ArsenalCoreStateCopyWithImpl<$Res, _$ArsenalCoreStateImpl>
    implements _$$ArsenalCoreStateImplCopyWith<$Res> {
  __$$ArsenalCoreStateImplCopyWithImpl(_$ArsenalCoreStateImpl _value,
      $Res Function(_$ArsenalCoreStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArsenalCoreState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allInstances = null,
    Object? userCategories = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? selectedCategory = freezed,
    Object? selectedBagNumber = null,
  }) {
    return _then(_$ArsenalCoreStateImpl(
      allInstances: null == allInstances
          ? _value._allInstances
          : allInstances // ignore: cast_nullable_to_non_nullable
              as List<UserArsenalInstance>,
      userCategories: null == userCategories
          ? _value._userCategories
          : userCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedBagNumber: null == selectedBagNumber
          ? _value.selectedBagNumber
          : selectedBagNumber // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ArsenalCoreStateImpl implements _ArsenalCoreState {
  const _$ArsenalCoreStateImpl(
      {final List<UserArsenalInstance> allInstances = const [],
      final List<String> userCategories = const [],
      this.isLoading = false,
      this.error,
      this.selectedCategory,
      this.selectedBagNumber = 1})
      : _allInstances = allInstances,
        _userCategories = userCategories;

  final List<UserArsenalInstance> _allInstances;
  @override
  @JsonKey()
  List<UserArsenalInstance> get allInstances {
    if (_allInstances is EqualUnmodifiableListView) return _allInstances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allInstances);
  }

  final List<String> _userCategories;
  @override
  @JsonKey()
  List<String> get userCategories {
    if (_userCategories is EqualUnmodifiableListView) return _userCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userCategories);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  final String? selectedCategory;
  @override
  @JsonKey()
  final int selectedBagNumber;

  @override
  String toString() {
    return 'ArsenalCoreState(allInstances: $allInstances, userCategories: $userCategories, isLoading: $isLoading, error: $error, selectedCategory: $selectedCategory, selectedBagNumber: $selectedBagNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsenalCoreStateImpl &&
            const DeepCollectionEquality()
                .equals(other._allInstances, _allInstances) &&
            const DeepCollectionEquality()
                .equals(other._userCategories, _userCategories) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedBagNumber, selectedBagNumber) ||
                other.selectedBagNumber == selectedBagNumber));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allInstances),
      const DeepCollectionEquality().hash(_userCategories),
      isLoading,
      error,
      selectedCategory,
      selectedBagNumber);

  /// Create a copy of ArsenalCoreState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArsenalCoreStateImplCopyWith<_$ArsenalCoreStateImpl> get copyWith =>
      __$$ArsenalCoreStateImplCopyWithImpl<_$ArsenalCoreStateImpl>(
          this, _$identity);
}

abstract class _ArsenalCoreState implements ArsenalCoreState {
  const factory _ArsenalCoreState(
      {final List<UserArsenalInstance> allInstances,
      final List<String> userCategories,
      final bool isLoading,
      final String? error,
      final String? selectedCategory,
      final int selectedBagNumber}) = _$ArsenalCoreStateImpl;

  @override
  List<UserArsenalInstance> get allInstances;
  @override
  List<String> get userCategories;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  String? get selectedCategory;
  @override
  int get selectedBagNumber;

  /// Create a copy of ArsenalCoreState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalCoreStateImplCopyWith<_$ArsenalCoreStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
