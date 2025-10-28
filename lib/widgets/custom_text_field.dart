import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;


  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 16),
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: GoogleFonts.bricolageGrotesque(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
