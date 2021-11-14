import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../util/utils.dart' as utils;

class Klimatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _currentCity = "";

  Future _navigateToSecondScreen(BuildContext context) async {
    Map results = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context){
        return ChangeCity();
      })
    );

    if (results != null && results.containsKey('city')) {
      _currentCity = results['city'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.menu, color: Colors.white),
            onPressed: () { _navigateToSecondScreen(context); },
        ),
        backgroundColor: Colors.red,
        title: new Text('Klimatic'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center (
            child: new Image.asset('images/rain.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(_currentCity.isEmpty ? '${utils.defaultCity}' : '$_currentCity', style: cityStyle()),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/rain_icon.png', width: 200.0, height: 150.0),
            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 200.0),
          ),
          //Container that contains weather data,=
          new Container(
            margin: const EdgeInsets.fromLTRB(120, 300, 0, 0),
            child: updateTempWidget(_currentCity.isEmpty ? utils.defaultCity : _currentCity),
          )
        ],
      )
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$appId&units=imperial';

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(utils.appId, city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        // Where we get all of the json data, we setup widgets etc.
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    content['main']['temp'].toString(),
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            )
          );
        } else {
          return new Container(
          );
        }
      }
    );
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new ListView(
            children: <Widget>[
              new Image.asset('images/cold.jpg', width: 490.0, height: 1200.0, fit: BoxFit.fill),
            ],
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                )
              ),
              new ListTile(
                title: new FlatButton(
                  textColor: Colors.white70,
                  onPressed: () {
                    Navigator.pop(context, {
                      'city': _cityFieldController.text,
                    });
                  },
                  color: Colors.redAccent,
                  child: new Text('Search'),
                ),
              )
            ],
          )
        ],
      )
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9
  );
}