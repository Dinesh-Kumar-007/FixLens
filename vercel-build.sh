#!/usr/bin/env bash
set -euo pipefail

echo "Downloading Flutter SDK..."
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git .flutter-sdk
export PATH="$PWD/.flutter-sdk/bin:$PATH"

flutter --version
flutter config --enable-web
flutter create --platforms=web .
flutter pub get
flutter build web --release
