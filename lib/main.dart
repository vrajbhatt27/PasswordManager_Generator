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
  File _jsonFile;
  Directory _dir;
  bool _fexists = false;
  String _fname = 'data.json';
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      _dir = directory;
      _jsonFile = File(_dir.path + '/' + _fname);
      _fexists = _jsonFile.existsSync();
      if (_fexists) {
        setState(() {
          _data = jsonDecode(_jsonFile.readAsStringSync());
          // dataLst = map2List(_data);
        });
      }
    });
  }

  void _callWrite2File(String key, dynamic value) {
    FileHandler fh = FileHandler(_jsonFile);
    fh.write2File(key, value);

    this.setState(() {
      _data = jsonDecode(_jsonFile.readAsStringSync());
    });
  }

  void _addNewData(BuildContext ctx, {dynamic data = '', String appId = ''}) {
    bool update = false;
    if (appId.isNotEmpty) {
      update = true;
    }

    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            child: update
                ? NewData(
                    _callWrite2File,
                    data: data,
                    appId: appId,
                  )
                : NewData(_callWrite2File),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _deleteData(String appId) {
    _data.remove(appId);
    FileHandler fh = FileHandler(_jsonFile);
    fh.deleteData(_data);
    setState(() {
      _data = jsonDecode(_jsonFile.readAsStringSync());
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
            ShowData(_data, _addNewData, _deleteData),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addNewData(context),
      ),
    );
  }
}
