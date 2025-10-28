import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import '../../../generated/l10n.dart';
import '../../../providers/authentication_provider.dart';
import '../../../widgets/authentication_button.dart';
import '../../../widgets/email_input.dart';
import '../../../widgets/password_input.dart';
import 'widgets/input_full_name.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationProvider>(
      create: (context) => AuthenticationProvider(
        context,
        context.read(),
        AuthenticationType.register,
        null,
      ),
      child: Consumer<AuthenticationProvider>(
        builder: (context, controller, child) {
          return LoadingOverlay(
            isLoading: controller.isLoading,
            color: Colors.black.withOpacity(0.5),
            progressIndicator: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: kToolbarHeight,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/logo_gv.png', width: 150),
                    SizedBox(height: 54),
                    InputFullName(),
                    SizedBox(height: 16),
                    EmailInput(),
                    SizedBox(height: 16),
                    PassWordInput(),
                    SizedBox(height: 34),
                    AuthenticationButton(
                      text: S.of(context).signup,
                      type: AuthenticationType.register,
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
            ),
          );
        }
      ),
    );
  }
}
