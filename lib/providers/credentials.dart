import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_app/models/FileHandler.dart';

class Credential extends ChangeNotifier {
  File _jsonFile;
  Directory _dir;
  bool _fexists = false;
  String _fname = 'data.json';

  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data {
    return {..._data};
  }

  Future<void> fetchAndSetData() async {
    _dir = await getApplicationDocumentsDirectory();
    _jsonFile = File(_dir.path + '/' + _fname);
    _fexists = _jsonFile.existsSync();
    if (_fexists) {
      _data = jsonDecode(_jsonFile.readAsStringSync());
    }
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(_data);
    notifyListeners();
  }

  Future<void> addData(key, value) async {
    _data[key] = value;
    _dir = await getApplicationDocumentsDirectory();
    _jsonFile = File(_dir.path + '/' + _fname);
    FileHandler fh = FileHandler(_jsonFile);
    fh.write2File(key, value);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_data);
    notifyListeners();
  }

  Future<void> deleteData(appId) async {
    _data.remove(appId);
    FileHandler fh = FileHandler(_jsonFile);
    fh.deleteData(_data);
    print("############################################");
    print(_data);
    notifyListeners();
  }
}
