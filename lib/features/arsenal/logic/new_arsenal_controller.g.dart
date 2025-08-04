// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_arsenal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userArsenalRepositoryHash() =>
    r'89c5de79d03c6c8cd86133f10170e400c4337a47';

/// New Arsenal repository provider
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
String _$filteredArsenalInstancesHash() =>
    r'6adbfdc6f12f37e60f51fb0f7a9fa4fdbd520540';

/// Provider to get filtered instances for current category
///
/// Copied from [filteredArsenalInstances].
@ProviderFor(filteredArsenalInstances)
final filteredArsenalInstancesProvider =
    AutoDisposeProvider<List<UserArsenalInstance>>.internal(
  filteredArsenalInstances,
  name: r'filteredArsenalInstancesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredArsenalInstancesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredArsenalInstancesRef
    = AutoDisposeProviderRef<List<UserArsenalInstance>>;
String _$newArsenalControllerHash() =>
    r'88398a42ffc8220758db0255fc43d83d4626302f';

/// New Arsenal controller
///
/// Copied from [NewArsenalController].
@ProviderFor(NewArsenalController)
final newArsenalControllerProvider =
    AutoDisposeNotifierProvider<NewArsenalController, NewArsenalState>.internal(
  NewArsenalController.new,
  name: r'newArsenalControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newArsenalControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NewArsenalController = AutoDisposeNotifier<NewArsenalState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
