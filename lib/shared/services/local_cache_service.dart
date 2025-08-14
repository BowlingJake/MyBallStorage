import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bowlingarsenal_app/features/arsenal/data/models/user_arsenal_instance.dart';
import 'package:bowlingarsenal_app/shared/models/bowling_ball.dart';

/// 本地快取服務 - 使用單例模式確保全域唯一實例
/// 
/// 功能：
/// - Arsenal 數據快取 (30分鐘有效期)
/// - Ball Library 數據快取 (24小時有效期) 
/// - 分層載入支援 (基本資料 + 詳細資料)
/// - 背景預載入機制
class LocalCacheService {
  static LocalCacheService? _instance;
  static const String _keyPrefix = 'cache_';
  static const String _timestampSuffix = '_timestamp';
  
  // 快取鍵
  static const String _arsenalKey = '${_keyPrefix}arsenal';
  static const String _arsenalCategoriesKey = '${_keyPrefix}arsenal_categories';
  static const String _ballLibraryKey = '${_keyPrefix}ball_library';
  static const String _ballLibraryBasicKey = '${_keyPrefix}ball_library_basic';
  static const String _userProfileKey = '${_keyPrefix}user_profile';
  
  // 快取有效期 (毫秒)
  static const int _arsenalCacheExpiry = 30 * 60 * 1000; // 30分鐘
  static const int _ballLibraryCacheExpiry = 24 * 60 * 60 * 1000; // 24小時
  static const int _userProfileCacheExpiry = 60 * 60 * 1000; // 1小時
  
  SharedPreferences? _prefs;
  bool _initialized = false;
  
  // 私有建構函數
  LocalCacheService._();
  
  /// 單例實例獲取
  static LocalCacheService get instance {
    _instance ??= LocalCacheService._();
    return _instance!;
  }
  
  /// 初始化快取服務
  Future<void> initialize() async {
    if (_initialized && _prefs != null) {
      return; // 已初始化
    }
    
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      log('LocalCacheService: Initialized successfully');
    } catch (e) {
      log('LocalCacheService: Failed to initialize: $e');
      rethrow;
    }
  }
  
  void _ensureInitialized() {
    if (!_initialized || _prefs == null) {
      throw Exception('LocalCacheService not initialized. Call initialize() first.');
    }
  }
  
  /// 檢查快取是否有效
  bool _isCacheValid(String key, int expiryMs) {
    final timestampKey = '$key$_timestampSuffix';
    final timestamp = _prefs!.getInt(timestampKey);
    
    if (timestamp == null) return false;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - timestamp) < expiryMs;
  }
  
  /// 設定快取時間戳
  Future<void> _setCacheTimestamp(String key) async {
    final timestampKey = '$key$_timestampSuffix';
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _prefs!.setInt(timestampKey, timestamp);
  }
  
  /// 清除過期快取
  Future<void> clearExpiredCache() async {
    _ensureInitialized();
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    final now = DateTime.now().millisecondsSinceEpoch;
    
    for (final key in keys) {
      if (key.endsWith(_timestampSuffix)) continue;
      
      final timestampKey = '$key$_timestampSuffix';
      final timestamp = _prefs!.getInt(timestampKey);
      
      if (timestamp != null) {
        int expiry;
        if (key.contains('arsenal')) {
          expiry = _arsenalCacheExpiry;
        } else if (key.contains('ball_library')) {
          expiry = _ballLibraryCacheExpiry;
        } else {
          expiry = _userProfileCacheExpiry;
        }
        
        if ((now - timestamp) >= expiry) {
          await _prefs!.remove(key);
          await _prefs!.remove(timestampKey);
          log('LocalCacheService: Cleared expired cache: $key');
        }
      }
    }
  }
  
  // =============================================================================
  // Arsenal 快取方法
  // =============================================================================
  
  /// 快取 Arsenal 數據
  Future<void> cacheArsenalData({
    required String userId,
    required List<UserArsenalInstance> instances,
    required List<String> categories,
  }) async {
    _ensureInitialized();
    
    try {
      // 快取 Arsenal 實例
      final instancesJson = instances.map((instance) => instance.toJson()).toList();
      await _prefs!.setString('${_arsenalKey}_$userId', jsonEncode(instancesJson));
      await _setCacheTimestamp('${_arsenalKey}_$userId');
      
      // 快取類別
      await _prefs!.setString('${_arsenalCategoriesKey}_$userId', jsonEncode(categories));
      await _setCacheTimestamp('${_arsenalCategoriesKey}_$userId');
      
      log('LocalCacheService: Arsenal data cached for user: $userId (${instances.length} instances, ${categories.length} categories)');
    } catch (e) {
      log('LocalCacheService: Failed to cache Arsenal data: $e');
    }
  }
  
  /// 取得快取的 Arsenal 數據
  Future<({List<UserArsenalInstance> instances, List<String> categories})?> getCachedArsenalData(String userId) async {
    _ensureInitialized();
    
    try {
      // 檢查快取是否有效
      if (!_isCacheValid('${_arsenalKey}_$userId', _arsenalCacheExpiry) ||
          !_isCacheValid('${_arsenalCategoriesKey}_$userId', _arsenalCacheExpiry)) {
        return null;
      }
      
      // 取得 Arsenal 實例
      final instancesString = _prefs!.getString('${_arsenalKey}_$userId');
      final categoriesString = _prefs!.getString('${_arsenalCategoriesKey}_$userId');
      
      if (instancesString == null || categoriesString == null) {
        return null;
      }
      
      final instancesJson = jsonDecode(instancesString) as List;
      final instances = instancesJson
          .map((json) => UserArsenalInstance.fromJson(json as Map<String, dynamic>))
          .toList();
      
      final categories = (jsonDecode(categoriesString) as List)
          .map((item) => item.toString())
          .toList();
      
      log('LocalCacheService: Arsenal data loaded from cache for user: $userId (${instances.length} instances, ${categories.length} categories)');
      return (instances: instances, categories: categories);
    } catch (e) {
      log('LocalCacheService: Failed to load cached Arsenal data: $e');
      return null;
    }
  }
  
  // =============================================================================
  // Ball Library 快取方法 - 改進版本
  // =============================================================================
  
  /// 快取 Ball Library 基本數據 (分層載入第一層)
  Future<void> cacheBallLibraryBasicData(List<BowlingBall> balls) async {
    _ensureInitialized();
    
    try {
      // 使用 BowlingBall 的完整序列化，確保所有資料都被保存
      final basicBalls = balls.take(50).map((ball) => _ballToJson(ball)).toList();
      
      await _prefs!.setString(_ballLibraryBasicKey, jsonEncode(basicBalls));
      await _setCacheTimestamp(_ballLibraryBasicKey);
      
      log('LocalCacheService: Ball Library basic data cached (${basicBalls.length} balls)');
    } catch (e) {
      log('LocalCacheService: Failed to cache Ball Library basic data: $e');
    }
  }
  
  /// 快取完整 Ball Library 數據
  Future<void> cacheBallLibraryFullData(List<BowlingBall> balls) async {
    _ensureInitialized();
    
    try {
      // 使用完整的球資料序列化
      final ballsJson = balls.map((ball) => _ballToJson(ball)).toList();
      
      await _prefs!.setString(_ballLibraryKey, jsonEncode(ballsJson));
      await _setCacheTimestamp(_ballLibraryKey);
      
      log('LocalCacheService: Ball Library full data cached (${balls.length} balls)');
    } catch (e) {
      log('LocalCacheService: Failed to cache Ball Library full data: $e');
    }
  }
  
  /// BowlingBall 到 JSON 的完整轉換 - 使用已存在的 toJsonWithCustomFields 方法
  Map<String, dynamic> _ballToJson(BowlingBall ball) {
    return ball.toJsonWithCustomFields();
  }
  
  /// 取得快取的 Ball Library 基本數據
  Future<List<BowlingBall>?> getCachedBallLibraryBasicData() async {
    _ensureInitialized();
    
    try {
      if (!_isCacheValid(_ballLibraryBasicKey, _ballLibraryCacheExpiry)) {
        return null;
      }
      
      final ballsString = _prefs!.getString(_ballLibraryBasicKey);
      if (ballsString == null) return null;
      
      final ballsJson = jsonDecode(ballsString) as List;
      final balls = ballsJson.map((json) => BowlingBall.fromJson(json as Map<String, dynamic>)).toList();
      
      log('LocalCacheService: Ball Library basic data loaded from cache (${balls.length} balls)');
      return balls;
    } catch (e) {
      log('LocalCacheService: Failed to load cached Ball Library basic data: $e');
      return null;
    }
  }
  
  /// 取得快取的完整 Ball Library 數據
  Future<List<BowlingBall>?> getCachedBallLibraryFullData() async {
    _ensureInitialized();
    
    try {
      if (!_isCacheValid(_ballLibraryKey, _ballLibraryCacheExpiry)) {
        return null;
      }
      
      final ballsString = _prefs!.getString(_ballLibraryKey);
      if (ballsString == null) return null;
      
      final ballsJson = jsonDecode(ballsString) as List;
      final balls = ballsJson.map((json) => BowlingBall.fromJson(json as Map<String, dynamic>)).toList();
      
      log('LocalCacheService: Ball Library full data loaded from cache (${balls.length} balls)');
      return balls;
    } catch (e) {
      log('LocalCacheService: Failed to load cached Ball Library full data: $e');
      return null;
    }
  }
  
  // =============================================================================
  // 用戶檔案快取方法
  // =============================================================================
  
  /// 快取用戶檔案數據
  Future<void> cacheUserProfile(String userId, Map<String, dynamic> profileData) async {
    _ensureInitialized();
    
    try {
      await _prefs!.setString('${_userProfileKey}_$userId', jsonEncode(profileData));
      await _setCacheTimestamp('${_userProfileKey}_$userId');
      
      log('LocalCacheService: User profile cached for user: $userId');
    } catch (e) {
      log('LocalCacheService: Failed to cache user profile: $e');
    }
  }
  
  /// 取得快取的用戶檔案數據
  Future<Map<String, dynamic>?> getCachedUserProfile(String userId) async {
    _ensureInitialized();
    
    try {
      if (!_isCacheValid('${_userProfileKey}_$userId', _userProfileCacheExpiry)) {
        return null;
      }
      
      final profileString = _prefs!.getString('${_userProfileKey}_$userId');
      if (profileString == null) return null;
      
      final profileData = jsonDecode(profileString) as Map<String, dynamic>;
      
      log('LocalCacheService: User profile loaded from cache for user: $userId');
      return profileData;
    } catch (e) {
      log('LocalCacheService: Failed to load cached user profile: $e');
      return null;
    }
  }
  
  // =============================================================================
  // 快取管理方法
  // =============================================================================
  
  /// 清除特定用戶的所有快取
  Future<void> clearUserCache(String userId) async {
    _ensureInitialized();
    
    final keysToRemove = [
      '${_arsenalKey}_$userId',
      '${_arsenalCategoriesKey}_$userId',
      '${_userProfileKey}_$userId',
      '${_arsenalKey}_${userId}$_timestampSuffix',
      '${_arsenalCategoriesKey}_${userId}$_timestampSuffix',
      '${_userProfileKey}_${userId}$_timestampSuffix',
    ];
    
    for (final key in keysToRemove) {
      await _prefs!.remove(key);
    }
    
    log('LocalCacheService: Cleared all cache for user: $userId');
  }
  
  /// 清除所有快取
  Future<void> clearAllCache() async {
    _ensureInitialized();
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await _prefs!.remove(key);
    }
    
    log('LocalCacheService: Cleared all cache');
  }
  
  /// 強制清除 Ball Library 快取 (用於調試)
  Future<void> clearBallLibraryCache() async {
    _ensureInitialized();
    
    final keys = [
      _ballLibraryKey,
      _ballLibraryBasicKey,
      '${_ballLibraryKey}$_timestampSuffix',
      '${_ballLibraryBasicKey}$_timestampSuffix',
    ];
    
    for (final key in keys) {
      await _prefs!.remove(key);
    }
    
    log('LocalCacheService: Cleared Ball Library cache for debugging');
  }
  
  /// 取得快取統計資訊
  Future<Map<String, dynamic>> getCacheStats() async {
    _ensureInitialized();
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    final stats = <String, dynamic>{
      'totalCacheEntries': keys.length,
      'cacheKeys': keys.toList(),
      'initialized': _initialized,
    };
    
    return stats;
  }
}