@echo off
echo Initializing Git Repository for Elegant Cuisine
echo =============================================
echo.

REM Use the directory where the script is located
cd /d "%~dp0"

echo 1. Initializing Git repository...
call git init

echo 2. Adding files to repository...
call git add .

echo 3. Making initial commit...
call git commit -m "Initial commit of Elegant Cuisine web application"

echo.
echo Git repository initialized locally!
echo.
echo Next steps:
echo 1. Create a new repository on GitHub through the website
echo 2. Run the following commands to connect and push to GitHub:
echo    git remote add origin https://github.com/yourusername/elegant-cuisine.git
echo    git push -u origin main
echo.
echo Done!
