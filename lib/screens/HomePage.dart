import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/NewData.dart';
import '../widgets/ShowData.dart';
import '../models/FileHandler.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _jsonFile;
  Directory _dir;
  bool _fexists = false;
  String _fname = 'data.json';
  Map<String, dynamic> _data = {};

  // Instantiate the _dir and _file and reads data from jsonFile that are shown on screen.
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

  // calls write2File() of FileFandler and writes data into jsonFile.
  void _callWrite2File(String key, dynamic value) {
    FileHandler fh = FileHandler(_jsonFile);
    fh.write2File(key, value);

    this.setState(() {
      _data = jsonDecode(_jsonFile.readAsStringSync());
    });
  }

  // Opens ModalBottomSheet. It calls NewData. Here if it is opening for update then args data and appId are also passed with callwrite2file method.
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

  // Deletes the given app info and calls deleteData of fileHandler. It also calls setState so that the deleted app info is removed from screen
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
            ShowData(_data, _addNewData, _deleteData,),
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