import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Singleton cache manager for the app
class AppCacheManager {
  static const key = 'elegantCuisineCache';
  static const Duration stalePeriod = Duration(days: 14); // Images are stale after 14 days
  
  static final AppCacheManager _instance = AppCacheManager._internal();
  
  factory AppCacheManager() {
    return _instance;
  }
  
  AppCacheManager._internal();
  
  final cacheManager = CacheManager(
    Config(
      key,
      stalePeriod: stalePeriod,
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
  
  /// Clears the entire app cache
  Future<void> clearCache() async {
    await cacheManager.emptyCache();
  }
  
  /// Clears a specific file from the cache
  Future<void> removeFile(String url) async {
    await cacheManager.removeFile(url);
  }
}
