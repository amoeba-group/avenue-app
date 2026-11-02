import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../generated/l10n.dart';
import '../../../../providers/authentication_provider.dart';
import '../../../../widgets/custom_text_field.dart';

class InputFullName extends StatelessWidget {
  const InputFullName({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, controller, child) {
        return CustomTextField(
          labelText: S.of(context).full_name,
          controller: controller.fullNameController,
          onChanged: controller.onChangedFullName,
        );
      },
    );
  }
}
