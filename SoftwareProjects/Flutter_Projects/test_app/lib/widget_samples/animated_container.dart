import 'package:flutter/material.dart';

class AnimatedContainerSample extends StatefulWidget {
  AnimatedContainerSample({Key key}) : super (key: key);

  @override
  _AnimatedContainerSampleState createState() => _AnimatedContainerSampleState();
}

class _AnimatedContainerSampleState extends State<AnimatedContainerSample> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Container Sample'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _selected = !_selected;
          });
        },
        child: Center(
          child: AnimatedContainer(
            width: _selected ? 200.0 : 100.0,
            height: _selected ? 100.0 : 200.0,
            color: _selected ? Colors.red : Colors.blue,
            alignment: _selected ? Alignment.center : AlignmentDirectional.topCenter,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            child: FlutterLogo(size: 75),
          )
        )
      )
    );
  }
}