import 'package:flutter/material.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';
import 'package:hendrix_potty/read_and_write_data.dart';
import 'package:string_validator/string_validator.dart';

class FriendPage extends StatefulWidget {
  FriendPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  FriendList listOfFriends;

  @override
  initState() {
    super.initState();
    listOfFriends = FriendList();
    Friend self = Friend("172.0.0.1", "Self");
    listOfFriends.addFriend(self);
    loadFriendsFromMemory().then((friendsList) {
      setState(() {
        print(friendsList.friends);
        listOfFriends = friendsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement friend get from storage
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        actions: getActionIcons(),
      ),
      body: Center(
        child: ListView(
          children: createFriendListWidget(listOfFriends),
        ),
      ),
    );
  }


  List<Widget> createFriendListWidget(FriendList friendListForWidgetList) {
    List<Widget> listToReturn = List();
    for (Friend friend in friendListForWidgetList.friends) {
      Widget elementToAdd = createFriendListElement(friend);
      listToReturn.add(elementToAdd);
    }
    return listToReturn;
  }

  Widget createFriendListElement(Friend friendForElement) {
    return GestureDetector(
      child: Container(
        height: 50,
        color: Colors.deepOrangeAccent,
        child: Center(child: Text(friendForElement.name)),
      ),
      onTap: addFriend,
    );
  }

  Future<FriendList> loadFriendsFromMemory() async {
    FriendList toReturn = FriendList();
    toReturn = await ReadAndWriteData().readData(toReturn, "FriendListFile");
    return toReturn;
  }

  Future<void> writeFriendsListToMemory() async {
    await ReadAndWriteData().writeJsonToFile(listOfFriends, "FriendListFile");
  }

  List<Widget> getActionIcons() {
    List<Widget> toReturn = List();
    toReturn.add(addFriendIcon());
    return toReturn;
  }

  Widget addFriendIcon() {
    return IconButton(
        icon: const Icon(Icons.account_circle),
        tooltip: "Add a Friend",
        onPressed: promptFriendDialog,
    );
  }

  void addFriend() {
    setState(() {
      listOfFriends.addFriend(Friend("IP", "New Friend"));
    });
    writeFriendsListToMemory().then((value) {
      print("Data saved");
    });

  }
  // inspired by Hendrix Cat Finder https://github.com/ericpinter/hendrix_cat_finder
  Future<void> promptFriendDialog() async {
    await showDialog(
      context: context,
      builder: (_) => FriendAlertDialog().build(context),
      barrierDismissible: true,
    ).then((ip) {
      if (ip != null) {
        setState(() {
          listOfFriends.addFriend(Friend(ip, "Friend $ip"));
        });
      }
      print(ip);
    });
  }


}

// Inspired by the Hendrix Cat Finder App https://github.com/ericpinter/hendrix_cat_finder
class FriendAlertDialog {
  final _formKey = GlobalKey<FormState>();
  String friendIp;

  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text("Add a new friend"),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'IP address',
                ),
                onSaved: (ip) {
                  friendIp = ip;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!isIP(value, 4)) {
                    return 'Please enter a valid IPv4 address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Navigator.pop(context, friendIp);
              }
            },
            child: Text("Submit"),
          )
        ]);
  }
}
