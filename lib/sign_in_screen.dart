import 'dart:developer';
import 'package:avenue/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: 54, left: 16, right: 16),
        child: Column(
          spacing: 16,
          children: [
            SignInWithAppleButton(
              onPressed: () async {
                final credential = await SignInWithApple.getAppleIDCredential(
                  scopes: [
                    AppleIDAuthorizationScopes.email,
                    AppleIDAuthorizationScopes.fullName,
                  ],
                );

                log(credential.toString());
              },
            ),
            MaterialButton(
              onPressed: () async {
                final result = await getGoogleAccount();
                if (result != null && context.mounted) {
                  LocalStorageService.saveLoginStatus(true);
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: Text('Sign In Google'),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];

final _googleSignIn = GoogleSignIn.instance;
bool _isGoogleSignInInitialized = false;

Future<void> _initializeGoogleSignIn() async {
  try {
    await _googleSignIn.initialize();
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

Future<GoogleSignInAccount?> getGoogleAccount() async {
  await _ensureGoogleSignInInitialized();
  GoogleSignInAccount? account;
  try {
    account = await _googleSignIn.authenticate(scopeHint: scopes);
    return account;
  } on GoogleSignInException catch (e) {
    log('Google Sign In error:\n$e');
    return null;
  } catch (error) {
    log('Unexpected Google Sign-In error: $error');
    return null;
  }
}
