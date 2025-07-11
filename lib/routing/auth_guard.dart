/// 認證守衛 - 純函式實現，易於測試
library auth_guard;

/// 認證守衛狀態
class AuthGuardState {
  const AuthGuardState({
    required this.isAuthenticated,
    required this.shouldShowOnboarding,
  });

  final bool isAuthenticated;
  final bool shouldShowOnboarding;
}

/// 認證守衛 - 根據認證狀態和當前位置決定重導向
/// 
/// 返回 null 表示不需要重導向
/// 返回 String 表示需要重導向到該路徑
String? authGuard(AuthGuardState authState, String currentLocation) {
  final isAuthenticated = authState.isAuthenticated;
  final shouldShowOnboarding = authState.shouldShowOnboarding;
  
  final isLoggingIn = currentLocation == '/login';
  final isOnboarding = currentLocation == '/onboarding';
  final isAtRoot = currentLocation == '/';

  // 案例 1: 使用者未認證
  if (!isAuthenticated) {
    // 如果他不在登入頁，就導向登入頁。否則不動。
    return isLoggingIn ? null : '/login';
  }

  // 案例 2: 使用者已認證，但需要顯示引導頁
  if (shouldShowOnboarding) {
    // 如果他不在引導頁，就導向引導頁。否則不動。
    return isOnboarding ? null : '/onboarding';
  }

  // 案例 3: 使用者已認證且已完成引導，但還停留在登入或引導頁
  if (isLoggingIn || isOnboarding) {
    return '/';
  }
  
  // 所有其他情況，不進行重導向
  return null;
} 