import 'package:avenue/features/main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart';
import '../../widgets/custom_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
        child: Column(
          children: [
            Image.asset('assets/logo_gv.png', width: 150),
            SizedBox(height: 54),
            CustomTextField(
              labelText: S.of(context).full_name,
              controller: TextEditingController(),
            ),
            SizedBox(height: 16),
            CustomTextField(
              labelText: "Email",
              controller: TextEditingController(),
            ),
            SizedBox(height: 16),
            CustomTextField(
              labelText: S.of(context).password,
              controller: TextEditingController(),
            ),
            SizedBox(height: 32),
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: () {},
              child: Text(
                S.of(context).signup,
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w400,
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
                    text: S.of(context).you_have_account,
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },
                    text: " ${S.of(context).login}",
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                    ),
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
