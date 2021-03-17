import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../widgets/NewData.dart';
import '../widgets/ShowData.dart';
import '../models/FileHandler.dart';
import '../other/styles.dart';

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
  var height;

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
      isScrollControlled: true,
      barrierColor: Colors.black54,
      backgroundColor: Color(0xFF1F2426),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: update
              ? Container(
                  height: height * 0.6,
                  child: NewData(
                    _callWrite2File,
                    data: data,
                    appId: appId,
                  ),
                )
              : Container(
                  height: height * 0.6,
                  child: NewData(_callWrite2File),
                ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
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
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                'Your Credentials',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor),
              ),
              alignment: Alignment.bottomLeft,
            ),
            Container(
              height: height * 0.8,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundColor,
                    AppColors.backgroundFadedColor,
                  ],
                  // stops: [0.0, 1],
                ),
              ),
              child: ShowData(_data, _addNewData, _deleteData),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentColor,
        child: Icon(Icons.add),
        onPressed: () => _addNewData(context),
      ),
    );
  }
}
