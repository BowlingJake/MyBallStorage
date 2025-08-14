import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bowlingarsenal_app/features/arsenal/logic/new_arsenal_controller.dart';
import 'package:bowlingarsenal_app/features/ball_library/logic/ball_library_controller.dart';
import 'package:bowlingarsenal_app/features/user/logic/user_profile_controller.dart';
import 'package:bowlingarsenal_app/shared/providers/cache_providers.dart';

/// 背景預載入服務 - 在用戶未主動要求時預先載入數據
/// 
/// 策略：
/// 1. 在應用啟動後 3 秒開始預載入
/// 2. 在首頁停留超過 5 秒時開始預載入
/// 3. 優先載入 Arsenal 數據（使用頻率高）
/// 4. 然後載入 Ball Library 基本數據
/// 5. 最後載入 Ball Library 完整數據
class PreloadService {
  static const int _initialDelayMs = 3000; // 應用啟動後 3 秒
  static const int _homePageDelayMs = 5000; // 首頁停留 5 秒
  
  final Ref _ref;
  bool _isPreloading = false;
  bool _arsenalPreloaded = false;
  bool _ballLibraryBasicPreloaded = false;
  bool _ballLibraryFullPreloaded = false;
  
  PreloadService(this._ref);
  
  /// 應用啟動時的預載入
  Future<void> startInitialPreload(String userId) async {
    if (_isPreloading) return;
    
    log('PreloadService: Starting initial preload after ${_initialDelayMs}ms delay');
    
    // 延遲後開始預載入
    await Future.delayed(Duration(milliseconds: _initialDelayMs));
    
    await _preloadArsenal(userId);
    await _preloadBallLibraryBasic();
  }
  
  /// 首頁停留時的預載入
  Future<void> startHomePagePreload(String userId) async {
    if (_isPreloading) return;
    
    log('PreloadService: Starting home page preload after ${_homePageDelayMs}ms delay');
    
    // 延遲後開始預載入
    await Future.delayed(Duration(milliseconds: _homePageDelayMs));
    
    // 如果還沒預載入過 Arsenal，先載入
    if (!_arsenalPreloaded) {
      await _preloadArsenal(userId);
    }
    
    // 如果還沒預載入過 Ball Library 基本數據，載入
    if (!_ballLibraryBasicPreloaded) {
      await _preloadBallLibraryBasic();
    }
    
    // 最後載入完整的 Ball Library 數據
    if (!_ballLibraryFullPreloaded) {
      await _preloadBallLibraryFull();
    }
  }
  
  /// 預載入 Arsenal 數據
  Future<void> _preloadArsenal(String userId) async {
    if (_arsenalPreloaded) return;
    
    try {
      _isPreloading = true;
      log('PreloadService: Preloading Arsenal data for user: $userId');
      
      // 檢查是否已有快取
      final cacheService = _ref.read(localCacheServiceProvider);
      await cacheService.initialize();
      
      final cachedData = await cacheService.getCachedArsenalData(userId);
      if (cachedData != null) {
        log('PreloadService: Arsenal data already cached, skipping');
        _arsenalPreloaded = true;
        return;
      }
      
      // 觸發 Arsenal Controller 初始化 (這會自動快取數據)
      final arsenalController = _ref.read(newArsenalControllerProvider.notifier);
      await arsenalController.initialize(userId);
      
      _arsenalPreloaded = true;
      log('PreloadService: Arsenal preload completed');
    } catch (e) {
      log('PreloadService: Arsenal preload failed: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  /// 預載入 Ball Library 基本數據
  Future<void> _preloadBallLibraryBasic() async {
    if (_ballLibraryBasicPreloaded) return;
    
    try {
      _isPreloading = true;
      log('PreloadService: Preloading Ball Library basic data');
      
      // 檢查是否已有快取
      final cacheService = _ref.read(localCacheServiceProvider);
      await cacheService.initialize();
      
      final cachedData = await cacheService.getCachedBallLibraryBasicData();
      if (cachedData != null && cachedData.isNotEmpty) {
        log('PreloadService: Ball Library basic data already cached, skipping');
        _ballLibraryBasicPreloaded = true;
        return;
      }
      
      // 觸發 Ball Library Controller 初始化 (這會自動快取基本數據)
      _ref.read(ballLibraryControllerProvider);
      
      _ballLibraryBasicPreloaded = true;
      log('PreloadService: Ball Library basic preload completed');
    } catch (e) {
      log('PreloadService: Ball Library basic preload failed: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  /// 預載入 Ball Library 完整數據
  Future<void> _preloadBallLibraryFull() async {
    if (_ballLibraryFullPreloaded) return;
    
    try {
      _isPreloading = true;
      log('PreloadService: Preloading Ball Library full data');
      
      // 檢查是否已有完整快取
      final cacheService = _ref.read(localCacheServiceProvider);
      await cacheService.initialize();
      
      final cachedData = await cacheService.getCachedBallLibraryFullData();
      if (cachedData != null && cachedData.length > 50) {
        log('PreloadService: Ball Library full data already cached, skipping');
        _ballLibraryFullPreloaded = true;
        return;
      }
      
      // 等待 Ball Library Controller 完成背景載入
      // (Controller 會自動觸發背景載入完整數據)
      
      _ballLibraryFullPreloaded = true;
      log('PreloadService: Ball Library full preload initiated');
    } catch (e) {
      log('PreloadService: Ball Library full preload failed: $e');
    } finally {
      _isPreloading = false;
    }
  }
  
  /// 重置預載入狀態 (用戶登出時)
  void reset() {
    _isPreloading = false;
    _arsenalPreloaded = false;
    _ballLibraryBasicPreloaded = false;
    _ballLibraryFullPreloaded = false;
    log('PreloadService: Reset completed');
  }
  
  /// 取得預載入狀態
  Map<String, bool> getPreloadStatus() {
    return {
      'isPreloading': _isPreloading,
      'arsenalPreloaded': _arsenalPreloaded,
      'ballLibraryBasicPreloaded': _ballLibraryBasicPreloaded,
      'ballLibraryFullPreloaded': _ballLibraryFullPreloaded,
    };
  }
}