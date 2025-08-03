import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/supabase_user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'new_arsenal_controller.freezed.dart';
part 'new_arsenal_controller.g.dart';

/// State class for new Arsenal management
@freezed
class NewArsenalState with _$NewArsenalState {
  const factory NewArsenalState({
    @Default([]) List<UserArsenalInstance> allInstances,
    @Default([]) List<String> userCategories,
    String? selectedCategory, // null means "All My Arsenal"
    @Default(false) bool isLoading,
    String? error,
    @Default(ArsenalViewMode.grid) ArsenalViewMode viewMode,
  }) = _NewArsenalState;
}

enum ArsenalViewMode { grid, list }

/// New Arsenal repository provider
@riverpod
UserArsenalRepository userArsenalRepository(UserArsenalRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserArsenalRepository(supabase);
}

/// New Arsenal controller
@riverpod
class NewArsenalController extends _$NewArsenalController {
  @override
  NewArsenalState build() {
    return const NewArsenalState();
  }

  UserArsenalRepository get _repository => ref.read(userArsenalRepositoryProvider);

  /// Initialize arsenal data for user
  Future<void> initialize(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('New Arsenal Controller: Initializing for user $userId');
      
      // Load all instances
      await _loadAllInstances(userId);
      
      // Load user categories
      await _loadUserCategories(userId);
      
      // Set default selected category to "All My Arsenal" (null)
      state = state.copyWith(
        selectedCategory: null, // "All My Arsenal" 
        isLoading: false,
      );
      
      print('New Arsenal Controller: Initialization complete - ${state.allInstances.length} instances, ${state.userCategories.length} categories');
    } catch (e) {
      print('New Arsenal Controller: Initialization error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize arsenal: $e',
      );
    }
  }

  /// Load all user instances
  Future<void> _loadAllInstances(String userId) async {
    try {
      final instances = await _repository.getUserArsenal(userId);
      print('New Arsenal Controller: Loaded ${instances.length} instances');
      state = state.copyWith(allInstances: instances);
    } catch (e) {
      print('New Arsenal Controller: Error loading instances: $e');
      throw Exception('Failed to load instances: $e');
    }
  }

  /// Load user categories
  Future<void> _loadUserCategories(String userId) async {
    try {
      final categories = await _repository.getUserCategories(userId);
      print('New Arsenal Controller: Loaded categories: $categories');
      state = state.copyWith(userCategories: categories);
    } catch (e) {
      print('New Arsenal Controller: Error loading categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Get filtered instances based on selected category
  List<UserArsenalInstance> get filteredInstances {
    if (state.selectedCategory == null) {
      // "All My Arsenal" - show all instances
      return state.allInstances;
    }
    
    // Filter by specific category
    return state.allInstances
        .where((instance) => instance.belongsToCategory(state.selectedCategory!))
        .toList();
  }

  /// Get all available categories including virtual "All My Arsenal"
  List<String> get allAvailableCategories {
    return ['All My Arsenal', ...state.userCategories];
  }

  /// Select a category (null for "All My Arsenal")
  void selectCategory(String? categoryName) {
    if (categoryName == 'All My Arsenal') {
      state = state.copyWith(selectedCategory: null);
    } else {
      state = state.copyWith(selectedCategory: categoryName);
    }
    print('New Arsenal Controller: Selected category: ${state.selectedCategory ?? "All My Arsenal"}');
  }

  /// Change view mode
  void setViewMode(ArsenalViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// Add a ball from library to arsenal
  Future<void> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName,
    String? notes,
  }) async {
    try {
      print('New Arsenal Controller: Adding ball $ballId to category "$categoryName"');
      
      final instance = await _repository.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryName: categoryName,
        notes: notes,
      );

      // Add to current state
      final updatedInstances = [...state.allInstances, instance];
      state = state.copyWith(allInstances: updatedInstances);
      
      // Refresh categories in case it's a new category
      await _loadUserCategories(userId);
      
      print('New Arsenal Controller: Successfully added ball');
    } catch (e) {
      print('New Arsenal Controller: Error adding ball: $e');
      state = state.copyWith(error: 'Failed to add ball: $e');
      rethrow;
    }
  }

  /// Remove an instance
  Future<void> removeInstance(int instanceId, String userId) async {
    try {
      await _repository.removeArsenalInstance(instanceId);
      
      // Remove from current state
      final updatedInstances = state.allInstances
          .where((instance) => instance.id != instanceId)
          .toList();
      state = state.copyWith(allInstances: updatedInstances);
      
      // Refresh categories in case we removed the last ball of a category
      await _loadUserCategories(userId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove instance: $e');
      rethrow;
    }
  }

  /// Update games used
  Future<void> updateGamesUsed(int instanceId, int gamesUsed, String userId) async {
    try {
      await _repository.updateGamesUsed(instanceId, gamesUsed);
      
      // Update in current state
      final updatedInstances = state.allInstances.map((instance) {
        return instance.id == instanceId 
            ? instance.copyWith(gamesUsed: gamesUsed)
            : instance;
      }).toList();
      
      state = state.copyWith(allInstances: updatedInstances);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update games used: $e');
      rethrow;
    }
  }

  /// Update layout
  Future<void> updateLayout({
    required int instanceId,
    required String layoutType,
    required double value1,
    required double value2,
    required double value3,
    required String userId,
  }) async {
    try {
      await _repository.updateLayout(
        instanceId: instanceId,
        layoutType: layoutType,
        value1: value1,
        value2: value2,
        value3: value3,
      );
      
      // Update in current state
      final updatedInstances = state.allInstances.map((instance) {
        return instance.id == instanceId 
            ? instance.copyWith(
                hasLayout: true,
                layoutType: layoutType,
                layoutValue1: value1,
                layoutValue2: value2,
                layoutValue3: value3,
              )
            : instance;
      }).toList();
      
      state = state.copyWith(allInstances: updatedInstances);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update layout: $e');
      rethrow;
    }
  }

  /// Refresh all data
  Future<void> refresh(String userId) async {
    await initialize(userId);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider to get filtered instances for current category
@riverpod
List<UserArsenalInstance> filteredArsenalInstances(FilteredArsenalInstancesRef ref) {
  final controller = ref.watch(newArsenalControllerProvider);
  final notifier = ref.read(newArsenalControllerProvider.notifier);
  return notifier.filteredInstances;
}