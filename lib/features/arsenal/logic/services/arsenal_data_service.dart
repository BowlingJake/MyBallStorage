import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/repositories/user_arsenal_repository.dart';

/// Arsenal 資料管理服務
/// 負責處理所有與後端資料操作相關的業務邏輯
class ArsenalDataService {
  final UserArsenalRepository _repository;

  ArsenalDataService(this._repository);

  /// 初始化用戶的 Arsenal 資料
  Future<ArsenalDataResult> initialize(String userId) async {
    try {
      // 同時載入球具實例和類別
      final results = await Future.wait([
        _repository.getUserArsenal(userId),
        _repository.getUserCategories(userId),
      ]);

      final instances = results[0] as List<UserArsenalInstance>;
      final categories = results[1] as List<String>;

      return ArsenalDataResult.success(
        instances: instances,
        categories: categories,
      );
    } catch (e) {
      return ArsenalDataResult.error('Failed to initialize arsenal: $e');
    }
  }

  /// 載入所有用戶球具實例
  Future<List<UserArsenalInstance>> loadAllInstances(String userId) async {
    try {
      return await _repository.getUserArsenal(userId);
    } catch (e) {
      throw Exception('Failed to load instances: $e');
    }
  }

  /// 載入用戶類別
  Future<List<String>> loadUserCategories(String userId) async {
    try {
      return await _repository.getUserCategories(userId);
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// 從球具庫添加球具到 Arsenal
  Future<UserArsenalInstance> addBallFromLibrary({
    required String userId,
    required int ballId,
    required String categoryName,
    String? notes,
  }) async {
    try {
      return await _repository.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryName: categoryName,
        notes: notes,
      );
    } catch (e) {
      throw Exception('Failed to add ball: $e');
    }
  }

  /// 從球具庫添加球具到多個袋子
  Future<UserArsenalInstance> addBallFromLibraryToMultipleBags({
    required String userId,
    required int ballId,
    required String categoryName,
    required List<int> bagNumbers,
    String? notes,
  }) async {
    try {
      // 首先添加球具到 Arsenal (預設會加到袋子1)
      final instance = await _repository.addBallFromLibrary(
        userId: userId,
        ballId: ballId,
        categoryName: categoryName,
        notes: notes,
      );

      // 將球具添加到其他指定的袋子 (排除袋子1)
      final additionalBags = bagNumbers.where((bagNum) => bagNum != 1).toList();
      for (final bagNumber in additionalBags) {
        await _repository.updateBagAssignment(
          instanceId: instance.id,
          bagNumber: bagNumber,
          isInBag: true,
        );
      }

      return instance;
    } catch (e) {
      throw Exception('Failed to add ball to multiple bags: $e');
    }
  }

  /// 移除球具實例
  Future<void> removeInstance(int instanceId) async {
    try {
      await _repository.removeArsenalInstance(instanceId);
    } catch (e) {
      throw Exception('Failed to remove instance: $e');
    }
  }

  /// 更新球具使用次數
  Future<void> updateGamesUsed(int instanceId, int gamesUsed) async {
    try {
      await _repository.updateGamesUsed(instanceId, gamesUsed);
    } catch (e) {
      throw Exception('Failed to update games used: $e');
    }
  }

  /// 更新球具佈局資訊
  Future<void> updateLayout({
    required int instanceId,
    required String layoutType,
    required double value1,
    required double value2,
    required double value3,
    String? notes,
  }) async {
    try {
      await _repository.updateLayout(
        instanceId: instanceId,
        layoutType: layoutType,
        value1: value1,
        value2: value2,
        value3: value3,
        notes: notes,
      );
    } catch (e) {
      throw Exception('Failed to update layout: $e');
    }
  }

  /// 更新球具備註
  Future<void> updateNotes(int instanceId, String note) async {
    try {
      await _repository.updateNotes(instanceId, note);
    } catch (e) {
      throw Exception('Failed to update notes: $e');
    }
  }

  /// 更新袋子分配
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
    } catch (e) {
      throw Exception('Failed to update bag assignment: $e');
    }
  }

  /// 批量移除球具實例
  Future<List<int>> removeMultipleInstances(List<int> instanceIds) async {
    final removedIds = <int>[];
    
    for (final instanceId in instanceIds) {
      try {
        await _repository.removeArsenalInstance(instanceId);
        removedIds.add(instanceId);
      } catch (e) {
        // 記錄錯誤但繼續處理其他球具
        print('Failed to remove instance $instanceId: $e');
      }
    }
    
    return removedIds;
  }

  /// 批量更新袋子分配
  Future<List<int>> updateMultipleBagAssignments({
    required List<int> instanceIds,
    required int bagNumber,
    required bool isInBag,
  }) async {
    final updatedIds = <int>[];
    
    for (final instanceId in instanceIds) {
      try {
        await _repository.updateBagAssignment(
          instanceId: instanceId,
          bagNumber: bagNumber,
          isInBag: isInBag,
        );
        updatedIds.add(instanceId);
      } catch (e) {
        // 記錄錯誤但繼續處理其他球具
        print('Failed to update bag assignment for instance $instanceId: $e');
      }
    }
    
    return updatedIds;
  }

  /// 重新整理所有資料
  Future<ArsenalDataResult> refresh(String userId) async {
    return await initialize(userId);
  }
}

/// Arsenal 資料操作結果
class ArsenalDataResult {
  final bool isSuccess;
  final List<UserArsenalInstance>? instances;
  final List<String>? categories;
  final String? error;

  const ArsenalDataResult._({
    required this.isSuccess,
    this.instances,
    this.categories,
    this.error,
  });

  factory ArsenalDataResult.success({
    required List<UserArsenalInstance> instances,
    required List<String> categories,
  }) {
    return ArsenalDataResult._(
      isSuccess: true,
      instances: instances,
      categories: categories,
    );
  }

  factory ArsenalDataResult.error(String error) {
    return ArsenalDataResult._(
      isSuccess: false,
      error: error,
    );
  }
}