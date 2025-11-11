#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.24.3"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_ARCHIVE}"

echo "Downloading Flutter ${FLUTTER_VERSION}..."
curl -L "${FLUTTER_URL}" -o "${FLUTTER_ARCHIVE}"

echo "Extracting Flutter SDK..."
tar xf "${FLUTTER_ARCHIVE}"
export PATH="$PWD/flutter/bin:$PATH"

echo "Removing embedded Flutter git metadata to avoid ownership checks..."
rm -rf flutter/.git
git config --global --add safe.directory "$PWD/flutter"
git config --global --add safe.directory '*'

echo "Checking Flutter version..."
flutter doctor --version

echo "Enabling Flutter for web..."
flutter config --no-analytics
flutter config --enable-web

echo "Fetching dependencies..."
cd our_story_flutter
flutter pub get

echo "Building Flutter web release..."
flutter build web --release --web-renderer canvaskit

echo "Build complete. Output at our_story_flutter/build/web"

echo "Copying build output to dist directory..."
mkdir -p ../dist
cp -r build/web/. ../dist/

echo "Build ready for deployment"

