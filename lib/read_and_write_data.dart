import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hendrix_potty/friend_list.dart';

// Taken from Flutter API Doc https://flutter.dev/docs/cookbook/persistence/reading-writing-files

class ReadAndWriteData {
  String filename;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }


  Future<File> writeJsonToFile(JsonConvertible objectToWrite) async {
    print("writing");
    final file = await _localFile;
    return file.writeAsString(objectToWrite.convertToJson());
  }

  Future<JsonConvertible> readData(JsonConvertible objectToRead) async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      objectToRead.fromJson(contents);
      return objectToRead;
    }
    catch (e) {
      return objectToRead;
    }
  }
}