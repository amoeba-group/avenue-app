import 'dart:async';
import 'config/env_config.dart';
import 'generated/l10n.dart';
import 'package:flutter/material.dart';
import 'features/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'services/client_service.dart';
import 'services/local_storage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:avenue/features/auth/login/login_page.dart';
import 'package:avenue/providers/language_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:avenue/managers/firebase_messaging_manager.dart';
import 'package:avenue/repository/notification_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:avenue/repository/authentication_repository.dart';
import 'package:avenue/services/sign_in_social_service.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await EnvConfig().init();
      await Firebase.initializeApp();
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        kReleaseMode,
      );
      Provider.debugCheckInvalidValueType = null;
      runApp(MyApp());
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
        Provider(create: (context) => ClientService(), lazy: true),
        Provider(create: (context) => SignInSocialService(), lazy: true),
        Provider(create: (context) => NotificationRepository(), lazy: true),
        Provider(
          create: (context) => AuthenticationRepository(context.read()),
          lazy: true,
        ),
        Provider(create: (context) => FirebaseMessagingManager(context.read())),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) => LanguageProvider(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final language = context.watch<LanguageProvider>();
          print('-----> ${language.locale.languageCode}');
          return MaterialApp(
            key: navigatorKey,
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
                if (snapshot.hasData) {
                  final isLoggedIn = snapshot.data ?? false;
                  if (isLoggedIn) {
                    return const MainScreen();
                  } else {
                    return const LoginPage();
                  }
                }
                return Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: SvgPicture.asset("assets/ic_logo.svg"),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
