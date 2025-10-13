import 'package:avenue/features/auth/login_page.dart';
import 'package:avenue/features/profile/widgets/menu_profile.dart';
import 'package:avenue/services/local_storage_service.dart';
import 'package:avenue/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../widgets/custom_appbar.dart';
import '../auth/change_password_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).account,
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: FutureBuilder(
                future: LocalStorageService.read(keyEmail),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? "",
                    style: GoogleFonts.bricolageGrotesque(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),
            ),
            Text(
              "(+84) 0334542911",
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Color(0xff292D32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        S.of(context).change_password,
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      onPressed: () {
                        AppUtils.showConfirmationDialog(
                          context,
                          title: S.of(context).title,
                          confirmText: S.of(context).confirm,
                          message: S.of(context).confirm_sign_out,
                          cancelText: S.of(context).cancel,
                          onConfirm: () {
                            _logOut(context);
                          },
                        );
                      },
                      child: Text(
                        S.of(context).sign_out,
                        style: GoogleFonts.bricolageGrotesque(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 34, bottom: 20),
              child: MenuProfile(
                ic: "assets/ic_term.svg",
                title: S.of(context).terms_of_service,
                action: () =>
                    AppUtils.openUrl("https://gvmarket.vn/dieukiengiaodich"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MenuProfile(
                ic: "assets/ic_term.svg",
                title: S.of(context).privacy_policies,
                action: () => AppUtils.openUrl(
                  "https://gvmarket.vn/chinh-sach-thanh-toan",
                ),
              ),
            ),
            Text(
              S.current.contact,
              style: GoogleFonts.bricolageGrotesque(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color(0xff292D32),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).address,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).info_address,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).phone,
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                    TextSpan(
                      text: "+84 000 0000 000",
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Email: ",
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                    TextSpan(
                      text: "brandnewk.marketing@gmail.com",
                      style: GoogleFonts.bricolageGrotesque(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(0xff292D32),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MenuProfile(
              ic: "assets/ic_delete.svg",
              title: S.of(context).delete_account,
              color: Color(0xffED1C24),
              action: () {
                AppUtils.showConfirmationDialog(
                  context,
                  title: S.of(context).title,
                  message: S.of(context).confirm_delete_account,
                  confirmText: S.of(context).confirm,
                  cancelText: S.of(context).cancel,
                  onConfirm: () {
                    _logOut(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _logOut(BuildContext context) {
    LocalStorageService.clear("is_logged_in");
    LocalStorageService.clear("device_token");
    LocalStorageService.clear("device_token");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
