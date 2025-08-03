import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/supabase_user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
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
    @Default('') String searchText,
    @Default(BallFilters()) BallFilters filters,
    @Default(false) bool isRemoveMode,
    @Default({}) Set<int> selectedForRemoval,
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
      
      // Load all instances
      await _loadAllInstances(userId);
      
      // Load user categories
      await _loadUserCategories(userId);
      
      // Set default selected category to "All My Arsenal" (null)
      state = state.copyWith(
        selectedCategory: null, // "All My Arsenal" 
        isLoading: false,
      );
      
    } catch (e) {
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
      state = state.copyWith(allInstances: instances);
    } catch (e) {
      throw Exception('Failed to load instances: $e');
    }
  }

  /// Load user categories
  Future<void> _loadUserCategories(String userId) async {
    try {
      final categories = await _repository.getUserCategories(userId);
      state = state.copyWith(userCategories: categories);
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Get filtered instances based on selected category, search text, and filters
  List<UserArsenalInstance> get filteredInstances {
    var instances = state.allInstances;
    
    // Filter by category first
    if (state.selectedCategory != null) {
      instances = instances
          .where((instance) => instance.belongsToCategory(state.selectedCategory!))
          .toList();
    }
    
    // Filter by search text
    if (state.searchText.isNotEmpty) {
      final searchLower = state.searchText.toLowerCase();
      instances = instances.where((instance) {
        final ball = instance.bowlingBall;
        if (ball == null) return false;
        final ballName = ball.name.toLowerCase();
        final ballBrand = ball.brand.toLowerCase();
        return ballName.contains(searchLower) || ballBrand.contains(searchLower);
      }).toList();
    }
    
    // Filter by brands
    if (state.filters.brands.isNotEmpty) {
      instances = instances.where((instance) {
        final ball = instance.bowlingBall;
        return ball != null && state.filters.brands.contains(ball.brand);
      }).toList();
    }
    
    // Filter by cores
    if (state.filters.cores.isNotEmpty) {
      instances = instances.where((instance) {
        final ball = instance.bowlingBall;
        if (ball?.coreType == null) return false;
        // Check if ball's core type is in selected cores
        final coreType = ball!.coreType!.toLowerCase().contains('asym') ? 'Asymmetric' : 'Symmetric';
        return state.filters.cores.contains(coreType);
      }).toList();
    }
    
    // Filter by coverstocks
    if (state.filters.coverstocks.isNotEmpty) {
      instances = instances.where((instance) {
        final ball = instance.bowlingBall;
        return ball?.coverstockType != null && 
               state.filters.coverstocks.contains(ball!.coverstockType!);
      }).toList();
    }
    
    return instances;
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
  }

  /// Change view mode
  void setViewMode(ArsenalViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// Update search text
  void updateSearchText(String searchText) {
    state = state.copyWith(searchText: searchText);
  }

  /// Update filters
  void updateFilters(BallFilters newFilters) {
    state = state.copyWith(filters: newFilters);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      searchText: '',
      filters: const BallFilters(),
    );
  }

  /// Add a ball from library to arsenal
  Future<void> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName,
    String? notes,
  }) async {
    try {
      
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
      
    } catch (e) {
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

  /// Toggle remove mode
  void toggleRemoveMode() {
    state = state.copyWith(
      isRemoveMode: !state.isRemoveMode,
      selectedForRemoval: {}, // Clear selection when toggling
    );
  }

  /// Toggle instance selection for removal
  void toggleInstanceForRemoval(int instanceId) {
    final currentSelection = Set<int>.from(state.selectedForRemoval);
    if (currentSelection.contains(instanceId)) {
      currentSelection.remove(instanceId);
    } else {
      currentSelection.add(instanceId);
    }
    state = state.copyWith(selectedForRemoval: currentSelection);
  }

  /// Remove selected instances
  Future<void> removeSelectedInstances(String userId) async {
    try {
      final selectedIds = state.selectedForRemoval.toList();
      
      // Remove each selected instance
      for (final instanceId in selectedIds) {
        await _repository.removeArsenalInstance(instanceId);
      }
      
      // Update state by removing all selected instances
      final updatedInstances = state.allInstances
          .where((instance) => !selectedIds.contains(instance.id))
          .toList();
      
      state = state.copyWith(
        allInstances: updatedInstances,
        selectedForRemoval: {},
        isRemoveMode: false,
      );
      
      // Refresh categories in case we removed balls from categories
      await _loadUserCategories(userId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove selected instances: $e');
      rethrow;
    }
  }

  /// Update bag assignment for a ball instance
  Future<void> updateBagAssignment({
    required int instanceId,
    required int bagNumber,
    required bool isInBag,
  }) async {
    try {
      await _repository.updateBagAssignment(
        instanceId: instanceId,
        bagNumber: bagNumber,
        isInBag: isInBag,
      );
      
      // Refresh instances to reflect the change
      final userId = state.allInstances.isNotEmpty 
          ? state.allInstances.first.userId 
          : '';
      if (userId.isNotEmpty) {
        await _loadAllInstances(userId);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to update bag assignment: $e');
      rethrow;
    }
  }
}

/// Provider to get filtered instances for current category
@riverpod
List<UserArsenalInstance> filteredArsenalInstances(FilteredArsenalInstancesRef ref) {
  final controller = ref.watch(newArsenalControllerProvider);
  final notifier = ref.read(newArsenalControllerProvider.notifier);
  return notifier.filteredInstances;
}