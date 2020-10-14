import 'package:flutter/material.dart';
import 'package:hendrix_potty/read_and_write_data.dart';

import 'alert.dart';

class WritingPage extends StatefulWidget {
  WritingPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  String pottyType = "Happy";
  String location = "";
  String description = "";
  TextStyle _ts;
  TextEditingController locationController, descriptionController;

  @override
  Widget build(BuildContext context) {
    _ts = Theme.of(context).textTheme.headline4;
    locationController = TextEditingController(text: location);
    print(locationController.text);
    descriptionController = TextEditingController(text: description);

    return Scaffold(
      appBar: AppBar(
        title: Text("Hendrix Potty"),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton(
              value: pottyType,
              onChanged: (String newPotty) {
                setState(() {
                  print("Type changed to " + newPotty);
                  pottyType = newPotty;
                });
              },
              items: ["Happy", "Sad"].map((String pottyType) {
                return DropdownMenuItem(
                  value: pottyType,
                  child: Row(
                    children: <Widget>[
                      Text(pottyType, style: _ts),
                    ],
                  ),
                );
              }
              ).toList(),
            ),
            SizedBox(width: 300,
            child: TextField(controller: locationController, decoration: InputDecoration(labelText: "Location"))),
            SizedBox(width: 300,
                child: TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description (Optional)"))),
            RaisedButton(
              onPressed: () {
                location = locationController.text;
                if (location != "") {
                  description = descriptionController.text;
                  writeAlertToMemory();
                  Navigator.pop(context);
                }
              },
              child: Text("Save Alert"),
            ),
          ],
        ),
      ),
    );
  }

  writeAlertToMemory() {
    String filename = "AlertListFile";
    loadAlertsFromMemory().then((alertList) {
      Alert newAlert = Alert(this.pottyType == "Happy", this.location, this.description);
      alertList.addAlert(newAlert);
      ReadAndWriteData().writeJsonToFile(alertList, filename);
    });
  }

  Future<AlertList> loadAlertsFromMemory() async {
    AlertList toReturn = AlertList();
    toReturn = await ReadAndWriteData().readData(toReturn, "AlertListFile");
    print(toReturn.alerts);
    return toReturn;
  }
}