import 'package:avenue/home_screen.dart';
import 'package:flutter/material.dart';
import 'auth/auth_controller.dart';
import 'services/local_storage_service.dart';
import 'sign_in_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final AuthController authController = AuthController();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
  await Future.delayed(const Duration(milliseconds: 500));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GV Market',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: Color(0xFFFD7513),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder<bool>(
        future: LocalStorageService.getLoginStatus(),
        builder: (context, snapshot) {
          final isLoggedIn = snapshot.data ?? false;
          if (isLoggedIn) {
            return const HomeScreen();
          } else {
            return const SignInScreen();
          }
        },
      ),
      routes: {
        '/signIn': (context) => SignInScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
