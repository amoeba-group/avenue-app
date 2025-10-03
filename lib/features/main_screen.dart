import 'package:avenue/features/bill/bill_page.dart';
import 'package:avenue/features/home/home_page.dart';
import 'package:avenue/features/notification/notification_page.dart';
import 'package:avenue/features/profile/profile_page.dart';
import 'package:avenue/widgets/bottom_nv_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../generated/l10n.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomePage(lang: lang,),
          NotificationPage(),
          BillPage(lang: lang),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Color(0xFF212121),
          selectedItemColor: Theme.of(context).primaryColor,
          selectedLabelStyle: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.bricolageGrotesque(
            fontWeight: FontWeight.normal,
          ),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: BottomNvItem(ic: "assets/ic_home.svg"),
              activeIcon: BottomNvItem(ic: "assets/ic_selected_home.svg"),
              label: S.of(context).tab_home,
            ),
            BottomNavigationBarItem(
              icon: BottomNvItem(ic: "assets/ic_notification.svg"),
              activeIcon: BottomNvItem(
                ic: "assets/ic_selected_notification.svg",
              ),
              label: S.of(context).tab_notification,
            ),
            BottomNavigationBarItem(
              icon: BottomNvItem(ic: "assets/ic_billing.svg"),
              activeIcon: BottomNvItem(ic: "assets/ic_selected_billing.svg"),
              label: S.of(context).tab_billing,
            ),
            BottomNavigationBarItem(
              icon: BottomNvItem(ic: "assets/ic_profile.svg"),
              activeIcon: BottomNvItem(ic: "assets/ic_selected_profile.svg"),
              label: S.of(context).tab_profile,
            ),
          ],
        ),
      ),
    );
  }
}
