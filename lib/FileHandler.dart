import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';

class FileHandler {
  File jsonFile;
  Directory dir;
  bool fexists = false;
  String fname = 'data.json';
  Map<String, dynamic> data;

  FileHandler({@required this.dir, @required this.jsonFile});

  void createFile(Map<String, dynamic> content) {
    print('creating file...!');
    File file = new File(dir.path + '/' + fname);
    file.createSync();
    fexists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  void write2File(String key, dynamic value) {
    print('writing to file...!');
    Map<String, dynamic> content = {key: value};

    if (fexists) {
      print('file exists.');
      Map<String, dynamic> jsonfcontent =
          jsonDecode(jsonFile.readAsStringSync());

      jsonfcontent.addAll(content);

      jsonFile.writeAsStringSync(jsonEncode(jsonfcontent));
    } else {
      print('file doesnot exist...!!!');
      createFile(content);
    }
  }
}
