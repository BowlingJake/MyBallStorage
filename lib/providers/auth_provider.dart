import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_preferences_service.dart';
import 'user_profile_provider.dart';

// 使用者認證狀態
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? error;

  const AuthState({
    required this.status,
    this.userId,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      error: error ?? this.error,
    );
  }
}

// 認證狀態管理
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState(status: AuthStatus.unknown)) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final userId = prefs.getString('userId');
      
      if (isLoggedIn && userId != null) {
        // 觸發載入使用者檔案
        await _ref.read(userProfileProvider.notifier).loadProfile();
        state = AuthState(status: AuthStatus.authenticated, userId: userId);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    try {
      // TODO: 實作真正的登入邏輯
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', username);
      
      // 觸發載入使用者檔案
      await _ref.read(userProfileProvider.notifier).loadProfile();
      state = AuthState(status: AuthStatus.authenticated, userId: username);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString());
    }
  }

  Future<void> loginAsGuest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', 'guest_user');
      await prefs.setBool('isGuestMode', true);
      await prefs.setBool('onboarding_completed', true); // 訪客跳過 Onboarding
      
      // 設定預設的訪客檔案
      await _setDefaultGuestProfile();
      // 手動觸發使用者檔案 provider 更新
      await _ref.read(userProfileProvider.notifier).loadProfile();
      
      state = const AuthState(status: AuthStatus.authenticated, userId: 'guest_user');
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString());
    }
  }

  Future<void> _setDefaultGuestProfile() async {
    final userService = UserPreferencesService();
    await userService.saveProfile(
      nickname: '訪客使用者',
      hand: '右手',
      ballPath: '直球',
      pap: '待設定',
    );
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.toString());
    }
  }
}

// Provider 定義
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
}); 