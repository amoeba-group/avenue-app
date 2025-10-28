import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/authentication_provider.dart';

enum AuthenticationType { login, register }

class AuthenticationButton extends StatelessWidget {
  final String text;
  final AuthenticationType type;
  const AuthenticationButton({
    super.key,
    required this.text,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, controller, child) {
        return Stack(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 52),
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(controller.isLoggedIn ? 1 : 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              onPressed: controller.isLoggedIn
                  ? () {
                      if (type == AuthenticationType.login) {
                        controller.login();
                      } else {
                        controller.register();
                      }
                    }
                  : null,
              child: controller.isLoading
                  ? SizedBox.shrink()
                  : Text(
                      text,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
            controller.isLoading
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: (8)),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        constraints: BoxConstraints(
                          minWidth: 34,
                          minHeight: 34,
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
