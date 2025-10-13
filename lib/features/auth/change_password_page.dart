import 'package:avenue/features/main_screen.dart';
import 'package:avenue/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          S.of(context).change_password,
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
        padding: EdgeInsets.only(top: kToolbarHeight + 24, left: 16, right: 16),
        child: Column(
          children: [
            Image.asset('assets/logo_gv.png', width: 150),
            SizedBox(height: 54),
            CustomTextField(
              labelText: S.of(context).password,
              controller: TextEditingController(),
            ),
            SizedBox(height: 24),
            CustomTextField(
              labelText: S.of(context).confirm_password,
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
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const MainScreen(),
                  ),
                  ModalRoute.withName('/'),
                );
              },
              child: Text(
                S.of(context).confirm,
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
