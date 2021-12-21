import 'package:flutter/foundation.dart';
import 'package:test_app/models/FileHandler.dart';

class Credential extends ChangeNotifier {
  FileHandler _fh = FileHandler('credentials.json');

  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data {
    return {..._data};
  }

  Future<void> fetchAndSetData() async {
    _data = await _fh.readFile();
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(_data);
    notifyListeners();
  }

  Future<void> addData(Map<String, dynamic> content) async {
    _data.addAll(content);
    _fh.write2File(content);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_data);
    notifyListeners();
  }

  Future<void> deleteData(appId) async {
    _data.remove(appId);
    _fh.write2File(_data, override: true);
    print("############################################");
    print(_data);
    notifyListeners();
  }
}
