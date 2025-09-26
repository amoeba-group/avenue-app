import 'package:avenue/features/bill/bill_page.dart';
import 'package:avenue/features/home/home_page.dart';
import 'package:avenue/features/notification/notification_page.dart';
import 'package:avenue/features/profile/profile_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final List<Widget> _screens = [
    HomePage(),
    NotificationPage(),
    BillPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Screen')),
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height:
            kBottomNavigationBarHeight +
            MediaQuery.paddingOf(context).bottom +
            (kDebugMode ? 16 : 0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    index = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: <Widget>[
                    SvgPicture.asset("assets/ic_home.svg"),
                    Text("Home"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: <Widget>[
                    SvgPicture.asset("assets/ic_notification.svg"),
                    Text("Notifications"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: <Widget>[
                    SvgPicture.asset("assets/ic_billing.svg"),
                    Text("Billing"),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: <Widget>[
                    SvgPicture.asset("assets/ic_profile.svg"),
                    Text("Profile"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
