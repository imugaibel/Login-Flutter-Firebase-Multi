import 'package:flutter/material.dart';
import 'package:login/language.dart';
import 'package:login/status.dart';
import 'package:login/user-model.dart';
import 'package:login/assets.dart';

import 'package:login/M.S.dart';
import '../main.dart';
import '../lang.dart';

import 'package:login/user_profile.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      _wrapper();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          Assets.shared.icLogo,
          width: 225,
          height: 225,
          fit: BoxFit.cover,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          AppLocalization.of(context)!.trans("M.S"),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 18),
        ),
      ),
    );
  }

  _wrapper() async {
       await UserProfile.shared.getLanguage().then((lang) {
         MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
       });

    UserModel? user = await UserProfile.shared.getUser();

    if (user != null) {
      FirebaseManager.shared.getUserByUid(uid: user.uid).then((user) {
        if (user.accountStatus == Status.ACTIVE) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/TabBarPage", (route) => false,
              arguments: user.userType);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/SignIn", (route) => false);
        }
      });
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil("/SignIn", (route) => false);
    }
  }
}
