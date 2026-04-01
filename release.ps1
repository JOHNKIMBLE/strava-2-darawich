# release.ps1 - Initial push to GitHub
$ErrorActionPreference = "Stop"

$remote = "https://github.com/JOHNKIMBLE/strava-2-darawich.git"

Write-Host "=== Strava-2-Dawarich Release ===" -ForegroundColor Cyan

# Stage all files
git add -A

# Commit
git commit -m "Initial release: Strava activity to GPX with Dawarich push"

# Rename branch to main
git branch -M main

# Set remote
$remotes = git remote
if ($remotes -contains "origin") {
    git remote set-url origin $remote
} else {
    git remote add origin $remote
}

# Push
git push -u origin main

Write-Host "`nPushed to $remote" -ForegroundColor Green
Write-Host "https://github.com/JOHNKIMBLE/strava-2-darawich" -ForegroundColor Yellow
