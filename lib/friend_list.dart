import 'dart:convert';
import 'package:hendrix_potty/friend.dart';

class FriendList extends JsonConvertible {
  List<Friend> friends;

  @override
  FriendList() {
    this.friends = List();
  }

  @override
  fromJson(String jsonString) {
    this.friends = List();
    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    List<dynamic> jsonFriendList = jsonObject["friends"];
    for (Map<String, dynamic> jsonFriend in jsonFriendList) {
      Friend friend = Friend.fromJson(jsonFriend);
      addFriend(friend);
    }
  }

  addFriend(Friend friendToAdd) {
    this.friends.add(friendToAdd);
  }

  @override
  String convertToJson() {
    String jsonString = '{"friends": [';
    for (Friend friend in this.friends) {
      jsonString += friend.convertToJson();
      jsonString += ',';
    }
    jsonString = this.friends.length > 0 ? removeTrailingChar(jsonString) + ']}':
    '{"friends": []}';
    return jsonString;
  }

  String removeTrailingChar(String stringToModify) {
    return stringToModify.substring(0, stringToModify.length - 1);
  }
}

abstract class JsonConvertible {
  JsonConvertible();

  String convertToJson();

  fromJson(String jsonString);
}