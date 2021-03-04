import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import './widgets/NewData.dart';
import './widgets/ShowData.dart';
import './models/FileHandler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
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
        setState(() {
          data = jsonDecode(jsonFile.readAsStringSync());
        });
      }
    });
  }

	void callWrite2File(String key, dynamic value) {
    FileHandler fh = FileHandler(jsonFile);
    fh.write2File(key, value);
    this.setState(() {
      data = jsonDecode(jsonFile.readAsStringSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Json Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
							ShowData(data),
              NewData(callWrite2File),
            ],
          ),
        ));
  }
}
