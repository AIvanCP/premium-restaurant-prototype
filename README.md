# Elegant Cuisine - Premium F&B Web Application

A premium Flutter web application for an upscale food and beverage brand targeting young adults (18-24) with higher disposable income. The application features a sophisticated and elegant design that communicates luxury while providing an intuitive user experience.

## Features

### 5 Main Pages

1. **Home Page**
   - Hero image with brand showcase
   - Tagline "THE LEGEND IS BACK!"
   - About section with brand story
   - 3 key benefits with elegant icons
   - Contact form for inquiries and reservations

2. **Menu Page**
   - 5 premium food items with high-quality images
   - 5 signature beverages with descriptions
   - Detailed ingredients listings
   - Price information
   - Category filters

3. **Gallery**
   - 3 restaurant images showcasing the ambiance
   - Location details for each space
   - Elegant card-based presentation

4. **News Section**
   - 6 news items featuring brand updates
   - 2 clickable news items with detailed content
   - Date and category information
   - Visual indicators for expandable content

5. **Locations Page**
   - 2 restaurant branches with images
   - Detailed contact information
   - Business hours
   - Enhanced Google Maps integration for the Downtown location
     - Interactive "View Map" button overlay on location images
     - Visual "Maps" indicator showing the location is clickable
     - Styled clickable address with underline and accent color
     - Direct integration with device map applications
   - Reservation functionality with interactive form
   - Email link functionality for direct communication

### Key Features

- **Table Reservation System**
  - Easy access from both home screen and locations page
  - Comprehensive form with contact details input
  - Interactive date and time selection
  - Party size selection
  - Form validation and error handling
  - Success confirmation and status updates
  - View recent reservations with status tracking
  - Detailed reservation records with all booking information

- **Premium Design Elements**
  - Dark color scheme with gold accents (#1E1E2C and #D4AF37)
  - Sophisticated typography with Playfair Display and Montserrat
  - Responsive design for all device sizes
  - Elegant animations and transitions
  - Footer with contact information on all pages

## Technical Details

This application is built with:

- **Flutter Web**: Utilizing the Flutter framework's web capabilities
- **Provider Package**: For state management across the application
- **Google Fonts**: For premium typography
- **Cached Network Image**: For efficient image loading and caching
- **URL Launcher**: For external links and maps integration
- **Carousel Slider**: For elegant image galleries
- **Flutter Staggered Grid View**: For attractive grid layouts
- **Shared Preferences**: For local storage and user preferences
- **Flutter Markdown**: For rich text rendering

## Project Structure

```
lib/
├── main.dart               # Application entry point
├── models/                 # Data models
│   ├── app_data.dart       # Sample data
│   └── menu_item.dart      # Menu item model
├── screens/                # Main application screens
│   ├── home_screen.dart    # Home page
│   ├── menu_screen.dart    # Menu page
│   ├── gallery_screen.dart # Gallery page
│   ├── news_screen.dart    # News page
│   ├── locations_screen.dart # Locations page
│   ├── reservation_screen.dart # Reservation form
│   └── recent_reservations_screen.dart # View reservations
├── utils/                  # Utility classes
│   ├── analytics_service.dart # Analytics tracking
│   ├── app_provider.dart   # State management
│   ├── constants.dart      # App constants
│   ├── storage_service.dart # Local storage
│   └── theme.dart          # App theming
└── widgets/                # Reusable components
    ├── common_widgets.dart # Shared UI components
    ├── footer_widget.dart  # Application footer
    └── navbar_widget.dart  # Navigation components
```

## Responsive Design

The application features a fully responsive design that adapts to different screen sizes:

- **Desktop**: Clean navigation bar with full content display
- **Tablet**: Adjusted layouts with preserved visual hierarchy
- **Mobile**: Side drawer navigation and bottom tabs for easy access

### Recent Responsive Design Improvements

The application has undergone significant responsive design optimizations to ensure flawless display across all devices:

- **Home Screen**: Fixed 217px overflow with enhanced breakpoint system
- **Menu Screen**: Fixed various overflows (58px, 38px, 58px) with fixed-height components
- **Gallery Screen**: Fixed sub-pixel rendering issues (0.5px, 2.5px overflows) with precise padding and card sizing
- **Locations Screen**: Fixed 73px overflow with optimized layouts
- **Android Devices**: Fixed 45px general overflow with platform-specific adjustments
- **High-Resolution Screens**: Fixed 68px and 77px overflows on 1920x1080 displays with improved aspect ratios

## Getting Started

1. Clone this repository
   ```
   git clone https://github.com/yourusername/elegant-cuisine.git
   cd elegant-cuisine
   ```
2. Run `flutter pub get` to install dependencies
3. Execute `flutter run -d chrome --web-renderer html` to run in development mode
4. Use `flutter build web --web-renderer html` for production builds

## Setup Git Repository (For Developers)

If you're starting with this codebase and need to initialize a Git repository, follow these steps:

1. Initialize a new Git repository
   ```
   git init
   ```

2. Add all files to the repository
   ```
   git add .
   ```

3. Make the initial commit
   ```
   git commit -m "Initial commit of Elegant Cuisine web application"
   ```

4. Create a new repository on GitHub through the website

5. Connect your local repository to GitHub
   ```
   git remote add origin https://github.com/yourusername/elegant-cuisine.git
   ```

6. Push your code to GitHub
   ```
   git push -u origin main
   ```

## Future Enhancements

- Backend integration for reservation system
- User accounts with personalized preferences
- Online ordering capabilities
- Integration with payment gateways
- Social media sharing features
- Performance optimizations for image loading
- Enhanced animations and interactions

- Flutter for web
- Material Design components with custom styling
- Responsive layouts for mobile, tablet, and desktop
- Navigation with smooth transitions
- External integrations (maps, contact forms)

## Setup and Running

1. Ensure Flutter is installed and configured for web development
   `
   flutter doctor
   `

2. Get dependencies
   `
   flutter pub get
   `

3. Run the web application
   `
   flutter run -d chrome
   `

4. Build for production
   `
   flutter build web
   `

## Project Structure

- lib/models/ - Data models for menu items, locations, etc.
- lib/screens/ - Main screen implementations
- lib/utils/ - Theme configurations and utilities
- lib/widgets/ - Reusable UI components
- web/ - Web-specific configurations

## Designed For

This application is specifically designed for upscale food and beverage brands looking to create a premium digital presence that appeals to young adults with higher disposable income who value quality, aesthetics, and exceptional experiences.
