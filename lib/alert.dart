import 'dart:convert';

import 'friend_list.dart';

class Alert {
  bool isHappy;
  String location;
  String description;

  Alert(this.isHappy, this.location, this.description);

  Alert.fromJson(Map<String, dynamic> jsonObject) {
    this.isHappy = jsonObject['isHappy'] == "true";
    this.location = jsonObject['location'];
    this.description = jsonObject['description'];
  }

  String toJson() {
    return '{"isHappy": "$isHappy", '
        '"location": "$location", '
        '"description": "$description"}';
  }

  bool operator == (dynamic other) =>
      other != null && other is Alert && other.isHappy == isHappy && other.location == location;

  @override
  int get hashCode => super.hashCode;

}

class AlertList extends JsonConvertible{
  List<Alert> alerts;

  @override
  AlertList() {
    alerts = List();
  }

  @override
  fromJson(String jsonString) {
    this.alerts = List();
    Map<String, dynamic> jsonObject = jsonDecode(jsonString);
    List<dynamic> jsonAlertList = jsonObject["alerts"];
    for (Map<String, dynamic> jsonAlert in jsonAlertList) {
      Alert alert = Alert.fromJson(jsonAlert);
      addAlert(alert);
    }
  }

  addAlert(Alert alert) {
    alerts.add(alert);
  }

  @override
  String convertToJson() {
    String jsonString = '{"alerts": [';
    for (Alert alert in this.alerts) {
      jsonString += alert.toJson();
      jsonString += ',';
    }
    jsonString = this.alerts.length > 0 ? removeTrailingChar(jsonString) + ']}':
    '{"alerts": []}';
    return jsonString;
  }

  String removeTrailingChar(String stringToModify) {
    return stringToModify.substring(0, stringToModify.length - 1);
  }
}