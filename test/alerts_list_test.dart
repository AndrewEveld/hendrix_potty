import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hendrix_potty/alert.dart';
import 'package:hendrix_potty/friend.dart';
import 'package:hendrix_potty/read_and_write_data.dart';
import 'package:hendrix_potty/send_receive.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Create Alert No Description", () {
    bool isHappy = true;
    String location = "testLocation";
    String description = "";
    Alert createdAlert = Alert(isHappy, location, description);
    expect(createdAlert.isHappy, isHappy);
    expect(createdAlert.location, location);
    expect(createdAlert.description, description);
  });

  test("Convert Alert to Json", () {
    bool isHappy = false;
    String location = "jsonTestLocation";
    String description = "jsonTestDescription";
    Alert alertToConvert = Alert(isHappy, location, description);
    String converted = alertToConvert.toJson();
    String expected = '{"isHappy": "$isHappy", "location": "$location", "description": "$description"}';
    expect(converted, expected);
  });

  test("Writing and reading json files work", () async {
    String testLocation = "Location for testing writing";
    String testFileName = "testFile";
    Alert alertToWrite = Alert(true, testLocation, "");
    AlertList alertListToWrite = AlertList();
    alertListToWrite.addAlert(alertToWrite);
    await ReadAndWriteData().writeJsonToFile(alertListToWrite, testFileName);
    AlertList readAlertList = await ReadAndWriteData().readData(new AlertList(), testFileName);
    await ReadAndWriteData().deleteJsonFile(testFileName);
    String locationFromMemory = readAlertList.alerts.elementAt(0).location;
    expect(locationFromMemory, testLocation);
  });

  setUpAll(() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });

}