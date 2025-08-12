// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arsenal_family_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$arsenalInstancesByBagHash() =>
    r'445e647983d47e751d6d762fa3ab3d569bc2a74c';

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

/// Family provider for filtered Arsenal instances by bag number
/// This allows each bag to have its own cached filtered list
///
/// Copied from [arsenalInstancesByBag].
@ProviderFor(arsenalInstancesByBag)
const arsenalInstancesByBagProvider = ArsenalInstancesByBagFamily();

/// Family provider for filtered Arsenal instances by bag number
/// This allows each bag to have its own cached filtered list
///
/// Copied from [arsenalInstancesByBag].
class ArsenalInstancesByBagFamily extends Family<List<UserArsenalInstance>> {
  /// Family provider for filtered Arsenal instances by bag number
  /// This allows each bag to have its own cached filtered list
  ///
  /// Copied from [arsenalInstancesByBag].
  const ArsenalInstancesByBagFamily();

  /// Family provider for filtered Arsenal instances by bag number
  /// This allows each bag to have its own cached filtered list
  ///
  /// Copied from [arsenalInstancesByBag].
  ArsenalInstancesByBagProvider call(
    int bagNumber,
  ) {
    return ArsenalInstancesByBagProvider(
      bagNumber,
    );
  }

  @override
  ArsenalInstancesByBagProvider getProviderOverride(
    covariant ArsenalInstancesByBagProvider provider,
  ) {
    return call(
      provider.bagNumber,
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
  String? get name => r'arsenalInstancesByBagProvider';
}

/// Family provider for filtered Arsenal instances by bag number
/// This allows each bag to have its own cached filtered list
///
/// Copied from [arsenalInstancesByBag].
class ArsenalInstancesByBagProvider
    extends AutoDisposeProvider<List<UserArsenalInstance>> {
  /// Family provider for filtered Arsenal instances by bag number
  /// This allows each bag to have its own cached filtered list
  ///
  /// Copied from [arsenalInstancesByBag].
  ArsenalInstancesByBagProvider(
    int bagNumber,
  ) : this._internal(
          (ref) => arsenalInstancesByBag(
            ref as ArsenalInstancesByBagRef,
            bagNumber,
          ),
          from: arsenalInstancesByBagProvider,
          name: r'arsenalInstancesByBagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$arsenalInstancesByBagHash,
          dependencies: ArsenalInstancesByBagFamily._dependencies,
          allTransitiveDependencies:
              ArsenalInstancesByBagFamily._allTransitiveDependencies,
          bagNumber: bagNumber,
        );

  ArsenalInstancesByBagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bagNumber,
  }) : super.internal();

  final int bagNumber;

  @override
  Override overrideWith(
    List<UserArsenalInstance> Function(ArsenalInstancesByBagRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArsenalInstancesByBagProvider._internal(
        (ref) => create(ref as ArsenalInstancesByBagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bagNumber: bagNumber,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<UserArsenalInstance>> createElement() {
    return _ArsenalInstancesByBagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArsenalInstancesByBagProvider &&
        other.bagNumber == bagNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bagNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArsenalInstancesByBagRef
    on AutoDisposeProviderRef<List<UserArsenalInstance>> {
  /// The parameter `bagNumber` of this provider.
  int get bagNumber;
}

class _ArsenalInstancesByBagProviderElement
    extends AutoDisposeProviderElement<List<UserArsenalInstance>>
    with ArsenalInstancesByBagRef {
  _ArsenalInstancesByBagProviderElement(super.provider);

  @override
  int get bagNumber => (origin as ArsenalInstancesByBagProvider).bagNumber;
}

String _$arsenalInstanceByIdHash() =>
    r'8d57248753fe622ec5d30ca73fc3837734a85c9e';

/// Family provider for individual Arsenal instance by ID
/// This allows each instance to be cached separately
///
/// Copied from [arsenalInstanceById].
@ProviderFor(arsenalInstanceById)
const arsenalInstanceByIdProvider = ArsenalInstanceByIdFamily();

/// Family provider for individual Arsenal instance by ID
/// This allows each instance to be cached separately
///
/// Copied from [arsenalInstanceById].
class ArsenalInstanceByIdFamily extends Family<UserArsenalInstance?> {
  /// Family provider for individual Arsenal instance by ID
  /// This allows each instance to be cached separately
  ///
  /// Copied from [arsenalInstanceById].
  const ArsenalInstanceByIdFamily();

  /// Family provider for individual Arsenal instance by ID
  /// This allows each instance to be cached separately
  ///
  /// Copied from [arsenalInstanceById].
  ArsenalInstanceByIdProvider call(
    int instanceId,
  ) {
    return ArsenalInstanceByIdProvider(
      instanceId,
    );
  }

  @override
  ArsenalInstanceByIdProvider getProviderOverride(
    covariant ArsenalInstanceByIdProvider provider,
  ) {
    return call(
      provider.instanceId,
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
  String? get name => r'arsenalInstanceByIdProvider';
}

/// Family provider for individual Arsenal instance by ID
/// This allows each instance to be cached separately
///
/// Copied from [arsenalInstanceById].
class ArsenalInstanceByIdProvider
    extends AutoDisposeProvider<UserArsenalInstance?> {
  /// Family provider for individual Arsenal instance by ID
  /// This allows each instance to be cached separately
  ///
  /// Copied from [arsenalInstanceById].
  ArsenalInstanceByIdProvider(
    int instanceId,
  ) : this._internal(
          (ref) => arsenalInstanceById(
            ref as ArsenalInstanceByIdRef,
            instanceId,
          ),
          from: arsenalInstanceByIdProvider,
          name: r'arsenalInstanceByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$arsenalInstanceByIdHash,
          dependencies: ArsenalInstanceByIdFamily._dependencies,
          allTransitiveDependencies:
              ArsenalInstanceByIdFamily._allTransitiveDependencies,
          instanceId: instanceId,
        );

  ArsenalInstanceByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.instanceId,
  }) : super.internal();

  final int instanceId;

  @override
  Override overrideWith(
    UserArsenalInstance? Function(ArsenalInstanceByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArsenalInstanceByIdProvider._internal(
        (ref) => create(ref as ArsenalInstanceByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        instanceId: instanceId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<UserArsenalInstance?> createElement() {
    return _ArsenalInstanceByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArsenalInstanceByIdProvider &&
        other.instanceId == instanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, instanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArsenalInstanceByIdRef on AutoDisposeProviderRef<UserArsenalInstance?> {
  /// The parameter `instanceId` of this provider.
  int get instanceId;
}

class _ArsenalInstanceByIdProviderElement
    extends AutoDisposeProviderElement<UserArsenalInstance?>
    with ArsenalInstanceByIdRef {
  _ArsenalInstanceByIdProviderElement(super.provider);

  @override
  int get instanceId => (origin as ArsenalInstanceByIdProvider).instanceId;
}

String _$isInstanceSelectedHash() =>
    r'894b1a0b502f8605b78a593ccdcc9a13eb4b4f06';

/// Family provider for selection state of individual instances
/// This prevents unnecessary rebuilds when selection changes
///
/// Copied from [isInstanceSelected].
@ProviderFor(isInstanceSelected)
const isInstanceSelectedProvider = IsInstanceSelectedFamily();

/// Family provider for selection state of individual instances
/// This prevents unnecessary rebuilds when selection changes
///
/// Copied from [isInstanceSelected].
class IsInstanceSelectedFamily extends Family<bool> {
  /// Family provider for selection state of individual instances
  /// This prevents unnecessary rebuilds when selection changes
  ///
  /// Copied from [isInstanceSelected].
  const IsInstanceSelectedFamily();

  /// Family provider for selection state of individual instances
  /// This prevents unnecessary rebuilds when selection changes
  ///
  /// Copied from [isInstanceSelected].
  IsInstanceSelectedProvider call(
    int instanceId,
  ) {
    return IsInstanceSelectedProvider(
      instanceId,
    );
  }

  @override
  IsInstanceSelectedProvider getProviderOverride(
    covariant IsInstanceSelectedProvider provider,
  ) {
    return call(
      provider.instanceId,
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
  String? get name => r'isInstanceSelectedProvider';
}

/// Family provider for selection state of individual instances
/// This prevents unnecessary rebuilds when selection changes
///
/// Copied from [isInstanceSelected].
class IsInstanceSelectedProvider extends AutoDisposeProvider<bool> {
  /// Family provider for selection state of individual instances
  /// This prevents unnecessary rebuilds when selection changes
  ///
  /// Copied from [isInstanceSelected].
  IsInstanceSelectedProvider(
    int instanceId,
  ) : this._internal(
          (ref) => isInstanceSelected(
            ref as IsInstanceSelectedRef,
            instanceId,
          ),
          from: isInstanceSelectedProvider,
          name: r'isInstanceSelectedProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isInstanceSelectedHash,
          dependencies: IsInstanceSelectedFamily._dependencies,
          allTransitiveDependencies:
              IsInstanceSelectedFamily._allTransitiveDependencies,
          instanceId: instanceId,
        );

  IsInstanceSelectedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.instanceId,
  }) : super.internal();

  final int instanceId;

  @override
  Override overrideWith(
    bool Function(IsInstanceSelectedRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsInstanceSelectedProvider._internal(
        (ref) => create(ref as IsInstanceSelectedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        instanceId: instanceId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsInstanceSelectedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsInstanceSelectedProvider &&
        other.instanceId == instanceId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, instanceId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsInstanceSelectedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `instanceId` of this provider.
  int get instanceId;
}

class _IsInstanceSelectedProviderElement
    extends AutoDisposeProviderElement<bool> with IsInstanceSelectedRef {
  _IsInstanceSelectedProviderElement(super.provider);

  @override
  int get instanceId => (origin as IsInstanceSelectedProvider).instanceId;
}

String _$bagStatisticsHash() => r'ac2625e44c78f07e1a2ec207fd192aff4a37749c';

/// Family provider for bag statistics
/// This allows each bag to have its own cached statistics
///
/// Copied from [bagStatistics].
@ProviderFor(bagStatistics)
const bagStatisticsProvider = BagStatisticsFamily();

/// Family provider for bag statistics
/// This allows each bag to have its own cached statistics
///
/// Copied from [bagStatistics].
class BagStatisticsFamily extends Family<BagStatistics> {
  /// Family provider for bag statistics
  /// This allows each bag to have its own cached statistics
  ///
  /// Copied from [bagStatistics].
  const BagStatisticsFamily();

  /// Family provider for bag statistics
  /// This allows each bag to have its own cached statistics
  ///
  /// Copied from [bagStatistics].
  BagStatisticsProvider call(
    int bagNumber,
  ) {
    return BagStatisticsProvider(
      bagNumber,
    );
  }

  @override
  BagStatisticsProvider getProviderOverride(
    covariant BagStatisticsProvider provider,
  ) {
    return call(
      provider.bagNumber,
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
  String? get name => r'bagStatisticsProvider';
}

/// Family provider for bag statistics
/// This allows each bag to have its own cached statistics
///
/// Copied from [bagStatistics].
class BagStatisticsProvider extends AutoDisposeProvider<BagStatistics> {
  /// Family provider for bag statistics
  /// This allows each bag to have its own cached statistics
  ///
  /// Copied from [bagStatistics].
  BagStatisticsProvider(
    int bagNumber,
  ) : this._internal(
          (ref) => bagStatistics(
            ref as BagStatisticsRef,
            bagNumber,
          ),
          from: bagStatisticsProvider,
          name: r'bagStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bagStatisticsHash,
          dependencies: BagStatisticsFamily._dependencies,
          allTransitiveDependencies:
              BagStatisticsFamily._allTransitiveDependencies,
          bagNumber: bagNumber,
        );

  BagStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bagNumber,
  }) : super.internal();

  final int bagNumber;

  @override
  Override overrideWith(
    BagStatistics Function(BagStatisticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BagStatisticsProvider._internal(
        (ref) => create(ref as BagStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bagNumber: bagNumber,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<BagStatistics> createElement() {
    return _BagStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BagStatisticsProvider && other.bagNumber == bagNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bagNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BagStatisticsRef on AutoDisposeProviderRef<BagStatistics> {
  /// The parameter `bagNumber` of this provider.
  int get bagNumber;
}

class _BagStatisticsProviderElement
    extends AutoDisposeProviderElement<BagStatistics> with BagStatisticsRef {
  _BagStatisticsProviderElement(super.provider);

  @override
  int get bagNumber => (origin as BagStatisticsProvider).bagNumber;
}

String _$arsenalInstancesCountByBagHash() =>
    r'628bf5ec2c72e064337d7cdd224e9dc53180092c';

/// Family provider for filtered instances count by bag
/// Useful for displaying counts in tabs without rebuilding entire lists
///
/// Copied from [arsenalInstancesCountByBag].
@ProviderFor(arsenalInstancesCountByBag)
const arsenalInstancesCountByBagProvider = ArsenalInstancesCountByBagFamily();

/// Family provider for filtered instances count by bag
/// Useful for displaying counts in tabs without rebuilding entire lists
///
/// Copied from [arsenalInstancesCountByBag].
class ArsenalInstancesCountByBagFamily extends Family<int> {
  /// Family provider for filtered instances count by bag
  /// Useful for displaying counts in tabs without rebuilding entire lists
  ///
  /// Copied from [arsenalInstancesCountByBag].
  const ArsenalInstancesCountByBagFamily();

  /// Family provider for filtered instances count by bag
  /// Useful for displaying counts in tabs without rebuilding entire lists
  ///
  /// Copied from [arsenalInstancesCountByBag].
  ArsenalInstancesCountByBagProvider call(
    int bagNumber,
  ) {
    return ArsenalInstancesCountByBagProvider(
      bagNumber,
    );
  }

  @override
  ArsenalInstancesCountByBagProvider getProviderOverride(
    covariant ArsenalInstancesCountByBagProvider provider,
  ) {
    return call(
      provider.bagNumber,
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
  String? get name => r'arsenalInstancesCountByBagProvider';
}

/// Family provider for filtered instances count by bag
/// Useful for displaying counts in tabs without rebuilding entire lists
///
/// Copied from [arsenalInstancesCountByBag].
class ArsenalInstancesCountByBagProvider extends AutoDisposeProvider<int> {
  /// Family provider for filtered instances count by bag
  /// Useful for displaying counts in tabs without rebuilding entire lists
  ///
  /// Copied from [arsenalInstancesCountByBag].
  ArsenalInstancesCountByBagProvider(
    int bagNumber,
  ) : this._internal(
          (ref) => arsenalInstancesCountByBag(
            ref as ArsenalInstancesCountByBagRef,
            bagNumber,
          ),
          from: arsenalInstancesCountByBagProvider,
          name: r'arsenalInstancesCountByBagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$arsenalInstancesCountByBagHash,
          dependencies: ArsenalInstancesCountByBagFamily._dependencies,
          allTransitiveDependencies:
              ArsenalInstancesCountByBagFamily._allTransitiveDependencies,
          bagNumber: bagNumber,
        );

  ArsenalInstancesCountByBagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bagNumber,
  }) : super.internal();

  final int bagNumber;

  @override
  Override overrideWith(
    int Function(ArsenalInstancesCountByBagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArsenalInstancesCountByBagProvider._internal(
        (ref) => create(ref as ArsenalInstancesCountByBagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bagNumber: bagNumber,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _ArsenalInstancesCountByBagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArsenalInstancesCountByBagProvider &&
        other.bagNumber == bagNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bagNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArsenalInstancesCountByBagRef on AutoDisposeProviderRef<int> {
  /// The parameter `bagNumber` of this provider.
  int get bagNumber;
}

class _ArsenalInstancesCountByBagProviderElement
    extends AutoDisposeProviderElement<int> with ArsenalInstancesCountByBagRef {
  _ArsenalInstancesCountByBagProviderElement(super.provider);

  @override
  int get bagNumber => (origin as ArsenalInstancesCountByBagProvider).bagNumber;
}

String _$bagHasInstancesHash() => r'84e588945c2b27281df07c3f70660782c11b62fe';

/// Family provider for checking if bag has instances
/// Optimized for quick bag state checks
///
/// Copied from [bagHasInstances].
@ProviderFor(bagHasInstances)
const bagHasInstancesProvider = BagHasInstancesFamily();

/// Family provider for checking if bag has instances
/// Optimized for quick bag state checks
///
/// Copied from [bagHasInstances].
class BagHasInstancesFamily extends Family<bool> {
  /// Family provider for checking if bag has instances
  /// Optimized for quick bag state checks
  ///
  /// Copied from [bagHasInstances].
  const BagHasInstancesFamily();

  /// Family provider for checking if bag has instances
  /// Optimized for quick bag state checks
  ///
  /// Copied from [bagHasInstances].
  BagHasInstancesProvider call(
    int bagNumber,
  ) {
    return BagHasInstancesProvider(
      bagNumber,
    );
  }

  @override
  BagHasInstancesProvider getProviderOverride(
    covariant BagHasInstancesProvider provider,
  ) {
    return call(
      provider.bagNumber,
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
  String? get name => r'bagHasInstancesProvider';
}

/// Family provider for checking if bag has instances
/// Optimized for quick bag state checks
///
/// Copied from [bagHasInstances].
class BagHasInstancesProvider extends AutoDisposeProvider<bool> {
  /// Family provider for checking if bag has instances
  /// Optimized for quick bag state checks
  ///
  /// Copied from [bagHasInstances].
  BagHasInstancesProvider(
    int bagNumber,
  ) : this._internal(
          (ref) => bagHasInstances(
            ref as BagHasInstancesRef,
            bagNumber,
          ),
          from: bagHasInstancesProvider,
          name: r'bagHasInstancesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bagHasInstancesHash,
          dependencies: BagHasInstancesFamily._dependencies,
          allTransitiveDependencies:
              BagHasInstancesFamily._allTransitiveDependencies,
          bagNumber: bagNumber,
        );

  BagHasInstancesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bagNumber,
  }) : super.internal();

  final int bagNumber;

  @override
  Override overrideWith(
    bool Function(BagHasInstancesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BagHasInstancesProvider._internal(
        (ref) => create(ref as BagHasInstancesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bagNumber: bagNumber,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _BagHasInstancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BagHasInstancesProvider && other.bagNumber == bagNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bagNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BagHasInstancesRef on AutoDisposeProviderRef<bool> {
  /// The parameter `bagNumber` of this provider.
  int get bagNumber;
}

class _BagHasInstancesProviderElement extends AutoDisposeProviderElement<bool>
    with BagHasInstancesRef {
  _BagHasInstancesProviderElement(super.provider);

  @override
  int get bagNumber => (origin as BagHasInstancesProvider).bagNumber;
}

String _$searchResultsInBagHash() =>
    r'e3a4ebf42d58915c8fe955e77a6fba5b310b25e9';

/// Family provider for search results in specific bag
/// Allows search to be scoped to individual bags
///
/// Copied from [searchResultsInBag].
@ProviderFor(searchResultsInBag)
const searchResultsInBagProvider = SearchResultsInBagFamily();

/// Family provider for search results in specific bag
/// Allows search to be scoped to individual bags
///
/// Copied from [searchResultsInBag].
class SearchResultsInBagFamily extends Family<List<UserArsenalInstance>> {
  /// Family provider for search results in specific bag
  /// Allows search to be scoped to individual bags
  ///
  /// Copied from [searchResultsInBag].
  const SearchResultsInBagFamily();

  /// Family provider for search results in specific bag
  /// Allows search to be scoped to individual bags
  ///
  /// Copied from [searchResultsInBag].
  SearchResultsInBagProvider call(
    int bagNumber,
    String searchTerm,
  ) {
    return SearchResultsInBagProvider(
      bagNumber,
      searchTerm,
    );
  }

  @override
  SearchResultsInBagProvider getProviderOverride(
    covariant SearchResultsInBagProvider provider,
  ) {
    return call(
      provider.bagNumber,
      provider.searchTerm,
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
  String? get name => r'searchResultsInBagProvider';
}

/// Family provider for search results in specific bag
/// Allows search to be scoped to individual bags
///
/// Copied from [searchResultsInBag].
class SearchResultsInBagProvider
    extends AutoDisposeProvider<List<UserArsenalInstance>> {
  /// Family provider for search results in specific bag
  /// Allows search to be scoped to individual bags
  ///
  /// Copied from [searchResultsInBag].
  SearchResultsInBagProvider(
    int bagNumber,
    String searchTerm,
  ) : this._internal(
          (ref) => searchResultsInBag(
            ref as SearchResultsInBagRef,
            bagNumber,
            searchTerm,
          ),
          from: searchResultsInBagProvider,
          name: r'searchResultsInBagProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchResultsInBagHash,
          dependencies: SearchResultsInBagFamily._dependencies,
          allTransitiveDependencies:
              SearchResultsInBagFamily._allTransitiveDependencies,
          bagNumber: bagNumber,
          searchTerm: searchTerm,
        );

  SearchResultsInBagProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.bagNumber,
    required this.searchTerm,
  }) : super.internal();

  final int bagNumber;
  final String searchTerm;

  @override
  Override overrideWith(
    List<UserArsenalInstance> Function(SearchResultsInBagRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultsInBagProvider._internal(
        (ref) => create(ref as SearchResultsInBagRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        bagNumber: bagNumber,
        searchTerm: searchTerm,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<UserArsenalInstance>> createElement() {
    return _SearchResultsInBagProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsInBagProvider &&
        other.bagNumber == bagNumber &&
        other.searchTerm == searchTerm;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, bagNumber.hashCode);
    hash = _SystemHash.combine(hash, searchTerm.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultsInBagRef
    on AutoDisposeProviderRef<List<UserArsenalInstance>> {
  /// The parameter `bagNumber` of this provider.
  int get bagNumber;

  /// The parameter `searchTerm` of this provider.
  String get searchTerm;
}

class _SearchResultsInBagProviderElement
    extends AutoDisposeProviderElement<List<UserArsenalInstance>>
    with SearchResultsInBagRef {
  _SearchResultsInBagProviderElement(super.provider);

  @override
  int get bagNumber => (origin as SearchResultsInBagProvider).bagNumber;
  @override
  String get searchTerm => (origin as SearchResultsInBagProvider).searchTerm;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
