import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// This service will handle storing user preferences and settings
// Note: We would need to add shared_preferences to pubspec.yaml to use this

class StorageService {
  static final StorageService _instance = StorageService._internal();
  
  factory StorageService() {
    return _instance;
  }
  
  StorageService._internal();
  
  // Keys for storage
  static const String _recentViewsKey = 'recent_views';
  static const String _favoritesKey = 'favorites';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _themeKey = 'theme_mode';
  
  // Save recently viewed menu items
  Future<void> saveRecentView(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> recentViews = await getRecentViews();
    
    // Remove if already exists and add to front
    recentViews.removeWhere((id) => id == itemId);
    recentViews.insert(0, itemId);
    
    // Keep only the last 10
    final trimmedList = recentViews.take(10).toList();
    
    await prefs.setStringList(_recentViewsKey, trimmedList);
  }
  
  // Get recently viewed menu items
  Future<List<String>> getRecentViews() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_recentViewsKey) ?? [];
  }
  
  // Save a favorite item
  Future<void> toggleFavorite(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = await getFavorites();
    
    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
    } else {
      favorites.add(itemId);
    }
    
    await prefs.setStringList(_favoritesKey, favorites);
  }
  
  // Get favorite items
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }
  
  // Check if an item is a favorite
  Future<bool> isFavorite(String itemId) async {
    final favorites = await getFavorites();
    return favorites.contains(itemId);
  }
  
  // Save user preferences
  Future<void> saveUserPreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedPreferences = jsonEncode(preferences);
    await prefs.setString(_userPreferencesKey, encodedPreferences);
  }
  
  // Get user preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedPreferences = prefs.getString(_userPreferencesKey);
    
    if (encodedPreferences == null) {
      return {};
    }
    
    return jsonDecode(encodedPreferences) as Map<String, dynamic>;
  }
  
  // Save theme mode
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode);
  }
  
  // Get theme mode
  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system';
  }
  
  // Clear all saved data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
