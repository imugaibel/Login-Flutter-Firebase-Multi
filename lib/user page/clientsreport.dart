//ClientsReport
import 'package:flutter/material.dart';


class uservendor extends StatefulWidget {
  const uservendor({Key? key}) : super(key: key);

  @override
  _uservendorState createState() => _uservendorState();
}

class _uservendorState extends State<uservendor> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,

      body: const Center(child: Text("USER"),),

    );
  }
}