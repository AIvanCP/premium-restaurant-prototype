import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/app_cache_manager.dart';
import '../utils/theme.dart';

class CachedImageView extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? color;
  final BlendMode? colorBlendMode;
  final Widget? errorWidget;
  final Widget? placeholder;

  const CachedImageView({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.color,
    this.colorBlendMode,
    this.errorWidget,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      cacheManager: AppCacheManager().cacheManager,
      placeholder: (context, url) => placeholder ?? Container(
        color: AppTheme.primaryColor,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.accentColor),
        ),
      ),
      errorWidget: (context, url, error) => errorWidget ?? Container(
        color: AppTheme.primaryColor,
        child: const Icon(Icons.image_not_supported, color: AppTheme.accentColor, size: 40),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }
}
