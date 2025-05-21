import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Custom cache manager for the app's images
class AppImageCacheManager {
  static const String key = 'elegantCuisineImageCache';
  
  static final AppImageCacheManager _instance = AppImageCacheManager._internal();
  
  factory AppImageCacheManager() {
    return _instance;
  }
  
  AppImageCacheManager._internal();
  
  final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Cache images for 7 days
      maxNrOfCacheObjects: 200, // Max number of objects to keep in cache
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
  
  /// Get a cached network image with standard placeholder and error handling
  static Widget getCachedNetworkImage({
    required String imageUrl,
    BoxFit fit = BoxFit.cover,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      cacheManager: AppImageCacheManager().instance,
      placeholder: (context, url) => placeholder ?? const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => errorWidget ?? const Center(
        child: Icon(Icons.error),
      ),
    );
  }
  
  /// Clear all cached images
  Future<void> clearCache() async {
    await instance.emptyCache();
  }
}
