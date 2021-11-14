import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:demo2_app/ui/constants/routes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Email*', hintText: "john.doe@gmail.com"),
                  controller: emailInputController,
                  keyboardType: TextInputType.emailAddress,
                  validator: emailValidator,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password*', hintText: "********"),
                  controller: pwdInputController,
                  obscureText: true,
                  validator: pwdValidator,
                ),
                RaisedButton(
                  child: Text("Login"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_loginFormKey.currentState.validate()) {
                      FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailInputController.text,
                            password: pwdInputController.text)
                        .then((currentUser) => Firestore.instance
                          .collection("users")
                          .document(currentUser.user.uid)
                          .get()
                          .then((DocumentSnapshot result) =>
                            NavigatorUtil.pushAndRemoveUntil(RouteNames.MAIN, (route) {
                              return (route.settings?.name?.contains(RouteNames.MAIN) == true);
                            })
                          )
                          .catchError((err) => print(err)))
                        .catchError((err) => print(err));
                    }
                  },
                ),
                Text("Don't have an account yet?"),
                FlatButton(
                  child: Text("Sign up here!"),
                  onPressed: () {
                    NavigatorUtil.pushReplacement(RouteNames.SIGNUP);
                  },
                ),
                GoogleSignInButton(
                  onPressed: signInWithGoogle,
                  darkMode: true,
                ),
                FacebookSignInButton(
                  onPressed: loginWithFacebook,
                )
              ],
            ),
          )
        )
      )
    );
  }

  void signInWithGoogle() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();
    final GoogleSignInAuthentication googleAuthentication = await googleSignIn.signIn()
      .then((GoogleSignInAccount googleAccount) async {
        if (googleAccount == null) {
          return null;
        } else {
          return await googleAccount.authentication;
        }
      })
      .catchError((err) {print(err); return;});
    
    if (await googleSignIn.isSignedIn()) {
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken,
      );

      await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((AuthResult currentUser) async {
          assert(currentUser.user.email != null);

          var names = currentUser.user.displayName.split(' ');
          await Firestore.instance
          .collection('users')
          .document(currentUser.user.uid)
          .setData(
            {
              'uid': currentUser.user.uid,
              'fname': names[0],
              'surname': names[names.length-1],
              'email': currentUser.user.email,
            },
            merge: true,
          )
          .then((result) =>
            NavigatorUtil.pushAndRemoveUntil(RouteNames.MAIN, (route) {
              return (route.settings?.name?.contains(RouteNames.MAIN) == true);
            })           
          )
          .catchError((err) => print(err));
        })
        .catchError((err) => print(err));
    }
  }

  void loginWithFacebook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logIn(['email', 'public_profile']);
    var graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');
    var profile = json.decode(graphResponse.body);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token
        );          

        await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((currentUser) => Firestore.instance
            .collection('users')
            .document(currentUser.user.uid)
            .setData(
              {
                'uid': currentUser.user.uid,
                'fname': profile['first_name'],
                'surname': profile['last_name'],
                'email': profile['email'],
              },
              merge: true,
            )
            .then((result) =>
              NavigatorUtil.pushAndRemoveUntil(RouteNames.MAIN, (route) {
                return (route.settings?.name?.contains(RouteNames.MAIN) == true);
              })            
            )
            .catchError((err) => print(err)))
          .catchError((err) => print(err));
          
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Facebook Sign In cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Facebook Sign In failed');
        break;
    }
  }
}