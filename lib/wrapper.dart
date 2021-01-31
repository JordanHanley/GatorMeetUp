import 'package:flutter/material.dart';
import 'package:gator_meet_up/screens/home.dart';
import 'authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    User curUser = Provider.of<User>(context);
    if (curUser != null) {
      return Home();
    } else {
      return Authenticate();
    }
  }
}
