import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hendrix_potty/friend_list.dart';

import 'alert.dart';

// Taken from Flutter API Doc https://flutter.dev/docs/cookbook/persistence/reading-writing-files

class ReadAndWriteData {
  String filename;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename.json');
  }

  Future<void> deleteJsonFile(String dataType) async {
    print("deleting $dataType");
    filename = dataType;
    final file = await _localFile;
    await file.delete();
  }

  Future<void> writeJsonToFile(JsonConvertible objectToWrite, String dataType) async {
    print("writing");
    filename = dataType;
    final file = await _localFile;
    await file.writeAsString(objectToWrite.convertToJson());
  }

  Future<JsonConvertible> readData(JsonConvertible objectToRead, String dataType) async {
    try {
      filename = dataType;
      final file = await _localFile;
      String contents = await file.readAsString();
      print(contents);
      objectToRead.fromJson(contents);
      print("reading successful");
      return objectToRead;
    }
    catch (e) {
      print("Reading failed");
      return objectToRead;
    }
  }

  Future<void> writeAlertToMemory(bool isHappy, String location, String description) async {
    String filename = "AlertListFile";
    AlertList savedAlerts;
    savedAlerts = await loadAlertsFromMemory();
    Alert newAlert = Alert(isHappy, location, description);
    savedAlerts.addAlert(newAlert);
    await writeJsonToFile(savedAlerts, filename);
  }

  Future<AlertList> loadAlertsFromMemory() async {
    AlertList toReturn = AlertList();
    toReturn = await readData(toReturn, "AlertListFile");
    print(toReturn.alerts);
    return toReturn;
  }
}