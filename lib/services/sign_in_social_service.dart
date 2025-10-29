import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constants/constants.dart';

class SignInSocialService {
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(serverClientId: serverClientId);
      _isGoogleSignInInitialized = true;
    } catch (e) {
      log('Failed to initialize Google Sign-In: $e');
    }
  }

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<GoogleSignInAccount?> signInGoogle(BuildContext context) async {
    await _ensureGoogleSignInInitialized();
    try {
      GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );
      return account;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        log('Login cancelled by user ${e.code} - ${e.description}');
      } else {
        log('Google Sign-In error: $e');
      }
    } catch (error) {
      log('Unexpected Google Sign-In error: $error');
    }
    return null;
  }

  Future<LoginResult?> signFacebook(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      return result;
    } else {
      return null;
    }
  }

  Future<AuthorizationCredentialAppleID> signAppleId(
    BuildContext context,
  ) async {
    return await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
  }

  void signOut() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
}
