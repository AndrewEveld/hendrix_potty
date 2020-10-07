import 'dart:io';

import 'dart:typed_data';

import 'friend.dart';

class SendReceive {
  int ourPort = 6666;
  String receivedString;

  Future<String> setupServer() async {
    try {
      print("waiting for message");
      ServerSocket server =
      await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen(_listenToSocket); // StreamSubscription<Socket>
      return receivedString;
    } on SocketException catch (e) {
      return e.message;
    }
  }

   _listenToSocket(Socket socket) {
    String dataReceived;
    socket.listen((data) {
      dataReceived = _handleIncomingMessage(socket.remoteAddress.address, data);
    });
    return dataReceived;
  }

   _handleIncomingMessage(String ip, Uint8List incomingData) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    receivedString = received;
  }

  Future<void> send(String alert, Friend friendToSend) async {
    return await sendToCurrentFriend(alert, friendToSend);
  }

  Future<String> sendToCurrentFriend(String pottyAlert, Friend friendToSend) async {
    print("in function");
      print("about to send");
      SocketOutcome sent = await friendToSend.sendTo(pottyAlert);
      if (sent.sent) {
        print("message sent");
        return "";
      } else {
        print("message not sent");
        return sent.errorMessage;
      }
  }
}