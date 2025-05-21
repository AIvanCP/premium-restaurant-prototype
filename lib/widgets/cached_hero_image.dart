import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/theme.dart';

/// A reusable widget for hero sections with cached network images
class CachedHeroImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final Widget child;
  final IconData fallbackIcon;

  const CachedHeroImage({
    Key? key,
    required this.imageUrl,
    this.height = 0.5, // Percentage of screen height
    required this.child,
    this.fallbackIcon = Icons.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.primaryColor,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.accentColor),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.primaryColor,
              child: Icon(fallbackIcon, color: AppTheme.accentColor, size: 50),
            ),
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
          child,
        ],
      ),
    );
  }
}
