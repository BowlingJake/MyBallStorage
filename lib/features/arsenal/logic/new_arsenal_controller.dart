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
    @Default(false) bool isMoveMode,
    @Default({}) Set<int> selectedForMove,
    @Default(1) int selectedBagNumber, // 預設選擇袋子 1
    @Default(SortOption.nameAZ) SortOption sortOption, // 排序選項
    @Default(false) bool sortAscending, // 排序方向
  }) = _NewArsenalState;
}

enum ArsenalViewMode { grid, list }

/// 排序選項枚舉
enum SortOption {
  nameAZ('Name (A-Z)'),
  nameZA('Name (Z-A)'),
  brandAZ('Brand (A-Z)'),
  brandZA('Brand (Z-A)'),
  dateNewest('Date Added (Newest)'),
  dateOldest('Date Added (Oldest)'),
  gamesUsedMost('Games Used (Most)'),
  gamesUsedLeast('Games Used (Least)');

  const SortOption(this.displayName);
  final String displayName;
}

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

  /// Get filtered instances based on selected bag, category, search text, and filters
  List<UserArsenalInstance> get filteredInstances {
    var instances = state.allInstances;
    
    // Filter by selected bag first
    if (state.selectedBagNumber != 1) {
      // 如果不是 "All My Arsenal" (袋子1)，則根據袋子篩選
      instances = instances
          .where((instance) => instance.isInBag(state.selectedBagNumber))
          .toList();
    }
    
    // Filter by category
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
    
    // Apply sorting
    return _sortInstances(instances);
  }

  /// 排序球具列表
  List<UserArsenalInstance> _sortInstances(List<UserArsenalInstance> instances) {
    final sortedInstances = List<UserArsenalInstance>.from(instances);
    
    switch (state.sortOption) {
      case SortOption.nameAZ:
        sortedInstances.sort((a, b) => 
            (a.bowlingBall?.name ?? '').compareTo(b.bowlingBall?.name ?? ''));
        break;
      case SortOption.nameZA:
        sortedInstances.sort((a, b) => 
            (b.bowlingBall?.name ?? '').compareTo(a.bowlingBall?.name ?? ''));
        break;
      case SortOption.brandAZ:
        sortedInstances.sort((a, b) => 
            (a.bowlingBall?.brand ?? '').compareTo(b.bowlingBall?.brand ?? ''));
        break;
      case SortOption.brandZA:
        sortedInstances.sort((a, b) => 
            (b.bowlingBall?.brand ?? '').compareTo(a.bowlingBall?.brand ?? ''));
        break;
      case SortOption.dateNewest:
        sortedInstances.sort((a, b) {
          if (a.addedDate == null && b.addedDate == null) return 0;
          if (a.addedDate == null) return 1;
          if (b.addedDate == null) return -1;
          return b.addedDate!.compareTo(a.addedDate!);
        });
        break;
      case SortOption.dateOldest:
        sortedInstances.sort((a, b) {
          if (a.addedDate == null && b.addedDate == null) return 0;
          if (a.addedDate == null) return 1;
          if (b.addedDate == null) return -1;
          return a.addedDate!.compareTo(b.addedDate!);
        });
        break;
      case SortOption.gamesUsedMost:
        sortedInstances.sort((a, b) => b.gamesUsed.compareTo(a.gamesUsed));
        break;
      case SortOption.gamesUsedLeast:
        sortedInstances.sort((a, b) => a.gamesUsed.compareTo(b.gamesUsed));
        break;
    }
    
    return sortedInstances;
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

  /// Select a specific bag
  void selectBag(int bagNumber) {
    state = state.copyWith(selectedBagNumber: bagNumber);
  }

  /// Update filters
  void updateFilters(BallFilters newFilters) {
    state = state.copyWith(filters: newFilters);
  }

  /// 設定排序選項
  void setSortOption(SortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
  }

  /// 切換排序方向
  void toggleSortDirection() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  /// 獲取當前排序狀態的描述
  String get currentSortDescription {
    return state.sortOption.displayName;
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

  /// Add a ball from library to multiple bags
  Future<void> addBallFromLibraryToMultipleBags({
    required String userId,
    required int ballId,
    required String categoryName,
    required List<int> bagNumbers,
    String? notes,
  }) async {
    try {
      // First add the ball to arsenal (this will add to bag 1 by default)
      final instance = await _repository.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryName: categoryName,
        notes: notes,
      );

      // Add to current state
      final updatedInstances = [...state.allInstances, instance];
      state = state.copyWith(allInstances: updatedInstances);
      
      // Add to additional bags if needed (exclude bag 1 as it's already added)
      final additionalBags = bagNumbers.where((bagNum) => bagNum != 1).toList();
      for (final bagNumber in additionalBags) {
        await _repository.updateBagAssignment(
          instanceId: instance.id,
          bagNumber: bagNumber,
          isInBag: true,
        );
      }
      
      // Refresh data to get updated bag assignments
      await _loadAllInstances(userId);
      
      // Refresh categories in case it's a new category
      await _loadUserCategories(userId);
      
    } catch (e) {
      state = state.copyWith(error: 'Failed to add ball to multiple bags: $e');
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

  /// Update notes for an instance
  Future<void> updateNotes(int instanceId, String note, String userId) async {
    try {
      await _repository.updateNotes(instanceId: instanceId, notes: note.isEmpty ? null : note);
      final updated = state.allInstances.map((inst) => inst.id == instanceId ? inst.copyWith(notes: note.isEmpty ? null : note) : inst).toList();
      state = state.copyWith(allInstances: updated);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update notes: $e');
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
      isMoveMode: false, // Disable move mode when remove mode is active
      selectedForMove: {}, // Clear move selection
    );
  }

  /// Toggle move mode
  void toggleMoveMode() {
    state = state.copyWith(
      isMoveMode: !state.isMoveMode,
      selectedForMove: {}, // Clear selection when toggling
      isRemoveMode: false, // Disable remove mode when move mode is active
      selectedForRemoval: {}, // Clear removal selection
    );
  }

  /// Toggle instance for move
  void toggleInstanceForMove(int instanceId) {
    // 單選模式：若點同一顆則取消，否則只保留該顆
    if (state.selectedForMove.contains(instanceId)) {
      state = state.copyWith(selectedForMove: {});
    } else {
      state = state.copyWith(selectedForMove: {instanceId});
    }
  }

  /// Move selected instances to target bag
  Future<void> moveSelectedInstancesToBag(int targetBagNumber, String userId) async {
    try {
      final selectedIds = state.selectedForMove.toList();
      final int sourceBagNumber = state.selectedBagNumber ?? 1;
      
      for (final instanceId in selectedIds) {
        // 剪下貼上：先從來源袋移除（若來源與目標不同且來源非主袋時）
        if (sourceBagNumber != targetBagNumber) {
          await _repository.updateBagAssignment(
            instanceId: instanceId,
            bagNumber: sourceBagNumber,
            isInBag: false,
          );
        }
        // 加入目標袋
        await _repository.updateBagAssignment(
          instanceId: instanceId,
          bagNumber: targetBagNumber,
          isInBag: true,
        );
      }
      
      // Refresh data to get updated bag assignments
      await _loadAllInstances(userId);
      
      // Clear move mode and selection
      state = state.copyWith(
        isMoveMode: false,
        selectedForMove: {},
      );
      
    } catch (e) {
      state = state.copyWith(error: 'Failed to move balls: $e');
      rethrow;
    }
  }

  /// Remove selected instances from current bag (not from arsenal)
  Future<void> removeSelectedInstancesFromBag(int bagNumber, String userId) async {
    try {
      final selectedIds = state.selectedForRemoval.toList();
      
      for (final instanceId in selectedIds) {
        await _repository.updateBagAssignment(
          instanceId: instanceId,
          bagNumber: bagNumber,
          isInBag: false,
        );
      }
      
      // Refresh data to get updated bag assignments
      await _loadAllInstances(userId);
      
      // Clear remove mode and selection
      state = state.copyWith(
        isRemoveMode: false,
        selectedForRemoval: {},
      );
      
    } catch (e) {
      state = state.copyWith(error: 'Failed to remove balls from bag: $e');
      rethrow;
    }
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