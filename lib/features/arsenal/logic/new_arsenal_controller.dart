import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/supabase_user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_data_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_filter_service.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/services/arsenal_sort_service.dart';
import 'package:bowlingarsenal_app/features/ball_library/data/models/ball_library_state.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

/// New Arsenal repository provider
@riverpod
UserArsenalRepository userArsenalRepository(UserArsenalRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserArsenalRepository(supabase);
}

/// Arsenal data service provider
@riverpod
ArsenalDataService arsenalDataService(ArsenalDataServiceRef ref) {
  final repository = ref.watch(userArsenalRepositoryProvider);
  return ArsenalDataService(repository);
}

/// New Arsenal controller
@riverpod
class NewArsenalController extends _$NewArsenalController {
  @override
  NewArsenalState build() {
    return const NewArsenalState();
  }

  UserArsenalRepository get _repository => ref.read(userArsenalRepositoryProvider);
  ArsenalDataService get _dataService => ref.read(arsenalDataServiceProvider);

  /// Initialize arsenal data for user
  Future<void> initialize(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _dataService.initialize(userId);
      
      if (result.isSuccess) {
        state = state.copyWith(
          allInstances: result.instances!,
          userCategories: result.categories!,
          selectedCategory: null, // "All My Arsenal" 
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize arsenal: $e',
      );
    }
  }

  /// Get filtered instances based on selected bag, category, search text, and filters
  List<UserArsenalInstance> get filteredInstances {
    // 使用 ArsenalFilterService 進行過濾
    final filteredInstances = ArsenalFilterService.filterInstances(
      instances: state.allInstances,
      selectedBagNumber: state.selectedBagNumber,
      selectedCategory: state.selectedCategory,
      searchText: state.searchText,
      filters: state.filters,
    );
    
    // 使用 ArsenalSortService 進行排序
    return ArsenalSortService.sortInstances(
      instances: filteredInstances,
      sortOption: state.sortOption,
      ascending: state.sortAscending,
    );
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
    return ArsenalSortService.getSortDisplayName(state.sortOption);
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      selectedBagNumber: 1, // 重置到 "All My Arsenal"
      selectedCategory: null, // 重置類別選擇
      searchText: '',
      filters: const BallFilters(),
    );
  }

  /// Check if any filters are currently active
  bool get hasActiveFilters {
    return ArsenalFilterService.hasActiveFilters(
      selectedBagNumber: state.selectedBagNumber,
      selectedCategory: state.selectedCategory,
      searchText: state.searchText,
      filters: state.filters,
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
      final instance = await _dataService.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryName: categoryName,
        notes: notes,
      );

      // Add to current state
      final updatedInstances = [...state.allInstances, instance];
      state = state.copyWith(allInstances: updatedInstances);
      
      // Refresh categories in case it's a new category
      final categories = await _dataService.loadUserCategories(userId);
      state = state.copyWith(userCategories: categories);
      
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
      await _dataService.updateNotes(instanceId, note.isEmpty ? null : note);
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

  /// Load all instances for a user
  Future<void> _loadAllInstances(String userId) async {
    try {
      final instances = await _dataService.loadAllInstances(userId);
      state = state.copyWith(allInstances: instances);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load instances: $e');
    }
  }

  /// Load user categories
  Future<void> _loadUserCategories(String userId) async {
    try {
      final categories = await _dataService.loadUserCategories(userId);
      state = state.copyWith(userCategories: categories);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load categories: $e');
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