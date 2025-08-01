// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sortedCategoriesHash() => r'0d3eae8bae741bc52d8fe00ba52e6ea4ec7b0a39';

/// Provider to get categories sorted by display order
///
/// Copied from [sortedCategories].
@ProviderFor(sortedCategories)
final sortedCategoriesProvider =
    AutoDisposeProvider<List<BagCategory>>.internal(
  sortedCategories,
  name: r'sortedCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortedCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SortedCategoriesRef = AutoDisposeProviderRef<List<BagCategory>>;
String _$categoryByIdHash() => r'4b2fdad6a3bc0d56966623298dbf63c710bb49e1';

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

/// Provider to get specific category by ID
///
/// Copied from [categoryById].
@ProviderFor(categoryById)
const categoryByIdProvider = CategoryByIdFamily();

/// Provider to get specific category by ID
///
/// Copied from [categoryById].
class CategoryByIdFamily extends Family<BagCategory?> {
  /// Provider to get specific category by ID
  ///
  /// Copied from [categoryById].
  const CategoryByIdFamily();

  /// Provider to get specific category by ID
  ///
  /// Copied from [categoryById].
  CategoryByIdProvider call(
    String categoryId,
  ) {
    return CategoryByIdProvider(
      categoryId,
    );
  }

  @override
  CategoryByIdProvider getProviderOverride(
    covariant CategoryByIdProvider provider,
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
  String? get name => r'categoryByIdProvider';
}

/// Provider to get specific category by ID
///
/// Copied from [categoryById].
class CategoryByIdProvider extends AutoDisposeProvider<BagCategory?> {
  /// Provider to get specific category by ID
  ///
  /// Copied from [categoryById].
  CategoryByIdProvider(
    String categoryId,
  ) : this._internal(
          (ref) => categoryById(
            ref as CategoryByIdRef,
            categoryId,
          ),
          from: categoryByIdProvider,
          name: r'categoryByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryByIdHash,
          dependencies: CategoryByIdFamily._dependencies,
          allTransitiveDependencies:
              CategoryByIdFamily._allTransitiveDependencies,
          categoryId: categoryId,
        );

  CategoryByIdProvider._internal(
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
    BagCategory? Function(CategoryByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryByIdProvider._internal(
        (ref) => create(ref as CategoryByIdRef),
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
  AutoDisposeProviderElement<BagCategory?> createElement() {
    return _CategoryByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryByIdProvider && other.categoryId == categoryId;
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
mixin CategoryByIdRef on AutoDisposeProviderRef<BagCategory?> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryByIdProviderElement
    extends AutoDisposeProviderElement<BagCategory?> with CategoryByIdRef {
  _CategoryByIdProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryByIdProvider).categoryId;
}

String _$categoryControllerHash() =>
    r'ab4acbb92c2302fda901b7b67296ec891b8e064b';

/// Category management controller
///
/// Copied from [CategoryController].
@ProviderFor(CategoryController)
final categoryControllerProvider =
    AutoDisposeNotifierProvider<CategoryController, CategoryState>.internal(
  CategoryController.new,
  name: r'categoryControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$categoryControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryController = AutoDisposeNotifier<CategoryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
