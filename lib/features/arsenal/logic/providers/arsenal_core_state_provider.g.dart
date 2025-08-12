// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_core_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userArsenalRepositoryHash() =>
    r'89c5de79d03c6c8cd86133f10170e400c4337a47';

/// Arsenal repository provider
///
/// Copied from [userArsenalRepository].
@ProviderFor(userArsenalRepository)
final userArsenalRepositoryProvider =
    AutoDisposeProvider<UserArsenalRepository>.internal(
  userArsenalRepository,
  name: r'userArsenalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userArsenalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserArsenalRepositoryRef
    = AutoDisposeProviderRef<UserArsenalRepository>;
String _$arsenalCoreStateProviderHash() =>
    r'98eed3e067be44e50fc20fd5a7987a97065092aa';

/// Core Arsenal data provider - handles only data loading and bag operations
///
/// Copied from [ArsenalCoreStateProvider].
@ProviderFor(ArsenalCoreStateProvider)
final arsenalCoreStateProviderProvider = AutoDisposeNotifierProvider<
    ArsenalCoreStateProvider, ArsenalCoreState>.internal(
  ArsenalCoreStateProvider.new,
  name: r'arsenalCoreStateProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$arsenalCoreStateProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArsenalCoreStateProvider = AutoDisposeNotifier<ArsenalCoreState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
