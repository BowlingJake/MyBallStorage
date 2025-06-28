import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/providers.dart';
import 'views/login_page.dart';
import 'views/onboarding/onboarding_page.dart';
import 'home_page.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final shouldShowOnboarding = ref.watch(shouldShowOnboardingProvider);

    // 根據認證狀態和 Onboarding 狀態決定顯示的頁面
    switch (authState.status) {
      case AuthStatus.unknown:
        // 正在檢查認證狀態，顯示載入畫面
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
        
      case AuthStatus.unauthenticated:
        // 未認證，顯示登入頁面
        return const LoginPage();
        
      case AuthStatus.authenticated:
        // 已認證，檢查是否需要顯示 Onboarding
        if (shouldShowOnboarding) {
          return const OnboardingPage();
        } else {
          return const HomePage();
        }
    }
  }
}

// 路由配置
class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('頁面不存在'),
            ),
          ),
        );
    }
  }
} 