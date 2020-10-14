import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hendrix_potty/read_and_write_data.dart';
import 'package:hendrix_potty/send_receive.dart';

import 'alert.dart';
import 'friend.dart';
import 'friend_list.dart';

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
  AlertList alertList;
  FriendList friends;
  Alert currentAlert;
  Friend currentFriend = Friend("none", "Choose Friend");
  TextStyle _ts;

  @override
  void initState() {
    alertList = AlertList();
    friends = FriendList();
    super.initState();
    loadAlertsFromMemory().then((memoryAlerts) {
      setState(() {
        alertList = memoryAlerts;
        if (alertList.alerts.isEmpty) {
          alertList.addAlert(Alert(true, "Choose Potty Alert", "Example"));
          currentAlert = alertList.alerts[0];
        } else {
          currentAlert = alertList.alerts[0];
        }
      });
    });
    loadFriendsFromMemory().then((memoryFriends) {
      setState(() {
        friends = memoryFriends;
        if (friends.friends.isEmpty) {
          friends.addFriend(Friend("none", "Choose Friend"));
          currentFriend = friends.friends[0];
        } else {
          currentFriend = friends.friends[0];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline6;

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
              onChanged: (Friend newFriend) {
                setState(() {
                  print("Type changed to " + newFriend.name);
                  currentFriend = newFriend;
                });
              },
              items: friends.friends.map((Friend currentFriend) {
                return DropdownMenuItem(
                  value: currentFriend,
                  child: Row(
                    children: <Widget>[
                      Text(currentFriend.name, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),
            DropdownButton(
              value: currentAlert,
              onChanged: (Alert newAlert) {
                setState(() {
                  print("Type changed to " + newAlert.description);
                  currentAlert = newAlert;
                });
              },
              items: alertList.alerts.map((Alert currentAlert) {
                return DropdownMenuItem(
                  value: currentAlert,
                  child: Row(
                    children: <Widget>[
                      Text(currentAlert.isHappy ? "Happy" : "Sad" + ": " +
                          currentAlert.location + ": " +
                          currentAlert.description, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),
            RaisedButton(
              onPressed: () {
                SendReceive().send(currentAlert, currentFriend);
                Navigator.pop(context);
              },
              child: Text("Send Alert"),
            ),
          ],
        ),
      ),
    );
  }

  Future<FriendList> loadFriendsFromMemory() async {
    FriendList toReturn = FriendList();
    toReturn = await ReadAndWriteData().readData(toReturn, "FriendListFile");
    return toReturn;
  }

  Future<AlertList> loadAlertsFromMemory() async {
    AlertList toReturn = AlertList();
    toReturn = await ReadAndWriteData().readData(toReturn, "AlertListFile");
    print(toReturn.alerts);
    return toReturn;
  }
}