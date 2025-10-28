# GV Market
- flutter build apk --release lib/main.dart
- flutter build appbundle lib/main.dart
- flutter build ipa --release lib/main.dart

  flutter pub run intl_utils:generate
- 
  open ios/Podfile


Create hash for facebook: 
 keytool -exportcert -alias gv_market -keystore ../gv_market.jks | openssl sha1 -binary | openssl base64

Khi build release để upload Play Store → nhớ add cả SHA-1 / SHA-256 của release keystore hoặc App Signing key trên Google Play Console.

1. API Authentication: login, register, forgot password, reset password, sign in with social.
2. API get profile, send device token, get list notification for orders

- API sign in apple id, facebook, google
 - API Apple id truyền user id cho lần đăng nhập kế tiếp để lấy thông tin email or name. Apple chỉ trả về email, name lần đầu khi sign in
 - Nếu user dùng sđt để login với fb thì fb sẽ không trả về field phone. Yêu cầu nhập email từ app
