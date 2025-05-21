@echo off
echo "Building Premium Flutter Web Application"
echo "========================================"

REM Use the directory where the script is located
cd /d "%~dp0"

echo "1. Fetching dependencies..."
call flutter pub get

echo "2. Analyzing project..."
call flutter analyze

echo "3. Building web app..."
call flutter build web --web-renderer html

echo "4. Starting development server..."
call flutter run -d chrome --web-renderer html

echo "Done!"
