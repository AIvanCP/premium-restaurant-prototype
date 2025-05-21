#!/bin/powershell
# Script to initialize and set up Git repository for Elegant Cuisine

Write-Host "Initializing Git Repository for Elegant Cuisine" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Use current directory instead of hardcoded path
$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
Set-Location -Path $scriptDir

Write-Host "1. Initializing Git repository..." -ForegroundColor Yellow
git init

Write-Host "2. Adding files to repository..." -ForegroundColor Yellow
git add .

Write-Host "3. Making initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit of Elegant Cuisine web application"

Write-Host "`nGit repository initialized locally!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor White
Write-Host "1. Create a new repository on GitHub through the website" -ForegroundColor White
Write-Host "2. Run the following commands to connect and push to GitHub:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/yourusername/elegant-cuisine.git" -ForegroundColor Yellow
Write-Host "   git push -u origin main" -ForegroundColor Yellow
Write-Host "`nDone!" -ForegroundColor Cyan
