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
import 'package:bowlingarsenal_app/features/training/presentation/pages/create_training_step1_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/create_training_step2_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/create_training_step3_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/training_history_years_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/training_history_months_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/training_history_days_page.dart';
import 'package:bowlingarsenal_app/features/training/presentation/pages/training_detail_page.dart';
import 'package:bowlingarsenal_app/shared/views/developer_page.dart';
import 'package:bowlingarsenal_app/features/arsenal/presentation/pages/my_arsenal_page.dart';
import 'package:bowlingarsenal_app/shared/views/settings_page.dart';
import 'package:bowlingarsenal_app/features/tournament/views/my_tournament_page.dart';
import 'package:bowlingarsenal_app/features/tournament/presentation/pages/new_tournament_step1_page.dart';
import 'package:bowlingarsenal_app/features/tournament/presentation/pages/new_tournament_step2_page.dart';
import 'package:bowlingarsenal_app/features/tournament/presentation/pages/new_tournament_step3_page.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:bowlingarsenal_app/features/auth/data/auth_repository.dart';
import 'package:bowlingarsenal_app/features/auth/logic/auth_controller.dart';
import 'package:bowlingarsenal_app/features/onboarding/providers/onboarding_provider.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/edit_profile_page.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/favorite_centers_oil_patterns_page.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/view_profile_page.dart';
import 'package:bowlingarsenal_app/features/user/presentation/pages/my_profile_page.dart';
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
        pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
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
        pageBuilder: (context, state) => const NoTransitionPage(child: BallLibraryPage()),
      ),
      GoRoute(
        path: '/training',
        name: 'training',
        pageBuilder: (context, state) => const NoTransitionPage(child: MyTrainingPage()),
      ),
      GoRoute(
        path: '/training/create/step-1',
        name: 'training-create-step1',
        pageBuilder: (context, state) => const NoTransitionPage(child: CreateTrainingStep1Page()),
      ),
      GoRoute(
        path: '/training/create/step-2',
        name: 'training-create-step2',
        pageBuilder: (context, state) => const NoTransitionPage(child: CreateTrainingStep2Page()),
      ),
      GoRoute(
        path: '/training/create/step-3',
        name: 'training-create-step3',
        pageBuilder: (context, state) => const NoTransitionPage(child: CreateTrainingStep3Page()),
      ),
      // Training History Routes
      GoRoute(
        path: '/training/history',
        name: 'training-history-years',
        pageBuilder: (context, state) => const NoTransitionPage(child: TrainingHistoryYearsPage()),
      ),
      GoRoute(
        path: '/training/history/:year',
        name: 'training-history-months',
        pageBuilder: (context, state) {
          final year = int.parse(state.pathParameters['year']!);
          return NoTransitionPage(child: TrainingHistoryMonthsPage(year: year));
        },
      ),
      GoRoute(
        path: '/training/history/:year/:month',
        name: 'training-history-days',
        pageBuilder: (context, state) {
          final year = int.parse(state.pathParameters['year']!);
          final month = int.parse(state.pathParameters['month']!);
          return NoTransitionPage(child: TrainingHistoryDaysPage(year: year, month: month));
        },
      ),
      GoRoute(
        path: '/training/detail/:sessionId',
        name: 'training-detail',
        pageBuilder: (context, state) {
          final sessionId = state.pathParameters['sessionId']!;
          // We'll need to pass the training session data through extra or fetch it
          final trainingSession = state.extra as dynamic;
          return NoTransitionPage(
            child: TrainingDetailPage(
              sessionId: sessionId,
              trainingSession: trainingSession,
            ),
          );
        },
      ),
      GoRoute(
        path: '/my-arsenal',
        name: 'my-arsenal',
        pageBuilder: (context, state) => const NoTransitionPage(child: MyArsenalPage()),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        pageBuilder: (context, state) => const NoTransitionPage(child: FavoritesPage()),
      ),
      GoRoute(
        path: '/tournament',
        name: 'tournament',
        pageBuilder: (context, state) => const NoTransitionPage(child: MyTournamentPage()),
      ),
      GoRoute(
        path: '/tournaments/new/1',
        name: 'tournaments-new-step1',
        pageBuilder: (context, state) => const NoTransitionPage(child: NewTournamentStep1Page()),
      ),
      GoRoute(
        path: '/tournaments/new/2',
        name: 'tournaments-new-step2',
        pageBuilder: (context, state) => const NoTransitionPage(child: NewTournamentStep2Page()),
      ),
      GoRoute(
        path: '/tournaments/new/3',
        name: 'tournaments-new-step3',
        pageBuilder: (context, state) => const NoTransitionPage(child: NewTournamentStep3Page()),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
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
        path: '/my-profile',
        name: 'my-profile',
        pageBuilder: (context, state) => const NoTransitionPage(child: MyProfilePage()),
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