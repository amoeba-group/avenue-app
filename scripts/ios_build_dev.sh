#!/bin/bash
# Script build iOS dev flavor

set -e

echo "✅ Cleaning Flutter build..."
flutter clean

echo "✅ Getting Flutter packages..."
flutter pub get

echo "✅ Installing iOS pods..."
cd ios
pod install
cd ..

echo "✅ Building and running iOS app (dev flavor)..."
flutter run --flavor dev -t lib/main.dart
