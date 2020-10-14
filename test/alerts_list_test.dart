import 'package:flutter_test/flutter_test.dart';
import 'package:hendrix_potty/alert.dart';

void main() {
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
    String expected = '{"isHappy": $isHappy, "location": $location, "description": $description}';
    expect(converted, expected);
  });
}