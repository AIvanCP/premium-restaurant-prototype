import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_data.dart';
import '../utils/theme.dart';
import '../widgets/footer_widget.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroSection(context),
          _buildLocationsSection(context, isMobile),
          const FooterWidget(),
        ],
      ),
    );
  }
  Widget _buildHeroSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMicroScreen = screenWidth < 300;
    
    return Container(
      height: MediaQuery.of(context).size.height * (screenWidth < 400 ? 0.4 : 0.5),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: 'https://images.unsplash.com/photo-1466978913421-dad2ebd01d17?ixlib=rb-4.0.3',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.primaryColor,
              child: const Center(
                child: CircularProgressIndicator(color: AppTheme.accentColor),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.primaryColor,
              child: const Icon(Icons.location_on, color: AppTheme.accentColor, size: 50),
            ),
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OUR LOCATIONS',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppTheme.accentColor,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                        fontSize: isMicroScreen ? 24 : (screenWidth < 400 ? 32 : null),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'FIND US NEARBY',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: isMicroScreen ? 16 : (screenWidth < 400 ? 18 : null),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }  Widget _buildLocationsSection(BuildContext context, bool isMobile) {
    final locations = RestaurantLocation.getLocations();
    final screenWidth = MediaQuery.of(context).size.width;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final isDesktop = screenWidth >= 1200;
    final isHighResDesktop = screenWidth >= 1920;
    
    // Further reduced padding for Android to prevent platform-specific overflow
    final dynamicBottomPadding = isAndroid 
        ? (screenWidth < 400 ? 5.0 : 15.0) 
        : (screenWidth < 400 ? 10.0 : 30.0);
    
    // Add extra padding for desktop to prevent overflow
    final desktopBottomPadding = isHighResDesktop 
        ? 100.0  // Even more padding for 1920x1080 screens
        : (isDesktop ? 80.0 : dynamicBottomPadding);
    
    // Dynamically adjust top padding
    final topPadding = screenWidth < 400 ? 30.0 : 60.0;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding,
        left: screenWidth < 300 ? 10 : (isMobile ? 20 : 60),
        right: screenWidth < 300 ? 10 : (isMobile ? 20 : 60),
        bottom: desktopBottomPadding, // Use extra padding for desktop
      ),
      color: AppTheme.backgroundColor,
      child: Column(
        children: [
          Text(
            'VISIT US',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.accentColor,
                  letterSpacing: 2,
                  fontSize: screenWidth < 400 ? 24 : null,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 60,
            height: 3,
            color: AppTheme.accentColor,
          ),
          SizedBox(height: screenWidth < 400 ? 15 : 30), // Further reduced vertical spacing
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth,
            ),
            child: isMobile
              ? Column(
                  children: locations
                      .map((location) => _buildLocationCard(context, location, isMobile))
                      .toList(),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // Significantly improved aspect ratio for higher resolution screens
                    final desktopAspectRatio = constraints.maxWidth > 1900
                        ? 1.6   // Much higher aspect ratio for 1920x1080 screens
                        : (constraints.maxWidth > 1500
                            ? 1.5   // Higher aspect ratio for larger screens
                            : (constraints.maxWidth > 1200 
                                ? 1.45 
                                : 1.35));
                        
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constraints.maxWidth > 1700 ? 3 : 2,
                        mainAxisSpacing: 20, // Reduced spacing
                        crossAxisSpacing: 20, // Reduced spacing
                        // Adjust aspect ratio to make cards shorter on desktop
                        childAspectRatio: isAndroid 
                            ? (constraints.maxWidth > 1200 ? 1.4 : 1.3) 
                            : desktopAspectRatio,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return _buildLocationCard(context, locations[index], isMobile);
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, RestaurantLocation location, bool isMobile) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isVerySmallScreen = screenWidth < 400;
    final bool isMicroScreen = screenWidth < 300;
    final bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final bool isDesktop = screenWidth >= 1200;
    final bool isHighResDesktop = screenWidth >= 1900;
    
    // Check if the location has a map URL (clickable location)
    final bool hasMapUrl = location.mapUrl != null && location.isClickable;
    
    // Adjust card margin specifically for Android and high-res desktop
    final bottomMargin = isHighResDesktop 
        ? 6.0  // Even smaller margin for high-res desktop
        : (isAndroid 
            ? (isMobile ? 16.0 : 4.0) 
            : (isMobile ? 24.0 : 8.0));
    
    // Adjust image height for high-res desktop
    final imageHeight = isHighResDesktop
        ? 165.0  // Even smaller images on high-res desktop
        : (isDesktop 
            ? 170.0  // Slightly smaller images on desktop
            : (isAndroid 
                ? (isVerySmallScreen ? 160.0 : 170.0) 
                : 180.0));
    
    return Card(
      margin: EdgeInsets.only(bottom: bottomMargin),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            // Setting a maximum width to avoid overflow on mobile
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 500,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: imageHeight,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: location.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppTheme.primaryColor,
                            child: const Center(
                              child: CircularProgressIndicator(color: AppTheme.accentColor),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppTheme.primaryColor,
                            child: const Icon(Icons.location_on, color: AppTheme.accentColor, size: 50),
                          ),
                        ),
                      ),
                      // Map button overlay for clickable locations
                      if (hasMapUrl)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(30),
                            elevation: 4,
                            child: InkWell(
                              onTap: () async {
                                if (await canLaunch(location.mapUrl!)) {
                                  await launch(location.mapUrl!);
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.map,
                                      color: AppTheme.accentColor,
                                      size: isMicroScreen ? 14 : 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'View Map',
                                      style: TextStyle(
                                        color: AppTheme.accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isMicroScreen ? 12 : 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  // Adjust padding based on screen size, platform and resolution
                  padding: EdgeInsets.all(isHighResDesktop
                      ? 14.0  // Even smaller padding for high-res displays
                      : (isDesktop 
                          ? 16.0  // Slightly reduced padding for desktop
                          : (isAndroid 
                              ? (isMicroScreen ? 10.0 : 14.0)
                              : (isMicroScreen ? 12.0 : 20.0)))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMicroScreen ? 18 : null,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          // Map location icon for clickable locations
                          if (hasMapUrl)
                            Icon(
                              Icons.place,
                              color: AppTheme.accentColor,
                              size: isMicroScreen ? 18 : 22,
                            ),
                        ],
                      ),
                      SizedBox(height: isHighResDesktop ? 6 : (isMicroScreen ? 6 : (isDesktop ? 8 : 10))),
                      // Make the address clickable for locations with map URLs
                      GestureDetector(
                        onTap: hasMapUrl ? () async {
                          if (await canLaunch(location.mapUrl!)) {
                            await launch(location.mapUrl!);
                          }
                        } : null,
                        child: Text(
                          location.address,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: isMicroScreen ? 13 : null,
                                color: hasMapUrl ? AppTheme.accentColor : null,
                                decoration: hasMapUrl ? TextDecoration.underline : null,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: isHighResDesktop ? 4 : (isAndroid ? 6 : (isDesktop ? 6 : 8))),
                      Text(
                        'Hours: ${location.hours}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: isMicroScreen ? 13 : null,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: isHighResDesktop ? 1 : 2,  // Limit to 1 line on high-res desktop
                      ),
                      SizedBox(height: isHighResDesktop ? 4 : (isAndroid ? 6 : (isDesktop ? 6 : 8))),
                      // Ensure phone number doesn't overflow
                      Text(
                        'Phone: ${location.phone}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: isMicroScreen ? 13 : null,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: isHighResDesktop ? 4 : (isAndroid ? 6 : (isDesktop ? 6 : 8))),
                      // Email with clickable link
                      GestureDetector(
                        onTap: () async {
                          final emailUrl = 'mailto:${location.email}';
                          if (await canLaunch(emailUrl)) {
                            await launch(emailUrl);
                          }
                        },
                        child: Text(
                          'Email: ${location.email}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontSize: isMicroScreen ? 13 : null,
                                color: AppTheme.accentColor,
                                decoration: TextDecoration.underline,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: isHighResDesktop ? 10 : (isMicroScreen ? 8 : (isAndroid ? 12 : (isDesktop ? 12 : 16)))),
                      // More responsive button layout
                      _buildLocationButtons(context, location, isVerySmallScreen, isMicroScreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Optional: Visual indicator for clickable locations
          if (hasMapUrl)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Maps',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: isMicroScreen ? 10 : 12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationButtons(BuildContext context, RestaurantLocation location, bool isVerySmallScreen, bool isMicroScreen) {
    final bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 1200;
    
    // Further reduce button size for Android and optimize for desktop
    final buttonVerticalPadding = isDesktop
        ? 10.0  // More compact buttons for desktop
        : (isAndroid 
            ? (isMicroScreen ? 6.0 : 8.0)
            : (isMicroScreen ? 8.0 : 12.0));
        
    // Optimize button text based on available width to avoid overflow
    final directionsText = screenWidth < 280 ? 'MAP' : (isMicroScreen ? 'DIRECTION' : 'DIRECTIONS');
    
    // Adjust text style for platform and screen size
    final buttonTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isMicroScreen ? Colors.black : null,
          fontWeight: FontWeight.bold,
          fontSize: isDesktop
              ? 12  // Smaller text for desktop
              : (isAndroid 
                  ? (isMicroScreen ? 10 : 12)
                  : (isMicroScreen ? 11 : null)),
        );

    final accentButtonTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.bold,
          fontSize: isDesktop
              ? 12  // Smaller text for desktop
              : (isAndroid 
                  ? (isMicroScreen ? 10 : 12)
                  : (isMicroScreen ? 11 : null)),
        );

    return isVerySmallScreen
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.directions, 
                      color: Colors.black, 
                      size: isDesktop
                          ? 18  // Optimized size for desktop
                          : (isAndroid 
                              ? (isMicroScreen ? 14 : 16) 
                              : (isMicroScreen ? 16 : 24))),
                label: Text(directionsText, style: buttonTextStyle),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              SizedBox(height: isDesktop ? 6 : (isAndroid ? 4 : (isMicroScreen ? 6 : 8))),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/reservation-with-location',
                    arguments: location.name,
                  );
                },
                icon: Icon(Icons.restaurant_menu, 
                      color: AppTheme.accentColor, 
                      size: isDesktop
                          ? 18  // Optimized size for desktop
                          : (isAndroid 
                              ? (isMicroScreen ? 14 : 16) 
                              : (isMicroScreen ? 16 : 24))),
                label: Text('RESERVE', style: accentButtonTextStyle),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                  side: BorderSide(color: AppTheme.accentColor, width: isDesktop ? 1.0 : 1.5),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.directions, 
                        color: Colors.black, 
                        size: isDesktop
                            ? 18  // Optimized size for desktop
                            : (isAndroid 
                                ? (isMicroScreen ? 14 : 16) 
                                : (isMicroScreen ? 16 : 24))),
                  label: Text(directionsText, style: buttonTextStyle),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              SizedBox(width: isDesktop ? 8 : (isAndroid ? 4 : (isMicroScreen ? 6 : 10))),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/reservation-with-location',
                      arguments: location.name,
                    );
                  },
                  icon: Icon(Icons.restaurant_menu, 
                        color: AppTheme.accentColor, 
                        size: isDesktop
                            ? 18  // Optimized size for desktop
                            : (isAndroid 
                                ? (isMicroScreen ? 14 : 16) 
                                : (isMicroScreen ? 16 : 24))),
                  label: Text('RESERVE', style: accentButtonTextStyle),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: buttonVerticalPadding),
                    side: BorderSide(color: AppTheme.accentColor, width: isDesktop ? 1.0 : 1.5),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          );
  }
}
