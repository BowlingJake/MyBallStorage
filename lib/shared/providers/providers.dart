// lib/shared/providers/providers.dart
// 統一匯出所有 Provider，方便其他檔案使用

import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/auth_provider.dart';
import 'package:bowlingarsenal_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/features/ball_library/providers/ball_library_providers.dart';
import 'package:bowlingarsenal_app/services/user_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

export 'auth_provider.dart';
export '../../features/onboarding/providers/onboarding_provider.dart';
export 'user_profile_provider.dart';
// Ball Library providers are now in features/ball_library/providers/ball_library_providers.dart
// They are re-exported here for backwards compatibility
export 'package:bowlingarsenal_app/features/ball_library/providers/ball_library_providers.dart';

/// 全局底部導覽列索引
final bottomNavProvider = StateProvider<int>((ref) => 0);

// 計算型 Provider - 檢查是否需要顯示 Onboarding
final shouldShowOnboardingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);

  if (authState.status != AuthStatus.authenticated) {
    return false;
  }

  // 當 auth 狀態確定後，監聽其他 providers
  final onboardingCompleted = ref.watch(onboardingProvider);
  // 直接從 Notifier 獲取狀態，這是可接受的，因為它不涉及方法調用
  final isProfileComplete = ref.watch(userProfileProvider.notifier).isProfileComplete;

  // 如果 onboarding 未完成，總是要顯示
  if (!onboardingCompleted) {
    return true;
  }

  // 如果 onboarding 已完成，但 profile 不完整，也要顯示
  if (!isProfileComplete) {
    return true;
  }

  // 所有條件都滿足，不顯示 onboarding
  return false;
});

// Service Providers
final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService();
});

// Ball Library filter and sort providers are now in their own module 