import 'package:flutter/foundation.dart';
import 'package:test_app/models/hiveHandler.dart';

class Credential extends ChangeNotifier {
  HiveHandler _h = HiveHandler('credentials');
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data {
    return {..._data};
  }

  Future<void> fetchAndSetData() async {
    _data = await _h.read();
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(_data);
    notifyListeners();
  }

  Future<void> addData(Map<String, dynamic> content) async {
    _data.addAll(content);
    _h.add(_data);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_data);
    notifyListeners();
  }

  Future<void> deleteData(appId) async {
    _data.remove(appId);
    _h.add(_data);
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
