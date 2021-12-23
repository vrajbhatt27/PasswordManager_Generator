import 'package:flutter/foundation.dart';
import 'package:test_app/models/hiveHandler.dart';

class Notes extends ChangeNotifier {
  HiveHandler _h = HiveHandler('notes');
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get notesData {
    return {..._data};
  }

  Future<void> fetchAndSetNotesData() async {
    _data = await _h.read();
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    print(_data);
    notifyListeners();
  }

  Future<void> addNotesData(Map<String, dynamic> content) async {
    _data.addAll(content);
    _h.add(_data);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    print(_data);
    notifyListeners();
  }

  // Future<void> deleteData(noteId) async {
  //   _data.remove(appId);
  //   _h.add(_data);
  //   print("############################################");
  //   print(_data);
  //   notifyListeners();
  // }

  // findById(appId) {
  //   if (_data.containsKey(appId)) {
  //     return _data[appId];
  //   }

  //   return null;
  // }
}
