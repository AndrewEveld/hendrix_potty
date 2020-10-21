import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hendrix_potty/alert_screen.dart';
import 'package:hendrix_potty/friend_screen.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';
import 'package:hendrix_potty/send_receive.dart';
import 'package:hendrix_potty/writing_screen.dart';

import 'alert.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'The Hendrix Potty',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/friends': (context) => FriendPage(),
        '/alert': (context) => AlertPage(),
        '/writing': (context) => WritingPage(),
        '/sending': (context) => FriendPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String connectionMessage = "";
  TextStyle _ts;
  int ourPort = 6666;
  FriendList friends;


  void initState() {
    super.initState();
    friends = FriendList();
    friends.addFriend(Friend("127.0.0.1", "Self"));
    setupSocket().then((value) {print("In then");});
  }

  Future<void> setupSocket() async {
    print("waiting");
    SendReceive handler = SendReceive();
    Alert receivedMessage = await handler.setupServer(context);
    print(receivedMessage);
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
            uniformButton("/writing", "Write New Potty Alert"),
            SizedBox(height:20),
            uniformButton("/sending", "Send Potty Alert"),
            SizedBox(height:20),
            Flexible(
                child: new Text(connectionMessage, style: _ts)),
          ],
        ),
      ),
    );
  }

  // Inspired by the Boggle App https://github.com/Haedge/Project-2
  Widget uniformButton(String route, String buttonText) {
    return Container(
      width: 300,
      height: 50,
      child:RaisedButton(
          child: Text(buttonText, style: TextStyle(color: Colors.white),),
          color: Colors.deepOrangeAccent,
          onPressed: () {
            Navigator.pushNamed(context, route);
          }
        ),
    );
  }
}
