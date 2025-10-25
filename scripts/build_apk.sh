#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${ANDROID_SDK_ROOT:-}" ]]; then
  echo "ANDROID_SDK_ROOT must be set to a valid Android SDK installation" >&2
  exit 1
fi

BUILD_TOOLS_VERSION="${BUILD_TOOLS_VERSION:-34.0.0}"
PLATFORM_VERSION="${PLATFORM_VERSION:-android-34}"

BUILD_TOOLS_DIR="$ANDROID_SDK_ROOT/build-tools/$BUILD_TOOLS_VERSION"
PLATFORM_DIR="$ANDROID_SDK_ROOT/platforms/$PLATFORM_VERSION"

for tool in aapt2 d8 apksigner zipalign; do
  if [[ ! -x "$BUILD_TOOLS_DIR/$tool" ]]; then
    echo "Missing $tool in $BUILD_TOOLS_DIR" >&2
    exit 1
  fi
done

if ! command -v kotlinc >/dev/null 2>&1; then
  echo "kotlinc is required on PATH" >&2
  exit 1
fi

if ! command -v keytool >/dev/null 2>&1; then
  echo "keytool from the JDK is required on PATH" >&2
  exit 1
fi

ANDROID_JAR="$PLATFORM_DIR/android.jar"
if [[ ! -f "$ANDROID_JAR" ]]; then
  echo "Unable to find android.jar in $PLATFORM_DIR" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
INTERMEDIATES_DIR="$BUILD_DIR/intermediates"
OUTPUT_APK="$BUILD_DIR/SwarmSpace-debug.apk"
UNSIGNED_APK="$INTERMEDIATES_DIR/unsigned.apk"
ALIGNED_APK="$INTERMEDIATES_DIR/aligned.apk"

rm -rf "$BUILD_DIR"
mkdir -p "$INTERMEDIATES_DIR"

KOTLIN_SRC=("$ROOT_DIR/app/src/main/kotlin/com/swarmspace/apk/MainActivity.kt")
KOTLIN_OUT="$INTERMEDIATES_DIR/classes.jar"

kotlinc "${KOTLIN_SRC[@]}" \
  -classpath "$ANDROID_JAR" \
  -include-runtime \
  -d "$KOTLIN_OUT"

"$BUILD_TOOLS_DIR/aapt2" link \
  --manifest "$ROOT_DIR/app/src/main/AndroidManifest.xml" \
  -I "$ANDROID_JAR" \
  --rename-manifest-package com.swarmspace.apk \
  --min-sdk-version 21 \
  --target-sdk-version 34 \
  -o "$INTERMEDIATES_DIR/base.apk"

"$BUILD_TOOLS_DIR/d8" \
  --lib "$ANDROID_JAR" \
  "$KOTLIN_OUT" \
  --output "$INTERMEDIATES_DIR/dex"

cd "$INTERMEDIATES_DIR"
unzip -q base.apk -d apk_contents
cp dex/classes.dex apk_contents/
cd apk_contents
zip -qr "$UNSIGNED_APK" .
cd "$ROOT_DIR"

"$BUILD_TOOLS_DIR/zipalign" -f 4 "$UNSIGNED_APK" "$ALIGNED_APK"

KEYSTORE="$ROOT_DIR/scripts/debug.keystore"
if [[ ! -f "$KEYSTORE" ]]; then
  keytool -genkeypair \
    -alias androiddebugkey \
    -keypass android \
    -keystore "$KEYSTORE" \
    -storepass android \
    -dname "CN=Android Debug,O=Android,C=US" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 >/dev/null
fi

"$BUILD_TOOLS_DIR/apksigner" sign \
  --ks "$KEYSTORE" \
  --ks-pass pass:android \
  --key-pass pass:android \
  --out "$OUTPUT_APK" \
  "$ALIGNED_APK"

echo "APK created at $OUTPUT_APK"
