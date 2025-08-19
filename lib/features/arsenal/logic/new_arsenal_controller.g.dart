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
String _$arsenalDataServiceHash() =>
    r'ab424d930a854faa14675b9618ac5d5f76267d48';

/// Arsenal data service provider
///
/// Copied from [arsenalDataService].
@ProviderFor(arsenalDataService)
final arsenalDataServiceProvider =
    AutoDisposeProvider<ArsenalDataService>.internal(
  arsenalDataService,
  name: r'arsenalDataServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$arsenalDataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArsenalDataServiceRef = AutoDisposeProviderRef<ArsenalDataService>;
String _$filteredArsenalInstancesHash() =>
    r'8c4fa1eb1dd0fc9993fa0edf4f26bb489013f8ed';

/// Provider to get filtered instances using background isolate
///
/// Copied from [filteredArsenalInstances].
@ProviderFor(filteredArsenalInstances)
final filteredArsenalInstancesProvider =
    AutoDisposeFutureProvider<List<UserArsenalInstance>>.internal(
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
    = AutoDisposeFutureProviderRef<List<UserArsenalInstance>>;
String _$newArsenalControllerHash() =>
    r'f04a70894a42cabb24e73e6fcf5a7cf17e89d395';

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
