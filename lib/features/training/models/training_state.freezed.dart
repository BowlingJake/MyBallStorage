// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainingState {
  List<TrainingDaySummary> get trainingDays =>
      throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError;
  Set<String> get selectedDayIds => throw _privateConstructorUsedError;

  /// Create a copy of TrainingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingStateCopyWith<TrainingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingStateCopyWith<$Res> {
  factory $TrainingStateCopyWith(
          TrainingState value, $Res Function(TrainingState) then) =
      _$TrainingStateCopyWithImpl<$Res, TrainingState>;
  @useResult
  $Res call(
      {List<TrainingDaySummary> trainingDays,
      bool isSelectionMode,
      Set<String> selectedDayIds});
}

/// @nodoc
class _$TrainingStateCopyWithImpl<$Res, $Val extends TrainingState>
    implements $TrainingStateCopyWith<$Res> {
  _$TrainingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainingDays = null,
    Object? isSelectionMode = null,
    Object? selectedDayIds = null,
  }) {
    return _then(_value.copyWith(
      trainingDays: null == trainingDays
          ? _value.trainingDays
          : trainingDays // ignore: cast_nullable_to_non_nullable
              as List<TrainingDaySummary>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDayIds: null == selectedDayIds
          ? _value.selectedDayIds
          : selectedDayIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingStateImplCopyWith<$Res>
    implements $TrainingStateCopyWith<$Res> {
  factory _$$TrainingStateImplCopyWith(
          _$TrainingStateImpl value, $Res Function(_$TrainingStateImpl) then) =
      __$$TrainingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TrainingDaySummary> trainingDays,
      bool isSelectionMode,
      Set<String> selectedDayIds});
}

/// @nodoc
class __$$TrainingStateImplCopyWithImpl<$Res>
    extends _$TrainingStateCopyWithImpl<$Res, _$TrainingStateImpl>
    implements _$$TrainingStateImplCopyWith<$Res> {
  __$$TrainingStateImplCopyWithImpl(
      _$TrainingStateImpl _value, $Res Function(_$TrainingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trainingDays = null,
    Object? isSelectionMode = null,
    Object? selectedDayIds = null,
  }) {
    return _then(_$TrainingStateImpl(
      trainingDays: null == trainingDays
          ? _value._trainingDays
          : trainingDays // ignore: cast_nullable_to_non_nullable
              as List<TrainingDaySummary>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDayIds: null == selectedDayIds
          ? _value._selectedDayIds
          : selectedDayIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$TrainingStateImpl extends _TrainingState {
  const _$TrainingStateImpl(
      {final List<TrainingDaySummary> trainingDays = const [],
      this.isSelectionMode = false,
      final Set<String> selectedDayIds = const <String>{}})
      : _trainingDays = trainingDays,
        _selectedDayIds = selectedDayIds,
        super._();

  final List<TrainingDaySummary> _trainingDays;
  @override
  @JsonKey()
  List<TrainingDaySummary> get trainingDays {
    if (_trainingDays is EqualUnmodifiableListView) return _trainingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trainingDays);
  }

  @override
  @JsonKey()
  final bool isSelectionMode;
  final Set<String> _selectedDayIds;
  @override
  @JsonKey()
  Set<String> get selectedDayIds {
    if (_selectedDayIds is EqualUnmodifiableSetView) return _selectedDayIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedDayIds);
  }

  @override
  String toString() {
    return 'TrainingState(trainingDays: $trainingDays, isSelectionMode: $isSelectionMode, selectedDayIds: $selectedDayIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._trainingDays, _trainingDays) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedDayIds, _selectedDayIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_trainingDays),
      isSelectionMode,
      const DeepCollectionEquality().hash(_selectedDayIds));

  /// Create a copy of TrainingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingStateImplCopyWith<_$TrainingStateImpl> get copyWith =>
      __$$TrainingStateImplCopyWithImpl<_$TrainingStateImpl>(this, _$identity);
}

abstract class _TrainingState extends TrainingState {
  const factory _TrainingState(
      {final List<TrainingDaySummary> trainingDays,
      final bool isSelectionMode,
      final Set<String> selectedDayIds}) = _$TrainingStateImpl;
  const _TrainingState._() : super._();

  @override
  List<TrainingDaySummary> get trainingDays;
  @override
  bool get isSelectionMode;
  @override
  Set<String> get selectedDayIds;

  /// Create a copy of TrainingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingStateImplCopyWith<_$TrainingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
