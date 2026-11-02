import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomNvItem extends StatelessWidget {
  final String ic;
  const BottomNvItem({super.key, required this.ic});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SvgPicture.asset(ic),
    );
  }
}