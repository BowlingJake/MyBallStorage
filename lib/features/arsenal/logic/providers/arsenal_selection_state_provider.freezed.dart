// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arsenal_selection_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ArsenalSelectionState {
  bool get isRemoveMode => throw _privateConstructorUsedError;
  Set<int> get selectedForRemoval => throw _privateConstructorUsedError;
  bool get isMoveMode => throw _privateConstructorUsedError;
  Set<int> get selectedForMove => throw _privateConstructorUsedError;
  SelectionModeType get activeMode => throw _privateConstructorUsedError;
  bool get isSelectionLocked => throw _privateConstructorUsedError;

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArsenalSelectionStateCopyWith<ArsenalSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArsenalSelectionStateCopyWith<$Res> {
  factory $ArsenalSelectionStateCopyWith(ArsenalSelectionState value,
          $Res Function(ArsenalSelectionState) then) =
      _$ArsenalSelectionStateCopyWithImpl<$Res, ArsenalSelectionState>;
  @useResult
  $Res call(
      {bool isRemoveMode,
      Set<int> selectedForRemoval,
      bool isMoveMode,
      Set<int> selectedForMove,
      SelectionModeType activeMode,
      bool isSelectionLocked});
}

/// @nodoc
class _$ArsenalSelectionStateCopyWithImpl<$Res,
        $Val extends ArsenalSelectionState>
    implements $ArsenalSelectionStateCopyWith<$Res> {
  _$ArsenalSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRemoveMode = null,
    Object? selectedForRemoval = null,
    Object? isMoveMode = null,
    Object? selectedForMove = null,
    Object? activeMode = null,
    Object? isSelectionLocked = null,
  }) {
    return _then(_value.copyWith(
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
      activeMode: null == activeMode
          ? _value.activeMode
          : activeMode // ignore: cast_nullable_to_non_nullable
              as SelectionModeType,
      isSelectionLocked: null == isSelectionLocked
          ? _value.isSelectionLocked
          : isSelectionLocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArsenalSelectionStateImplCopyWith<$Res>
    implements $ArsenalSelectionStateCopyWith<$Res> {
  factory _$$ArsenalSelectionStateImplCopyWith(
          _$ArsenalSelectionStateImpl value,
          $Res Function(_$ArsenalSelectionStateImpl) then) =
      __$$ArsenalSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRemoveMode,
      Set<int> selectedForRemoval,
      bool isMoveMode,
      Set<int> selectedForMove,
      SelectionModeType activeMode,
      bool isSelectionLocked});
}

/// @nodoc
class __$$ArsenalSelectionStateImplCopyWithImpl<$Res>
    extends _$ArsenalSelectionStateCopyWithImpl<$Res,
        _$ArsenalSelectionStateImpl>
    implements _$$ArsenalSelectionStateImplCopyWith<$Res> {
  __$$ArsenalSelectionStateImplCopyWithImpl(_$ArsenalSelectionStateImpl _value,
      $Res Function(_$ArsenalSelectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRemoveMode = null,
    Object? selectedForRemoval = null,
    Object? isMoveMode = null,
    Object? selectedForMove = null,
    Object? activeMode = null,
    Object? isSelectionLocked = null,
  }) {
    return _then(_$ArsenalSelectionStateImpl(
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
      activeMode: null == activeMode
          ? _value.activeMode
          : activeMode // ignore: cast_nullable_to_non_nullable
              as SelectionModeType,
      isSelectionLocked: null == isSelectionLocked
          ? _value.isSelectionLocked
          : isSelectionLocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ArsenalSelectionStateImpl implements _ArsenalSelectionState {
  const _$ArsenalSelectionStateImpl(
      {this.isRemoveMode = false,
      final Set<int> selectedForRemoval = const {},
      this.isMoveMode = false,
      final Set<int> selectedForMove = const {},
      this.activeMode = SelectionModeType.none,
      this.isSelectionLocked = false})
      : _selectedForRemoval = selectedForRemoval,
        _selectedForMove = selectedForMove;

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
  final SelectionModeType activeMode;
  @override
  @JsonKey()
  final bool isSelectionLocked;

  @override
  String toString() {
    return 'ArsenalSelectionState(isRemoveMode: $isRemoveMode, selectedForRemoval: $selectedForRemoval, isMoveMode: $isMoveMode, selectedForMove: $selectedForMove, activeMode: $activeMode, isSelectionLocked: $isSelectionLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsenalSelectionStateImpl &&
            (identical(other.isRemoveMode, isRemoveMode) ||
                other.isRemoveMode == isRemoveMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedForRemoval, _selectedForRemoval) &&
            (identical(other.isMoveMode, isMoveMode) ||
                other.isMoveMode == isMoveMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedForMove, _selectedForMove) &&
            (identical(other.activeMode, activeMode) ||
                other.activeMode == activeMode) &&
            (identical(other.isSelectionLocked, isSelectionLocked) ||
                other.isSelectionLocked == isSelectionLocked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isRemoveMode,
      const DeepCollectionEquality().hash(_selectedForRemoval),
      isMoveMode,
      const DeepCollectionEquality().hash(_selectedForMove),
      activeMode,
      isSelectionLocked);

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArsenalSelectionStateImplCopyWith<_$ArsenalSelectionStateImpl>
      get copyWith => __$$ArsenalSelectionStateImplCopyWithImpl<
          _$ArsenalSelectionStateImpl>(this, _$identity);
}

abstract class _ArsenalSelectionState implements ArsenalSelectionState {
  const factory _ArsenalSelectionState(
      {final bool isRemoveMode,
      final Set<int> selectedForRemoval,
      final bool isMoveMode,
      final Set<int> selectedForMove,
      final SelectionModeType activeMode,
      final bool isSelectionLocked}) = _$ArsenalSelectionStateImpl;

  @override
  bool get isRemoveMode;
  @override
  Set<int> get selectedForRemoval;
  @override
  bool get isMoveMode;
  @override
  Set<int> get selectedForMove;
  @override
  SelectionModeType get activeMode;
  @override
  bool get isSelectionLocked;

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalSelectionStateImplCopyWith<_$ArsenalSelectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
