import 'package:hive/hive.dart';
import './passwordGenerator.dart';
import './backup.dart';

class HiveHandler {
  String _fname;

  HiveHandler(fname) {
    this._fname = fname;
  }

  // returns true if hive is empty.
  Future<bool> hiveEmpty() async {
    Box box = await Hive.openBox(_fname);
    return box.isEmpty;
  }

  // Writes data to Hive.
  Future<void> add(Map<String, dynamic> content, {bool backUp = true}) async {
    Box box = await Hive.openBox(_fname);
    box.put("this", content);
    // If Backup is false then only hive will be created and not the file in storage.
    if (backUp) {
      Backup.backup(_fname, content);
    }
  }

  Future<Map<String, dynamic>> read() async {
    Map<String, dynamic> content = {};
    Box box = await Hive.openBox(_fname);
    if (box.isNotEmpty) {
      content = Map<String, dynamic>.from(box.values.toList()[0]);
    }
    return content;
  }

  static Future<void> restoreData() async {
    List<String> fnames = ['credentials', 'data', 'notes'];
    Box box;
    Map<String, dynamic> data = {};
    var res;
    for (var fname in fnames) {
      res = await Backup.restore(fname);
      if (res == null) {
        Utils.dispToast('File Not Found');
        continue;
      }

      data = Map<String, dynamic>.from(res);
      box = await Hive.openBox(fname);
      box.put("this", data);
    }
  }
}
