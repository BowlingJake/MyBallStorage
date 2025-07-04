// lib/providers/providers.dart
// 統一匯出所有 Provider，方便其他檔案使用

import 'package:bowlingarsenal_app/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/providers/auth_provider.dart';
import 'package:bowlingarsenal_app/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/providers/user_profile_provider.dart';
import 'package:bowlingarsenal_app/services/ball_data_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'auth_provider.dart';
export 'onboarding_provider.dart';
export 'user_profile_provider.dart';

/// 提供保齡球列表的 FutureProvider
///
/// 會自動處理讀取、快取（由 BallDataService 處理）、錯誤和成功狀態
final ballListProvider = FutureProvider<List<BowlingBall>>((ref) {
  return BallDataService.loadBallData();
});

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