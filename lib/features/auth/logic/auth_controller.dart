import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/auth/data/auth_repository.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'auth_controller.g.dart';

/// Provider for AuthRepository
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepository(supabase);
}

/// Provider for current user
@riverpod
User? currentUser(CurrentUserRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.currentUser;
}

/// Controller for authentication operations
@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    final authRepository = ref.watch(authRepositoryProvider);
    
    // 監聽認證狀態變化
    authRepository.authStateChanges.listen((authState) {
      state = AsyncValue.data(authState.session?.user);
    });
    
    return authRepository.currentUser;
  }

  /// 使用 Email 和密碼登入
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.signInWithEmailAndPassword(email, password);
      state = AsyncValue.data(response.user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 使用 Email 和密碼註冊
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authRepository = ref.read(authRepositoryProvider);
      final response = await authRepository.signUpWithEmailAndPassword(email, password);
      state = AsyncValue.data(response.user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 登出
  Future<void> signOut() async {
    try {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}