#!/bin/bash

echo "🧹 Cleaning up fixed files and folders..."

# Delete the entire fixed folder
rm -rf src/fixed

# Git commit cleanup
git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"
git add -A
git commit -m "🧹 Cleanup: Removed all fixed versions"
git push
