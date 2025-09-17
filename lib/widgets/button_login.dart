import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final String ic;
  final String title;
  final VoidCallback action;

  const ButtonLogin({
    super.key,
    required this.ic,
    required this.title,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        onPressed: () => action.call(),
        child: Text(title),
      ),
    );
  }
}
