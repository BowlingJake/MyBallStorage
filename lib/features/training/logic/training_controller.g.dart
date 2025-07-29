// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trainingDataServiceHash() =>
    r'8c5dcef8fc4021ce74b90848cc6bbb6490ce47c1';

/// 提供 TrainingDataService 的 Provider
///
/// Copied from [trainingDataService].
@ProviderFor(trainingDataService)
final trainingDataServiceProvider =
    AutoDisposeProvider<TrainingDataService>.internal(
  trainingDataService,
  name: r'trainingDataServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trainingDataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrainingDataServiceRef = AutoDisposeProviderRef<TrainingDataService>;
String _$trainingRepositoryHash() =>
    r'eb45f0bb0ee9bbe8ae88b554118509c3d45d3ec3';

/// 提供 TrainingRepository 的 Provider
///
/// Copied from [trainingRepository].
@ProviderFor(trainingRepository)
final trainingRepositoryProvider =
    AutoDisposeProvider<TrainingRepository>.internal(
  trainingRepository,
  name: r'trainingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trainingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrainingRepositoryRef = AutoDisposeProviderRef<TrainingRepository>;
String _$trainingControllerHash() =>
    r'1b98f7a4d956611f260829fa0825a559a9dfbf38';

/// 訓練頁面控制器
/// 專注於訓練數據相關的業務邏輯和狀態管理
///
/// Copied from [TrainingController].
@ProviderFor(TrainingController)
final trainingControllerProvider =
    AutoDisposeNotifierProvider<TrainingController, TrainingState>.internal(
  TrainingController.new,
  name: r'trainingControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$trainingControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TrainingController = AutoDisposeNotifier<TrainingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
