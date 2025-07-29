// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ballDataServiceHash() => r'bf317fe8b12e3a3930463b9a7cd8b8ba4f5392b1';

/// 提供 BallDataService 的 Provider
///
/// Copied from [ballDataService].
@ProviderFor(ballDataService)
final ballDataServiceProvider = AutoDisposeProvider<BallDataService>.internal(
  ballDataService,
  name: r'ballDataServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ballDataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BallDataServiceRef = AutoDisposeProviderRef<BallDataService>;
String _$ballRepositoryHash() => r'7d30ff1b723e82fe453e4dd84ade0f00bbd369a8';

/// 提供 BallRepository 的 Provider
///
/// Copied from [ballRepository].
@ProviderFor(ballRepository)
final ballRepositoryProvider = AutoDisposeProvider<BallRepository>.internal(
  ballRepository,
  name: r'ballRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ballRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BallRepositoryRef = AutoDisposeProviderRef<BallRepository>;
String _$ballLibraryControllerHash() =>
    r'dc62ee2843137e5c51653cad6593f7b05d0ea284';

/// Ball Library 控制器
/// 專注於球庫相關的業務邏輯和狀態管理
///
/// Copied from [BallLibraryController].
@ProviderFor(BallLibraryController)
final ballLibraryControllerProvider = AutoDisposeAsyncNotifierProvider<
    BallLibraryController, BallLibraryState>.internal(
  BallLibraryController.new,
  name: r'ballLibraryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ballLibraryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BallLibraryController = AutoDisposeAsyncNotifier<BallLibraryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
