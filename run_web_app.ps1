#!/bin/powershell
# Script to run the app optimized for web

Write-Host "Running Elegant Cuisine web app with optimizations..." -ForegroundColor Green

# Clean the build to avoid any cached issues
flutter clean

# Rebuild web resources
flutter pub get

# Run the app with web renderer set to html (more compatible)
flutter run -d chrome --web-renderer html

Write-Host "`nIf the app loads correctly, the _FlutterLoader error should be fixed." -ForegroundColor Yellow
Write-Host "Check the browser console (F12) to confirm no errors are present." -ForegroundColor Yellow
