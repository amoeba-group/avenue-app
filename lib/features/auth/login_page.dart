import 'dart:io';
import 'package:avenue/features/main_screen.dart';
import 'package:avenue/main.dart';
import 'package:flutter/material.dart';
import 'package:avenue/widgets/button_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 54, left: 16, right: 16),
        child: Column(
          spacing: 16,
          children: [
            Image.asset('assets/ic_logo.png', width: 200, height: 200),
            SizedBox(height: 34),
            Row(
              spacing: 16,
              children: [
                Visibility(
                  visible: Platform.isIOS,
                  child: ButtonLogin(
                    ic: "",
                    title: "Apple Id",
                    action: () async {
                      final result = await authController.signAppleId();
                      if (result) {
                        navigateToHomeScreen();
                      }
                    },
                  ),
                ),
                ButtonLogin(
                  ic: "",
                  title: "Google",
                  action: () async {
                    final result = await authController.signInGoogle();
                    if (result) {
                      navigateToHomeScreen();
                    }
                  },
                ),
                ButtonLogin(
                  ic: "",
                  title: "Facebook",
                  action: () async {
                    final result = await authController.signFacebook();
                    if (result) {
                      navigateToHomeScreen();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }
}
