#!/bin/bash

set -e
echo "🧹 Cleaning up fixed files and folders..."

# Check if the fixed folder exists
if [ -d "src/fixed" ]; then
  rm -rf src/fixed
  echo "✅ Deleted src/fixed folder"
else
  echo "⚠️ No src/fixed folder to delete"
fi

# Git identity for commit
git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"

# Stage, commit, and push changes
git add -A

if git diff --cached --quiet; then
  echo "ℹ️ Nothing to commit after cleanup."
else
  git commit -m "🧹 Cleanup: Removed all fixed versions"
  git push
  echo "✅ Cleanup committed and pushed."
fi
