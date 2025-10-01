import 'package:avenue/features/auth/login_page.dart';
import 'package:avenue/features/profile/widgets/menu_profile.dart';
import 'package:avenue/services/local_storage_service.dart';
import 'package:avenue/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/constants.dart';
import '../../widgets/custom_appbar.dart';

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
              "Tài khoản",
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
                      onPressed: () {},
                      child: Text(
                        "Change Password",
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
                          title: "Thông báo",
                          message: "Bạn có chắc chắn muốn đăng xuất không?",
                          onConfirm: () {
                            _logOut(context);
                          },
                        );
                      },
                      child: Text(
                        "Sign out",
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
                title: "Terms of Service",
                action: () =>
                    AppUtils.openUrl("https://gvmarket.vn/dieukiengiaodich"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MenuProfile(
                ic: "assets/ic_term.svg",
                title: "Privacy Policies",
                action: () => AppUtils.openUrl(
                  "https://gvmarket.vn/chinh-sach-thanh-toan",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: MenuProfile(
                ic: "assets/ic_contact.svg",
                title: "Contact us",
                action: () {},
              ),
            ),
            MenuProfile(
              ic: "assets/ic_delete.svg",
              title: "Delete account",
              color: Color(0xffED1C24),
              action: () {
                AppUtils.showConfirmationDialog(
                  context,
                  title: "Thông báo",
                  message: "Bạn có chắc chắn muốn xóa tài khoản không?",
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
