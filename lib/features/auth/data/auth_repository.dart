import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepository(this._supabaseClient);

  // 新增：定義 currentUser getter
  User? get currentUser => _supabaseClient.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  // 你可以在這裡添加更多的身份驗證方法，例如：
  // Future<void> signInWithEmailAndPassword(String email, String password) async {
  //   await _supabaseClient.auth.signInWithPassword(email: email, password: password);
  // }

  // Future<void> signOut() async {
  //   await _supabaseClient.auth.signOut();
  // }
}