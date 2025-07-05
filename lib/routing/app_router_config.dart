import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/home_page.dart';
import 'package:bowlingarsenal_app/views/login_page.dart';
import 'package:bowlingarsenal_app/views/onboarding/onboarding_page.dart';
import 'package:bowlingarsenal_app/providers/auth_provider.dart';
import 'package:bowlingarsenal_app/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/ball_library_page.dart';
import 'package:bowlingarsenal_app/my_training_page.dart';
import 'package:bowlingarsenal_app/views/developer_page.dart';
import 'package:bowlingarsenal_app/views/my_arsenal_page.dart';
import 'package:bowlingarsenal_app/views/settings_page.dart';

// 1. 建立 GoRouterRefreshStream
// 這是 go_router 官方建議的，用來監聽 Stream 並在事件發生時觸發路由刷新的類別。
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// 2. 建立主要的 routerProvider
final routerProvider = Provider<GoRouter>((ref) {
  // 監聽 authProvider 的變化
  final authState = ref.watch(authProvider);

  return GoRouter(
    // 3. 設定初始路由
    initialLocation: '/login',

    // 4. 設定路由表
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const BallLibraryPage(),
      ),
      GoRoute(
        path: '/training',
        name: 'training',
        builder: (context, state) => const MyTrainingPage(),
      ),
      GoRoute(
        path: '/my-arsenal',
        name: 'my-arsenal',
        builder: (context, state) => const MyArsenalPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/developer',
        name: 'developer',
        builder: (context, state) => const DeveloperPage(),
      ),
    ],

    // 5. 設定錯誤頁面
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('頁面不存在')),
      body: Center(
        child: Text('錯誤: ${state.error?.message}'),
      ),
    ),

    // 6. 設定重導向邏輯 (核心)
    redirect: (BuildContext context, GoRouterState state) {
      // 讀取最新的認證和引導頁狀態
      final isAuthenticated = authState.isAuthenticated;
      final shouldShowOnboarding = !ref.read(onboardingProvider);
      
      final isLoggingIn = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isAtRoot = state.matchedLocation == '/';

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
      
      // 如果用戶已認證，但嘗試訪問登入頁，將他們導向主頁
      if(isAuthenticated && isLoggingIn) return '/';

      // 所有其他情況，不進行重導向
      return null;
    },

    // 7. 設定狀態監聽，讓路由響應變化
    refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
  );
}); 