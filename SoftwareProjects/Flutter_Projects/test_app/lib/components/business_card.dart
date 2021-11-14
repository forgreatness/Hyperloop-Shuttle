import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh\'s Business Card',
          textAlign: TextAlign.center,
        )
      ),
      body: Container(
        width: 300,
        height: 100,
        color: Colors.blue,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.account_circle, size: 50),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(
                    'Danh Nguyen',
                    style: Theme.of(context).textTheme.headline
                  ),
                  Text('Experienced Flutter Developer'),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,          
              children: [
              Text('10648 sw 41st ave'),
              Spacer(
                flex: 1
              ),
              Text('(971) 344-3559'),
              ],
            ),
            Row(),
          ],
        )
      )
    );
  }
}