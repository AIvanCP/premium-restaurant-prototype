import 'package:flutter/material.dart';

// Responsive breakpoints
class ScreenSize {
  static const double mobile = 600; // 0-600
  static const double tablet = 900; // 600-900
  static const double desktop = 1200; // 900-1200
  static const double largeDesktop = 1800; // 1200+
}

// Helper class for responsive design
class ResponsiveView extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveView({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  // Get device screen size type
  static ScreenSizeType getScreenSizeType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < ScreenSize.mobile) {
      return ScreenSizeType.mobile;
    } else if (width < ScreenSize.tablet) {
      return ScreenSizeType.tablet;
    } else if (width < ScreenSize.desktop) {
      return ScreenSizeType.desktop;
    } else {
      return ScreenSizeType.largeDesktop;
    }
  }

  // Check if current screen is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ScreenSize.mobile;

  // Check if current screen is tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= ScreenSize.mobile &&
      MediaQuery.of(context).size.width < ScreenSize.tablet;

  // Check if current screen is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ScreenSize.tablet &&
      MediaQuery.of(context).size.width < ScreenSize.desktop;

  // Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= ScreenSize.desktop;

  // Get content padding based on screen size
  static EdgeInsets getContentPadding(BuildContext context) {
    final screenType = getScreenSizeType(context);
    
    switch (screenType) {
      case ScreenSizeType.mobile:
        return const EdgeInsets.all(16.0);
      case ScreenSizeType.tablet:
        return const EdgeInsets.all(24.0);
      case ScreenSizeType.desktop:
        return const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0);
      case ScreenSizeType.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 80.0, vertical: 48.0);
    }
  }

  // Get content max width based on screen size
  static double getContentMaxWidth(BuildContext context) {
    final screenType = getScreenSizeType(context);
    
    switch (screenType) {
      case ScreenSizeType.mobile:
        return double.infinity;
      case ScreenSizeType.tablet:
        return 760.0;
      case ScreenSizeType.desktop:
        return 1140.0;
      case ScreenSizeType.largeDesktop:
        return 1400.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Large desktop layout
    if (screenWidth >= ScreenSize.desktop && largeDesktop != null) {
      return largeDesktop!;
    }
    
    // Desktop layout
    if (screenWidth >= ScreenSize.tablet && desktop != null) {
      return desktop!;
    }
    
    // Tablet layout
    if (screenWidth >= ScreenSize.mobile && tablet != null) {
      return tablet!;
    }
    
    // Mobile layout (default)
    return mobile;
  }
}

// Enum for screen size types
enum ScreenSizeType {
  mobile,
  tablet,
  desktop,
  largeDesktop,
}
