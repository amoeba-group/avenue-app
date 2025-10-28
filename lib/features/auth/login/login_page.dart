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
import '../../../widgets/sign_in_social.dart';
import 'package:avenue/features/auth/forgot_password_page.dart';
import 'package:avenue/features/auth/register/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthenticationProvider>(
      create: (context) => AuthenticationProvider(
        context,
        context.read(),
        AuthenticationType.login,
        context.read(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<AuthenticationProvider>(
          builder: (context, controller, child) {
            return LoadingOverlay(
              isLoading: controller.isLoading,
              color: Colors.black.withOpacity(0.5),
              progressIndicator: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.paddingOf(context).top + kToolbarHeight + 44,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/logo_gv.png', width: 150),
                    SizedBox(height: 54),
                    EmailInput(),
                    SizedBox(height: 24),
                    PassWordInput(),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
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
                    AuthenticationButton(
                      text: S.of(context).login,
                      type: AuthenticationType.login,
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
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpPage(),
                                  ),
                                );
                              },
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
                      onPressedFaceBook: () => context
                          .read<AuthenticationProvider>()
                          .signInFacebook(),
                      onPressedGoogle: () =>
                          context.read<AuthenticationProvider>().signInGoogle(),
                      onPressedApple: () =>
                          context.read<AuthenticationProvider>().signAppleId(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
