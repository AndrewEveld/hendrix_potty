import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'alert.dart';
import 'friend.dart';
import 'package:flutter/material.dart';


class SendReceive {
  int ourPort = 6666;
  Alert receivedAlert;

  Future<String> setupServer(BuildContext context) async {
    try {
      print("waiting for message");
      ServerSocket server =
      await ServerSocket.bind(InternetAddress.anyIPv4, ourPort);
      server.listen((data) {
        receivedAlert = _listenToSocket(data, context);
      }); // StreamSubscription<Socket>
      return "Alert received";
    } on SocketException catch (e) {
      return e.message;
    }
  }

   Alert _listenToSocket(Socket socket, BuildContext context) {
    Alert dataReceived;
    socket.listen((data) {
      dataReceived = _handleIncomingMessage(socket.address.address, data, context);
    });
    return dataReceived;
  }

   Alert _handleIncomingMessage(String ip, Uint8List incomingData, BuildContext context) {
    Alert received = Alert.fromJson(jsonDecode(String.fromCharCodes(incomingData)));
    print("Received '$received' from '$ip'");
    Navigator.pushNamed(context, "/alert", arguments: received);
    return received;
  }

  Future<void> send(Alert alert, Friend friendToSend) async {
    return await sendToCurrentFriend(alert, friendToSend);
  }

  Future<String> sendToCurrentFriend(Alert pottyAlert, Friend friendToSend) async {
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