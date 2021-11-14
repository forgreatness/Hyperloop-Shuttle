import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:demo2_app/ui/constants/routes.dart';
import 'package:demo2_app/ui/utils/navigator_util.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super (key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    FirebaseAuth.instance
      .currentUser()
      .then((currentUser) => {
        if (currentUser == null) {
          NavigatorUtil.pushReplacement(RouteNames.LOGIN)
        }
        else {
          Firestore.instance
          .collection("users")
          .document(currentUser.uid)
          .get()
          .then((DocumentSnapshot result) => {
            NavigatorUtil.pushReplacement(RouteNames.MAIN)
          })
        }
      })
      .catchError((err) => print(err));
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}