import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:test_app/models/FileHandler.dart';

class Credential extends ChangeNotifier {
  FileHandler _fh = FileHandler('credentials.json');
  Box _box;
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data {
    return {..._data};
  }

  Future<void> fetchAndSetData() async {
    _box = await Hive.openBox('credentials');
    if (_box.isNotEmpty) {
      _data = Map<String, dynamic>.from(_box.values.toList()[0]);
    }
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(_data);
    notifyListeners();
  }

  Future<void> addData(Map<String, dynamic> content) async {
    _data.addAll(content);
    _box = await Hive.openBox('credentials');
    _box.put("this", _data);
    // _box.clear();
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_data);
    notifyListeners();
  }

  Future<void> deleteData(appId) async {
    _data.remove(appId);
    _box = await Hive.openBox('credentials');
    _box.put("this", _data);
    print("############################################");
    print(_data);
    notifyListeners();
  }

  findById(appId) {
    if (_data.containsKey(appId)) {
      return _data[appId];
    }

    return null;
  }
}
