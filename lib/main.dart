import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Home/forgot_password.dart';
import 'notifications.dart';
import 'Home/signin.dart';
import 'Home/signup.dart';
import 'Home/splash.dart';
import 'Home/tabbar.dart';
import '/init.dart'
if (dart.library.html) 'web_init.dart'
if (dart.library.io) 'io_init.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await Firebase.initializeApp().then((_) {
    FirebaseFirestore.instance.settings =
    const Settings(persistenceEnabled: false);
  });
  runApp(const MyApp());
}


class AppLocalization {
  AppLocalization(this.locale);

  Locale? locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  late Map<String, String> _sentences;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString("assets/languages/languages-${locale!.languageCode}.json");
    Map<String, dynamic> _result = json.decode(jsonString);

    _sentences = {};
    _result.forEach((String key, dynamic value) {
      _sentences[key] = value.toString();
    });

    return true;
  }

  trans(String key) {
    return _sentences[key];
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = AppLocalization(locale);
    await localizations.load();

    if (kDebugMode) {
      print("Load ${locale.languageCode}");
    }

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
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
    //  Firebase.initializeApp();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale:_locale,

      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US')
      ],
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },
      title: 'login',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        primaryColor:  Colors.blue,
        backgroundColor: Colors.white,
        platform: TargetPlatform.android,
        fontFamily: 'NeoSansArabic', colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black,),
      ),
      initialRoute: "/Splash",
      onGenerateRoute: (settings) {
        final arguments = settings.arguments;
        switch (settings.name) {
          case '/Splash':
            return MaterialPageRoute(builder: (_) =>  const Splash());
          case '/SignIn':
            return MaterialPageRoute(builder: (_) =>  SignIn(message: arguments,));
          case '/SignUp':
            return MaterialPageRoute(builder: (_) =>  Signup());
          case '/ForgotPassword':
            return MaterialPageRoute(builder: (_) => ForgotPassword());
          case '/TabBarPage':
            return MaterialPageRoute(builder: (_) => TabBarPage(userType: arguments,));
          case '/Notification':
            return MaterialPageRoute(builder: (_) =>  const Notifications());
          default:
            return null;
        }
      },
    );
  }
}