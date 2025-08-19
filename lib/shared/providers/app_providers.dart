import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/auth/data/auth_repository.dart';
import 'package:bowlingarsenal_app/shared/services/image_upload_service.dart';

/// Provider for the SupabaseClient instance.
/// This is the foundational provider that other providers will depend on.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider for the AuthRepository.
/// It depends on the `supabaseClientProvider` to get the SupabaseClient instance.
/// This demonstrates dependency injection.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient);
});

/// StreamProvider to listen to authentication state changes.
/// The UI will watch this provider to know if a user is logged in or out,
/// and can rebuild or navigate accordingly.
final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Provider for the ImageUploadService.
/// It depends on the `supabaseClientProvider` to get the SupabaseClient instance.
final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return ImageUploadService(supabaseClient);
}); 