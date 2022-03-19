import 'package:flutter/material.dart';
import 'package:login/extensions.dart';

import '../M.S.dart';
import '../language.dart';
import '../loader.dart';
import '../lang.dart';
import '../notification.dart';
import '../status.dart';
import '../user-model.dart';
import '../user-type.dart';
import '../user_profile.dart';

class Users extends StatefulWidget {
  _UsersState createState() => _UsersState();
  bool searchMode = false;
  Users( );
}

class _UsersState extends State<Users> {
  Language lang = Language.ENGLISH;
  final TextEditingController? searchTextField = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    searchTextField!.dispose();
    super.dispose();
  }
  Widget appBarTitle = Text(("M.S"),
      style: TextStyle( color: Colors.black));
  Icon actionIcon = const Icon(Icons.search);

  Status status = Status.PENDING;
  UserType userType = UserType.USER;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
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
          title: appBarTitle,
          centerTitle: true,
          actions: [
            IconButton(
              icon: actionIcon,
            tooltip: AppLocalization.of(context)!.trans(
                "Notifications"),
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.close);
                    appBarTitle = TextField(
                      controller: searchTextField,
                      onChanged: (value) {
                        searchTextField!.text = value;
                        searchTextField!.text.isEmpty
                            ? widget.searchMode = false
                            : widget.searchMode = true;
                        searchTextField!.selection = TextSelection.fromPosition(
                            TextPosition(offset: searchTextField!.text.length));
                        setState(() {});
                      },
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.blue),
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.blue)),
                    );
                  } else {
                    actionIcon = const Icon(Icons.search);
                    appBarTitle = Text(
                      AppLocalization.of(context)!.trans("Users"),
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    );
                  }
                });
              },
            ),
            const NotificationsWidget(),
          ],
        ),
        body: FutureBuilder<UserModel?>(
            future: UserProfile.shared.getUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel? currentUser = snapshot.data;
                return StreamBuilder<List<UserModel>>(
                    stream: widget.searchMode
                        ? FirebaseManager.shared.getUsersBYsearch(
                            Name: searchTextField!.text, fieldType: "id")
                        : FirebaseManager.shared.getAllUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<UserModel> items = [];
                        for (var user in snapshot.data!) {
                          if (user.uid != currentUser!.uid &&
                              user.accountStatus == status &&
                              user.userType == userType) {
                            items.add(user);
                          }
                        }
                        items.sort((a, b) {
                          return DateTime.parse(b.dateCreated)
                              .compareTo(DateTime.parse(a.dateCreated));
                        });
                        List<UserModel>? searchMode = snapshot.data;
                        if (widget.searchMode) {
                          for (int i = 0; i < searchMode!.length; i++) {
                            // ignore: unrelated_type_equality_checks
                            if (searchMode[i].accountStatus.index !=
                                widget.searchMode) {
                              searchMode.removeAt(i);
                            }
                          }
                        }
                        return ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: items.isEmpty
                              ? items.length + 2
                              : items.length + 1,
                          itemBuilder: (context, index) {
                            return index == 0
                                ? _header()
                                : (items.isEmpty
                                    ? Center(
                                        child: Text(
                                          AppLocalization.of(context)!
                                              .trans("There are no members"),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      )
                                    : _item(user: items[index - 1]));
                          },
                        );
                      } else {
                        return Center(child: loader(context));
                      }
                    });
              } else {
                return const SizedBox();
              }
            }));
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalization.of(context)!.trans("Status Account:-"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.ACTIVE,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("Active")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.Disable,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("Disabled")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: Status.PENDING,
                  groupValue: status,
                  onChanged: (Status? value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("Pending")),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalization.of(context)!.trans("User Type:-"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.ADMIN,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("ADMIN")),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: UserType.USER,
                  groupValue: userType,
                  onChanged: (UserType? value) {
                    setState(() {
                      userType = value!;
                    });
                  },
                ),
                Text(AppLocalization.of(context)!.trans("USER")),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _item({required UserModel user}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("User ID: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.id,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("User name: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Email: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.email,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Phone: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.phone,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                AppLocalization.of(context)!.trans("Date created: "),
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(user.dateCreated.changeDateFormat(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid,
                            status: Status.ACTIVE);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          AppLocalization.of(context)!.trans("Accept"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.PENDING,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid,
                            status: Status.Disable);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          AppLocalization.of(context)!.trans("Disabled"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid,
                            status: Status.ACTIVE);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          AppLocalization.of(context)!.trans("Activation"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.ACTIVE,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        FirebaseManager.shared.changeStatusAccount(
                            scaffoldKey: _scaffoldKey,
                            userId: user.uid,
                            status: Status.Disable);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          AppLocalization.of(context)!.trans("Disabled"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: status == Status.Disable,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _deleteAccount(context, user.uid);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * (50 / 812),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                            child: Text(
                          AppLocalization.of(context)!.trans("Delete"),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _deleteAccount(context, String iduser) {
    FirebaseManager.shared.deleteAccount(context, iduser: iduser);
  }
}