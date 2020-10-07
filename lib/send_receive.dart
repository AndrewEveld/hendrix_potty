import 'dart:io';

import 'dart:typed_data';

class SendReceive {
  int ourPort = 4884;
  String receivedString;

  Future<String> setupServer() async {
    try {
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
}