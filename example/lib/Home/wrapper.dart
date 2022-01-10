import 'package:flutter/material.dart';
import 'package:login/language.dart';
import 'package:login/user-model.dart';
import 'package:login_example/Home/signin.dart';
import 'package:login_example/Home/tabbar.dart';
import 'package:login/user_profile.dart';

import '../main.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
        future: UserProfile.shared.getUser(),
        builder: (context, snapshot) {

          Future.delayed(Duration.zero, () {

            UserProfile.shared.getLanguage().then((value) {
              MyApp.setLocale(context, Locale(value == Language.ARABIC ? "ar" : "en"));
            });

          });

          if (snapshot.hasData) {
            return TabBarPage(userType: snapshot.data!.userType);
          } else {
            return  const SignIn();
          }
        }
    );
  }
}

