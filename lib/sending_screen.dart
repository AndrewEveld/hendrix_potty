import 'package:flutter/material.dart';

class SendingPage extends StatefulWidget {
  SendingPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _SendingPageState createState() => _SendingPageState();
}

class _SendingPageState extends State<SendingPage> {
  List alertList;
  List friends;
  String currentAlert = "Alert 1";
  String currentFriend = "Friend 1";
  TextStyle _ts;


  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    friends = ["Friend 1","Friend 2","Friend 3"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Hendrix Potty"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              value: currentFriend,
              onChanged: (String newFriend) {
                setState(() {
                  print("Type changed to " + newFriend);
                  currentFriend = newFriend;
                });
              },
              items: ["Friend 1","Friend 2","Friend 3"].map((String currentFriend) {
                return DropdownMenuItem(
                  value: currentFriend,
                  child: Row(
                    children: <Widget>[
                      Text(currentFriend, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),
            DropdownButton(
              value: currentAlert,
              onChanged: (String newAlert) {
                setState(() {
                  print("Type changed to " + newAlert);
                  currentAlert = newAlert;
                });
              },
              items: ["Alert 1","Alert 2","Alert 3"].map((String currentAlert) {
                return DropdownMenuItem(
                  value: currentAlert,
                  child: Row(
                    children: <Widget>[
                      Text(currentAlert, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),
            RaisedButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text("Send Alert"),
            ),
          ],
        ),
      ),
    );
  }
}