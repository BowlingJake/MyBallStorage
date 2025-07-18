import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository.dart';
import '../viewmodels/user_viewmodel.dart';

// Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

// ViewModel Provider
final userViewModelProvider = ChangeNotifierProvider<UserViewModel>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserViewModel(repository);
});

// Current User Provider
final currentUserProvider = Provider((ref) {
  final viewModel = ref.watch(userViewModelProvider);
  return viewModel.currentUser;
});

// Loading State Provider
final userLoadingProvider = Provider<bool>((ref) {
  final viewModel = ref.watch(userViewModelProvider);
  return viewModel.isLoading;
});

// Error Message Provider
final userErrorProvider = Provider<String?>((ref) {
  final viewModel = ref.watch(userViewModelProvider);
  return viewModel.errorMessage;
});

// Has User Provider
final hasUserProvider = Provider<bool>((ref) {
  final viewModel = ref.watch(userViewModelProvider);
  return viewModel.hasUser;
}); 