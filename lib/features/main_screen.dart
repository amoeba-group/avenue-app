import 'package:avenue/features/bill/bill_page.dart';
import 'package:avenue/features/home/home_page.dart';
import 'package:avenue/features/notification/notification_page.dart';
import 'package:avenue/features/profile/profile_page.dart';
import 'package:avenue/widgets/bottom_nv_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../generated/l10n.dart';
import '../providers/language_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WebViewController buildController(String url) {
    final controller = WebViewController()
      ..setBackgroundColor(Colors.white)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            Uri uri = Uri.parse(url);
            String? lang = uri.queryParameters['lang'];
            if (lang != null) {
              context.read<LanguageProvider>().saveLocale(Locale(lang));
            }
          },
          onPageFinished: (url) {
            debugPrint("Finished: $url");
          },
          onWebResourceError: (error) {
            debugPrint("Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    return controller;
  }

  String lang = 'en';
  int currentIndex = 0;

  void _changeLang(String newLang) {
    setState(() {
      lang = newLang;
    });
  }

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
