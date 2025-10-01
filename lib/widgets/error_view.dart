import 'package:flutter/material.dart';

class ErrorView extends StatefulWidget {
  final VoidCallback action;
  const ErrorView({super.key, required this.action});

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        Text("Có lỗi xảy ra"),
        TextButton(
          onPressed: () => widget.action(),
          child: Text('Vui lòng thử lại'),
        ),
      ],
    );
  }
}
