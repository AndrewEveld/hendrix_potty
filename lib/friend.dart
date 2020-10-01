class Friend {
  String ipAddress;
  String name;

  Friend(this.ipAddress, this.name);

  Friend.fromJson(String jsonString) {
    
  }

  void sendPottyAlertToFriend() {
    //TODO: write function that handles the sending of potty alerts.
  }

  String convertToJson() {
    String jsonString = '{';
    jsonString += 'ipAddress: "' + this.ipAddress + '",';
    jsonString += 'name: "' + this.name + '"';
    jsonString += '}';
    return jsonString;
  }


}