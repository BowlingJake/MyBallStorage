import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_analytics.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// Abstract Arsenal Repository interface
/// Defines all operations related to Arsenal data management
abstract class ArsenalRepository {
  // ================= Ball Instance Management =================
  
  /// Get all ball instances for a user
  Future<List<ArsenalBallInstance>> getUserArsenal(String userId);
  
  /// Get ball instances by category
  Future<List<ArsenalBallInstance>> getBallsByCategory(String userId, String categoryId);
  
  /// Add a ball from library to arsenal
  Future<ArsenalBallInstance> addBallFromLibrary({
    required String userId,
    required String ballId,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
  });
  
  /// Add a custom ball to arsenal
  Future<ArsenalBallInstance> addCustomBall({
    required String userId,
    required BowlingBall customBall,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
    String? localImagePath,
  });
  
  /// Update ball instance information
  Future<void> updateBallInstance(ArsenalBallInstance instance);
  
  /// Remove ball instance from arsenal
  Future<void> removeBallInstance(String instanceId);
  
  /// Move ball instance to different category
  Future<void> moveBallToCategory(String instanceId, String newCategoryId);
  
  /// Get instance count for a specific ball
  Future<int> getBallInstanceCount(String userId, String ballId);
  
  // ================= Category Management =================
  
  /// Get all categories for a user
  Future<List<BagCategory>> getUserCategories(String userId);
  
  /// Create new category
  Future<BagCategory> createCategory(BagCategory category);
  
  /// Update category
  Future<void> updateCategory(BagCategory category);
  
  /// Delete category (and handle ball reassignment)
  Future<void> deleteCategory(String categoryId, String? reassignToCategoryId);
  
  /// Reorder categories
  Future<void> reorderCategories(String userId, List<String> categoryIds);
  
  /// Initialize default categories for new user
  Future<void> initializeDefaultCategories(String userId);
  
  // ================= Layout Management =================
  
  /// Create or update ball layout
  Future<BallLayout> saveLayout(BallLayout layout);
  
  /// Get layout by ID
  Future<BallLayout?> getLayout(String layoutId);
  
  /// Delete layout
  Future<void> deleteLayout(String layoutId);
  
  /// Get layouts by user
  Future<List<BallLayout>> getUserLayouts(String userId);
  
  // ================= Analytics =================
  
  /// Get arsenal analytics for user
  Future<ArsenalAnalytics> getArsenalAnalytics(String userId);
  
  /// Refresh analytics data
  Future<void> refreshAnalytics(String userId);
  
  // ================= Search and Filtering =================
  
  /// Search ball instances by name or brand
  Future<List<ArsenalBallInstance>> searchBalls(String userId, String query);
  
  /// Filter balls by criteria
  Future<List<ArsenalBallInstance>> filterBalls({
    required String userId,
    List<String>? categoryIds,
    List<String>? brands,
    List<LayoutType>? layoutTypes,
    double? minRG,
    double? maxRG,
    double? minDiff,
    double? maxDiff,
  });
  
  // ================= Batch Operations =================
  
  /// Add multiple balls from library at once
  Future<List<ArsenalBallInstance>> addMultipleBallsFromLibrary({
    required String userId,
    required List<String> ballIds,
    required String categoryId,
  });
  
  /// Export arsenal data
  Future<Map<String, dynamic>> exportArsenalData(String userId);
  
  /// Import arsenal data
  Future<void> importArsenalData(String userId, Map<String, dynamic> data);
}