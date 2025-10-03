import 'dart:async';
import 'package:avenue/managers/firebase_messaging_manager.dart';
import 'package:avenue/repository/notification_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'auth/auth_controller.dart';
import 'features/main_screen.dart';
import 'generated/l10n.dart';
import 'package:avenue/features/auth/login_page.dart';
import 'package:avenue/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/local_storage_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final AuthController authController = AuthController();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      Provider.debugCheckInvalidValueType = null;
      runApp(MyApp());
      await Future.delayed(const Duration(milliseconds: 500));
      FlutterNativeSplash.remove();
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => NotificationRepository(), lazy: true),
        Provider(create: (context) => FirebaseMessagingManager(context.read())),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
      ],
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
                final isLoggedIn = snapshot.data ?? false;
                if (isLoggedIn) {
                  return const MainScreen();
                } else {
                  return const LoginPage();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
