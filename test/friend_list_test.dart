import 'package:flutter_test/flutter_test.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/friend_list.dart';

void main() {
  test("Create friend", () {
    String testIp = "testIpAddress";
    String testName = "testName";
    Friend testFriend = Friend(testIp, testName);
    expect(testFriend.ipAddress, testIp);
    expect(testFriend.name, testName);
  });

  test("Convert friend to json", () {
    String testIp = "testIpAddress";
    String testName = "testName";
    Friend testFriend = Friend(testIp, testName);
    String jsonFriend = testFriend.convertToJson();
    String expectedJsonFriend = '{"ipAddress": "$testIp","name": "$testName"}';
    expect(jsonFriend, expectedJsonFriend);
  });

  test("Create friend from Map<String, dynamic>", () {
    String testIp = "testIpAddress";
    String testName = "testName";
    Map<String, dynamic> friendJsonMap = Map();
    friendJsonMap.putIfAbsent("ipAddress", () => testIp);
    friendJsonMap.putIfAbsent("name", () => testName);
    Friend friendFromJsonMap = Friend.fromJson(friendJsonMap);
    expect(friendFromJsonMap.ipAddress, testIp);
    expect(friendFromJsonMap.name, testName);
  });

  test("Create empty friends list", () {
    FriendList emptyTestFriendList = FriendList();
    expect(emptyTestFriendList.friends.length, 0);
  });

  test("Add friend to friends list", () {
    FriendList testFriendList = FriendList();
    String testIp = "testIpAddress";
    String testName = "testName";
    Friend friendToAdd = Friend(testIp, testName);
    testFriendList.addFriend(friendToAdd);
    Friend friendAfterAdding = testFriendList.friends.elementAt(0);
    expect(testFriendList.friends.length, 1);
    expect(friendAfterAdding.ipAddress, testIp);
    expect(friendAfterAdding.name, testName);
  });

  test("Convert empty friend list to json", () {
    FriendList friendListToConvert = FriendList();
    String jsonFriendList = friendListToConvert.convertToJson();
    String expectedJson = '{"friends": []}';
    expect(jsonFriendList, expectedJson);
  });

  test("Convert friend list to json", () {
    FriendList friendListToConvert = FriendList();
    String testIp = "testIpAddress";
    String testName = "testName";
    Friend friendToAdd = Friend(testIp, testName);
    friendListToConvert.addFriend(friendToAdd);
    String expectedJson = '{"friends": [{"ipAddress": "$testIp","name": "$testName"}]}';
    String convertedFriendList = friendListToConvert.convertToJson();
    expect(convertedFriendList, expectedJson);
  });

  test("Convert json string to empty friends list", () {
    String jsonToConvert = '{"friends": []}';
    FriendList convertedFriendList = FriendList();
    convertedFriendList.fromJson(jsonToConvert);
    expect(convertedFriendList.friends.length, 0);
  });

  test("Convert json string to friends list", () {
    String testIp = "testIpAddress";
    String testName = "testName";
    String jsonToConvert = '{"friends": [{"ipAddress": "$testIp","name": "$testName"}]}';
    FriendList convertedFriendList = FriendList();
    convertedFriendList.fromJson(jsonToConvert);
    Friend expectedFriend = convertedFriendList.friends.elementAt(0);
    expect(convertedFriendList.friends.length, 1);
    expect(expectedFriend.ipAddress, testIp);
    expect(expectedFriend.name, testName);
  });


}