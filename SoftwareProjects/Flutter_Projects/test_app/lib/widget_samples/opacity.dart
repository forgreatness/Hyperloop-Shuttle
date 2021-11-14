import 'package:flutter/material.dart';

class OpacitySample extends StatefulWidget {
  OpacitySample({Key key}) : super (key : key);

  @override
  _OpacitySampleState createState() {
    return _OpacitySampleState();
  }
}

class _OpacitySampleState extends State<OpacitySample> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Opacity Sample'),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _visible = !_visible;
          });
        },
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[300],
              shape: BoxShape.circle,
              border: Border.all(
                width: 2.0,
                color: Colors.black
              ),
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.indigo[800],
                  Colors.indigo[700],
                  Colors.indigo[300],
                  Colors.indigo[100],
                ],
              ),
            ),
            child: AnimatedOpacity(
              duration: Duration(seconds: 2),
              opacity: _visible ? 1 : 0,
              child: Image.asset('assets/images/opacity.jpg')
            ),
          ),
        )
      )
    );
  }
}