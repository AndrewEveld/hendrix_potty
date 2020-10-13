import 'dart:io';

import 'dart:typed_data';

import 'friend.dart';
import 'package:flutter/material.dart';


class SendReceive {
  int ourPort = 6666;
  String receivedString;

  Future<String> setupServer(BuildContext context) async {
    try {
      print("waiting for message");
      ServerSocket server =
      await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen((data) {
        receivedString = _listenToSocket(data, context);
      }); // StreamSubscription<Socket>
      return receivedString;
    } on SocketException catch (e) {
      return e.message;
    }
  }

   String _listenToSocket(Socket socket, BuildContext context) {
    String dataReceived;
    socket.listen((data) {
      dataReceived = _handleIncomingMessage(socket.address.address, data, context);
    });
    return dataReceived;
  }

   String _handleIncomingMessage(String ip, Uint8List incomingData, BuildContext context) {
    String received = String.fromCharCodes(incomingData);
    print("Received '$received' from '$ip'");
    Navigator.pushNamed(context, "/alert", arguments: received);
    return received;
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