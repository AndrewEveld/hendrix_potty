import 'package:flutter/material.dart';
import 'package:hendrix_potty/read_and_write_data.dart';
import 'package:hendrix_potty/send_receive.dart';

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
              dropdownColor: Colors.teal,
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
            SizedBox(height:20),
            textBox("Location", locationController),
            SizedBox(height:20),
            textBox("Optional Description", descriptionController),
            SizedBox(height:20),
            uniformButton("Save Alert"),
          ],
        ),
      ),
    );
  }

  Widget uniformButton(String text) {
    return Container(
      width: 300,
      height: 50,
      child: RaisedButton(
          child: Text(text, style: TextStyle(color: Colors.white),),
          color: Colors.deepOrangeAccent,
          onPressed: () {
            location = locationController.text;
            if (location != "") {
              description = descriptionController.text;
              ReadAndWriteData().writeAlertToMemory(
                  pottyType == "Happy", location, description).then((none) {
                Navigator.pop(context);
              });
            }
          }
      ),
    );
  }

  Widget textBox(String text, TextEditingController controller) {
    return SizedBox(width: 300,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: text,
          ),
        )
    );
  }
}