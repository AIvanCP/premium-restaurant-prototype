import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/news_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/reservation_screen.dart';
import 'screens/recent_reservations_screen.dart';
import 'utils/theme.dart';
import 'utils/app_provider.dart';
import 'utils/app_routes.dart';
import 'widgets/navbar_widget.dart';

void main() { 
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elegant Cuisine',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const AppStartup(),
      builder: (context, child) {
        // Global layout adjustments to prevent overflows
        final screenWidth = MediaQuery.of(context).size.width;
        final isHighResDesktop = screenWidth >= 1900;
        
        return MediaQuery(
          // Apply platform-specific adjustments to prevent overflow issues
          data: MediaQuery.of(context).copyWith(
            // Adjust text scale factor based on platform and screen size - slightly reduce for all sizes
            textScaleFactor: isHighResDesktop
                ? MediaQuery.of(context).textScaleFactor.clamp(0.88, 0.98) // More reduction for high-res
                : MediaQuery.of(context).textScaleFactor.clamp(0.78, 1.08),
            padding: MediaQuery.of(context).padding.copyWith(
              // Add extra padding for Android devices and high-resolution displays
              bottom: Theme.of(context).platform == TargetPlatform.android 
                  ? MediaQuery.of(context).padding.bottom + 8
                  : (isHighResDesktop 
                      ? MediaQuery.of(context).padding.bottom + 8 // Increased padding for high-res desktop
                      : MediaQuery.of(context).padding.bottom + 3), // Add small padding for all devices
            ),
          ),
          child: child!,
        );
      },
      routes: {
        '/reservation': (context) => const ReservationScreen(),
        '/recent-reservations': (context) => const RecentReservationsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/reservation-with-location') {
          final String locationName = settings.arguments as String;
          return AppRoutes.slideUpRoute(ReservationScreen(preselectedLocation: locationName));
        }
        return null;
      },
    );
  }
}

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _showSplash = true;
  bool _appInitialized = false;
  bool _timerCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      print('AppStartup: Starting app initialization...');
      
      // Initialize two parallel processes:
      // 1. Minimum display time for splash screen
      // 2. Loading actual app data
      
      // Set a timer for minimum splash screen display
      Timer(const Duration(milliseconds: 2500), () {
        print('AppStartup: Splash timer completed');
        if (mounted) {
          setState(() {
            _timerCompleted = true;
            // Only transition if app data is also loaded
            if (_appInitialized) {
              print('AppStartup: App already initialized, transitioning to main screen');
              _showSplash = false;
            } else {
              print('AppStartup: Timer completed but app not initialized yet');
            }
          });
        }
      });
      
      // Safety timeout - if app doesn't initialize in 5 seconds, proceed anyway
      Timer(const Duration(seconds: 5), () {
        print('AppStartup: Safety timeout reached');
        if (mounted && !_appInitialized) {
          setState(() {
            _appInitialized = true;
            // Force transition if timer is also done
            if (_timerCompleted) {
              print('AppStartup: Forcing transition due to timeout');
              _showSplash = false;
            }
          });
        }
      });

      // Load app data in parallel
      print('AppStartup: Starting to load app data...');
      
      // Get the provider instance
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      
      // Force a small delay to ensure the splash screen renders first
      await Future.delayed(const Duration(milliseconds: 100));
      
      try {
        // Use the refreshData method to load all app data
        await appProvider.refreshData();
        print('AppStartup: App data loaded successfully');
      } catch (e) {
        print('AppStartup: Error loading app data: $e');
        // Continue with app initialization even if there was an error
      } finally {
        // Mark initialization as complete regardless of success/failure
        if (mounted) {
          setState(() {
            _appInitialized = true;
            // Check if timer has completed, and if so, transition to main screen
            if (_timerCompleted) {
              print('AppStartup: App initialized and timer already completed, transitioning to main screen');
              _showSplash = false;
            } else {
              print('AppStartup: App initialized but timer still running');
            }
          });
        }
      }
    } catch (e) {
      print('Error during app initialization: $e');
      // Even if there's an error, proceed to main screen after delay
      if (mounted) {
        setState(() {
          _appInitialized = true;
          if (_timerCompleted) {
            print('AppStartup: Error occurred but proceeding to main screen');
            _showSplash = false;
          }
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: _showSplash
          ? const SplashScreen(key: ValueKey('splash'))
          : const MainScreen(key: ValueKey('main')),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const HomeScreen(),
    const MenuScreen(),
    const GalleryScreen(),
    const NewsScreen(),
    const LocationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final appProvider = Provider.of<AppProvider>(context);
    final int currentIndex = appProvider.currentScreenIndex;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundColor,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppTheme.primaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: AppTheme.accentColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ELEGANT CUISINE',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                  ),
                ],
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: AppTheme.accentColor,
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: NavBarWidget(
                currentIndex: currentIndex,
                onTap: (index) {
                  appProvider.setCurrentScreenIndex(index);
                },
              ),
            ),
      drawer: isMobile
          ? MobileDrawer(
              currentIndex: currentIndex,
              onTap: (index) {
                appProvider.setCurrentScreenIndex(index);
                Navigator.pop(context); // Close drawer after selection
              },
            )
          : null,
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(currentIndex),
          child: _screens[currentIndex],
        ),
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                appProvider.setCurrentScreenIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.primaryColor,
              selectedItemColor: AppTheme.accentColor,
              unselectedItemColor: AppTheme.textSecondaryColor,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo_library),
                  label: 'Gallery',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.article),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Locations',
                ),
              ],
            )
          : null,
    );
  }
}
