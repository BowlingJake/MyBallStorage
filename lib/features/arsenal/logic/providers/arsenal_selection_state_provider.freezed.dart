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
  SelectionModeType get selectionMode => throw _privateConstructorUsedError;
  Set<int> get selectedInstanceIds => throw _privateConstructorUsedError;
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
      {SelectionModeType selectionMode,
      Set<int> selectedInstanceIds,
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
    Object? selectionMode = null,
    Object? selectedInstanceIds = null,
    Object? isSelectionLocked = null,
  }) {
    return _then(_value.copyWith(
      selectionMode: null == selectionMode
          ? _value.selectionMode
          : selectionMode // ignore: cast_nullable_to_non_nullable
              as SelectionModeType,
      selectedInstanceIds: null == selectedInstanceIds
          ? _value.selectedInstanceIds
          : selectedInstanceIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
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
      {SelectionModeType selectionMode,
      Set<int> selectedInstanceIds,
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
    Object? selectionMode = null,
    Object? selectedInstanceIds = null,
    Object? isSelectionLocked = null,
  }) {
    return _then(_$ArsenalSelectionStateImpl(
      selectionMode: null == selectionMode
          ? _value.selectionMode
          : selectionMode // ignore: cast_nullable_to_non_nullable
              as SelectionModeType,
      selectedInstanceIds: null == selectedInstanceIds
          ? _value._selectedInstanceIds
          : selectedInstanceIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isSelectionLocked: null == isSelectionLocked
          ? _value.isSelectionLocked
          : isSelectionLocked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ArsenalSelectionStateImpl extends _ArsenalSelectionState {
  const _$ArsenalSelectionStateImpl(
      {this.selectionMode = SelectionModeType.none,
      final Set<int> selectedInstanceIds = const {},
      this.isSelectionLocked = false})
      : _selectedInstanceIds = selectedInstanceIds,
        super._();

  @override
  @JsonKey()
  final SelectionModeType selectionMode;
  final Set<int> _selectedInstanceIds;
  @override
  @JsonKey()
  Set<int> get selectedInstanceIds {
    if (_selectedInstanceIds is EqualUnmodifiableSetView)
      return _selectedInstanceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedInstanceIds);
  }

  @override
  @JsonKey()
  final bool isSelectionLocked;

  @override
  String toString() {
    return 'ArsenalSelectionState(selectionMode: $selectionMode, selectedInstanceIds: $selectedInstanceIds, isSelectionLocked: $isSelectionLocked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArsenalSelectionStateImpl &&
            (identical(other.selectionMode, selectionMode) ||
                other.selectionMode == selectionMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedInstanceIds, _selectedInstanceIds) &&
            (identical(other.isSelectionLocked, isSelectionLocked) ||
                other.isSelectionLocked == isSelectionLocked));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectionMode,
      const DeepCollectionEquality().hash(_selectedInstanceIds),
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

abstract class _ArsenalSelectionState extends ArsenalSelectionState {
  const factory _ArsenalSelectionState(
      {final SelectionModeType selectionMode,
      final Set<int> selectedInstanceIds,
      final bool isSelectionLocked}) = _$ArsenalSelectionStateImpl;
  const _ArsenalSelectionState._() : super._();

  @override
  SelectionModeType get selectionMode;
  @override
  Set<int> get selectedInstanceIds;
  @override
  bool get isSelectionLocked;

  /// Create a copy of ArsenalSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArsenalSelectionStateImplCopyWith<_$ArsenalSelectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
