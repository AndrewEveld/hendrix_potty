import 'dart:core';
import 'dart:io';

import 'alert.dart';

const int ourPort = 6666;

class Friend {
  String ipAddress;
  String name;

  Friend(this.ipAddress, this.name);

  Friend.fromJson(Map<String, dynamic> jsonObject) {
    this.ipAddress = jsonObject['ipAddress'];
    this.name = jsonObject['name'];
  }

  Future<SocketOutcome> sendTo(Alert message) async {
    try {
      Socket socket = await Socket.connect(ipAddress, ourPort);
      socket.write(message.toJson());
      socket.close();
      return SocketOutcome();
    } on SocketException catch (e) {
      return SocketOutcome(errorMsg: e.message);
    }
  }

  String convertToJson() {
    String jsonString = '{';
    jsonString += '"ipAddress": "' + this.ipAddress + '",';
    jsonString += '"name": "' + this.name + '"';
    jsonString += '}';
    return jsonString;
  }

  bool operator == (dynamic other) =>
      other != null && other is Friend && other.name == name && other.ipAddress == ipAddress;

  @override
  int get hashCode => super.hashCode;
}

class SocketOutcome {
  String errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    errorMessage = errorMsg;
  }
  bool get sent => errorMessage.length == 0;
}

