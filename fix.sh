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

# Replace new Random() with SecureRandom
grep -rl 'new Random()' $VULN_JAVA_DIR | while read -r file; do
  echo "🔍 Fixing 'new Random()' in $file"
  sed -i 's/new Random()/new SecureRandom()/g' "$file"
done

# Replace Math.random() with secureRandom.nextDouble()
grep -rl 'Math.random()' $VULN_JAVA_DIR | while read -r file; do
  echo "🔍 Fixing 'Math.random()' in $file"
  sed -i 's/Math.random()/secureRandom.nextDouble()/g' "$file"
done

# Add import if SecureRandom is used
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

  # Replace default constructor with safer version
  sed -i 's/new AutoDetectParser()/new AutoDetectParser(new SecureContentHandler())/g' "$file"

  # Add setEntityResolver if missing
  grep -q 'setEntityResolver' "$file" || sed -i '/AutoDetectParser/ a \
parser.setEntityResolver(new org.xml.sax.helpers.DefaultHandler());' "$file"

  # Add imports if not present
  grep -q 'SecureContentHandler' "$file" || sed -i '1i import org.apache.tika.sax.SecureContentHandler;' "$file"
  grep -q 'DefaultHandler'
