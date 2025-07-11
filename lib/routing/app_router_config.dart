import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/home_page.dart';
import 'package:bowlingarsenal_app/shared/views/login_page.dart';
import 'package:bowlingarsenal_app/features/onboarding/views/onboarding_page.dart';
import 'package:bowlingarsenal_app/shared/providers/auth_provider.dart';
import 'package:bowlingarsenal_app/routing/auth_guard.dart';

import 'package:bowlingarsenal_app/features/ball_library/views/ball_library_page.dart';
import 'package:bowlingarsenal_app/features/training/views/my_training_page.dart';
import 'package:bowlingarsenal_app/shared/views/developer_page.dart';
import 'package:bowlingarsenal_app/features/arsenal/views/my_arsenal_page.dart';
import 'package:bowlingarsenal_app/shared/views/settings_page.dart';
import 'package:bowlingarsenal_app/shared/providers/providers.dart';

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

    // 6. 設定重導向邏輯 (核心) - 使用純函式auth guard
    redirect: (BuildContext context, GoRouterState state) {
      // 讀取最新的認證和引導頁狀態
      final authState = AuthGuardState(
        isAuthenticated: ref.read(authProvider).isAuthenticated,
        shouldShowOnboarding: !ref.read(onboardingProvider),
      );
      
      // 使用純函式進行重導向決策
      return authGuard(authState, state.matchedLocation);
    },

    // 7. 設定狀態監聽，讓路由響應變化
    refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.notifier).stream),
  );
}); 