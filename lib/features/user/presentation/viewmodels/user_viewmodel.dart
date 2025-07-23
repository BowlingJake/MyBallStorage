import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserViewModel(this._userRepository);

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasUser => _currentUser != null;

  // Load current user
  Future<void> loadCurrentUser() async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _userRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load user data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _userRepository.updateUser(user);
      notifyListeners();
    } catch (e) {
      _setError('Failed to update user data: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Create user
  Future<void> createUser(UserModel user) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _userRepository.createUser(user);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create user: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Delete user
  Future<void> deleteCurrentUser() async {
    if (_currentUser == null) return;

    _setLoading(true);
    _clearError();

    try {
      await _userRepository.deleteUser(_currentUser!.id);
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete user: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile image
  Future<void> updateProfileImage(String? imageUrl) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      profileImageUrl: imageUrl,
      updatedAt: DateTime.now(),
    );

    await updateUser(updatedUser);
  }

  // Clear user data (for logout)
  void clearUser() {
    _currentUser = null;
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
} 