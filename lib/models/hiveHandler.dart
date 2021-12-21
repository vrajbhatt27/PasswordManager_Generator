import 'package:hive/hive.dart';

class HiveHandler {
  String _fname;
  Box _box;

  HiveHandler(fname) {
    this._fname = fname;
  }

  // Writes data to Hive
  Future<void> add(Map<String, dynamic> content) async {
    _box = await Hive.openBox(_fname);
    _box.put("this", content);
    // _box.clear();
  }

  Future<Map<String, dynamic>> read() async {
    Map<String, dynamic> content = {};
    _box = await Hive.openBox(_fname);
    if (_box.isNotEmpty) {
      content = Map<String, dynamic>.from(_box.values.toList()[0]);
    }
    return content;
  }
}
