#!/bin/bash
set -e

run_safe() {
  "$@" || true
}

echo "Preparing Flutter build environment..."

PROJECT_DIR="${VERCEL_SOURCE_DIR:-$(pwd)}"
APP_DIR="${PROJECT_DIR}/our_story_flutter"

FLUTTER_VERSION="3.24.3"
FLUTTER_SDK="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_SDK}"
FLUTTER_CACHE_DIR="/tmp/flutter"
PUB_CACHE_DIR="/tmp/.pub-cache"

mkdir -p "${FLUTTER_CACHE_DIR}"
mkdir -p "${PUB_CACHE_DIR}"

echo "Downloading Flutter ${FLUTTER_VERSION}..."
cd /tmp
if command -v curl >/dev/null 2>&1; then
  curl -L "${FLUTTER_URL}" -o "${FLUTTER_SDK}"
elif command -v wget >/dev/null 2>&1; then
  wget -q "${FLUTTER_URL}" -O "${FLUTTER_SDK}"
else
  echo "Error: neither curl nor wget is available on the build machine."
  exit 1
fi

echo "Extracting Flutter SDK..."
tar xf "${FLUTTER_SDK}" -C "${FLUTTER_CACHE_DIR}" --strip-components=1

echo "Configuring git safe directories..."
git config --global --add safe.directory "${FLUTTER_CACHE_DIR}"
git config --global --add safe.directory '*'
chmod -R u+w "${FLUTTER_CACHE_DIR}" 2>/dev/null || true

export FLUTTER_ROOT="${FLUTTER_CACHE_DIR}"
export FLUTTER_BIN="${FLUTTER_ROOT}/bin/flutter"
export PATH="${FLUTTER_ROOT}/bin:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin:${PATH}"
export PUB_CACHE="${PUB_CACHE_DIR}"

echo "Configuring Flutter settings..."
run_safe "${FLUTTER_BIN}" config --no-analytics
run_safe "${FLUTTER_BIN}" config --no-cli-animations
run_safe "${FLUTTER_BIN}" config --enable-web

echo "Flutter SDK version:"
run_safe "${FLUTTER_BIN}" --version | head -5

echo "Precaching Flutter web artifacts..."
run_safe "${FLUTTER_BIN}" precache --web

echo "Running flutter doctor (non-blocking)..."
run_safe "${FLUTTER_BIN}" doctor

if [ ! -d "${APP_DIR}" ]; then
  echo "Error: Flutter project directory not found at ${APP_DIR}"
  exit 1
fi

echo "Fetching project dependencies..."
cd "${APP_DIR}"
"${FLUTTER_BIN}" pub get

echo "Building Flutter web release..."
"${FLUTTER_BIN}" build web --release --web-renderer canvaskit

echo "Build completed successfully. Output at ${APP_DIR}/build/web"

echo "Writing Vercel output directory..."
mkdir -p "${VERCEL_OUTPUT_DIR}"
cp -r "${APP_DIR}/build/web" "${VERCEL_OUTPUT_DIR}/web"
cat > "${VERCEL_OUTPUT_DIR}/config.json" <<'JSON'
{
  "version": 3,
  "routes": []
}
JSON

