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
  bool get isMoveMode => throw _privateConstructorUsedError;
  Set<int> get selectedForMove => throw _privateConstructorUsedError;
  int get selectedBagNumber => throw _privateConstructorUsedError; // 預設選擇袋子 1
  SortOption get sortOption => throw _privateConstructorUsedError; // 排序選項
  bool get sortAscending => throw _privateConstructorUsedError;

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
      Set<int> selectedForRemoval,
      bool isMoveMode,
      Set<int> selectedForMove,
      int selectedBagNumber,
      SortOption sortOption,
      bool sortAscending});

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
    Object? isMoveMode = null,
    Object? selectedForMove = null,
    Object? selectedBagNumber = null,
    Object? sortOption = null,
    Object? sortAscending = null,
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
      isMoveMode: null == isMoveMode
          ? _value.isMoveMode
          : isMoveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedForMove: null == selectedForMove
          ? _value.selectedForMove
          : selectedForMove // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      selectedBagNumber: null == selectedBagNumber
          ? _value.selectedBagNumber
          : selectedBagNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sortOption: null == sortOption
          ? _value.sortOption
          : sortOption // ignore: cast_nullable_to_non_nullable
              as SortOption,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
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
      Set<int> selectedForRemoval,
      bool isMoveMode,
      Set<int> selectedForMove,
      int selectedBagNumber,
      SortOption sortOption,
      bool sortAscending});

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
    Object? isMoveMode = null,
    Object? selectedForMove = null,
    Object? selectedBagNumber = null,
    Object? sortOption = null,
    Object? sortAscending = null,
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
      isMoveMode: null == isMoveMode
          ? _value.isMoveMode
          : isMoveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedForMove: null == selectedForMove
          ? _value._selectedForMove
          : selectedForMove // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      selectedBagNumber: null == selectedBagNumber
          ? _value.selectedBagNumber
          : selectedBagNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sortOption: null == sortOption
          ? _value.sortOption
          : sortOption // ignore: cast_nullable_to_non_nullable
              as SortOption,
      sortAscending: null == sortAscending
          ? _value.sortAscending
          : sortAscending // ignore: cast_nullable_to_non_nullable
              as bool,
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
      final Set<int> selectedForRemoval = const {},
      this.isMoveMode = false,
      final Set<int> selectedForMove = const {},
      this.selectedBagNumber = 1,
      this.sortOption = SortOption.nameAZ,
      this.sortAscending = false})
      : _allInstances = allInstances,
        _userCategories = userCategories,
        _selectedForRemoval = selectedForRemoval,
        _selectedForMove = selectedForMove;

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
  @JsonKey()
  final bool isMoveMode;
  final Set<int> _selectedForMove;
  @override
  @JsonKey()
  Set<int> get selectedForMove {
    if (_selectedForMove is EqualUnmodifiableSetView) return _selectedForMove;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedForMove);
  }

  @override
  @JsonKey()
  final int selectedBagNumber;
// 預設選擇袋子 1
  @override
  @JsonKey()
  final SortOption sortOption;
// 排序選項
  @override
  @JsonKey()
  final bool sortAscending;

  @override
  String toString() {
    return 'NewArsenalState(allInstances: $allInstances, userCategories: $userCategories, selectedCategory: $selectedCategory, isLoading: $isLoading, error: $error, viewMode: $viewMode, searchText: $searchText, filters: $filters, isRemoveMode: $isRemoveMode, selectedForRemoval: $selectedForRemoval, isMoveMode: $isMoveMode, selectedForMove: $selectedForMove, selectedBagNumber: $selectedBagNumber, sortOption: $sortOption, sortAscending: $sortAscending)';
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
                .equals(other._selectedForRemoval, _selectedForRemoval) &&
            (identical(other.isMoveMode, isMoveMode) ||
                other.isMoveMode == isMoveMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedForMove, _selectedForMove) &&
            (identical(other.selectedBagNumber, selectedBagNumber) ||
                other.selectedBagNumber == selectedBagNumber) &&
            (identical(other.sortOption, sortOption) ||
                other.sortOption == sortOption) &&
            (identical(other.sortAscending, sortAscending) ||
                other.sortAscending == sortAscending));
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
      const DeepCollectionEquality().hash(_selectedForRemoval),
      isMoveMode,
      const DeepCollectionEquality().hash(_selectedForMove),
      selectedBagNumber,
      sortOption,
      sortAscending);

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
      final Set<int> selectedForRemoval,
      final bool isMoveMode,
      final Set<int> selectedForMove,
      final int selectedBagNumber,
      final SortOption sortOption,
      final bool sortAscending}) = _$NewArsenalStateImpl;

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
  @override
  bool get isMoveMode;
  @override
  Set<int> get selectedForMove;
  @override
  int get selectedBagNumber; // 預設選擇袋子 1
  @override
  SortOption get sortOption; // 排序選項
  @override
  bool get sortAscending;

  /// Create a copy of NewArsenalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewArsenalStateImplCopyWith<_$NewArsenalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
