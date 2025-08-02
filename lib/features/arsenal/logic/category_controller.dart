import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/arsenal_controller.dart';

part 'category_controller.g.dart';

/// State for category management
class CategoryState {
  final List<BagCategory> categories;
  final bool isLoading;
  final String? error;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoryState copyWith({
    List<BagCategory>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Category management controller
@riverpod
class CategoryController extends _$CategoryController {
  @override
  CategoryState build() {
    return const CategoryState();
  }

  ArsenalRepository get _repository => ref.read(arsenalRepositoryProvider);

  /// Load categories for user
  Future<void> loadCategories(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final categories = await _repository.getUserCategories(userId);
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load categories: $e',
      );
    }
  }


  /// Create new category
  Future<BagCategory?> createCategory({
    required String userId,
    required String name,
    required IconData icon,
    required Color themeColor,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Generate ID and get next display order
      final categoryId = '${name.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}';
      final displayOrder = state.categories.length;
      
      final category = BagCategory(
        categoryId: categoryId,
        name: name,
        userId: userId,
        iconCodePoint: icon.codePoint,
        iconFontFamily: icon.fontFamily ?? 'Iconsax',
        iconFontPackage: icon.fontPackage ?? 'iconsax',
        themeColor: themeColor,
        displayOrder: displayOrder,
        isDefault: false,
        createdAt: DateTime.now(),
        description: description,
      );
      
      final createdCategory = await _repository.createCategory(category);
      
      // Add to current state
      final updatedCategories = [...state.categories, createdCategory];
      state = state.copyWith(categories: updatedCategories, isLoading: false);
      
      // Update arsenal controller
      ref.invalidate(arsenalControllerProvider);
      
      return createdCategory;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create category: $e',
      );
      return null;
    }
  }

  /// Update existing category
  Future<void> updateCategory(BagCategory category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.updateCategory(category);
      
      // Update in current state
      final updatedCategories = state.categories.map((cat) {
        return cat.categoryId == category.categoryId ? category : cat;
      }).toList();
      
      state = state.copyWith(categories: updatedCategories, isLoading: false);
      
      // Update arsenal controller
      ref.invalidate(arsenalControllerProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to update category: $e',
      );
    }
  }

  /// Delete category
  Future<void> deleteCategory(String categoryId, String? reassignToCategoryId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Check if it's a default category
      final category = state.categories.where((cat) => cat.categoryId == categoryId).firstOrNull;
      if (category?.isDefault == true) {
        throw Exception('Cannot delete default category');
      }
      
      await _repository.deleteCategory(categoryId, reassignToCategoryId);
      
      // Remove from current state
      final updatedCategories = state.categories.where((cat) => cat.categoryId != categoryId).toList();
      state = state.copyWith(categories: updatedCategories, isLoading: false);
      
      // Update arsenal controller
      ref.invalidate(arsenalControllerProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete category: $e',
      );
    }
  }

  /// Reorder categories
  Future<void> reorderCategories(String userId, List<String> categoryIds) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.reorderCategories(userId, categoryIds);
      
      // Update display order in current state
      final updatedCategories = <BagCategory>[];
      for (int i = 0; i < categoryIds.length; i++) {
        final categoryId = categoryIds[i];
        final category = state.categories.where((cat) => cat.categoryId == categoryId).firstOrNull;
        if (category != null) {
          updatedCategories.add(category.copyWith(displayOrder: i));
        }
      }
      
      state = state.copyWith(categories: updatedCategories, isLoading: false);
      
      // Update arsenal controller
      ref.invalidate(arsenalControllerProvider);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to reorder categories: $e',
      );
    }
  }

  /// Get category by ID
  BagCategory? getCategoryById(String categoryId) {
    return state.categories.where((cat) => cat.categoryId == categoryId).firstOrNull;
  }

  /// Get default categories
  List<BagCategory> get defaultCategories {
    return state.categories.where((cat) => cat.isDefault).toList();
  }

  /// Get custom categories
  List<BagCategory> get customCategories {
    return state.categories.where((cat) => !cat.isDefault).toList();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider to get categories sorted by display order
@riverpod
List<BagCategory> sortedCategories(SortedCategoriesRef ref) {
  final categoryState = ref.watch(categoryControllerProvider);
  final categories = [...categoryState.categories];
  categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  return categories;
}

/// Provider to get specific category by ID
@riverpod
BagCategory? categoryById(CategoryByIdRef ref, String categoryId) {
  final categoryState = ref.watch(categoryControllerProvider);
  return categoryState.categories.where((cat) => cat.categoryId == categoryId).firstOrNull;
}