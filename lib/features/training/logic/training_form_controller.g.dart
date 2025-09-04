// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trainingFormHash() => r'a7facec699d6ba59baee7a7ff1973ec687b7abb6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TrainingForm
    extends BuildlessAutoDisposeNotifier<TrainingFormState> {
  late final TrainingDaySummary? initialData;

  TrainingFormState build(
    TrainingDaySummary? initialData,
  );
}

/// See also [TrainingForm].
@ProviderFor(TrainingForm)
const trainingFormProvider = TrainingFormFamily();

/// See also [TrainingForm].
class TrainingFormFamily extends Family<TrainingFormState> {
  /// See also [TrainingForm].
  const TrainingFormFamily();

  /// See also [TrainingForm].
  TrainingFormProvider call(
    TrainingDaySummary? initialData,
  ) {
    return TrainingFormProvider(
      initialData,
    );
  }

  @override
  TrainingFormProvider getProviderOverride(
    covariant TrainingFormProvider provider,
  ) {
    return call(
      provider.initialData,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'trainingFormProvider';
}

/// See also [TrainingForm].
class TrainingFormProvider
    extends AutoDisposeNotifierProviderImpl<TrainingForm, TrainingFormState> {
  /// See also [TrainingForm].
  TrainingFormProvider(
    TrainingDaySummary? initialData,
  ) : this._internal(
          () => TrainingForm()..initialData = initialData,
          from: trainingFormProvider,
          name: r'trainingFormProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$trainingFormHash,
          dependencies: TrainingFormFamily._dependencies,
          allTransitiveDependencies:
              TrainingFormFamily._allTransitiveDependencies,
          initialData: initialData,
        );

  TrainingFormProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialData,
  }) : super.internal();

  final TrainingDaySummary? initialData;

  @override
  TrainingFormState runNotifierBuild(
    covariant TrainingForm notifier,
  ) {
    return notifier.build(
      initialData,
    );
  }

  @override
  Override overrideWith(TrainingForm Function() create) {
    return ProviderOverride(
      origin: this,
      override: TrainingFormProvider._internal(
        () => create()..initialData = initialData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialData: initialData,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TrainingForm, TrainingFormState>
      createElement() {
    return _TrainingFormProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrainingFormProvider && other.initialData == initialData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrainingFormRef on AutoDisposeNotifierProviderRef<TrainingFormState> {
  /// The parameter `initialData` of this provider.
  TrainingDaySummary? get initialData;
}

class _TrainingFormProviderElement
    extends AutoDisposeNotifierProviderElement<TrainingForm, TrainingFormState>
    with TrainingFormRef {
  _TrainingFormProviderElement(super.provider);

  @override
  TrainingDaySummary? get initialData =>
      (origin as TrainingFormProvider).initialData;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
