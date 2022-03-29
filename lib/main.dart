import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Home/edit-password.dart';
import 'Home/edit-profile.dart';
import 'Home/forgot_password.dart';
import 'firebase_options.dart';
import 'io_init.dart';
import 'lang.dart';
import 'notifications.dart';
import 'Home/signin.dart';
import 'Home/signup.dart';
import 'Home/splash.dart';
import 'Home/tabbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsOnMobile || kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform).then((_) {
      FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
    });}
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: const [
            Locale("ar"),
            Locale("en", "US"),
          ],
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeListResolutionCallback: (deviceLocale, supportedLocales) {
            for (var local in supportedLocales) {
              if (local.languageCode == deviceLocale![0].languageCode) {
                return local;
              }
            }
            return supportedLocales.first;
          },
          title: 'login',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.white,
            primaryColorDark: Colors.black26,
            bottomAppBarColor: Colors.red,
            primaryColor: Colors.blue,
            backgroundColor: Colors.white,
            platform: TargetPlatform.android,
            fontFamily: 'NeoSansArabic',
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.black,
            ),
          ),
          initialRoute: "/Splash",
          onGenerateRoute: (settings) {
            final arguments = settings.arguments;
            switch (settings.name) {
              case '/Splash':
                return MaterialPageRoute(builder: (_) => const Splash());
              case '/SignIn':
                return MaterialPageRoute(
                    builder: (_) => SignIn(
                          message: arguments,
                        ));
              case '/SignUp':
                return MaterialPageRoute(builder: (_) => const Signup());
              case '/ForgotPassword':
                return MaterialPageRoute(builder: (_) => ForgotPassword());
              case '/TabBarPage':
                return MaterialPageRoute(
                    builder: (_) => TabBarPage(
                          userType: arguments,
                        ));
              case '/Notification':
                return MaterialPageRoute(builder: (_) => const Notifications());
              case '/EditProfile':
                return MaterialPageRoute(builder: (_) => const EditProfile());
              case '/EditPassword':
                return MaterialPageRoute(builder: (_) => EditPassword());
              default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                          body: Center(
                            child:
                                Text('No route defined for ${settings.name}'),
                          ),
                        ));
            }
          },
        ));
  }
}
