import 'package:demo2_app/ui/screens/auth/login.dart';
import 'package:demo2_app/ui/screens/auth/signup.dart';
import 'package:flutter/material.dart';

import 'package:demo2_app/ui/constants/global_keys.dart';
import 'package:demo2_app/ui/screens/splash/splash_screen.dart';
import 'package:demo2_app/ui/constants/routes.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  
  _AppState() : super();

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: "Demo App #2",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue[900],
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Colors.white
          )
        ),
        primaryIconTheme: IconThemeData (
          color: Colors.white
        )
      ),
      home: SplashScreen(),
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route _onGenerateRoute(RouteSettings routeSettings) {
    var routeName = routeSettings.name;

    switch (routeName) {
      case RouteNames.LOGIN:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: routeSettings
        );
      case RouteNames.SIGNUP:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
          settings: routeSettings
        );
      case RouteNames.MAIN:
    }
  }


}