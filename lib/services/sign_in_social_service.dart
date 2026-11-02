import 'dart:io';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// ══════════════════════════════════════════════════════════════════════════════
/// Social Sign-In Service - Quản lý đăng nhập qua các nền tảng social
/// ══════════════════════════════════════════════════════════════════════════════
///
/// Chức năng:
/// - Sign in with Apple (iOS 13+)
/// - Sign in with Google
/// - Sign in with Facebook
///
/// Usage:
/// ```dart
/// final socialService = SignInSocialService();
///
/// // Apple Sign In
/// final appleResult = await socialService.signInWithApple();
/// if (appleResult != null) {
///   print('Apple User ID: ${appleResult.userId}');
///   print('Email: ${appleResult.email}');
///   print('Name: ${appleResult.fullName}');
/// }
///
/// // Google Sign In
/// final googleResult = await socialService.signInWithGoogle();
///
/// // Facebook Sign In
/// final facebookResult = await socialService.signInWithFacebook();
/// ```
///
/// ══════════════════════════════════════════════════════════════════════════════

/// Model cho kết quả social sign in
class SocialSignInResult {
  final String userId;
  final String? email;
  final String? fullName;
  final String? photoUrl;
  final String? idToken;
  final String? accessToken;

  SocialSignInResult({
    required this.userId,
    this.email,
    this.fullName,
    this.photoUrl,
    this.idToken,
    this.accessToken,
  });

  @override
  String toString() {
    return 'SocialSignInResult('
        'userId: $userId, '
        'email: $email, '
        'fullName: $fullName, '
        'photoUrl: $photoUrl'
        ')';
  }
}

class SignInSocialService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  bool _isGoogleSignInInitialized = false;

  final List<String> _googleScopes = ['email'];

  // ─────────────────────────────────────────────────────────────────────────────
  // Apple Sign In
  // ─────────────────────────────────────────────────────────────────────────────

  /// Đăng nhập với Apple
  ///
  /// ⚠️ LƯU Ý QUAN TRỌNG:
  /// - Apple CHỈ trả về email và fullName ở LẦN ĐẦU TIÊN sign in
  /// - Các lần sau chỉ trả về userIdentifier
  /// - Bạn cần lưu email/fullName vào database ngay lần đầu
  /// - Hoặc sử dụng userIdentifier để lấy từ server
  ///
  /// Returns: SocialSignInResult hoặc null nếu bị hủy/lỗi
  Future<SocialSignInResult?> signInWithApple() async {
    try {
      // Check xem thiết bị có hỗ trợ Sign in with Apple không
      if (!Platform.isIOS && !Platform.isMacOS) {
        throw Exception('Sign in with Apple chỉ hỗ trợ trên iOS và macOS');
      }

      final available = await SignInWithApple.isAvailable();
      if (!available) {
        throw Exception('Sign in with Apple không khả dụng trên thiết bị này');
      }

      // Request credentials
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Build full name từ givenName và familyName
      String? fullName;
      if (credential.givenName != null || credential.familyName != null) {
        final parts = [
          credential.givenName,
          credential.familyName,
        ].where((part) => part != null && part.isNotEmpty);
        fullName = parts.join(' ');
      }

      return SocialSignInResult(
        userId: credential.userIdentifier ?? '',
        email: credential.email,
        fullName: fullName,
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
    } catch (e) {
      print('Apple Sign In Error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Google Sign In (API v7.x)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize Google Sign In (chỉ cần gọi 1 lần)
  Future<void> _initializeGoogleSignIn({String? serverClientId}) async {
    if (_isGoogleSignInInitialized) return;

    try {
      await _googleSignIn.initialize(
        serverClientId: serverClientId ??
            "1092035910524-73uf4vbonjh8roto3jip8dbrcn2hrduc.apps.googleusercontent.com",
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Đảm bảo Google Sign In đã được initialize
  Future<void> _ensureGoogleSignInInitialized({String? serverClientId}) async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn(serverClientId: serverClientId);
    }
  }

  /// Đăng nhập với Google (API v7.x)
  ///
  /// [serverClientId]: Optional server client ID cho backend authentication
  ///
  /// Returns: SocialSignInResult hoặc null nếu bị hủy/lỗi
  Future<SocialSignInResult?> signInWithGoogle({String? serverClientId}) async {
    try {
      // Ensure initialized
      await _ensureGoogleSignInInitialized(serverClientId: serverClientId);

      // Authenticate với Google
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: _googleScopes,
      );

      // Lấy authentication details
      final GoogleSignInAuthentication auth = account.authentication;

      return SocialSignInResult(
        userId: account.id,
        email: account.email,
        fullName: account.displayName,
        photoUrl: account.photoUrl,
        idToken: auth.idToken,
        accessToken: null, // Google Sign-In v7.x doesn't provide accessToken
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        print('Google Sign-In cancelled by user');
        return null;
      } else {
        print('Google Sign-In error: ${e.code} - ${e.description}');
        return null;
      }
    } catch (e) {
      print('Unexpected Google Sign-In error: $e');
      return null;
    }
  }

  /// Đăng xuất Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  /// Disconnect Google account
  Future<void> disconnectGoogle() async {
    await _googleSignIn.disconnect();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Facebook Sign In
  // ─────────────────────────────────────────────────────────────────────────────

  /// Đăng nhập với Facebook
  ///
  /// ⚠️ LƯU Ý:
  /// - Nếu user dùng SĐT để login Facebook, Facebook sẽ KHÔNG trả về email
  /// - Trong trường hợp này, cần yêu cầu user nhập email từ app
  /// - Phone field chỉ khả dụng nếu app được Facebook approve permission
  ///
  /// Returns: SocialSignInResult hoặc null nếu bị hủy/lỗi
  Future<SocialSignInResult?> signInWithFacebook() async {
    try {
      // Trigger Facebook Login flow
      final LoginResult result = await _facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      // Check login status
      if (result.status != LoginStatus.success) {
        print('Facebook Login Status: ${result.status}');
        return null;
      }

      // Lấy user data
      final userData = await _facebookAuth.getUserData(
        fields: 'id,name,email,picture.width(200)',
      );

      // Extract photo URL
      String? photoUrl;
      if (userData['picture'] != null) {
        final picture = userData['picture'] as Map<String, dynamic>;
        if (picture['data'] != null) {
          photoUrl = picture['data']['url'] as String?;
        }
      }

      return SocialSignInResult(
        userId: userData['id'] as String,
        email: userData['email'] as String?,
        fullName: userData['name'] as String?,
        photoUrl: photoUrl,
        accessToken: result.accessToken?.tokenString,
      );
    } catch (e) {
      print('Facebook Sign In Error: $e');
      return null;
    }
  }

  /// Đăng xuất Facebook
  Future<void> signOutFacebook() async {
    await _facebookAuth.logOut();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Common Methods
  // ─────────────────────────────────────────────────────────────────────────────

  /// Đăng xuất tất cả social accounts
  Future<void> signOutAll() async {
    await Future.wait([
      signOutGoogle(),
      signOutFacebook(),
      // Apple không cần sign out vì sử dụng credential
    ]);
  }
}
