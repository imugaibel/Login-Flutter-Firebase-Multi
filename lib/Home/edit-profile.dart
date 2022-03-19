import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/extensions.dart';

import '../M.S.dart';
import '../input_style.dart';
import '../loader.dart';
import '../lang.dart';
import '../user-model.dart';
import '../user_profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey();

  File? _imagePerson;
  String? name;
  String? city;
  String? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            AppLocalization.of(context)!.trans("Edit Profile"),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(children: [
                  Center(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: FutureBuilder<UserModel?>(
                            future: UserProfile.shared.getUser(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserModel? user = snapshot.data;

                                return Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CircleAvatar(
                                            child: _imagePerson != null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                _imagePerson!),
                                                            fit: BoxFit.cover)),
                                                  )
                                                : user!.image.isURL()
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    user.image),
                                                                fit: BoxFit
                                                                    .cover)),
                                                      )
                                                    : Icon(
                                                        Icons.person,
                                                        size: 52,
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                      ),
                                            radius: 50,
                                            backgroundColor:
                                                const Color(0xFFF0F4F8),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 5,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _selectImgDialog(context),
                                              child: CircleAvatar(
                                                child: const Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.white,
                                                ),
                                                radius: 15,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              (100 / 812)),
                                      TextFormField(
                                        initialValue: user!.name,
                                        onSaved: (value) =>
                                            name = value!.trim(),
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        decoration: customInputForm
                                            .copyWith(
                                              prefixIcon: Icon(
                                                Icons.person_outline,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                            .copyWith(
                                                hintText:
                                                    AppLocalization.of(context)!
                                                        .trans("Name")),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        initialValue: user.city,
                                        onSaved: (value) =>
                                            city = value!.trim(),
                                        textInputAction: TextInputAction.next,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        decoration: customInputForm
                                            .copyWith(
                                              prefixIcon: Icon(
                                                Icons.location_city_outlined,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                            .copyWith(
                                                hintText:
                                                    AppLocalization.of(context)!
                                                        .trans("City")),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      TextFormField(
                                        initialValue: user.phone,
                                        onSaved: (value) =>
                                            phone = value!.trim(),
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.done,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).accentColor,
                                        ),
                                        decoration: customInputForm
                                            .copyWith(
                                              prefixIcon: Icon(
                                                Icons.phone_outlined,
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                            )
                                            .copyWith(
                                                hintText:
                                                    AppLocalization.of(context)!
                                                        .trans("Phone Number")),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              (100 / 812)),
                                      RaisedButton(
                                          color: Theme.of(context).accentColor,
                                          child: Text(
                                              AppLocalization.of(context)!
                                                  .trans("Edit Profile"),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              )),
                                          onPressed: () =>
                                              _btnEdit(imgURL: user.image)),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Center(child: loader(context));
                              }
                            }),
                      ),
                    ),
                  )
                ]))));
  }

  _selectImgDialog(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(
                      AppLocalization.of(context)!.trans('Image form camera')),
                  onTap: () => _selectImage(type: ImageSource.camera)),
              ListTile(
                leading: const Icon(Icons.image),
                title: Text(
                    AppLocalization.of(context)!.trans('Image from gallery')),
                onTap: () => _selectImage(type: ImageSource.gallery),
              ),
            ],
          );
        });
  }

  _selectImage({required ImageSource type}) async {
    PickedFile? image = await ImagePicker.platform.pickImage(source: type);
    setState(() {
      _imagePerson = File(image!.path);
    });

    Navigator.of(context).pop();
  }

  bool _validation() {
    return !(name == "" || city == "" || phone == "");
  }

  _btnEdit({required String imgURL}) {
    _formKey.currentState!.save();

    String image = "";

    if (_imagePerson != null) {
      image = _imagePerson!.path;
    } else {
      image = imgURL;
    }

    if (_validation()) {
      FirebaseManager.shared.updateAccount(
          scaffoldKey: _scaffoldKey,
          image: image,
          name: name!,
          city: city!,
          phoneNumber: phone!);
    } else {
      _scaffoldKey.showTosta(
          message:
              AppLocalization.of(context)!.trans("Please fill in all fields"),
          isError: true);
    }
  }
}
