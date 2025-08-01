import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/arsenal_repository.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_ball_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/bag_category.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/ball_layout.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/arsenal_analytics.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';
import 'dart:math';

class SupabaseArsenalRepository implements ArsenalRepository {
  final SupabaseClient _supabase;
  final Random _random = Random();

  SupabaseArsenalRepository(this._supabase);

  /// Generate a unique ID using timestamp and random number
  String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(999999);
    return '${timestamp}_$random';
  }

  // ================= Ball Instance Management =================

  @override
  Future<List<ArsenalBallInstance>> getUserArsenal(String userId) async {
    try {
      final response = await _supabase
          .from('arsenal_ball_instances')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .order('added_date', ascending: false);

      return response.map<ArsenalBallInstance>((json) {
        // Parse the joined bowling ball data
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        // Create the instance with the bowling ball data
        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data'); // Remove the joined data
        instanceData['bowling_ball_data'] = bowlingBall?.toJsonWithCustomFields();

        return ArsenalBallInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get user arsenal: $e');
    }
  }

  @override
  Future<List<ArsenalBallInstance>> getBallsByCategory(String userId, String categoryId) async {
    try {
      final response = await _supabase
          .from('arsenal_ball_instances')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .eq('bag_category_id', categoryId)
          .order('added_date', ascending: false);

      return response.map<ArsenalBallInstance>((json) {
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data');
        instanceData['bowling_ball_data'] = bowlingBall?.toJsonWithCustomFields();

        return ArsenalBallInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get balls by category: $e');
    }
  }

  @override
  Future<ArsenalBallInstance> addBallFromLibrary({
    required String userId,
    required String ballId,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
  }) async {
    try {
      // Get the next instance number for this ball
      final instanceCount = await getBallInstanceCount(userId, ballId);
      
      // Create layout if provided
      BallLayout? savedLayout;
      if (layout != null) {
        savedLayout = await saveLayout(layout.copyWith(
          layoutId: _generateId(),
          userId: userId,
        ));
      }

      final instance = ArsenalBallInstance(
        instanceId: _generateId(),
        ballId: ballId,
        userId: userId,
        nickname: nickname ?? '',
        addedDate: DateTime.now(),
        purchaseDate: purchaseDate,
        bagCategoryId: categoryId,
        layout: savedLayout,
        instanceNumber: instanceCount + 1,
        isCustomBall: false,
      );

      final response = await _supabase
          .from('arsenal_ball_instances')
          .insert(instance.toJson())
          .select()
          .single();

      // Fetch the complete instance with bowling ball data
      return _getCompleteInstance(response['instance_id']);
    } catch (e) {
      throw Exception('Failed to add ball from library: $e');
    }
  }

  @override
  Future<ArsenalBallInstance> addCustomBall({
    required String userId,
    required BowlingBall customBall,
    required String categoryId,
    String? nickname,
    DateTime? purchaseDate,
    BallLayout? layout,
    String? localImagePath,
  }) async {
    try {
      // First, insert the custom bowling ball if it doesn't exist
      String ballId;
      if (customBall.id == 0) {
        // Create new custom ball
        final customBallData = customBall.toJsonWithCustomFields();
        customBallData.remove('id'); // Let database generate ID
        
        final ballResponse = await _supabase
            .from('ball_data')
            .insert(customBallData)
            .select()
            .single();
        
        ballId = ballResponse['id'].toString();
      } else {
        ballId = customBall.id.toString();
      }

      // Create layout if provided
      BallLayout? savedLayout;
      if (layout != null) {
        savedLayout = await saveLayout(layout.copyWith(
          layoutId: _generateId(),
          userId: userId,
        ));
      }

      final instanceCount = await getBallInstanceCount(userId, ballId);

      final instance = ArsenalBallInstance(
        instanceId: _generateId(),
        ballId: ballId,
        userId: userId,
        nickname: nickname ?? '',
        addedDate: DateTime.now(),
        purchaseDate: purchaseDate,
        bagCategoryId: categoryId,
        layout: savedLayout,
        instanceNumber: instanceCount + 1,
        isCustomBall: true,
        localImagePath: localImagePath,
        bowlingBall: customBall,
      );

      await _supabase
          .from('arsenal_ball_instances')
          .insert(instance.toJson());

      return instance;
    } catch (e) {
      throw Exception('Failed to add custom ball: $e');
    }
  }

  @override
  Future<void> updateBallInstance(ArsenalBallInstance instance) async {
    try {
      await _supabase
          .from('arsenal_ball_instances')
          .update(instance.toJson())
          .eq('instance_id', instance.instanceId);
    } catch (e) {
      throw Exception('Failed to update ball instance: $e');
    }
  }

  @override
  Future<void> removeBallInstance(String instanceId) async {
    try {
      await _supabase
          .from('arsenal_ball_instances')
          .delete()
          .eq('instance_id', instanceId);
    } catch (e) {
      throw Exception('Failed to remove ball instance: $e');
    }
  }

  @override
  Future<void> moveBallToCategory(String instanceId, String newCategoryId) async {
    try {
      await _supabase
          .from('arsenal_ball_instances')
          .update({'bag_category_id': newCategoryId})
          .eq('instance_id', instanceId);
    } catch (e) {
      throw Exception('Failed to move ball to category: $e');
    }
  }

  @override
  Future<int> getBallInstanceCount(String userId, String ballId) async {
    try {
      final response = await _supabase
          .from('arsenal_ball_instances')
          .select('instance_id')
          .eq('user_id', userId)
          .eq('ball_id', ballId);

      return response.length;
    } catch (e) {
      throw Exception('Failed to get ball instance count: $e');
    }
  }

  // ================= Category Management =================

  @override
  Future<List<BagCategory>> getUserCategories(String userId) async {
    try {
      final response = await _supabase
          .from('bag_categories')
          .select()
          .eq('user_id', userId)
          .order('display_order', ascending: true);

      return response.map<BagCategory>((json) => BagCategory.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get user categories: $e');
    }
  }

  @override
  Future<BagCategory> createCategory(BagCategory category) async {
    try {
      final response = await _supabase
          .from('bag_categories')
          .insert(category.toJson())
          .select()
          .single();

      return BagCategory.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  @override
  Future<void> updateCategory(BagCategory category) async {
    try {
      await _supabase
          .from('bag_categories')
          .update(category.toJson())
          .eq('category_id', category.categoryId);
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId, String? reassignToCategoryId) async {
    try {
      // If reassignment category is provided, move all balls first
      if (reassignToCategoryId != null) {
        await _supabase
            .from('arsenal_ball_instances')
            .update({'bag_category_id': reassignToCategoryId})
            .eq('bag_category_id', categoryId);
      }

      // Delete the category
      await _supabase
          .from('bag_categories')
          .delete()
          .eq('category_id', categoryId);
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  @override
  Future<void> reorderCategories(String userId, List<String> categoryIds) async {
    try {
      // Update display order for each category
      for (int i = 0; i < categoryIds.length; i++) {
        await _supabase
            .from('bag_categories')
            .update({'display_order': i})
            .eq('category_id', categoryIds[i])
            .eq('user_id', userId);
      }
    } catch (e) {
      throw Exception('Failed to reorder categories: $e');
    }
  }

  @override
  Future<void> initializeDefaultCategories(String userId) async {
    try {
      final defaultCategories = DefaultBagCategories.createForUser(userId);
      
      // Insert all default categories
      final categoriesData = defaultCategories.map((cat) => cat.toJson()).toList();
      await _supabase.from('bag_categories').insert(categoriesData);
    } catch (e) {
      throw Exception('Failed to initialize default categories: $e');
    }
  }

  // ================= Layout Management =================

  @override
  Future<BallLayout> saveLayout(BallLayout layout) async {
    try {
      final response = await _supabase
          .from('ball_layouts')
          .upsert(layout.toJson())
          .select()
          .single();

      return BallLayout.fromJson(response);
    } catch (e) {
      throw Exception('Failed to save layout: $e');
    }
  }

  @override
  Future<BallLayout?> getLayout(String layoutId) async {
    try {
      final response = await _supabase
          .from('ball_layouts')
          .select()
          .eq('layout_id', layoutId)
          .maybeSingle();

      return response != null ? BallLayout.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get layout: $e');
    }
  }

  @override
  Future<void> deleteLayout(String layoutId) async {
    try {
      await _supabase
          .from('ball_layouts')
          .delete()
          .eq('layout_id', layoutId);
    } catch (e) {
      throw Exception('Failed to delete layout: $e');
    }
  }

  @override
  Future<List<BallLayout>> getUserLayouts(String userId) async {
    try {
      final response = await _supabase
          .from('ball_layouts')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map<BallLayout>((json) => BallLayout.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get user layouts: $e');
    }
  }

  // ================= Analytics =================

  @override
  Future<ArsenalAnalytics> getArsenalAnalytics(String userId) async {
    try {
      final instances = await getUserArsenal(userId);
      
      // Calculate analytics from instances
      final totalBalls = instances.length;
      final customBalls = instances.where((i) => i.isCustomBall).length;
      
      // Brand distribution
      final brandDistribution = <String, int>{};
      for (final instance in instances) {
        final brand = instance.brandName;
        brandDistribution[brand] = (brandDistribution[brand] ?? 0) + 1;
      }
      
      // Category distribution
      final categoryDistribution = <String, int>{};
      for (final instance in instances) {
        final categoryId = instance.bagCategoryId;
        categoryDistribution[categoryId] = (categoryDistribution[categoryId] ?? 0) + 1;
      }
      
      // Layout type distribution
      final layoutTypeDistribution = <String, int>{};
      for (final instance in instances) {
        if (instance.layout != null) {
          final layoutType = instance.layout!.layoutType.name;
          layoutTypeDistribution[layoutType] = (layoutTypeDistribution[layoutType] ?? 0) + 1;
        }
      }
      
      // RG/Diff distribution
      final dataPoints = instances
          .where((i) => i.bowlingBall?.rg != null && i.bowlingBall?.diff != null)
          .map((i) => BallDataPointExtension.fromArsenalBall(i))
          .toList();
      
      double avgRG = 0, avgDiff = 0, minRG = 0, maxRG = 0, minDiff = 0, maxDiff = 0;
      
      if (dataPoints.isNotEmpty) {
        final rgs = dataPoints.map((p) => p.rg).toList();
        final diffs = dataPoints.map((p) => p.diff).toList();
        
        avgRG = rgs.reduce((a, b) => a + b) / rgs.length;
        avgDiff = diffs.reduce((a, b) => a + b) / diffs.length;
        minRG = rgs.reduce((a, b) => a < b ? a : b);
        maxRG = rgs.reduce((a, b) => a > b ? a : b);
        minDiff = diffs.reduce((a, b) => a < b ? a : b);
        maxDiff = diffs.reduce((a, b) => a > b ? a : b);
      }
      
      final rgDiffDistribution = RGDiffDistribution(
        dataPoints: dataPoints,
        avgRG: avgRG,
        avgDiff: avgDiff,
        minRG: minRG,
        maxRG: maxRG,
        minDiff: minDiff,
        maxDiff: maxDiff,
      );
      
      return ArsenalAnalytics(
        userId: userId,
        totalBalls: totalBalls,
        customBalls: customBalls,
        brandDistribution: brandDistribution,
        categoryDistribution: categoryDistribution,
        layoutTypeDistribution: layoutTypeDistribution,
        rgDiffDistribution: rgDiffDistribution,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get arsenal analytics: $e');
    }
  }

  @override
  Future<void> refreshAnalytics(String userId) async {
    // Analytics are calculated in real-time, so this is a no-op
    // In a future implementation, we might cache analytics in the database
  }

  // ================= Search and Filtering =================

  @override
  Future<List<ArsenalBallInstance>> searchBalls(String userId, String query) async {
    try {
      final response = await _supabase
          .from('arsenal_ball_instances')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId)
          .or('nickname.ilike.%$query%,ball_data.ball_name.ilike.%$query%,ball_data.brand.ilike.%$query%');

      return response.map<ArsenalBallInstance>((json) {
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data');
        instanceData['bowling_ball_data'] = bowlingBall?.toJsonWithCustomFields();

        return ArsenalBallInstance.fromJson(instanceData);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search balls: $e');
    }
  }

  @override
  Future<List<ArsenalBallInstance>> filterBalls({
    required String userId,
    List<String>? categoryIds,
    List<String>? brands,
    List<LayoutType>? layoutTypes,
    double? minRG,
    double? maxRG,
    double? minDiff,
    double? maxDiff,
  }) async {
    try {
      var query = _supabase
          .from('arsenal_ball_instances')
          .select('''
            *,
            ball_data(*)
          ''')
          .eq('user_id', userId);

      if (categoryIds != null && categoryIds.isNotEmpty) {
        query = query.inFilter('bag_category_id', categoryIds);
      }

      // For more complex filtering (brands, RG, Diff), we'll need to fetch and filter in-memory
      // This is a limitation of Supabase joins - in a production app, you might want to denormalize
      final response = await query.order('added_date', ascending: false);

      var instances = response.map<ArsenalBallInstance>((json) {
        final bowlingBallData = json['ball_data'] as Map<String, dynamic>?;
        BowlingBall? bowlingBall;
        if (bowlingBallData != null) {
          bowlingBall = BowlingBall.fromJson(bowlingBallData);
        }

        final instanceData = Map<String, dynamic>.from(json);
        instanceData.remove('ball_data');
        instanceData['bowling_ball_data'] = bowlingBall?.toJsonWithCustomFields();

        return ArsenalBallInstance.fromJson(instanceData);
      }).toList();

      // Apply additional filters
      if (brands != null && brands.isNotEmpty) {
        instances = instances.where((i) => brands.contains(i.brandName)).toList();
      }

      if (layoutTypes != null && layoutTypes.isNotEmpty) {
        instances = instances.where((i) => 
          i.layout != null && layoutTypes.contains(i.layout!.layoutType)
        ).toList();
      }

      if (minRG != null) {
        instances = instances.where((i) => 
          i.bowlingBall?.rg != null && i.bowlingBall!.rg! >= minRG
        ).toList();
      }

      if (maxRG != null) {
        instances = instances.where((i) => 
          i.bowlingBall?.rg != null && i.bowlingBall!.rg! <= maxRG
        ).toList();
      }

      if (minDiff != null) {
        instances = instances.where((i) => 
          i.bowlingBall?.diff != null && i.bowlingBall!.diff! >= minDiff
        ).toList();
      }

      if (maxDiff != null) {
        instances = instances.where((i) => 
          i.bowlingBall?.diff != null && i.bowlingBall!.diff! <= maxDiff
        ).toList();
      }

      return instances;
    } catch (e) {
      throw Exception('Failed to filter balls: $e');
    }
  }

  // ================= Batch Operations =================

  @override
  Future<List<ArsenalBallInstance>> addMultipleBallsFromLibrary({
    required String userId,
    required List<String> ballIds,
    required String categoryId,
  }) async {
    try {
      final instances = <ArsenalBallInstance>[];
      
      for (final ballId in ballIds) {
        final instance = await addBallFromLibrary(
          userId: userId,
          ballId: ballId,
          categoryId: categoryId,
        );
        instances.add(instance);
      }
      
      return instances;
    } catch (e) {
      throw Exception('Failed to add multiple balls: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportArsenalData(String userId) async {
    try {
      final instances = await getUserArsenal(userId);
      final categories = await getUserCategories(userId);
      final layouts = await getUserLayouts(userId);
      
      return {
        'user_id': userId,
        'export_date': DateTime.now().toIso8601String(),
        'instances': instances.map((i) => i.toJson()).toList(),
        'categories': categories.map((c) => c.toJson()).toList(),
        'layouts': layouts.map((l) => l.toJson()).toList(),
      };
    } catch (e) {
      throw Exception('Failed to export arsenal data: $e');
    }
  }

  @override
  Future<void> importArsenalData(String userId, Map<String, dynamic> data) async {
    // Implementation would depend on specific import requirements
    // This is a complex operation that would need careful handling of conflicts
    throw UnimplementedError('Import functionality not yet implemented');
  }

  // ================= Helper Methods =================

  Future<ArsenalBallInstance> _getCompleteInstance(String instanceId) async {
    final response = await _supabase
        .from('arsenal_ball_instances')
        .select('''
          *,
          ball_data(*)
        ''')
        .eq('instance_id', instanceId)
        .single();

    final bowlingBallData = response['ball_data'] as Map<String, dynamic>?;
    BowlingBall? bowlingBall;
    if (bowlingBallData != null) {
      bowlingBall = BowlingBall.fromJson(bowlingBallData);
    }

    final instanceData = Map<String, dynamic>.from(response);
    instanceData.remove('ball_data');
    instanceData['bowling_ball_data'] = bowlingBall?.toJsonWithCustomFields();

    return ArsenalBallInstance.fromJson(instanceData);
  }
}