import 'package:flutter/material.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';

class AlertPage extends StatefulWidget {
  AlertPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  List<List> savedAlerts = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement friend get from storage
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Flexible(
                child: new Text("You have recieved a potty alert of _____ in the location ______ from ______", style: Theme.of(context).textTheme.headline4)),
            RaisedButton(
              onPressed: () {
                // SAVE POTTY ALERT SOMEHOW USING JSON FILES
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Discard"),
            ),
          ],
        ),
      ),
    );
  }
}