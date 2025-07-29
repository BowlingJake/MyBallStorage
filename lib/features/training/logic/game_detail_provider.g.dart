// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameDetailNotifierHash() =>
    r'365745e18641eac2a00451e654879588d35957ac';

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

abstract class _$GameDetailNotifier
    extends BuildlessAutoDisposeNotifier<GameRecord> {
  late final GameRecord initialGame;

  GameRecord build(
    GameRecord initialGame,
  );
}

/// See also [GameDetailNotifier].
@ProviderFor(GameDetailNotifier)
const gameDetailNotifierProvider = GameDetailNotifierFamily();

/// See also [GameDetailNotifier].
class GameDetailNotifierFamily extends Family<GameRecord> {
  /// See also [GameDetailNotifier].
  const GameDetailNotifierFamily();

  /// See also [GameDetailNotifier].
  GameDetailNotifierProvider call(
    GameRecord initialGame,
  ) {
    return GameDetailNotifierProvider(
      initialGame,
    );
  }

  @override
  GameDetailNotifierProvider getProviderOverride(
    covariant GameDetailNotifierProvider provider,
  ) {
    return call(
      provider.initialGame,
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
  String? get name => r'gameDetailNotifierProvider';
}

/// See also [GameDetailNotifier].
class GameDetailNotifierProvider
    extends AutoDisposeNotifierProviderImpl<GameDetailNotifier, GameRecord> {
  /// See also [GameDetailNotifier].
  GameDetailNotifierProvider(
    GameRecord initialGame,
  ) : this._internal(
          () => GameDetailNotifier()..initialGame = initialGame,
          from: gameDetailNotifierProvider,
          name: r'gameDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$gameDetailNotifierHash,
          dependencies: GameDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              GameDetailNotifierFamily._allTransitiveDependencies,
          initialGame: initialGame,
        );

  GameDetailNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialGame,
  }) : super.internal();

  final GameRecord initialGame;

  @override
  GameRecord runNotifierBuild(
    covariant GameDetailNotifier notifier,
  ) {
    return notifier.build(
      initialGame,
    );
  }

  @override
  Override overrideWith(GameDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameDetailNotifierProvider._internal(
        () => create()..initialGame = initialGame,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialGame: initialGame,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GameDetailNotifier, GameRecord>
      createElement() {
    return _GameDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameDetailNotifierProvider &&
        other.initialGame == initialGame;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialGame.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GameDetailNotifierRef on AutoDisposeNotifierProviderRef<GameRecord> {
  /// The parameter `initialGame` of this provider.
  GameRecord get initialGame;
}

class _GameDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<GameDetailNotifier, GameRecord>
    with GameDetailNotifierRef {
  _GameDetailNotifierProviderElement(super.provider);

  @override
  GameRecord get initialGame =>
      (origin as GameDetailNotifierProvider).initialGame;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
