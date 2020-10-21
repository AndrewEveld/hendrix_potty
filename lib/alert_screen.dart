import 'package:flutter/material.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';
import 'package:hendrix_potty/read_and_write_data.dart';

import 'alert.dart';

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
  Alert receivedAlert;

  @override
  Widget build(BuildContext context) {
    receivedAlert = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            Flexible(
                child: new Text("You have received a potty alert of " +
                    (receivedAlert.isHappy ? "'Happy'" : "'Sad'") + " in the location '" +
                    receivedAlert.location + "' with description '" + receivedAlert.description + "'.",
                    style: Theme.of(context).textTheme.headline4)),
            SizedBox(height:20),
            uniformButton("Save", true),
            SizedBox(height:20),
            uniformButton("Discard", false),
          ],
        ),
      ),
    );
  }

  // Inspired by the Boggle App https://github.com/Haedge/Project-2
  Widget uniformButton(String buttonText, bool isSaving) {
    return Container(
      width: 300,
      height: 50,
      child:RaisedButton(
          child: Text(buttonText, style: TextStyle(color: Colors.white),),
          color: Colors.deepOrangeAccent,
          onPressed: () {
            if (isSaving)
              ReadAndWriteData().writeAlertToMemory(receivedAlert.isHappy,
                receivedAlert.location, receivedAlert.description);
            Navigator.pop(context);
          }
      ),
    );
  }


}