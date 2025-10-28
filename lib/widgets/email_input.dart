import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../providers/authentication_provider.dart';
import '../../../../widgets/custom_text_field.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, controller, child) {
        return CustomTextField(
          labelText: "Email",
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          onChanged: controller.onChangedEmail,
        );
      },
    );
  }
}
