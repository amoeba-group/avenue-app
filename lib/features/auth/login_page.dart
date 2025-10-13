import 'package:avenue/features/auth/forgot_password_page.dart';
import 'package:avenue/features/auth/signup_page.dart';
import 'package:avenue/features/main_screen.dart';
import 'package:avenue/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';
import '../../services/local_storage_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sign_in_social.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.paddingOf(context).top + kToolbarHeight + 44,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Image.asset('assets/logo_gv.png', width: 150),
            SizedBox(height: 54),
            CustomTextField(
              labelText: "Email",
              controller: TextEditingController(),
            ),
            SizedBox(height: 24),
            CustomTextField(
              labelText: S.of(context).password,
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
                  S.of(context).forgot_password,
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Colors.black,
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
                S.of(context).login,
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
                    text: S.of(context).dont_have_account,
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    recognizer: _signUpRecognizer,
                    text: " ${S.of(context).signup}",
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
                    S.of(context).or_login_with,
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
            SignInSocial(
              onPressedFaceBook: () async {
                final result = await authController.signFacebook();
                if (result && context.mounted) {
                  navigateToHomeScreen(context);
                }
              },
              onPressedGoogle: () async {
                final result = await authController.signInGoogle();
                if (result && context.mounted) {
                  navigateToHomeScreen(context);
                }
              },
              onPressedApple: () async {
                final result = await authController.signAppleId();
                if (result && context.mounted) {
                  navigateToHomeScreen(context);
                }
              },
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
