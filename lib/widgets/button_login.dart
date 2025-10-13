import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback action;

  const ButtonLogin({
    super.key,
    required this.color,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: () => action.call(),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
