import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:avenue/constants/constants.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../services/local_storage_service.dart';

class AuthController {
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId:
            "1092035910524-73uf4vbonjh8roto3jip8dbrcn2hrduc.apps.googleusercontent.com",
      );
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

  Future<bool> signInGoogle() async {
    await _ensureGoogleSignInInitialized();
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate(scopeHint: scopes);
      LocalStorageService.save(keyEmail, account.email);
      LocalStorageService.saveLoginStatus(true);
      return true;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        log('Login cancelled by user ${e.code} - ${e.description}');
        return false;
      } else {
        log('Google Sign-In error: $e');
        return false;
      }
    } catch (error) {
      log('Unexpected Google Sign-In error: $error');
      return false;
    }
  }

  Future<bool> signAppleId() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    LocalStorageService.save(keyEmail, credential.email ?? "");
    LocalStorageService.saveLoginStatus(true);
    return true;
  }


  Future<bool> signFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      if (Platform.isIOS) {
        LimitedToken limitedToken = result.accessToken as LimitedToken;
        saveUser(limitedToken.userEmail ?? "");
      } else {
        //AccessToken? accessToken = result.accessToken;
        //_printCredentials();
        final userData = await FacebookAuth.instance.getUserData();
        String id = userData["id"];
        String name = userData["name"];
        String? email = userData["email"];
        saveUser(email ?? "");
      }
      return true;
    } else {
      print(result.status);
      print(result.message);
      return false;
    }
  }

  void saveUser(String email) {
    LocalStorageService.save(keyEmail, email);
    LocalStorageService.saveLoginStatus(true);
  }

  // void _printCredentials() {
  //   print(prettyPrint(_accessToken!.toJson()));
  // }

  String prettyPrint(Map json) {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String pretty = encoder.convert(json);
    return pretty;
  }
}
