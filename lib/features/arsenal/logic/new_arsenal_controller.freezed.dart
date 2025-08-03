// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_arsenal_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NewArsenalState {
  List<UserArsenalInstance> get allInstances =>
      throw _privateConstructorUsedError;
  List<String> get userCategories => throw _privateConstructorUsedError;
  String? get selectedCategory =>
      throw _privateConstructorUsedError; // null means "All My Arsenal"
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  ArsenalViewMode get viewMode => throw _privateConstructorUsedError;
  String get searchText => throw _privateConstructorUsedError;
  BallFilters get filters => throw _privateConstructorUsedError;
  bool get isRemoveMode => throw _privateConstructorUsedError;
  Set<int> get selectedForRemoval => throw _privateConstructorUsedError;

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewArsenalStateCopyWith<NewArsenalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewArsenalStateCopyWith<$Res> {
  factory $NewArsenalStateCopyWith(
          NewArsenalState value, $Res Function(NewArsenalState) then) =
      _$NewArsenalStateCopyWithImpl<$Res, NewArsenalState>;
  @useResult
  $Res call(
      {List<UserArsenalInstance> allInstances,
      List<String> userCategories,
      String? selectedCategory,
      bool isLoading,
      String? error,
      ArsenalViewMode viewMode,
      String searchText,
      BallFilters filters,
      bool isRemoveMode,
      Set<int> selectedForRemoval});

  $BallFiltersCopyWith<$Res> get filters;
}

/// @nodoc
class _$NewArsenalStateCopyWithImpl<$Res, $Val extends NewArsenalState>
    implements $NewArsenalStateCopyWith<$Res> {
  _$NewArsenalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allInstances = null,
    Object? userCategories = null,
    Object? selectedCategory = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? viewMode = null,
    Object? searchText = null,
    Object? filters = null,
    Object? isRemoveMode = null,
    Object? selectedForRemoval = null,
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
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ArsenalViewMode,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as BallFilters,
      isRemoveMode: null == isRemoveMode
          ? _value.isRemoveMode
          : isRemoveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedForRemoval: null == selectedForRemoval
          ? _value.selectedForRemoval
          : selectedForRemoval // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ) as $Val);
  }

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BallFiltersCopyWith<$Res> get filters {
    return $BallFiltersCopyWith<$Res>(_value.filters, (value) {
      return _then(_value.copyWith(filters: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NewArsenalStateImplCopyWith<$Res>
    implements $NewArsenalStateCopyWith<$Res> {
  factory _$$NewArsenalStateImplCopyWith(_$NewArsenalStateImpl value,
          $Res Function(_$NewArsenalStateImpl) then) =
      __$$NewArsenalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserArsenalInstance> allInstances,
      List<String> userCategories,
      String? selectedCategory,
      bool isLoading,
      String? error,
      ArsenalViewMode viewMode,
      String searchText,
      BallFilters filters,
      bool isRemoveMode,
      Set<int> selectedForRemoval});

  @override
  $BallFiltersCopyWith<$Res> get filters;
}

/// @nodoc
class __$$NewArsenalStateImplCopyWithImpl<$Res>
    extends _$NewArsenalStateCopyWithImpl<$Res, _$NewArsenalStateImpl>
    implements _$$NewArsenalStateImplCopyWith<$Res> {
  __$$NewArsenalStateImplCopyWithImpl(
      _$NewArsenalStateImpl _value, $Res Function(_$NewArsenalStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allInstances = null,
    Object? userCategories = null,
    Object? selectedCategory = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? viewMode = null,
    Object? searchText = null,
    Object? filters = null,
    Object? isRemoveMode = null,
    Object? selectedForRemoval = null,
  }) {
    return _then(_$NewArsenalStateImpl(
      allInstances: null == allInstances
          ? _value._allInstances
          : allInstances // ignore: cast_nullable_to_non_nullable
              as List<UserArsenalInstance>,
      userCategories: null == userCategories
          ? _value._userCategories
          : userCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      viewMode: null == viewMode
          ? _value.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as ArsenalViewMode,
      searchText: null == searchText
          ? _value.searchText
          : searchText // ignore: cast_nullable_to_non_nullable
              as String,
      filters: null == filters
          ? _value.filters
          : filters // ignore: cast_nullable_to_non_nullable
              as BallFilters,
      isRemoveMode: null == isRemoveMode
          ? _value.isRemoveMode
          : isRemoveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedForRemoval: null == selectedForRemoval
          ? _value._selectedForRemoval
          : selectedForRemoval // ignore: cast_nullable_to_non_nullable
              as Set<int>,
    ));
  }
}

/// @nodoc

class _$NewArsenalStateImpl implements _NewArsenalState {
  const _$NewArsenalStateImpl(
      {final List<UserArsenalInstance> allInstances = const [],
      final List<String> userCategories = const [],
      this.selectedCategory,
      this.isLoading = false,
      this.error,
      this.viewMode = ArsenalViewMode.grid,
      this.searchText = '',
      this.filters = const BallFilters(),
      this.isRemoveMode = false,
      final Set<int> selectedForRemoval = const {}})
      : _allInstances = allInstances,
        _userCategories = userCategories,
        _selectedForRemoval = selectedForRemoval;

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
  final String? selectedCategory;
// null means "All My Arsenal"
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
  @override
  @JsonKey()
  final ArsenalViewMode viewMode;
  @override
  @JsonKey()
  final String searchText;
  @override
  @JsonKey()
  final BallFilters filters;
  @override
  @JsonKey()
  final bool isRemoveMode;
  final Set<int> _selectedForRemoval;
  @override
  @JsonKey()
  Set<int> get selectedForRemoval {
    if (_selectedForRemoval is EqualUnmodifiableSetView)
      return _selectedForRemoval;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedForRemoval);
  }

  @override
  String toString() {
    return 'NewArsenalState(allInstances: $allInstances, userCategories: $userCategories, selectedCategory: $selectedCategory, isLoading: $isLoading, error: $error, viewMode: $viewMode, searchText: $searchText, filters: $filters, isRemoveMode: $isRemoveMode, selectedForRemoval: $selectedForRemoval)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewArsenalStateImpl &&
            const DeepCollectionEquality()
                .equals(other._allInstances, _allInstances) &&
            const DeepCollectionEquality()
                .equals(other._userCategories, _userCategories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.searchText, searchText) ||
                other.searchText == searchText) &&
            (identical(other.filters, filters) || other.filters == filters) &&
            (identical(other.isRemoveMode, isRemoveMode) ||
                other.isRemoveMode == isRemoveMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedForRemoval, _selectedForRemoval));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_allInstances),
      const DeepCollectionEquality().hash(_userCategories),
      selectedCategory,
      isLoading,
      error,
      viewMode,
      searchText,
      filters,
      isRemoveMode,
      const DeepCollectionEquality().hash(_selectedForRemoval));

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewArsenalStateImplCopyWith<_$NewArsenalStateImpl> get copyWith =>
      __$$NewArsenalStateImplCopyWithImpl<_$NewArsenalStateImpl>(
          this, _$identity);
}

abstract class _NewArsenalState implements NewArsenalState {
  const factory _NewArsenalState(
      {final List<UserArsenalInstance> allInstances,
      final List<String> userCategories,
      final String? selectedCategory,
      final bool isLoading,
      final String? error,
      final ArsenalViewMode viewMode,
      final String searchText,
      final BallFilters filters,
      final bool isRemoveMode,
      final Set<int> selectedForRemoval}) = _$NewArsenalStateImpl;

  @override
  List<UserArsenalInstance> get allInstances;
  @override
  List<String> get userCategories;
  @override
  String? get selectedCategory; // null means "All My Arsenal"
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  ArsenalViewMode get viewMode;
  @override
  String get searchText;
  @override
  BallFilters get filters;
  @override
  bool get isRemoveMode;
  @override
  Set<int> get selectedForRemoval;

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewArsenalStateImplCopyWith<_$NewArsenalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
