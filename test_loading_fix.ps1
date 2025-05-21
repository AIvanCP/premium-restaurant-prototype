#!/bin/powershell
# Script to test the fixed app loading screen

Write-Host "Testing fixed app loading screen..." -ForegroundColor Green

# Run the app in Chrome
flutter run -d chrome

# After testing, provide instructions for the user
Write-Host "`nIf the app is still getting stuck on the loading screen, check debug logs in the terminal." -ForegroundColor Yellow
Write-Host "Look for error messages or issues in the app initialization process." -ForegroundColor Yellow
