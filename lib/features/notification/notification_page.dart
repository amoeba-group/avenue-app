import 'package:avenue/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 16),
            child: Text(
              "Thông báo",
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
