// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_library_cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ballLibraryCacheServiceHash() =>
    r'1e397245680080b834db63375eb27b75c5c2f683';

/// Ball Library Cache Service - Smart caching for improved performance
///
/// Features:
/// - LRU (Least Recently Used) cache eviction
/// - Separate caches for different data types
/// - Memory-aware cache management
/// - Cache hit rate optimization
///
/// Copied from [BallLibraryCacheService].
@ProviderFor(BallLibraryCacheService)
final ballLibraryCacheServiceProvider = AutoDisposeNotifierProvider<
    BallLibraryCacheService, BallLibraryCacheState>.internal(
  BallLibraryCacheService.new,
  name: r'ballLibraryCacheServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ballLibraryCacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BallLibraryCacheService = AutoDisposeNotifier<BallLibraryCacheState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
