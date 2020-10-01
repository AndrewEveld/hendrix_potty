import 'package:hendrix_potty/friend.dart';

class FriendList {
  List<Friend> friends;

  FriendList() {
    this.friends = List();
  }

  void addFriend(Friend friendToAdd) {
    this.friends.add(friendToAdd);
  }

  String convertToJson() {
    String jsonString = '{"friends": ';
    for (Friend friend in this.friends) {
      jsonString += friend.convertToJson();
      jsonString += ',';
    }
    jsonString = this.friends.length > 0 ? removeTrailingChar(jsonString) + '}':
    '{"friends": {}}';
    return jsonString;
  }

  String removeTrailingChar(String stringToModify) {
    return stringToModify.substring(0, stringToModify.length - 1);
  }
}