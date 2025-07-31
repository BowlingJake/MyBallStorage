import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bowlingarsenal_app/home_page.dart';
import 'package:bowlingarsenal_app/shared/views/login_page.dart';
import 'package:bowlingarsenal_app/features/onboarding/views/onboarding_page.dart';
import 'package:bowlingarsenal_app/routing/auth_guard.dart';
import 'package:bowlingarsenal_app/features/ball_library/presentation/pages/ball_library_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/my_training_page.dart';
import 'package:bowlingarsenal_app/shared/views/developer_page.dart';
import 'package:bowlingarsenal_app/features/arsenal/views/my_arsenal_page.dart';
import 'package:bowlingarsenal_app/shared/views/settings_page.dart';
import 'package:bowlingarsenal_app/features/events/views/events_page.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/features/auth/data/auth_repository.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/edit_profile_page.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/favorite_centers_oil_patterns_page.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/view_profile_page.dart';
import 'package:bowlingarsenal_app/features/favorites/presentation/pages/favorites_page.dart';

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
  // 使用 AuthController 來監聽認證狀態
  final authState = ref.watch(authControllerProvider);
  // final onboardingCompleted = ref.watch(onboardingProvider); // 測試階段暫時不用
  
  // 從 AuthController 取得認證狀態
  final isAuthenticated = authState.hasValue && authState.value != null;
  // 測試階段：暫時禁用 onboarding，直接進入主頁面
  const shouldShowOnboarding = false; // isAuthenticated && !onboardingCompleted;

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
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
       GoRoute(
        path: '/edit_profile',
        name: 'edit_profile', // 給它一個名字是好習慣
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/favorite_centers_oil_patterns',
        name: 'favorite_centers_oil_patterns',
        builder: (context, state) => const FavoriteCentersOilPatternsPage(),
      ),
      GoRoute(
        path: '/view_profile',
        name: 'view_profile',
        builder: (context, state) => const ViewProfilePage(),
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
        child: Text('錯誤:  ${state.error?.message}'),
      ),
    ),

    // 6. 設定重導向邏輯 (核心) - 使用純函式auth guard
    redirect: (context, state) {
      // 使用 AuthGuard 進行重導向決策
      final authGuardState = AuthGuardState(
        isAuthenticated: isAuthenticated,
        shouldShowOnboarding: shouldShowOnboarding,
      );
      
      return authGuard(authGuardState, state.matchedLocation);
    },

    // 7. 設定狀態監聽，讓路由響應變化
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateChangesProvider.stream),
    ),
  );
}); 