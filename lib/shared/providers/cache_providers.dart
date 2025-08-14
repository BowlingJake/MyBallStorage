import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bowlingarsenal_app/shared/services/local_cache_service.dart';
import 'package:bowlingarsenal_app/shared/services/preload_service.dart';

part 'cache_providers.g.dart';

/// 本地快取服務 Provider - 使用單例模式
@riverpod
LocalCacheService localCacheService(LocalCacheServiceRef ref) {
  final service = LocalCacheService.instance;
  
  // 異步初始化快取服務 (單例確保只初始化一次)
  ref.onDispose(() {
    // 清理過期快取
    service.clearExpiredCache();
  });
  
  return service;
}

/// 初始化快取服務的 Provider
@riverpod
Future<void> initializeCache(InitializeCacheRef ref) async {
  final cacheService = ref.read(localCacheServiceProvider);
  await cacheService.initialize();
}

/// 預載入服務 Provider
@riverpod
PreloadService preloadService(PreloadServiceRef ref) {
  final service = PreloadService(ref);
  
  ref.onDispose(() {
    service.reset();
  });
  
  return service;
}