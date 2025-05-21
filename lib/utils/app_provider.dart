import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/app_data.dart';
import '../utils/storage_service.dart';
import '../utils/analytics_service.dart';

class AppProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AnalyticsService _analyticsService = AnalyticsService();
  
  // Selected screen index
  int _currentScreenIndex = 0;
  int get currentScreenIndex => _currentScreenIndex;
  
  // Menu items
  List<MenuItem> _foodItems = [];
  List<MenuItem> _beverageItems = [];
  List<String> _favorites = [];
  
  // Gallery items
  List<GalleryItem> _galleryItems = [];
  
  // News items
  List<NewsItem> _newsItems = [];
  
  // Locations
  List<RestaurantLocation> _locations = [];
  
  // Reservations
  List<Map<String, dynamic>> _recentReservations = [];
  List<Map<String, dynamic>> get recentReservations {
    print('Getting recent reservations, count: ${_recentReservations.length}');
    return _recentReservations;
  }
  
  // Loading states
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  
  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  AppProvider() {
    print('AppProvider: Constructor called');
    _initialize();
  }
  
  // Initialize the provider
  Future<void> _initialize() async {
    try {
      print('AppProvider: Starting initialization...');
      _isLoading = true;
      notifyListeners();
      
      // Load data with small delays to prevent UI freezing
      print('AppProvider: Loading food items...');
      _foodItems = MenuItem.getFoodItems();
      await Future.delayed(const Duration(milliseconds: 50));
      
      print('AppProvider: Loading beverage items...');
      _beverageItems = MenuItem.getBeverageItems();
      await Future.delayed(const Duration(milliseconds: 50));
      
      print('AppProvider: Loading gallery items...');
      _galleryItems = GalleryItem.getGalleryItems();
      await Future.delayed(const Duration(milliseconds: 50));
      
      print('AppProvider: Loading news items...');
      _newsItems = NewsItem.getNewsItems();
      await Future.delayed(const Duration(milliseconds: 50));
      
      print('AppProvider: Loading locations...');
      _locations = RestaurantLocation.getLocations();
      await Future.delayed(const Duration(milliseconds: 50));
      
      print('AppProvider: Loading user preferences...');
      // Load user preferences
      _favorites = await _storageService.getFavorites();
      
      // Initialize reservations with empty list if not already loaded
      // In a real app, we would load from backend or local storage
      print('AppProvider: Initializing reservations...');
      _recentReservations = [];
      
      // Add a test reservation for debugging
      _recentReservations.add({
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '123-456-7890',
        'location': 'Downtown Branch',
        'date': DateTime.now().add(const Duration(days: 2)),
        'partySize': 4,
        'status': 'Confirmed',
        'reservationId': 'R202505210001',
      });
      
      print('Added test reservation, count: ${_recentReservations.length}');
      
      _isLoading = false;
      _errorMessage = null;    } catch (e) {
      _errorMessage = 'Failed to initialize: $e';
      _isLoading = false;
      print('Error during initialization: $e'); // Add debug print
      
      // Make sure to notify listeners even if there's an error
      notifyListeners();
      // Re-throw the error to be caught by the caller
      throw e;
    }
    
    notifyListeners();
  }
  
  // Navigation
  void setCurrentScreenIndex(int index) {
    if (_currentScreenIndex != index) {
      _currentScreenIndex = index;
      notifyListeners();
      
      // Track screen view
      String screenName;
      switch (index) {
        case 0:
          screenName = 'Home';
          break;
        case 1:
          screenName = 'Menu';
          break;
        case 2:
          screenName = 'Gallery';
          break;
        case 3:
          screenName = 'News';
          break;
        case 4:
          screenName = 'Locations';
          break;
        default:
          screenName = 'Unknown';
      }
      
      _analyticsService.trackScreenView(screenName);
    }
  }
  
  // Menu related methods
  List<MenuItem> getFoodItems() => _foodItems;
  List<MenuItem> getBeverageItems() => _beverageItems;
  
  Future<void> viewMenuItem(MenuItem item) async {
    await _storageService.saveRecentView(item.id);
    await _analyticsService.trackMenuItemView(
      item.id, item.name, item.category,
    );
  }
  
  Future<void> toggleFavorite(String itemId) async {
    await _storageService.toggleFavorite(itemId);
    _favorites = await _storageService.getFavorites();
    notifyListeners();
    
    _analyticsService.trackEvent(
      category: 'Menu',
      action: _favorites.contains(itemId) ? 'Add Favorite' : 'Remove Favorite',
      label: itemId,
    );
  }
  
  bool isFavorite(String itemId) {
    return _favorites.contains(itemId);
  }
  
  // Gallery related methods
  List<GalleryItem> getGalleryItems() => _galleryItems;
  
  // News related methods
  List<NewsItem> getNewsItems() => _newsItems;
  
  // Location related methods
  List<RestaurantLocation> getLocations() => _locations;
  
  // Contact form submission
  Future<bool> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      // This would normally send data to a backend
      await _analyticsService.trackEvent(
        category: 'Contact',
        action: 'Form Submission',
        label: email,
      );
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit form: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Reservation request
  Future<bool> requestReservation({
    required String name,
    required String email,
    required String phone,
    required String location,
    required DateTime date,
    required int partySize,
  }) async {
    try {
      // This would normally send data to a backend
      await _analyticsService.trackReservation(
        location,
        date.toIso8601String(),
        partySize,
      );
      
      // Add to recent reservations (for demo purposes only)
      print('Adding new reservation for $name');
      try {
        _recentReservations.add({
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'date': date,
          'partySize': partySize,
          'status': 'Pending',
          'reservationId': 'R${DateTime.now().millisecondsSinceEpoch}',
        });
        print('Successfully added reservation, count: ${_recentReservations.length}');
      } catch (e) {
        print('Error adding reservation: $e');
        // If there's an error adding to the list, create a new list
        _recentReservations = [{
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'date': date,
          'partySize': partySize,
          'status': 'Pending',
          'reservationId': 'R${DateTime.now().millisecondsSinceEpoch}',
        }];
        print('Created new reservation list with 1 item');
      }
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit reservation: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Cancel reservation
  Future<bool> cancelReservation(String reservationId) async {
    try {
      // Find reservation by ID
      final index = _recentReservations.indexWhere(
          (res) => res['reservationId'] == reservationId);
      
      if (index == -1) {
        throw Exception('Reservation not found');
      }
      
      // Update status to cancelled
      _recentReservations[index]['status'] = 'Cancelled';
      
      // Log analytics
      await _analyticsService.trackEvent(
        category: 'Reservation',
        action: 'Cancel',
        label: reservationId,
      );
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel reservation: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Edit reservation (go to reservation screen with prefilled data)
  Map<String, dynamic>? getReservationById(String reservationId) {
    try {
      final reservation = _recentReservations.firstWhere(
          (res) => res['reservationId'] == reservationId);
      return reservation;
    } catch (e) {
      _errorMessage = 'Reservation not found: $e';
      notifyListeners();
      return null;
    }
  }
  
  // Update existing reservation
  Future<bool> updateReservation({
    required String reservationId,
    required String name,
    required String email,
    required String phone,
    required String location,
    required DateTime date,
    required int partySize,
  }) async {
    try {
      // Find reservation by ID
      final index = _recentReservations.indexWhere(
          (res) => res['reservationId'] == reservationId);
      
      if (index == -1) {
        throw Exception('Reservation not found');
      }
      
      // Update reservation details
      _recentReservations[index] = {
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'date': date,
        'partySize': partySize,
        'status': 'Pending', // Reset to pending since it was modified
        'reservationId': reservationId,
      };
      
      // Log analytics
      await _analyticsService.trackEvent(
        category: 'Reservation',
        action: 'Update',
        label: reservationId,
      );
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update reservation: $e';
      notifyListeners();
      return false;
    }
  }
  
  // Error handling
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
    // Reload data
  Future<void> refreshData() async {
    try {
      print('AppProvider: Starting refreshData...');
      // Set loading state
      _isLoading = true;
      notifyListeners();
      
      // Wait for initialization to complete
      await _initialize();
      
      // Make sure to set loading to false and notify listeners again
      _isLoading = false;
      notifyListeners();
      
      print('AppProvider: refreshData completed successfully');
    } catch (e) {
      _errorMessage = 'Failed to refresh data: $e';
      _isLoading = false;
      notifyListeners();
      print('Error refreshing data: $e'); // Add debug print
    }
  }
}
