import '../models/user_model.dart';

// Abstract repository interface
abstract class UserRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<UserModel> createUser(UserModel user);
  Future<List<UserModel>> getAllUsers();
}

// Concrete implementation
class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserModel?> getCurrentUser() async {
    // TODO: Implement actual user fetching logic
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    // TODO: Implement actual user update logic
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(String userId) async {
    // TODO: Implement actual user deletion logic
    throw UnimplementedError();
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    // TODO: Implement actual user creation logic
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    // TODO: Implement actual users fetching logic
    throw UnimplementedError();
  }
} 