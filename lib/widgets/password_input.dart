import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../../providers/authentication_provider.dart';
import '../../../../widgets/custom_text_field.dart';

class PassWordInput extends StatelessWidget {
  const PassWordInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, controller, child) {
        return CustomTextField(
          labelText: S.of(context).password,
          obscureText: controller.obscureText,
          controller: controller.passwordController,
          onChanged: controller.onChangedPassword,
          suffixIcon: InkWell(
            onTap: () {
              controller.onChangedObscureText();
            },
            child: Icon(
              controller.obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
