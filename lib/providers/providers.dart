// lib/providers/providers.dart
// 統一匯出所有 Provider，方便其他檔案使用

export 'auth_provider.dart';
export 'user_profile_provider.dart';
export 'onboarding_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import 'user_profile_provider.dart';
import 'onboarding_provider.dart';

// 計算型 Provider - 檢查是否需要顯示 Onboarding
final shouldShowOnboardingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  
  if (authState.status != AuthStatus.authenticated) {
    return false;
  }

  // 當 auth 狀態確定後，監聽其他 providers
  final onboardingCompleted = ref.watch(onboardingProvider);
  final userProfile = ref.watch(userProfileProvider);
  
  // 如果 onboarding 未完成，總是要顯示
  if (!onboardingCompleted) {
    return true;
  }

  // 如果 onboarding 已完成，但 profile 不完整，也要顯示
  // (userProfile 為 null 也算不完整)
  final isProfileComplete = ref.read(userProfileProvider.notifier).isProfileComplete;
  if (!isProfileComplete) {
    return true;
  }
  
  // 所有條件都滿足，不顯示 onboarding
  return false;
}); 