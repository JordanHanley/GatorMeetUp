import 'package:flutter/material.dart';
import 'package:gator_meet_up/services/auth.dart';
import 'package:gator_meet_up/utilities/widget_decorations.dart';

class Authenticate extends StatelessWidget {
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue[300],
      body: Stack(children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 150),
              Image(
                image: AssetImage("assets/gator_meetup_icon.jpg"),
                height: 150,
                width: 150,
              )
              //CircleAvatar(
              // radius: 80,
              //backgroundImage: AssetImage("assets/gator_meetup_icon.jpg"),
              //),
            ]),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 120),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  onChanged: (val) => email = val),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                onChanged: (val) => password = val,
              ),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 140),
              child: FlatButton(
                color: Color.fromRGBO(250, 70, 22, 1),
                child: Text(
                  "Log In",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  dynamic result =
                      _auth.signInWithEmailAndPassword(email, password);
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 140),
              child: FlatButton(
                color: Color.fromRGBO(250, 70, 22, 1),
                child: Text("Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                    )),
                onPressed: () async {
                  dynamic resilt =
                      _auth.registerWithEmailAndPassword(email, password);
                },
              ),
            ),
            SizedBox(height: 80)
          ],
        )
      ]),
    );
  }
}
