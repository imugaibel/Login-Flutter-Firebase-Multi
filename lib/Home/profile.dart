import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../M.S.dart';
import '../lang.dart';
import '../language.dart';
import '../main.dart';
import '../notification.dart';
import '../profile.dart';
import '../user-model.dart';
import '../user-type.dart';
import '../user_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<ProfileList> items = [
    ProfileList.ABOUT_US,
    ProfileList.CHANGE_LANGUAGE,
    ProfileList.EDIT_PROFILE,
    ProfileList.EDIT_PASSWORD,
    ProfileList.PRIVACY_TERMS,
    ProfileList.CONTACT_US,
    ProfileList.LOGOUT
  ];

  Future<UserModel?> user = UserProfile.shared.getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(AppLocalization.of(context)!.trans("Profile"), style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: false,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      body: FutureBuilder<UserModel?>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel? user = snapshot.data;
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: user!.image != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(user.image),
                                          fit: BoxFit.cover)),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 52,
                                  color: Theme.of(context).accentColor,
                                ),
                          radius: 50,
                          backgroundColor: const Color(0xFFF0F4F8),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.userType == UserType.ADMIN
                                  ? AppLocalization.of(context)!.trans("ADMIN")
                                  : AppLocalization.of(context)!.trans("USER"),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.height * (40 / 812)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return _item(context,
                              item: items[index],
                              isLast: index == (items.length - 1));
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Widget _item(context, {required ProfileList item, bool isLast = false}) {
    String? title;
    String? screen;

    switch (item) {
      case ProfileList.ABOUT_US:
        title = "About us";
        screen = "/AboutUs";
        break;
      case ProfileList.CHANGE_LANGUAGE:
        title = "Change Language";
        break;
      case ProfileList.EDIT_PROFILE:
        title = "Edit Profile";
        screen = "/EditProfile";
        break;
      case ProfileList.EDIT_PASSWORD:
        title = "Edit Password";
        screen = "/EditPassword";
        break;
      case ProfileList.PRIVACY_TERMS:
        title = "Privacy Terms";
        screen = "/PrivacyTerms";
        break;
      case ProfileList.CONTACT_US:
        title = "Contact US";
        screen = "/ContactUs";
        break;
      case ProfileList.LOGOUT:
        title = "Logout";
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () async {
          if (item == ProfileList.CHANGE_LANGUAGE) {
            changeLanguage(context);
          } else if (item == ProfileList.LOGOUT) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(AppLocalization.of(context)!.trans("Logout")),
                content: Text(AppLocalization.of(context)!
                    .trans("Are you sure to logout?")),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => FirebaseManager.shared.signOut(context),
                    child: Text(AppLocalization.of(context)!.trans("Logout")),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalization.of(context)!.trans("Close")),
                  ),
                ],
              ),
            );
          } else {
            await Navigator.of(context).pushNamed(screen!);
            setState(() {
              user = UserProfile.shared.getUser();
            });
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalization.of(context)!.trans(title),
                  style: TextStyle(
                      color:
                      isLast ? Theme.of(context).bottomAppBarColor : Theme.of(context).primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  changeLanguage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  //              child: SvgPicture.asset(Assets.shared.icEnglish),
                ),
                title: const Text('English'),
                onTap: () => _changeLanguage(context, lang: Language.ENGLISH),
              ),
              ListTile(
                leading: Container(
                  width: 35,
                  height: 35,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  //               child: SvgPicture.asset(Assets.shared.icArabic),
                ),
                title: const Text('عربي'),
                onTap: () => _changeLanguage(context, lang: Language.ARABIC),
              ),
            ],
          );
        });
  }

  _changeLanguage(context, {required Language lang}) async {
    MyApp.setLocale(context, Locale(lang == Language.ARABIC ? "ar" : "en"));
    await UserProfile.shared.setLanguage(language: lang);
    Navigator.of(context).pop();
  }
}