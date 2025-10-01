# GV Market
- flutter build apk --release lib/main.dart
- flutter build appbundle lib/main.dart
- flutter build ipa --release lib/main.dart

  flutter pub run intl_utils:generate
- 
  open ios/Podfile

Khi build release để upload Play Store → nhớ add cả SHA-1 / SHA-256 của release keystore hoặc App Signing key trên Google Play Console.