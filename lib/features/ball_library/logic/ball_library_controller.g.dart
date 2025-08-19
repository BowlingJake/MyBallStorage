// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball_library_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ballDataServiceHash() => r'bf317fe8b12e3a3930463b9a7cd8b8ba4f5392b1';

/// 提供 BallDataService 的 Provider (本地JSON檔案)
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
String _$localBallRepositoryHash() =>
    r'9bbb2680f84db47a6fe3d908309e3e65ffe82306';

/// 提供本地JSON檔案的 BallRepository
///
/// Copied from [localBallRepository].
@ProviderFor(localBallRepository)
final localBallRepositoryProvider =
    AutoDisposeProvider<BallRepository>.internal(
  localBallRepository,
  name: r'localBallRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localBallRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalBallRepositoryRef = AutoDisposeProviderRef<BallRepository>;
String _$ballRepositoryHash() => r'5086569ff32c4e3c75af801bf2d93ebe1888906b';

/// 提供 Supabase 的 BallRepository
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
    r'c2933600f7f584bce8eb5e207063a02b9d8ecb4e';

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
