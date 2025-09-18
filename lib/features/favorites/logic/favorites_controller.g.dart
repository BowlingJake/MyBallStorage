// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$favoritesRepositoryHash() =>
    r'5fd17f429e132a1449f807a7dc8e7a463d49eb0e';

/// Provider for FavoritesRepository
///
/// Copied from [favoritesRepository].
@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider =
    AutoDisposeProvider<FavoritesRepository>.internal(
  favoritesRepository,
  name: r'favoritesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoritesRepositoryRef = AutoDisposeProviderRef<FavoritesRepository>;
String _$favoritesControllerHash() =>
    r'e158f39fd50c8c5880b0bae549be0df06fa50e34';

/// AsyncNotifier for managing favorites state
///
/// Copied from [FavoritesController].
@ProviderFor(FavoritesController)
final favoritesControllerProvider = AutoDisposeAsyncNotifierProvider<
    FavoritesController, FavoritesState>.internal(
  FavoritesController.new,
  name: r'favoritesControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$favoritesControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FavoritesController = AutoDisposeAsyncNotifier<FavoritesState>;
String _$ballFavoriteControllerHash() =>
    r'0b3a111a6072c4dd64506a4f48d948acbdeb647f';

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

abstract class _$BallFavoriteController
    extends BuildlessAutoDisposeAsyncNotifier<BallFavoriteState> {
  late final int ballId;

  FutureOr<BallFavoriteState> build(
    int ballId,
  );
}

/// Provider for checking if a specific ball is favorite
///
/// Copied from [BallFavoriteController].
@ProviderFor(BallFavoriteController)
const ballFavoriteControllerProvider = BallFavoriteControllerFamily();

/// Provider for checking if a specific ball is favorite
///
/// Copied from [BallFavoriteController].
class BallFavoriteControllerFamily
    extends Family<AsyncValue<BallFavoriteState>> {
  /// Provider for checking if a specific ball is favorite
  ///
  /// Copied from [BallFavoriteController].
  const BallFavoriteControllerFamily();

  /// Provider for checking if a specific ball is favorite
  ///
  /// Copied from [BallFavoriteController].
  BallFavoriteControllerProvider call(
    int ballId,
  ) {
    return BallFavoriteControllerProvider(
      ballId,
    );
  }

  @override
  BallFavoriteControllerProvider getProviderOverride(
    covariant BallFavoriteControllerProvider provider,
  ) {
    return call(
      provider.ballId,
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
  String? get name => r'ballFavoriteControllerProvider';
}

/// Provider for checking if a specific ball is favorite
///
/// Copied from [BallFavoriteController].
class BallFavoriteControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BallFavoriteController,
        BallFavoriteState> {
  /// Provider for checking if a specific ball is favorite
  ///
  /// Copied from [BallFavoriteController].
  BallFavoriteControllerProvider(
    int ballId,
  ) : this._internal(
          () => BallFavoriteController()..ballId = ballId,
          from: ballFavoriteControllerProvider,
          name: r'ballFavoriteControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ballFavoriteControllerHash,
          dependencies: BallFavoriteControllerFamily._dependencies,
          allTransitiveDependencies:
              BallFavoriteControllerFamily._allTransitiveDependencies,
          ballId: ballId,
        );

  BallFavoriteControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.ballId,
  }) : super.internal();

  final int ballId;

  @override
  FutureOr<BallFavoriteState> runNotifierBuild(
    covariant BallFavoriteController notifier,
  ) {
    return notifier.build(
      ballId,
    );
  }

  @override
  Override overrideWith(BallFavoriteController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BallFavoriteControllerProvider._internal(
        () => create()..ballId = ballId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        ballId: ballId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BallFavoriteController,
      BallFavoriteState> createElement() {
    return _BallFavoriteControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BallFavoriteControllerProvider && other.ballId == ballId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, ballId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BallFavoriteControllerRef
    on AutoDisposeAsyncNotifierProviderRef<BallFavoriteState> {
  /// The parameter `ballId` of this provider.
  int get ballId;
}

class _BallFavoriteControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BallFavoriteController,
        BallFavoriteState> with BallFavoriteControllerRef {
  _BallFavoriteControllerProviderElement(super.provider);

  @override
  int get ballId => (origin as BallFavoriteControllerProvider).ballId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
