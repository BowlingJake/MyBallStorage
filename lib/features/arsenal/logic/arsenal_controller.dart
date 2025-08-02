import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/supabase_arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'package:bowlingarsenal_app/shared/providers/app_providers.dart';

part 'arsenal_controller.g.dart';

/// State class for Arsenal management
class ArsenalState {
  final List<ArsenalBallInstance> balls;
  final List<BagCategory> categories;
  final String? selectedCategoryId;
  final bool isLoading;
  final String? error;
  final ArsenalViewMode viewMode;

  const ArsenalState({
    this.balls = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.isLoading = false,
    this.error,
    this.viewMode = ArsenalViewMode.grid,
  });

  ArsenalState copyWith({
    List<ArsenalBallInstance>? balls,
    List<BagCategory>? categories,
    String? selectedCategoryId,
    bool? isLoading,
    String? error,
    ArsenalViewMode? viewMode,
  }) {
    return ArsenalState(
      balls: balls ?? this.balls,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  /// Get balls for the currently selected category
  List<ArsenalBallInstance> get filteredBalls {
    if (selectedCategoryId == null) return balls;
    
    // Special handling for "All My Arsenal" category - show all balls
    if (selectedCategoryId!.contains('all_my_arsenal')) {
      return balls;
    }
    
    return balls.where((ball) => ball.bagCategoryId == selectedCategoryId).toList();
  }

  /// Get the currently selected category
  BagCategory? get selectedCategory {
    if (selectedCategoryId == null) return null;
    
    // Handle virtual "All My Arsenal" category
    if (selectedCategoryId == 'all_my_arsenal') {
      return _createVirtualAllArsenalCategory();
    }
    
    return categories.where((cat) => cat.categoryId == selectedCategoryId).firstOrNull;
  }

  /// Create virtual "All My Arsenal" category for UI display
  BagCategory _createVirtualAllArsenalCategory() {
    return BagCategory(
      categoryId: 'all_my_arsenal',
      name: 'All My Arsenal',
      userId: '',
      iconCodePoint: 57669, // Iconsax.bag
      iconFontFamily: 'Iconsax',
      iconFontPackage: 'iconsax',
      themeColor: const  Color(0xFF1976D2), // Blue
      displayOrder: -1,
      isDefault: true,
      createdAt: DateTime.now(),
      description: 'All balls in your arsenal',
    );
  }

  /// Get all available categories including virtual "All My Arsenal"
  List<BagCategory> get allAvailableCategories {
    return [_createVirtualAllArsenalCategory(), ...categories];
  }

  /// Check if we have any balls
  bool get hasBalls => balls.isNotEmpty;

  /// Check if we have any categories
  bool get hasCategories => categories.isNotEmpty;
}

enum ArsenalViewMode { grid, list }

/// Arsenal repository provider
@riverpod
ArsenalRepository arsenalRepository(ArsenalRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseArsenalRepository(supabase);
}

/// Main Arsenal controller
@riverpod
class ArsenalController extends _$ArsenalController {
  @override
  ArsenalState build() {
    return const ArsenalState();
  }

  ArsenalRepository get _repository => ref.read(arsenalRepositoryProvider);

  /// Initialize arsenal data for user
  Future<void> initialize(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Load categories first
      await _loadCategories(userId);
      
      // Load balls
      await _loadBalls(userId);
      
      // Always set "All My Arsenal" as default selected category
      if (state.selectedCategoryId == null) {
        state = state.copyWith(selectedCategoryId: 'all_my_arsenal');
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize arsenal: $e',
      );
    }
  }


  /// Load user's categories
  Future<void> _loadCategories(String userId) async {
    try {
      var categories = await _repository.getUserCategories(userId);
      
      // If no categories exist, initialize default ones for new users
      if (categories.isEmpty) {
        await _repository.initializeDefaultCategories(userId);
        categories = await _repository.getUserCategories(userId);
      }
      
      state = state.copyWith(categories: categories);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load categories: $e');
    }
  }

  /// Load user's balls
  Future<void> _loadBalls(String userId) async {
    try {
      print('Arsenal Controller: Loading balls for user: $userId');
      final balls = await _repository.getUserArsenal(userId);
      print('Arsenal Controller: Loaded ${balls.length} balls from database');
      for (final ball in balls) {
        print('Arsenal Controller: Ball - ID: ${ball.ballId}, Category: ${ball.bagCategoryId}, Name: ${ball.bowlingBall?.name ?? "Unknown"}');
      }
      state = state.copyWith(balls: balls);
    } catch (e) {
      print('Arsenal Controller: Error loading balls: $e');
      state = state.copyWith(error: 'Failed to load balls: $e');
    }
  }

  /// Refresh all data
  Future<void> refresh(String userId) async {
    await initialize(userId);
  }

  /// Select a category
  void selectCategory(String? categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  /// Change view mode (grid/list)
  void setViewMode(ArsenalViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// Add a ball from library to arsenal
  Future<void> addBallFromLibrary({
    required String userId,
    required String ballId,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final instance = await _repository.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryId: categoryId,
        nickname: nickname,
        purchaseDate: purchaseDate,
        layout: layout,
      );
      
      // Add to current state
      final updatedBalls = [...state.balls, instance];
      state = state.copyWith(balls: updatedBalls, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add ball from library: $e',
      );
    }
  }

  /// Add a custom ball to arsenal
  Future<void> addCustomBall({
    required String userId,
    required BowlingBall customBall,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
    String? localImagePath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final instance = await _repository.addCustomBall(
        userId: userId,
        customBall: customBall,
        categoryId: categoryId,
        nickname: nickname,
        purchaseDate: purchaseDate,
        layout: layout,
        localImagePath: localImagePath,
      );
      
      // Add to current state
      final updatedBalls = [...state.balls, instance];
      state = state.copyWith(balls: updatedBalls, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to add custom ball: $e',
      );
    }
  }

  /// Update ball instance
  Future<void> updateBallInstance(ArsenalBallInstance instance) async {
    try {
      await _repository.updateBallInstance(instance);
      
      // Update in current state
      final updatedBalls = state.balls.map((ball) {
        return ball.instanceId == instance.instanceId ? instance : ball;
      }).toList();
      
      state = state.copyWith(balls: updatedBalls);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update ball: $e');
    }
  }

  /// Remove ball instance
  Future<void> removeBallInstance(String instanceId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.removeBallInstance(instanceId);
      
      // Remove from current state
      final updatedBalls = state.balls.where((ball) => ball.instanceId != instanceId).toList();
      state = state.copyWith(balls: updatedBalls, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to remove ball: $e',
      );
    }
  }

  /// Move ball to different category
  Future<void> moveBallToCategory(String instanceId, String newCategoryId) async {
    try {
      await _repository.moveBallToCategory(instanceId, newCategoryId);
      
      // Update in current state
      final updatedBalls = state.balls.map((ball) {
        return ball.instanceId == instanceId 
            ? ball.copyWith(bagCategoryId: newCategoryId)
            : ball;
      }).toList();
      
      state = state.copyWith(balls: updatedBalls);
    } catch (e) {
      state = state.copyWith(error: 'Failed to move ball: $e');
    }
  }

  /// Search balls
  Future<List<ArsenalBallInstance>> searchBalls(String userId, String query) async {
    try {
      return await _repository.searchBalls(userId, query);
    } catch (e) {
      state = state.copyWith(error: 'Failed to search balls: $e');
      return [];
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider to get filtered balls for current category
@riverpod
List<ArsenalBallInstance> filteredArsenalBalls(FilteredArsenalBallsRef ref) {
  final arsenalState = ref.watch(arsenalControllerProvider);
  return arsenalState.filteredBalls;
}

/// Provider to get total ball count
@riverpod
int totalBallCount(TotalBallCountRef ref) {
  final arsenalState = ref.watch(arsenalControllerProvider);
  return arsenalState.balls.length;
}

/// Provider to get ball count for specific category
@riverpod
int categoryBallCount(CategoryBallCountRef ref, String categoryId) {
  final arsenalState = ref.watch(arsenalControllerProvider);
  return arsenalState.balls.where((ball) => ball.bagCategoryId == categoryId).length;
}