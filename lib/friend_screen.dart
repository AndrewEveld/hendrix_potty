import 'package:flutter/material.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';

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

  init() {
    super.initState();
    listOfFriends = FriendList();
    listOfFriends.addFriend(Friend("127.0.0.1", "Self"));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement friend get from storage
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Text("Friend 1"),
            Text("Friend 2"),
            Text("Friend 3"),
            Text("Friend 4"),
          ],
        ),
      ),
    );
  }

  Widget createFriendListElement(Friend friendForElement) {
    return Text(friendForElement.name);
  }

  List<Widget> createFriendListWidget(FriendList friendListForWidgetList) {
    List<Widget> listToReturn = List();
    for (Friend friend in friendListForWidgetList.friends) {
      Widget elementToAdd = createFriendListElement(friend);
      listToReturn.add(elementToAdd);
    }
    return listToReturn;
  }
}