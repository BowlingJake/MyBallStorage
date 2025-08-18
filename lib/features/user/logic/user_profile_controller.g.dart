// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userProfileRepositoryHash() =>
    r'bb00e984c047d568986df30676816c950d0b5d3c';

/// User profile repository provider
///
/// Copied from [userProfileRepository].
@ProviderFor(userProfileRepository)
final userProfileRepositoryProvider =
    AutoDisposeProvider<UserProfileRepository>.internal(
  userProfileRepository,
  name: r'userProfileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRepositoryRef
    = AutoDisposeProviderRef<UserProfileRepository>;
String _$userProfileControllerHash() =>
    r'dcc4ef5cb6f52cf32a37c4197deb935f75c83f78';

/// User profile controller
///
/// Copied from [UserProfileController].
@ProviderFor(UserProfileController)
final userProfileControllerProvider = AutoDisposeNotifierProvider<
    UserProfileController, UserProfileState>.internal(
  UserProfileController.new,
  name: r'userProfileControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userProfileControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserProfileController = AutoDisposeNotifier<UserProfileState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
