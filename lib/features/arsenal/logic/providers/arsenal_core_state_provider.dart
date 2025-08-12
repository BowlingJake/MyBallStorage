import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/supabase_user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'arsenal_core_state_provider.freezed.dart';
part 'arsenal_core_state_provider.g.dart';

/// Core Arsenal state containing only essential data
@freezed
class ArsenalCoreState with _$ArsenalCoreState {
  const factory ArsenalCoreState({
    @Default([]) List<UserArsenalInstance> allInstances,
    @Default([]) List<String> userCategories,
    @Default(false) bool isLoading,
    String? error,
    String? selectedCategory,
    @Default(1) int selectedBagNumber,
  }) = _ArsenalCoreState;
}

/// Arsenal repository provider
@riverpod
UserArsenalRepository userArsenalRepository(UserArsenalRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserArsenalRepository(supabase);
}

/// Core Arsenal data provider - handles only data loading and bag operations
@riverpod
class ArsenalCoreStateProvider extends _$ArsenalCoreStateProvider {
  @override
  ArsenalCoreState build() {
    return const ArsenalCoreState();
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
      state = state.copyWith(error: 'Failed to load arsenal instances: $e');
    }
  }

  /// Load user categories
  Future<void> _loadUserCategories(String userId) async {
    try {
      final categories = await _repository.getUserCategories(userId);
      state = state.copyWith(userCategories: categories);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load categories: $e');
    }
  }

  /// Refresh arsenal data
  Future<void> refresh(String userId) async {
    await initialize(userId);
  }

  /// Update selected category
  void updateSelectedCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Update selected bag number
  void updateSelectedBag(int bagNumber) {
    state = state.copyWith(selectedBagNumber: bagNumber);
  }

  /// Add new instance to arsenal
  Future<void> addInstance(UserArsenalInstance instance) async {
    try {
      // Optimistically update UI
      final updatedInstances = [...state.allInstances, instance];
      state = state.copyWith(allInstances: updatedInstances);
      
      // Note: Database persistence would be handled by the service layer
    } catch (e) {
      // Revert optimistic update on error
      await _loadAllInstances(instance.userId);
      state = state.copyWith(error: 'Failed to add instance: $e');
    }
  }

  /// Remove instances from arsenal
  Future<void> removeInstances(List<int> instanceIds) async {
    try {
      // Optimistically update UI
      final updatedInstances = state.allInstances
          .where((instance) => !instanceIds.contains(instance.id))
          .toList();
      state = state.copyWith(allInstances: updatedInstances);
      
      // Note: Database persistence would be handled by the service layer
    } catch (e) {
      // Revert optimistic update on error
      if (state.allInstances.isNotEmpty) {
        final userId = state.allInstances.first.userId;
        await _loadAllInstances(userId);
      }
      state = state.copyWith(error: 'Failed to remove instances: $e');
    }
  }

  /// Update instances in arsenal
  Future<void> updateInstances(List<UserArsenalInstance> instances) async {
    try {
      // Create a map for faster lookups
      final updatedInstancesMap = <int, UserArsenalInstance>{
        for (var instance in instances) instance.id: instance
      };
      
      // Update matching instances
      final updatedList = state.allInstances.map((existing) {
        return updatedInstancesMap[existing.id] ?? existing;
      }).toList();
      
      state = state.copyWith(allInstances: updatedList);
      
      // Note: Database persistence would be handled by the service layer
    } catch (e) {
      state = state.copyWith(error: 'Failed to update instances: $e');
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get instances for a specific bag
  List<UserArsenalInstance> getInstancesForBag(int bagNumber) {
    if (bagNumber == 1) {
      // Main arsenal view - return all instances
      return state.allInstances;
    } else {
      // Specific bag - return instances in that bag
      return state.allInstances
          .where((instance) => instance.activeBagNumbers.contains(bagNumber))
          .toList();
    }
  }

  /// Get instances for selected category
  List<UserArsenalInstance> getInstancesForCategory() {
    final instances = getInstancesForBag(state.selectedBagNumber);
    
    if (state.selectedCategory == null) {
      return instances; // All My Arsenal
    }
    
    return instances
        .where((instance) => instance.belongsToCategory(state.selectedCategory!))
        .toList();
  }

  /// Check if bag has data
  bool bagHasData(int bagNumber) {
    return getInstancesForBag(bagNumber).isNotEmpty;
  }

  /// Get available bag numbers with data
  List<int> getAvailableBagNumbers() {
    final bagNumbers = <int>{};
    for (final instance in state.allInstances) {
      bagNumbers.addAll(instance.activeBagNumbers);
    }
    return bagNumbers.toList()..sort();
  }
}