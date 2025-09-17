import 'dart:io';
import 'home_screen.dart';
import 'package:avenue/main.dart';
import 'package:flutter/material.dart';
import 'package:avenue/widgets/button_login.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 54, left: 16, right: 16),
        child: Column(
          spacing: 16,
          children: [
            const Text(
              'Welcome to GV Market',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Image.asset('assets/logo_new.jpg', width: 200, height: 200),
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
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
