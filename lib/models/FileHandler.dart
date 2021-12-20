import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class FileHandler {
  String _fname;

  FileHandler(fname) {
    this._fname = fname;
  }

  Future<File> getDir() async {
    Directory _dir = await getApplicationDocumentsDirectory();
    File file = File(_dir.path + '/' + _fname);
    return file;
  }

  // If file not present then creates it and adds the first content in it. Called by write2File() when file doesnot exist.
  void _createFile(File file, Map<String, dynamic> content) {
    print('creating file...!');
    file.createSync();
    file.writeAsStringSync(jsonEncode(content));
  }

  // Writes data to jsonFile
  Future<void> write2File(Map<String, dynamic> content, {bool override = false}) async {
    File file = await getDir();

    if (override) {
      file.writeAsStringSync(jsonEncode(content));
      return;
    }

    bool fexists = file.existsSync();

    if (fexists) {
      print('writing to file...!');
      Map<String, dynamic> jsonfcontent = jsonDecode(file.readAsStringSync());

      jsonfcontent.addAll(content);

      file.writeAsStringSync(jsonEncode(jsonfcontent));
      print('Done Writing.');
    } else {
      print('file doesnot exist...!!!');
      _createFile(file, content);
    }
  }

  Future<Map<String, dynamic>> readFile() async {
    File file = await getDir();
    Map<String, dynamic> content = jsonDecode(file.readAsStringSync());
    return content;
  }

  // // DeleteData from jsonFile.
  // void deleteData(Map<String, dynamic> content) {
  //   getDir().then((file) => );
  // }
}
