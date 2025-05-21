Write-Host "Building Premium Flutter Web Application" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Use current directory instead of hardcoded path
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
Set-Location -Path $scriptDir

Write-Host "1. Fetching dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host "2. Analyzing project..." -ForegroundColor Yellow
flutter analyze

Write-Host "3. Building web app..." -ForegroundColor Yellow
flutter build web --web-renderer html

Write-Host "4. Starting development server..." -ForegroundColor Green
flutter run -d chrome --web-renderer html

Write-Host "Done!" -ForegroundColor Cyan
