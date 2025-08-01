// lib/shared/providers/providers.dart
// 統一匯出所有 Provider，方便其他檔案使用

import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/shared/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/services/user_preferences_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

export '../../features/onboarding/providers/onboarding_provider.dart';
export 'user_profile_provider.dart';
// Ball Library controller and models are now in their new locations
// They are re-exported here for backwards compatibility
export 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
export 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';

/// 全局底部導覽列索引
final bottomNavProvider = StateProvider<int>((ref) => 0);

// 計算型 Provider - 檢查是否需要顯示 Onboarding
final shouldShowOnboardingProvider = Provider<bool>((ref) {
  // 只依賴 onboardingProvider 與 userProfileProvider
  final onboardingCompleted = ref.watch(onboardingProvider);
  final isProfileComplete = ref.watch(userProfileProvider.notifier).isProfileComplete;
  if (!onboardingCompleted) {
    return true;
  }
  if (!isProfileComplete) {
    return true;
  }
  return false;
});

// Service Providers
final userPreferencesServiceProvider = Provider<UserPreferencesService>((ref) {
  return UserPreferencesService();
});

// Ball Library filter and sort providers are now in their own module 