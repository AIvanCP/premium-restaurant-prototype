class AppConstants {
  // App Information
  static const String appName = 'Elegant Cuisine';
  static const String appTagline = 'THE LEGEND IS BACK!';
  static const String appDescription = 'Premium food and beverage brand targeting upscale customers aged 18-24.';
  
  // Contact Information
  static const String contactPhone = '+1 (800) ELEGANT';
  static const String contactEmail = 'info@elegantcuisine.com';
  
  // Social Media
  static const String instagramUrl = 'https://instagram.com/elegantcuisine';
  static const String facebookUrl = 'https://facebook.com/elegantcuisine';
  static const String twitterUrl = 'https://twitter.com/elegantcuisine';
  
  // Branch Information
  static const Map<String, String> downtownBranch = {
    'name': 'Downtown Branch',
    'address': '123 Luxury Avenue, New York, NY 10001',
    'phone': '+1 (212) 555-7890',
    'email': 'downtown@elegantcuisine.com',
    'hours': 'Mon-Thu: 5pm-11pm\nFri-Sat: 5pm-1am\nSun: 5pm-10pm',
    'mapUrl': 'https://www.google.com/maps?q=40.7128,-74.0060',
  };
  
  static const Map<String, String> riversideBranch = {
    'name': 'Riverside Branch',
    'address': '456 Waterfront Drive, Chicago, IL 60601',
    'phone': '+1 (312) 555-4321',
    'email': 'riverside@elegantcuisine.com',
    'hours': 'Mon-Thu: 5pm-11pm\nFri-Sat: 5pm-1am\nSun: 5pm-10pm',
  };
  
  // App Routes
  static const String homeRoute = '/';
  static const String menuRoute = '/menu';
  static const String galleryRoute = '/gallery';
  static const String newsRoute = '/news';
  static const String locationsRoute = '/locations';
  
  // Animation Durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 500);
  
  // API Endpoints (for future integration)
  static const String apiBaseUrl = 'https://api.elegantcuisine.com';
  static const String reservationsEndpoint = '/reservations';
  static const String newsletterEndpoint = '/newsletter';
}
