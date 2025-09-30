import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuProfile extends StatelessWidget {
  final String ic;
  final String title;
  final VoidCallback action;
  final Color? color;

  const MenuProfile({
    super.key,
    required this.ic,
    required this.title,
    required this.action,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(),
      behavior: HitTestBehavior.translucent,
      child: Row(
        spacing: 20,
        children: [
          SvgPicture.asset(ic),
          Text(
            title,
            style: GoogleFonts.bricolageGrotesque(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: color ?? Color(0xff111526),
            ),
          ),
          Spacer(),
          SvgPicture.asset('assets/ic_arrow_right.svg'),
        ],
      ),
    );
  }
}
