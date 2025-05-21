import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_data.dart';
import '../utils/theme.dart';
import '../widgets/footer_widget.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildGallerySection(context, isMobile),
          const FooterWidget(),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1559339352-11d035aa65de?ixlib=rb-4.0.3',
            fit: BoxFit.cover,
            placeholder:
                (context, url) => Container(
                  color: AppTheme.primaryColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.accentColor,
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: AppTheme.primaryColor,
                  child: const Icon(
                    Icons.photo_library,
                    color: AppTheme.accentColor,
                    size: 50,
                  ),
                ),
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OUR GALLERY',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'A GLIMPSE INTO LUXURY',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildGallerySection(BuildContext context, bool isMobile) {
    final galleryItems = GalleryItem.getGalleryItems();
    final screenWidth = MediaQuery.of(context).size.width;
    final isHighResDesktop = screenWidth >= 1900;
    
    // Adjust padding dynamically to prevent minor overflow
    final verticalPadding = screenWidth < 400 ? 50.0 : 70.0;
    final horizontalPadding = screenWidth < 300 ? 10.0 : (isMobile ? 16.0 : 50.0);
    
    // Enhanced bottom padding - add 3px extra to fix the 2.5px overflow
    final bottomPadding = isHighResDesktop ? 83.0 : (verticalPadding + 3.0);
    
    // Calculate improved grid aspect ratio for desktop with special handling for high-res
    final desktopAspectRatio = isHighResDesktop
        ? 1.16  // Slight adjustment for 1920x1080 screens
        : (screenWidth > 1500 
            ? 1.06 
            : (screenWidth > 1200 
                ? 0.93 
                : 0.88));
    
    return Container(
      padding: EdgeInsets.only(
        top: verticalPadding,
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: bottomPadding,  // Extra padding at the bottom to fix overflow
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'EXPLORE OUR SPACES',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppTheme.accentColor,
              letterSpacing: 2,
              fontSize: screenWidth < 350 ? 20 : null,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(width: 60, height: 3, color: AppTheme.accentColor),
          const SizedBox(height: 40),
          SizedBox(
            width: isMobile ? double.infinity : 800,
            child: Text(
              'Step into the world of Elegant Cuisine through these glimpses of our exquisite dining spaces. Each location is meticulously designed to provide an atmosphere of refined luxury and comfort.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenWidth < 400 ? 40 : 60),
          // Improved gallery display for both mobile and desktop
          SizedBox(
            width: double.infinity,
            child: isMobile
                ? Column(
                    children: galleryItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: _buildGalleryCard(context, item),
                      );
                    }).toList(),
                  )                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 1500 ? 4 : 3,
                      // More precisely tuned aspect ratio for desktop to prevent overflow
                      childAspectRatio: desktopAspectRatio,
                      crossAxisSpacing: 22,  // Slightly reduced spacing
                      mainAxisSpacing: isHighResDesktop ? 18 : 22, // Further reduced spacing
                    ),
                    itemCount: galleryItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildGalleryCard(context, galleryItems[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }  Widget _buildGalleryCard(BuildContext context, GalleryItem item) {
    // Get screen dimensions to optimize card size
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 768;
    final bool isHighResDesktop = screenWidth >= 1900;
    
    // More precise card height calculation with special handling for high-res desktop
    // Reducing card height by 2-3px to fix sub-pixel overflow issues
    final cardHeight = isHighResDesktop ? 286.0 : 
                      (screenWidth > 1600 ? 280.0 : 
                      (screenWidth > 1200 ? 290.0 : 
                      (screenWidth > 800 ? 300.0 : 320.0)));
                      
    // Responsive image height with slightly adjusted ratios for desktop
    final imageHeight = isHighResDesktop
        ? cardHeight * 0.585  // Slightly higher image ratio for high-res desktop
        : (isMobile 
            ? cardHeight * 0.55
            : cardHeight * 0.56); // Slightly higher ratio for desktop
        
    // Responsive content height with adjusted ratio for desktop
    final contentHeight = isHighResDesktop
        ? cardHeight * 0.415  // Slightly lower content ratio for high-res desktop
        : (isMobile
            ? cardHeight * 0.45
            : cardHeight * 0.44); // Slightly lower ratio for desktop
    
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 1), // Add tiny bottom margin to prevent sub-pixel issues
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: cardHeight, // Dynamic height based on screen size
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic height image container
            SizedBox(
              height: imageHeight,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppTheme.primaryColor,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppTheme.accentColor),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.primaryColor,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color: AppTheme.accentColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
            // Dynamic content area with background color
            Container(
              height: contentHeight, // Dynamic height
              padding: EdgeInsets.all(isHighResDesktop ? 9.0 : (screenWidth > 1600 ? 11.0 : 15.0)),
              color: AppTheme.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth > 1600 ? 18 : null,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isHighResDesktop ? 5 : 7), // Reduced spacing
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppTheme.accentColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isHighResDesktop ? 5 : 7), // Reduced spacing
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
