import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hendrix_potty/alert_screen.dart';
import 'package:hendrix_potty/friend_screen.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Hendrix Potty',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/friends': (context) => FriendPage(),
        '/alert': (context) => AlertPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentPottyType = "Happy";
  String connectionMessage = "";
  TextStyle _ts;
  int ourPort = 6666;
  FriendList friends;


  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text("Hendrix Potty"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              value: currentPottyType,
              onChanged: (String newPotty) {
                setState(() {
                  print("Type changed to " + newPotty);
                  currentPottyType = newPotty;
                });
              },
              items: ["Happy", "Sad"].map((String pottyType) {
                return DropdownMenuItem(
                  value: pottyType,
                  child: Row(
                    children: <Widget>[
                      Text(pottyType, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),

            RaisedButton(
              onPressed: null,
              child: Text("Send"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/alert");
              },
              child: Text("Friends List"),
            ),
            Flexible(
                child: new Text(connectionMessage, style: _ts)),
          ],
        ),
      ),
    );
  }

  Widget recieveAlert() {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget> [
            Flexible(
                child: new Text("You have recieved a potty alert of _____ in the location ______ from ______", style: _ts)),
            RaisedButton(
              onPressed: null,
              child: Text("Save"),
            ),
            RaisedButton(
              onPressed: () {send(currentPottyType);},
              child: Text("Discard"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> send(String alert) async {
    String response = await sendToCurrentFriend(alert);
    setState(() {
      connectionMessage = response;
    });
  }

  Future<String> sendToCurrentFriend(String pottyAlert) async {
    if (friends.friends.length != 0) {
      SocketOutcome sent = await friends.friends[0].sendTo(pottyAlert);
      if (sent.sent) {
        return "";
      } else {
        return sent.errorMessage;
      }
    } else {
      return "Can't send, No Friends";
    }
  }
}
