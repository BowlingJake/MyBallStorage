// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$arsenalRepositoryHash() => r'0fb57adf941e70960b6e253af201bfad3fbc7938';

/// Arsenal repository provider
///
/// Copied from [arsenalRepository].
@ProviderFor(arsenalRepository)
final arsenalRepositoryProvider =
    AutoDisposeProvider<ArsenalRepository>.internal(
  arsenalRepository,
  name: r'arsenalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$arsenalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ArsenalRepositoryRef = AutoDisposeProviderRef<ArsenalRepository>;
String _$filteredArsenalBallsHash() =>
    r'2c1a4a0749b5ff127698e6fe2aa82f450b02e403';

/// Provider to get filtered balls for current category
///
/// Copied from [filteredArsenalBalls].
@ProviderFor(filteredArsenalBalls)
final filteredArsenalBallsProvider =
    AutoDisposeProvider<List<ArsenalBallInstance>>.internal(
  filteredArsenalBalls,
  name: r'filteredArsenalBallsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredArsenalBallsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredArsenalBallsRef
    = AutoDisposeProviderRef<List<ArsenalBallInstance>>;
String _$totalBallCountHash() => r'07b65cc660579acc2da4871f631e79b9b9dfd77f';

/// Provider to get total ball count
///
/// Copied from [totalBallCount].
@ProviderFor(totalBallCount)
final totalBallCountProvider = AutoDisposeProvider<int>.internal(
  totalBallCount,
  name: r'totalBallCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$totalBallCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalBallCountRef = AutoDisposeProviderRef<int>;
String _$categoryBallCountHash() => r'1a4fecc753c1fa781ec166460d137d70cbf55fcb';

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

/// Provider to get ball count for specific category
///
/// Copied from [categoryBallCount].
@ProviderFor(categoryBallCount)
const categoryBallCountProvider = CategoryBallCountFamily();

/// Provider to get ball count for specific category
///
/// Copied from [categoryBallCount].
class CategoryBallCountFamily extends Family<int> {
  /// Provider to get ball count for specific category
  ///
  /// Copied from [categoryBallCount].
  const CategoryBallCountFamily();

  /// Provider to get ball count for specific category
  ///
  /// Copied from [categoryBallCount].
  CategoryBallCountProvider call(
    String categoryId,
  ) {
    return CategoryBallCountProvider(
      categoryId,
    );
  }

  @override
  CategoryBallCountProvider getProviderOverride(
    covariant CategoryBallCountProvider provider,
  ) {
    return call(
      provider.categoryId,
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
  String? get name => r'categoryBallCountProvider';
}

/// Provider to get ball count for specific category
///
/// Copied from [categoryBallCount].
class CategoryBallCountProvider extends AutoDisposeProvider<int> {
  /// Provider to get ball count for specific category
  ///
  /// Copied from [categoryBallCount].
  CategoryBallCountProvider(
    String categoryId,
  ) : this._internal(
          (ref) => categoryBallCount(
            ref as CategoryBallCountRef,
            categoryId,
          ),
          from: categoryBallCountProvider,
          name: r'categoryBallCountProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryBallCountHash,
          dependencies: CategoryBallCountFamily._dependencies,
          allTransitiveDependencies:
              CategoryBallCountFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  CategoryBallCountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    int Function(CategoryBallCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryBallCountProvider._internal(
        (ref) => create(ref as CategoryBallCountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _CategoryBallCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryBallCountProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryBallCountRef on AutoDisposeProviderRef<int> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryBallCountProviderElement extends AutoDisposeProviderElement<int>
    with CategoryBallCountRef {
  _CategoryBallCountProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryBallCountProvider).categoryId;
}

String _$arsenalControllerHash() => r'e196a0e28ac2b9dc254f5a13703d72d3e50668c9';

/// Main Arsenal controller
///
/// Copied from [ArsenalController].
@ProviderFor(ArsenalController)
final arsenalControllerProvider =
    AutoDisposeNotifierProvider<ArsenalController, ArsenalState>.internal(
  ArsenalController.new,
  name: r'arsenalControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$arsenalControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ArsenalController = AutoDisposeNotifier<ArsenalState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
