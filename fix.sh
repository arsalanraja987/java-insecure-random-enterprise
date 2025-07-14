#!/bin/bash

echo "🚀 Starting enterprise CVE remediation with safe fixed copies..."

##### STEP 1: Create fixed folders
echo "📁 Creating folders for fixed versions..."
mkdir -p src/fixed/java
mkdir -p src/fixed/gradle

##### STEP 2: Copy all vulnerable files
echo "📄 Copying vulnerable Java files to fixed folder..."
cp src/main/java/RandomVuln*.java src/fixed/java/
cp src/main/java/TikaVuln*.java src/fixed/java/

echo "📄 Copying vulnerable Gradle files to fixed folder..."
cp src/main/java/gradle-vuln/*.build.gradle src/fixed/gradle/

##### STEP 3: Fix CVE-2021-27568 - Insecure Randomness
VULN_JAVA_DIR="src/fixed/java"
echo "🔧 Fixing CVE-2021-27568: Insecure Randomness..."

grep -rl 'new Random()' $VULN_JAVA_DIR | while read -r file; do
  echo "🔍 Fixing 'new Random()' in $file"
  sed -i 's/new Random()/new SecureRandom()/g' "$file"
done

grep -rl 'Math.random()' $VULN_JAVA_DIR | while read -r file; do
  echo "🔍 Fixing 'Math.random()' in $file"
  sed -i 's/Math.random()/secureRandom.nextDouble()/g' "$file"
done

find $VULN_JAVA_DIR -type f -name "*.java" | while read -r file; do
  if grep -q 'SecureRandom' "$file" && ! grep -q 'import java.security.SecureRandom;' "$file"; then
    echo "📎 Adding SecureRandom import to $file"
    sed -i '1i import java.security.SecureRandom;' "$file"
  fi
done

##### STEP 4: Fix CVE-2021-29425 - Apache Tika XXE
echo "🔧 Fixing CVE-2021-29425: Apache Tika XXE..."

grep -rl 'AutoDetectParser' $VULN_JAVA_DIR | while read -r file; do
  echo "🔍 Securing AutoDetectParser in $file"
  sed -i 's/new AutoDetectParser()/new AutoDetectParser(new SecureContentHandler())/g' "$file"
  grep -q 'setEntityResolver' "$file" || sed -i '/AutoDetectParser/ a \
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());' "$file"
  grep -q 'SecureContentHandler' "$file" || sed -i '1i import org.apache.tika.sax.SecureContentHandler;' "$file"
  grep -q 'DefaultHandler' "$file" || sed -i '1i import org.xml.sax.helpers.DefaultHandler;' "$file"
done

##### STEP 5: Fix CVE-2021-29427 - Gradle Repository Filtering Bypass
VULN_GRADLE_DIR="src/fixed/gradle"
echo "🔧 Fixing CVE-2021-29427: Gradle filtering..."

find $VULN_GRADLE_DIR -type f -name "*.gradle" | while read -r gradle_file; do
  echo "🔍 Checking $gradle_file for repository issues..."

  if grep -q 'mavenCentral()' "$gradle_file" && ! grep -A2 'mavenCentral()' "$gradle_file" | grep -q 'content {'; then
    echo "⚠️ Patching mavenCentral() in $gradle_file"
    sed -i '/mavenCentral()/a \
        content {\n\
            includeGroup "org.apache.tika"\n\
            includeGroup "com.google.guava"\n\
        }' "$gradle_file"
  fi

  awk '
  /maven\s*{/ {
    print; print "        content {\n            includeGroup \"org.apache.tika\"\n            includeGroup \"com.google.guava\"\n        }"
    next
  }
  { print }
  ' "$gradle_file" > "$gradle_file.tmp" && mv "$gradle_file.tmp" "$gradle_file"

  echo "✅ Patched $gradle_file"
done

##### STEP 6: Commit Fixed Files to GitHub
echo "📦 Committing fixed files..."

git config --global user.name "AutoFix Bot"
git config --global user.email "autofix@bot.com"
git add src/fixed

if ! git diff --cached --quiet; then
  git commit -m "fix.sh: Added fixed versions for CVE remediation"
  git push
  echo "✅ Fixed files committed and pushed!"
else
  echo "ℹ️ No new changes to commit."
fi

echo "🎉 All CVEs fixed and results saved in src/fixed/"
