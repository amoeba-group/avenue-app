import 'package:avenue/utils/app_utils.dart';
import 'package:flutter/material.dart';
import '../error/app_exception.dart';
import '../features/main_screen.dart';
import '../services/local_storage_service.dart';
import '../widgets/authentication_button.dart';
import 'package:avenue/repository/authentication_repository.dart';

class AuthenticationProvider with ChangeNotifier {
  final BuildContext context;
  final AuthenticationRepository _authenticationRepository;
  final AuthenticationType type;

  AuthenticationProvider(
    this.context,
    this._authenticationRepository,
    this.type,
  );

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void login() async {
    try {
      _isLoading = true;
      notifyListeners();
      final result = await _authenticationRepository.login(
        emailController.text,
        passwordController.text,
      );
      if (result) {
        onGotoHome();
      }
    } on AppException catch (e) {
      _showError(e.message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void register() async {
    try {
      _isLoading = true;
      notifyListeners();
      final result = await _authenticationRepository.register(
        emailController.text,
        passwordController.text,
      );
      if (result) {
        onGotoHome();
      }
    } on AppException catch (e) {
      _showError(e.message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _showError(String mgs) {
    AppUtils.showErrorDialog(context, message: mgs);
  }

  void onGotoHome() {
    LocalStorageService.saveLoginStatus(true);
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MainScreen(),
      ),
    );
  }

  void onChangedObscureText() {
    _obscureText = !_obscureText;
    isLoggedIn;
    notifyListeners();
  }

  void onChangedFullName(String fullName) {
    fullNameController.text = fullName;
    isLoggedIn;
    notifyListeners();
  }

  void onChangedEmail(String email) {
    emailController.text = email;
    isLoggedIn;
    notifyListeners();
  }

  void onChangedPassword(String password) {
    passwordController.text = password;
    notifyListeners();
  }

  bool get isLoggedIn {
    if (type == AuthenticationType.login) {
      return emailController.text.isNotEmpty &&
          isValidEmail(emailController.text) &&
          passwordController.text.isNotEmpty;
    } else {
      return fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          isValidEmail(emailController.text) &&
          passwordController.text.isNotEmpty;
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
