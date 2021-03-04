import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';

import '../FileHandler.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NewData extends StatefulWidget {
  @override
  _NewData createState() => _NewData();
}

class _NewData extends State<NewData> {
  TextEditingController keyCtrl = TextEditingController();
  TextEditingController valCtrl = TextEditingController();

  File jsonFile;
  Directory dir;
  bool fexists = false;
  String fname = 'data.json';
  Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + '/' + fname);
      fexists = jsonFile.existsSync();
      if (fexists) {
        this.setState(() {
          data = jsonDecode(jsonFile.readAsStringSync());
        });
      }
    });
  }

  void callWrite2File(String key, dynamic value) {
    FileHandler fh = FileHandler(dir: dir, jsonFile: jsonFile);
    fh.write2File(key, value);
    this.setState(() {
      data = jsonDecode(jsonFile.readAsStringSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              labelText: 'Key',
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
          controller: keyCtrl,
        ),
        TextField(
          decoration: InputDecoration(
              labelText: 'Value',
              labelStyle: TextStyle(fontWeight: FontWeight.bold)),
          controller: valCtrl,
        ),
        ElevatedButton(
          onPressed: () => callWrite2File(keyCtrl.text, valCtrl.text),
          child: Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Card(
            elevation: 5,
            child: Text(
              data.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }
}
