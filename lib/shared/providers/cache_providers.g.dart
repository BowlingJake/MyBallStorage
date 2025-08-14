// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localCacheServiceHash() => r'13ebccb1e0c3901508916269856134dc8cac11c3';

/// 本地快取服務 Provider - 使用單例模式
///
/// Copied from [localCacheService].
@ProviderFor(localCacheService)
final localCacheServiceProvider =
    AutoDisposeProvider<LocalCacheService>.internal(
  localCacheService,
  name: r'localCacheServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localCacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalCacheServiceRef = AutoDisposeProviderRef<LocalCacheService>;
String _$initializeCacheHash() => r'c0f0470e42486f25f2adc926ed7ed66db8d140b3';

/// 初始化快取服務的 Provider
///
/// Copied from [initializeCache].
@ProviderFor(initializeCache)
final initializeCacheProvider = AutoDisposeFutureProvider<void>.internal(
  initializeCache,
  name: r'initializeCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$initializeCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InitializeCacheRef = AutoDisposeFutureProviderRef<void>;
String _$preloadServiceHash() => r'e24ba0eab83af30eaa967f5bc4b263642ced5a33';

/// 預載入服務 Provider
///
/// Copied from [preloadService].
@ProviderFor(preloadService)
final preloadServiceProvider = AutoDisposeProvider<PreloadService>.internal(
  preloadService,
  name: r'preloadServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$preloadServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PreloadServiceRef = AutoDisposeProviderRef<PreloadService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
