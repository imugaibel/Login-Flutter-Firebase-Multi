//alluser
import 'package:flutter/material.dart';

import '../lang.dart';
import '../notification.dart';


class Alluser extends StatefulWidget {
  @override
  _AlluserState createState() => _AlluserState();
}

class _AlluserState extends State<Alluser> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Text(AppLocalization.of(context)!.trans("M.S"), style: TextStyle(color: Theme.of(context).primaryColor),),
        centerTitle: false,
        actions: const [
          NotificationsWidget(),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: Container(child: Center(child: Text("ADMIN"),),),

    );
  }
}