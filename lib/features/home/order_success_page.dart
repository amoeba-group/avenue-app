import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Center(
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 100, color: Colors.green),
              Text(
                S.of(context).payment_success_title,
                style: GoogleFonts.bricolageGrotesque(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.of(context).btn_back_home,
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFFFC9501),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
