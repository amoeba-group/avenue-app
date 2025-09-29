import 'package:avenue/features/auth/login_page.dart';
import 'package:avenue/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'auth/auth_controller.dart';
import 'features/main_screen.dart';
import 'generated/l10n.dart';
import 'services/local_storage_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final AuthController authController = AuthController();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
  await Future.delayed(const Duration(milliseconds: 500));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider(),
      child: Builder(
        builder: (context) {
          final language = context.watch<LanguageProvider>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GV Market',
            theme: ThemeData(
              useMaterial3: false,
              primaryColor: Color(0xFFFC9501),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: AppBarTheme(backgroundColor: Color(0xFFFC9501)),
            ),
            locale: language.locale,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale("vi"), Locale("en"), Locale("ko")],
            home: FutureBuilder<bool>(
              future: LocalStorageService.getLoginStatus(),
              builder: (context, snapshot) {
                final isLoggedIn = snapshot.data ?? true;
                if (isLoggedIn) {
                  return const MainScreen();
                } else {
                  return const MainScreen();
                }
              },
            ),
            routes: {
              '/login': (context) => LoginPage(),
              '/main': (context) => MainScreen(),
            },
          );
        },
      ),
    );
  }
}
