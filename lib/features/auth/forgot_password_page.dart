import 'package:avenue/features/auth/change_password_page.dart';
import 'package:avenue/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          S.of(context).forgot_password,
          style: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: kToolbarHeight, left: 16, right: 16),
        child: Column(
          children: [
            Image.asset('assets/logo_gv.png', width: 150),
            SizedBox(height: 54),
            CustomTextField(
              labelText: "Email",
              controller: TextEditingController(),
              onChanged: (String p1) {},
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              child: Text(
                S.of(context).txt_continue,
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
