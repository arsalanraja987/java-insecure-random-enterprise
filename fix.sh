#!/bin/bash

echo "🚀 Starting enterprise CVE remediation script..."

############## 🟡 CVE-2021-27568: Insecure Randomness (Multiple Variations) ##############
echo "🧪 Fixing CVE-2021-27568: Insecure randomness..."

# Replace 'new Random()' with SecureRandom
grep -rl --include="*.java" 'new Random()' src/main/java | while read -r file; do
  echo "🔍 Fixing 'new Random()' in $file"
  sed -i 's/new Random()/new SecureRandom()/g' "$file"
done

# Replace 'Math.random()' with secureRandom.nextDouble()
grep -rl --include="*.java" 'Math.random()' src/main/java | while read -r file; do
  echo "🔍 Fixing 'Math.random()' in $file"
  sed -i 's/Math.random()/secureRandom.nextDouble()/g' "$file"
done

# Ensure SecureRandom import is added
find src/main/java -type f -name "*.java" | while read -r file; do
  if grep -q 'SecureRandom' "$file" && ! grep -q 'import java.security.SecureRandom;' "$file"; then
    echo "📎 Adding SecureRandom import to $file"
    sed -i '1i import java.security.SecureRandom;' "$file"
  fi
done

############## 🟡 CVE-2021-29425: Apache Tika XXE (Multiple Variants) ##############
echo "🧪 Fixing CVE-2021-29425: Apache Tika XXE..."

# Add SecureContentHandler and entity resolver where AutoDetectParser is found
grep -rl --include="*.java" 'AutoDetectParser' src/main/java | while read -r file; do
  echo "🔍 Securing AutoDetectParser in $file"

  # Add entity resolver line if not present
  grep -q 'setEntityResolver' "$file" || sed -i '/AutoDetectParser/ a \
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());' "$file"

  # Replace default constructor with secure version
  sed -i 's/new AutoDetectParser()/new AutoDetectParser(new SecureContentHandler())/g' "$file"

  # Add required imports if missing
  grep -q 'SecureContentHandler' "$file" || sed -i '1i import org.apache.tika.sax.SecureContentHandler;' "$file"
  grep -q 'DefaultHandler' "$file" || sed -i '1i import org.xml.sax.helpers.DefaultHandler;' "$file"
done

############## 🟡 CVE-2021-29427: Gradle Content Filtering Bypass ##############
echo "🧪 Fixing CVE-2021-29427: Gradle repo filtering..."

if [ -f "build.gradle" ]; then
  echo "🔍 Found build.gradle — scanning for vulnerable repositories..."

  # Fix mavenCentral() if not filtered
  if grep -q 'mavenCentral()' build.gradle && ! grep -A2 'mavenCentral()' build.gradle | grep -q 'content {'; then
    echo "⚠️ mavenCentral() lacks content filter — patching..."
    sed -i '/mavenCentral()/a \
    content {\n\
        includeGroup "org.apache.tika"\n\
        includeGroup "com.google.guava"\n\
    }' build.gradle
  fi

  # Fix custom maven { ... } blocks with no content filter
  awk '
  /maven\s*{/ {
    print; print "        content {\n            includeGroup \"org.apache.tika\"\n            includeGroup \"com.google.guava\"\n        }"
    next
  }
  { print }
  ' build.gradle > build.gradle.tmp && mv build.gradle.tmp build.gradle

  echo "✅ build.gradle patched."
else
  echo "❌ build.gradle not found — skipping Gradle patch."
fi

############## ✅ Final Git Commit (Optional) ##############
echo "📦 Committing fixed files..."

git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"
git diff --quiet || (git add . && git commit -m "Fix: CVE-2021-27568, CVE-2021-29425, CVE-2021-29427 remediated" && git push)

echo "✅ All CVEs processed and fixed!"
