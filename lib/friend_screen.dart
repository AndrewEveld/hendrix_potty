import 'package:flutter/material.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';
import 'package:hendrix_potty/read_and_write_data.dart';
import 'package:hendrix_potty/send_receive.dart';
import 'package:string_validator/string_validator.dart';

import 'alert.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  FriendList listOfFriends;
  AlertList listOfAlerts;
  bool isFriendList;
  Friend selectedFriend;

  @override
  initState() {
    isFriendList = true;
    super.initState();
    listOfFriends = FriendList();
    Friend self = Friend("127.0.0.1", "Self");
    listOfFriends.addFriend(self);
    loadFriendsFromMemory().then((friendsList) {
      setState(() {
        print(friendsList.friends);
        listOfFriends = friendsList.friends.isEmpty ? listOfFriends : friendsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Potty Alert"),
      ),
      body: Center(
        child: ListView(
          children: isFriendList ? createFriendListWidget(listOfFriends)
              : createAlertListWidget(listOfAlerts),
        ),
      ),
      floatingActionButton: addFriendButton(),
    );
  }


  List<Widget> createFriendListWidget(FriendList friendListForWidgetList) {
    List<Widget> listToReturn = List();
    listToReturn.add(createInstructionElement("Select Friend to Send Potty Alert to Them:"));
    for (Friend friend in friendListForWidgetList.friends) {
      Widget elementToAdd = createFriendListElement(friend);
      listToReturn.add(elementToAdd);
      listToReturn.add(Divider(
        color: Colors.black,
        height: 1,
      ));
    }
    return listToReturn;
  }

  List<Widget> createAlertListWidget(AlertList alertListForWidgetList) {
    List<Widget> listToReturn = List();
    listToReturn.add(createInstructionElement("Select Potty Alert to Send to Friend:"));
    for (Alert alert in alertListForWidgetList.alerts) {
      Widget elementToAdd = createAlertListElement(alert);
      listToReturn.add(elementToAdd);
      listToReturn.add(Divider(
        color: Colors.black,
        height: 1,
      ));
    }
    return listToReturn;
  }

  Widget createFriendListElement(Friend friendForElement) {
    String friendText = "${friendForElement.ipAddress}: ${friendForElement.name}";
    return
       friendTapHandler(createListElement(friendText), friendForElement);
  }

  Widget createAlertListElement(Alert alertForElement) {
    String happyOrNot = alertForElement.isHappy ? "Happy" : "Sad";
    String alertText = "$happyOrNot: ${alertForElement.location}";
    return
        alertTapHandler(createListElement(alertText), alertForElement);
  }

  Widget createListElement(String text) {
    return
      Container(
        height: 50,
        color: Colors.deepOrangeAccent,
        child: Center(
          child: Text(
            text
          ),
        ),
    );
  }

  Widget createInstructionElement(String text) {
    return
        Container(
          height: 50,
          color: Colors.teal,
          child: Center(
            child: Text(
              text
            ),
          ),
        );
  }

  Widget friendTapHandler(Widget friendListElement, Friend friend) {
    return
        GestureDetector(
          onTap: () {handleListElementTap(friend: friend);},
          child: friendListElement,
        );
  }

  Widget alertTapHandler(Widget alertListElement, Alert alert) {
    return
      GestureDetector(
        onTap: () {handleListElementTap(alert: alert);},
        child: alertListElement,
      );
  }

  handleListElementTap({Alert alert, Friend friend}) {
    if (friend != null) {
      selectedFriend = friend;
      isFriendList = false;
      setAlertListFromSaved();
    }
    if (alert != null) {
      print('alert pressed!!');
      SendReceive().send(alert, selectedFriend);
      Navigator.pop(context);
    }
  }

  void setAlertListFromSaved() {
    loadAlertsFromMemory().then((alertList) {
      setState(() {
        print(alertList.alerts);
        listOfAlerts = alertList;
      });
    });
  }

  Future<AlertList> loadAlertsFromMemory() async {
    AlertList toReturn = AlertList();
    toReturn = await ReadAndWriteData().readData(toReturn, "AlertListFile");
    return toReturn;
  }

  Future<FriendList> loadFriendsFromMemory() async {
    FriendList toReturn = FriendList();
    toReturn = await ReadAndWriteData().readData(toReturn, "FriendListFile");
    return toReturn;
  }

  Future<void> writeFriendsListToMemory() async {
    await ReadAndWriteData().writeJsonToFile(listOfFriends, "FriendListFile");
  }

  Widget addFriendButton() {
    return FloatingActionButton(
        tooltip: "Add a Friend",
        onPressed: isFriendList ? promptFriendDialog
            : () {Navigator.pushNamed(context, "/writing").then((value) {
              setState(() {
                setAlertListFromSaved();
              });
        });
            },
        child: Icon(Icons.add),
    );
  }

  // inspired by Hendrix Cat Finder https://github.com/ericpinter/hendrix_cat_finder
  Future<void> promptFriendDialog() async {
    await showDialog(
      context: context,
      builder: (_) => FriendAlertDialog().build(context),
      barrierDismissible: true,
    ).then((friend) {
      if (friend != null) {
        setState(() {
          listOfFriends.addFriend(Friend(friend[0], friend[1]));
          writeFriendsListToMemory();
        });
      }
      print(friend);
    });
  }


}

// Inspired by the Hendrix Cat Finder App https://github.com/ericpinter/hendrix_cat_finder
class FriendAlertDialog {
  final _formKey = GlobalKey<FormState>();
  String friendIp;
  String friendName;

  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a new friend"),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              inputTextForm(true),
              inputTextForm(false),
            ],
          ),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.pop(context, [friendIp, friendName]);
              }
            },
            child: Text("Submit"),
          )
        ]);
  }

  Widget inputTextForm(bool isIP) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: isIP ? "IP Address" : "Name",
      ),
      onSaved: (value) {
        if (isIP) {
          friendIp = value;
        } else {
          friendName = value;
        }
      },
      validator: isIP ? ipAddressValidator : (doNothing) {return null;},
    );
  }

  String ipAddressValidator(String ipAddressToValidate) {
    if (ipAddressToValidate.isEmpty) {
      return 'Please enter some text';
    } else if (!isIP(ipAddressToValidate, 4)) {
      return 'Please enter a valid IPv4 address';
    }
    return null;
  }
}
