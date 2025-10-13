import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignInSocial extends StatelessWidget {
  final VoidCallback onPressedFaceBook;
  final VoidCallback onPressedGoogle;
  final VoidCallback onPressedApple;

  const SignInSocial({
    super.key,
    required this.onPressedFaceBook,
    required this.onPressedGoogle,
    required this.onPressedApple,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        OutlinedButton(
          onPressed: () => onPressedFaceBook.call(),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          child: SvgPicture.asset("assets/facebook.svg"),
        ),
        OutlinedButton(
          onPressed: () => onPressedGoogle.call(),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          child: SvgPicture.asset("assets/google.svg"),
        ),
        if (Platform.isIOS)
          OutlinedButton(
            onPressed: () => onPressedApple.call(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            child: SvgPicture.asset("assets/apple.svg"),
          ),
      ],
    );
  }
}
