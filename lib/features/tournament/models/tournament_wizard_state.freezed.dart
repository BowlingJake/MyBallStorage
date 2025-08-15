// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_wizard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TournamentWizardState {
// Step 1: Basic Information
  String get tournamentName => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  TournamentDateMode get dateMode => throw _privateConstructorUsedError;
  List<DateTime> get nonContinuousDates => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  bool get useCustomLocation =>
      throw _privateConstructorUsedError; // Step 2: Tournament Configuration
  String get oilPatternName => throw _privateConstructorUsedError;
  String get oilPatternLength => throw _privateConstructorUsedError;
  bool get isHousePattern => throw _privateConstructorUsedError;
  String get entryFee => throw _privateConstructorUsedError;
  String get prizeInfo => throw _privateConstructorUsedError;
  String get tournamentType =>
      throw _privateConstructorUsedError; // recreational, competitive, professional
// Step 3: Smart Recommendations
  List<String> get recommendedBalls => throw _privateConstructorUsedError;
  String get strategyRecommendation => throw _privateConstructorUsedError;
  bool get analysisCompleted => throw _privateConstructorUsedError; // UI State
  int get currentStep => throw _privateConstructorUsedError;
  bool get isStep1Valid => throw _privateConstructorUsedError;
  bool get isStep2Valid => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TournamentWizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentWizardStateCopyWith<TournamentWizardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentWizardStateCopyWith<$Res> {
  factory $TournamentWizardStateCopyWith(TournamentWizardState value,
          $Res Function(TournamentWizardState) then) =
      _$TournamentWizardStateCopyWithImpl<$Res, TournamentWizardState>;
  @useResult
  $Res call(
      {String tournamentName,
      DateTime? startDate,
      DateTime? endDate,
      TournamentDateMode dateMode,
      List<DateTime> nonContinuousDates,
      String location,
      bool useCustomLocation,
      String oilPatternName,
      String oilPatternLength,
      bool isHousePattern,
      String entryFee,
      String prizeInfo,
      String tournamentType,
      List<String> recommendedBalls,
      String strategyRecommendation,
      bool analysisCompleted,
      int currentStep,
      bool isStep1Valid,
      bool isStep2Valid,
      bool isLoading,
      String errorMessage});
}

/// @nodoc
class _$TournamentWizardStateCopyWithImpl<$Res,
        $Val extends TournamentWizardState>
    implements $TournamentWizardStateCopyWith<$Res> {
  _$TournamentWizardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentWizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tournamentName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? dateMode = null,
    Object? nonContinuousDates = null,
    Object? location = null,
    Object? useCustomLocation = null,
    Object? oilPatternName = null,
    Object? oilPatternLength = null,
    Object? isHousePattern = null,
    Object? entryFee = null,
    Object? prizeInfo = null,
    Object? tournamentType = null,
    Object? recommendedBalls = null,
    Object? strategyRecommendation = null,
    Object? analysisCompleted = null,
    Object? currentStep = null,
    Object? isStep1Valid = null,
    Object? isStep2Valid = null,
    Object? isLoading = null,
    Object? errorMessage = null,
  }) {
    return _then(_value.copyWith(
      tournamentName: null == tournamentName
          ? _value.tournamentName
          : tournamentName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateMode: null == dateMode
          ? _value.dateMode
          : dateMode // ignore: cast_nullable_to_non_nullable
              as TournamentDateMode,
      nonContinuousDates: null == nonContinuousDates
          ? _value.nonContinuousDates
          : nonContinuousDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      useCustomLocation: null == useCustomLocation
          ? _value.useCustomLocation
          : useCustomLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      oilPatternName: null == oilPatternName
          ? _value.oilPatternName
          : oilPatternName // ignore: cast_nullable_to_non_nullable
              as String,
      oilPatternLength: null == oilPatternLength
          ? _value.oilPatternLength
          : oilPatternLength // ignore: cast_nullable_to_non_nullable
              as String,
      isHousePattern: null == isHousePattern
          ? _value.isHousePattern
          : isHousePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      entryFee: null == entryFee
          ? _value.entryFee
          : entryFee // ignore: cast_nullable_to_non_nullable
              as String,
      prizeInfo: null == prizeInfo
          ? _value.prizeInfo
          : prizeInfo // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentType: null == tournamentType
          ? _value.tournamentType
          : tournamentType // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedBalls: null == recommendedBalls
          ? _value.recommendedBalls
          : recommendedBalls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strategyRecommendation: null == strategyRecommendation
          ? _value.strategyRecommendation
          : strategyRecommendation // ignore: cast_nullable_to_non_nullable
              as String,
      analysisCompleted: null == analysisCompleted
          ? _value.analysisCompleted
          : analysisCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      isStep1Valid: null == isStep1Valid
          ? _value.isStep1Valid
          : isStep1Valid // ignore: cast_nullable_to_non_nullable
              as bool,
      isStep2Valid: null == isStep2Valid
          ? _value.isStep2Valid
          : isStep2Valid // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentWizardStateImplCopyWith<$Res>
    implements $TournamentWizardStateCopyWith<$Res> {
  factory _$$TournamentWizardStateImplCopyWith(
          _$TournamentWizardStateImpl value,
          $Res Function(_$TournamentWizardStateImpl) then) =
      __$$TournamentWizardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String tournamentName,
      DateTime? startDate,
      DateTime? endDate,
      TournamentDateMode dateMode,
      List<DateTime> nonContinuousDates,
      String location,
      bool useCustomLocation,
      String oilPatternName,
      String oilPatternLength,
      bool isHousePattern,
      String entryFee,
      String prizeInfo,
      String tournamentType,
      List<String> recommendedBalls,
      String strategyRecommendation,
      bool analysisCompleted,
      int currentStep,
      bool isStep1Valid,
      bool isStep2Valid,
      bool isLoading,
      String errorMessage});
}

/// @nodoc
class __$$TournamentWizardStateImplCopyWithImpl<$Res>
    extends _$TournamentWizardStateCopyWithImpl<$Res,
        _$TournamentWizardStateImpl>
    implements _$$TournamentWizardStateImplCopyWith<$Res> {
  __$$TournamentWizardStateImplCopyWithImpl(_$TournamentWizardStateImpl _value,
      $Res Function(_$TournamentWizardStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TournamentWizardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tournamentName = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? dateMode = null,
    Object? nonContinuousDates = null,
    Object? location = null,
    Object? useCustomLocation = null,
    Object? oilPatternName = null,
    Object? oilPatternLength = null,
    Object? isHousePattern = null,
    Object? entryFee = null,
    Object? prizeInfo = null,
    Object? tournamentType = null,
    Object? recommendedBalls = null,
    Object? strategyRecommendation = null,
    Object? analysisCompleted = null,
    Object? currentStep = null,
    Object? isStep1Valid = null,
    Object? isStep2Valid = null,
    Object? isLoading = null,
    Object? errorMessage = null,
  }) {
    return _then(_$TournamentWizardStateImpl(
      tournamentName: null == tournamentName
          ? _value.tournamentName
          : tournamentName // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateMode: null == dateMode
          ? _value.dateMode
          : dateMode // ignore: cast_nullable_to_non_nullable
              as TournamentDateMode,
      nonContinuousDates: null == nonContinuousDates
          ? _value._nonContinuousDates
          : nonContinuousDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      useCustomLocation: null == useCustomLocation
          ? _value.useCustomLocation
          : useCustomLocation // ignore: cast_nullable_to_non_nullable
              as bool,
      oilPatternName: null == oilPatternName
          ? _value.oilPatternName
          : oilPatternName // ignore: cast_nullable_to_non_nullable
              as String,
      oilPatternLength: null == oilPatternLength
          ? _value.oilPatternLength
          : oilPatternLength // ignore: cast_nullable_to_non_nullable
              as String,
      isHousePattern: null == isHousePattern
          ? _value.isHousePattern
          : isHousePattern // ignore: cast_nullable_to_non_nullable
              as bool,
      entryFee: null == entryFee
          ? _value.entryFee
          : entryFee // ignore: cast_nullable_to_non_nullable
              as String,
      prizeInfo: null == prizeInfo
          ? _value.prizeInfo
          : prizeInfo // ignore: cast_nullable_to_non_nullable
              as String,
      tournamentType: null == tournamentType
          ? _value.tournamentType
          : tournamentType // ignore: cast_nullable_to_non_nullable
              as String,
      recommendedBalls: null == recommendedBalls
          ? _value._recommendedBalls
          : recommendedBalls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      strategyRecommendation: null == strategyRecommendation
          ? _value.strategyRecommendation
          : strategyRecommendation // ignore: cast_nullable_to_non_nullable
              as String,
      analysisCompleted: null == analysisCompleted
          ? _value.analysisCompleted
          : analysisCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as int,
      isStep1Valid: null == isStep1Valid
          ? _value.isStep1Valid
          : isStep1Valid // ignore: cast_nullable_to_non_nullable
              as bool,
      isStep2Valid: null == isStep2Valid
          ? _value.isStep2Valid
          : isStep2Valid // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: null == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TournamentWizardStateImpl implements _TournamentWizardState {
  const _$TournamentWizardStateImpl(
      {this.tournamentName = '',
      this.startDate,
      this.endDate,
      this.dateMode = TournamentDateMode.singleDay,
      final List<DateTime> nonContinuousDates = const [],
      this.location = '',
      this.useCustomLocation = false,
      this.oilPatternName = '',
      this.oilPatternLength = '',
      this.isHousePattern = true,
      this.entryFee = '',
      this.prizeInfo = '',
      this.tournamentType = 'recreational',
      final List<String> recommendedBalls = const [],
      this.strategyRecommendation = '',
      this.analysisCompleted = false,
      this.currentStep = 1,
      this.isStep1Valid = false,
      this.isStep2Valid = false,
      this.isLoading = false,
      this.errorMessage = ''})
      : _nonContinuousDates = nonContinuousDates,
        _recommendedBalls = recommendedBalls;

// Step 1: Basic Information
  @override
  @JsonKey()
  final String tournamentName;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final TournamentDateMode dateMode;
  final List<DateTime> _nonContinuousDates;
  @override
  @JsonKey()
  List<DateTime> get nonContinuousDates {
    if (_nonContinuousDates is EqualUnmodifiableListView)
      return _nonContinuousDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nonContinuousDates);
  }

  @override
  @JsonKey()
  final String location;
  @override
  @JsonKey()
  final bool useCustomLocation;
// Step 2: Tournament Configuration
  @override
  @JsonKey()
  final String oilPatternName;
  @override
  @JsonKey()
  final String oilPatternLength;
  @override
  @JsonKey()
  final bool isHousePattern;
  @override
  @JsonKey()
  final String entryFee;
  @override
  @JsonKey()
  final String prizeInfo;
  @override
  @JsonKey()
  final String tournamentType;
// recreational, competitive, professional
// Step 3: Smart Recommendations
  final List<String> _recommendedBalls;
// recreational, competitive, professional
// Step 3: Smart Recommendations
  @override
  @JsonKey()
  List<String> get recommendedBalls {
    if (_recommendedBalls is EqualUnmodifiableListView)
      return _recommendedBalls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedBalls);
  }

  @override
  @JsonKey()
  final String strategyRecommendation;
  @override
  @JsonKey()
  final bool analysisCompleted;
// UI State
  @override
  @JsonKey()
  final int currentStep;
  @override
  @JsonKey()
  final bool isStep1Valid;
  @override
  @JsonKey()
  final bool isStep2Valid;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String errorMessage;

  @override
  String toString() {
    return 'TournamentWizardState(tournamentName: $tournamentName, startDate: $startDate, endDate: $endDate, dateMode: $dateMode, nonContinuousDates: $nonContinuousDates, location: $location, useCustomLocation: $useCustomLocation, oilPatternName: $oilPatternName, oilPatternLength: $oilPatternLength, isHousePattern: $isHousePattern, entryFee: $entryFee, prizeInfo: $prizeInfo, tournamentType: $tournamentType, recommendedBalls: $recommendedBalls, strategyRecommendation: $strategyRecommendation, analysisCompleted: $analysisCompleted, currentStep: $currentStep, isStep1Valid: $isStep1Valid, isStep2Valid: $isStep2Valid, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentWizardStateImpl &&
            (identical(other.tournamentName, tournamentName) ||
                other.tournamentName == tournamentName) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.dateMode, dateMode) ||
                other.dateMode == dateMode) &&
            const DeepCollectionEquality()
                .equals(other._nonContinuousDates, _nonContinuousDates) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.useCustomLocation, useCustomLocation) ||
                other.useCustomLocation == useCustomLocation) &&
            (identical(other.oilPatternName, oilPatternName) ||
                other.oilPatternName == oilPatternName) &&
            (identical(other.oilPatternLength, oilPatternLength) ||
                other.oilPatternLength == oilPatternLength) &&
            (identical(other.isHousePattern, isHousePattern) ||
                other.isHousePattern == isHousePattern) &&
            (identical(other.entryFee, entryFee) ||
                other.entryFee == entryFee) &&
            (identical(other.prizeInfo, prizeInfo) ||
                other.prizeInfo == prizeInfo) &&
            (identical(other.tournamentType, tournamentType) ||
                other.tournamentType == tournamentType) &&
            const DeepCollectionEquality()
                .equals(other._recommendedBalls, _recommendedBalls) &&
            (identical(other.strategyRecommendation, strategyRecommendation) ||
                other.strategyRecommendation == strategyRecommendation) &&
            (identical(other.analysisCompleted, analysisCompleted) ||
                other.analysisCompleted == analysisCompleted) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.isStep1Valid, isStep1Valid) ||
                other.isStep1Valid == isStep1Valid) &&
            (identical(other.isStep2Valid, isStep2Valid) ||
                other.isStep2Valid == isStep2Valid) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        tournamentName,
        startDate,
        endDate,
        dateMode,
        const DeepCollectionEquality().hash(_nonContinuousDates),
        location,
        useCustomLocation,
        oilPatternName,
        oilPatternLength,
        isHousePattern,
        entryFee,
        prizeInfo,
        tournamentType,
        const DeepCollectionEquality().hash(_recommendedBalls),
        strategyRecommendation,
        analysisCompleted,
        currentStep,
        isStep1Valid,
        isStep2Valid,
        isLoading,
        errorMessage
      ]);

  /// Create a copy of TournamentWizardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentWizardStateImplCopyWith<_$TournamentWizardStateImpl>
      get copyWith => __$$TournamentWizardStateImplCopyWithImpl<
          _$TournamentWizardStateImpl>(this, _$identity);
}

abstract class _TournamentWizardState implements TournamentWizardState {
  const factory _TournamentWizardState(
      {final String tournamentName,
      final DateTime? startDate,
      final DateTime? endDate,
      final TournamentDateMode dateMode,
      final List<DateTime> nonContinuousDates,
      final String location,
      final bool useCustomLocation,
      final String oilPatternName,
      final String oilPatternLength,
      final bool isHousePattern,
      final String entryFee,
      final String prizeInfo,
      final String tournamentType,
      final List<String> recommendedBalls,
      final String strategyRecommendation,
      final bool analysisCompleted,
      final int currentStep,
      final bool isStep1Valid,
      final bool isStep2Valid,
      final bool isLoading,
      final String errorMessage}) = _$TournamentWizardStateImpl;

// Step 1: Basic Information
  @override
  String get tournamentName;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  TournamentDateMode get dateMode;
  @override
  List<DateTime> get nonContinuousDates;
  @override
  String get location;
  @override
  bool get useCustomLocation; // Step 2: Tournament Configuration
  @override
  String get oilPatternName;
  @override
  String get oilPatternLength;
  @override
  bool get isHousePattern;
  @override
  String get entryFee;
  @override
  String get prizeInfo;
  @override
  String get tournamentType; // recreational, competitive, professional
// Step 3: Smart Recommendations
  @override
  List<String> get recommendedBalls;
  @override
  String get strategyRecommendation;
  @override
  bool get analysisCompleted; // UI State
  @override
  int get currentStep;
  @override
  bool get isStep1Valid;
  @override
  bool get isStep2Valid;
  @override
  bool get isLoading;
  @override
  String get errorMessage;

  /// Create a copy of TournamentWizardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentWizardStateImplCopyWith<_$TournamentWizardStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TournamentRecommendation {
  String get ballName => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  bool get isSelected => throw _privateConstructorUsedError;

  /// Create a copy of TournamentRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentRecommendationCopyWith<TournamentRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentRecommendationCopyWith<$Res> {
  factory $TournamentRecommendationCopyWith(TournamentRecommendation value,
          $Res Function(TournamentRecommendation) then) =
      _$TournamentRecommendationCopyWithImpl<$Res, TournamentRecommendation>;
  @useResult
  $Res call(
      {String ballName,
      String reason,
      double confidenceScore,
      bool isSelected});
}

/// @nodoc
class _$TournamentRecommendationCopyWithImpl<$Res,
        $Val extends TournamentRecommendation>
    implements $TournamentRecommendationCopyWith<$Res> {
  _$TournamentRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballName = null,
    Object? reason = null,
    Object? confidenceScore = null,
    Object? isSelected = null,
  }) {
    return _then(_value.copyWith(
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TournamentRecommendationImplCopyWith<$Res>
    implements $TournamentRecommendationCopyWith<$Res> {
  factory _$$TournamentRecommendationImplCopyWith(
          _$TournamentRecommendationImpl value,
          $Res Function(_$TournamentRecommendationImpl) then) =
      __$$TournamentRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ballName,
      String reason,
      double confidenceScore,
      bool isSelected});
}

/// @nodoc
class __$$TournamentRecommendationImplCopyWithImpl<$Res>
    extends _$TournamentRecommendationCopyWithImpl<$Res,
        _$TournamentRecommendationImpl>
    implements _$$TournamentRecommendationImplCopyWith<$Res> {
  __$$TournamentRecommendationImplCopyWithImpl(
      _$TournamentRecommendationImpl _value,
      $Res Function(_$TournamentRecommendationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TournamentRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ballName = null,
    Object? reason = null,
    Object? confidenceScore = null,
    Object? isSelected = null,
  }) {
    return _then(_$TournamentRecommendationImpl(
      ballName: null == ballName
          ? _value.ballName
          : ballName // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      isSelected: null == isSelected
          ? _value.isSelected
          : isSelected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TournamentRecommendationImpl implements _TournamentRecommendation {
  const _$TournamentRecommendationImpl(
      {required this.ballName,
      required this.reason,
      required this.confidenceScore,
      this.isSelected = false});

  @override
  final String ballName;
  @override
  final String reason;
  @override
  final double confidenceScore;
  @override
  @JsonKey()
  final bool isSelected;

  @override
  String toString() {
    return 'TournamentRecommendation(ballName: $ballName, reason: $reason, confidenceScore: $confidenceScore, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentRecommendationImpl &&
            (identical(other.ballName, ballName) ||
                other.ballName == ballName) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.isSelected, isSelected) ||
                other.isSelected == isSelected));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, ballName, reason, confidenceScore, isSelected);

  /// Create a copy of TournamentRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentRecommendationImplCopyWith<_$TournamentRecommendationImpl>
      get copyWith => __$$TournamentRecommendationImplCopyWithImpl<
          _$TournamentRecommendationImpl>(this, _$identity);
}

abstract class _TournamentRecommendation implements TournamentRecommendation {
  const factory _TournamentRecommendation(
      {required final String ballName,
      required final String reason,
      required final double confidenceScore,
      final bool isSelected}) = _$TournamentRecommendationImpl;

  @override
  String get ballName;
  @override
  String get reason;
  @override
  double get confidenceScore;
  @override
  bool get isSelected;

  /// Create a copy of TournamentRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentRecommendationImplCopyWith<_$TournamentRecommendationImpl>
      get copyWith => throw _privateConstructorUsedError;
}
