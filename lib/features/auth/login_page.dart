import 'dart:io';
import 'package:avenue/features/auth/forgot_password_page.dart';
import 'package:avenue/features/auth/signup_page.dart';
import 'package:avenue/features/main_screen.dart';
import 'package:avenue/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:avenue/widgets/button_login.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      };
  }

  @override
  void dispose() {
    _signUpRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + kToolbarHeight + 44,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Image.asset('assets/logo_gv.png', width: 150),
            SizedBox(height: 24),
            CustomTextField(
              labelText: "Email",
              controller: TextEditingController(),
            ),
            SizedBox(height: 16),
            CustomTextField(
              labelText: "Password",
              controller: TextEditingController(),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                );
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Forgot password",
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {
                LocalStorageService.saveLoginStatus(true);
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const MainScreen(),
                  ),
                );
              },
              child: Text(
                "Login",
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    recognizer: _signUpRecognizer,
                    text: "Sign up",
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OR",
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 24),
            Center(
              child: Row(
                spacing: 16,
                children: [
                  Visibility(
                    visible: Platform.isIOS,
                    child: ButtonLogin(
                      ic: "",
                      title: "Apple Id",
                      action: () async {
                        final result = await authController.signAppleId();
                        if (result && context.mounted) {
                          navigateToHomeScreen(context);
                        }
                      },
                    ),
                  ),
                  ButtonLogin(
                    ic: "",
                    title: "Google",
                    action: () async {
                      final result = await authController.signInGoogle();
                      if (result && context.mounted) {
                        navigateToHomeScreen(context);
                      }
                    },
                  ),
                  ButtonLogin(
                    ic: "",
                    title: "Facebook",
                    action: () async {
                      final result = await authController.signFacebook();
                      if (result && context.mounted) {
                        navigateToHomeScreen(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}
