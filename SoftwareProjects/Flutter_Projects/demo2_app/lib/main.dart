import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:demo2_app/app.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(App());
  });
}

