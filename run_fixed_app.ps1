#!/bin/powershell
# Script to run the fixed version of the app

Write-Host "Running fixed version of Elegant Cuisine app..." -ForegroundColor Green

# Rename the current files to backup
Rename-Item -Path "lib\main.dart" -NewName "main.dart.bak" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\utils\app_provider.dart" -NewName "app_provider.dart.bak" -ErrorAction SilentlyContinue

# Copy the fixed versions
Copy-Item -Path "lib\main_fixed.dart" -Destination "lib\main.dart" -ErrorAction SilentlyContinue
Copy-Item -Path "lib\utils\app_provider_fixed.dart" -Destination "lib\utils\app_provider.dart" -ErrorAction SilentlyContinue

# Run the app
flutter run -d chrome

# Wait for the app to run and testing to complete
Write-Host "Press Enter when you're done testing..." -ForegroundColor Yellow
$null = Read-Host

# Restore the original files
Rename-Item -Path "lib\main.dart" -NewName "main_fixed.dart" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\utils\app_provider.dart" -NewName "app_provider_fixed.dart" -ErrorAction SilentlyContinue

Rename-Item -Path "lib\main.dart.bak" -NewName "main.dart" -ErrorAction SilentlyContinue
Rename-Item -Path "lib\utils\app_provider.dart.bak" -NewName "app_provider.dart" -ErrorAction SilentlyContinue

Write-Host "Original files restored." -ForegroundColor Green
