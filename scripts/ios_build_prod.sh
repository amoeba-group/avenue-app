#!/bin/bash
# Script build iOS prod flavor

set -e

echo "✅ Cleaning Flutter build..."
flutter clean

echo "✅ Getting Flutter packages..."
flutter pub get

echo "✅ Installing iOS pods..."
cd ios
pod install
cd ..

echo "✅ Building and running iOS app (prod flavor)..."
flutter run --flavor prod -t lib/main.dart
