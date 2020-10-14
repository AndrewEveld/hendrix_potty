import 'dart:io';

const int ourPort = 6666;

class Friend {
  String ipAddress;
  String name;

  Friend(this.ipAddress, this.name);

  Friend.fromJson(Map<String, dynamic> jsonObject) {
    this.ipAddress = jsonObject['ipAddress'];
    this.name = jsonObject['name'];
  }

  Future<SocketOutcome> sendTo(String message) async {
    try {
      Socket socket = await Socket.connect(ipAddress, ourPort);
      socket.write(message);
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

}

class SocketOutcome {
  String errorMessage;

  SocketOutcome({String errorMsg = ""}) {
    errorMessage = errorMsg;
  }
  bool get sent => errorMessage.length == 0;
}

