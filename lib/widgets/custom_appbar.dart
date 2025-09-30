import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    String lang = context.watch<LanguageProvider>().locale.languageCode;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: SvgPicture.asset("assets/logo.svg", width: 146, height: 32,),
      ),
      leadingWidth: 154,
      actionsPadding: EdgeInsets.only(right: 16),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: (details) {
              _showPopUpMenu(details.globalPosition);
            },
            child: Row(
              spacing: 4,
              children: [
                Text(
                  lang.toUpperCase(),
                  style: GoogleFonts.bricolageGrotesque(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SvgPicture.asset("assets/ic_language.svg"),
                SvgPicture.asset("assets/ic_arrow_down.svg"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showPopUpMenu(Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    double left = offset.dx;
    double top = offset.dy;
    double right = screenSize.width - offset.dx;
    double bottom = screenSize.height - offset.dy;
    await showMenu<MenuItemType>(
      context: context,
      constraints: BoxConstraints(maxWidth: 64, minWidth: 64),
      position: RelativeRect.fromLTRB(left, top + 28, 16, bottom),
      items: MenuItemType.values
          .map(
            (MenuItemType menuItemType) => PopupMenuItem<MenuItemType>(
              value: menuItemType,
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: ClipOval(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      getMenuItemString(menuItemType),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    ).then((MenuItemType? item) {
      if (item == MenuItemType.vi) {
        changeLanguage(Locale("vi"));
      } else if (item == MenuItemType.us) {
        changeLanguage(Locale("en"));
      } else if (item == MenuItemType.ko) {
        changeLanguage(Locale("ko"));
      }
    });
  }

  void changeLanguage(Locale locale) {
    context.read<LanguageProvider>().saveLocale(locale);
  }
}

enum MenuItemType { vi, us, ko }

String getMenuItemString(MenuItemType menuItemType) {
  switch (menuItemType) {
    case MenuItemType.vi:
      return "assets/vn.svg";
    case MenuItemType.us:
      return "assets/us.svg";
    case MenuItemType.ko:
      return "assets/kr.svg";
  }
}
