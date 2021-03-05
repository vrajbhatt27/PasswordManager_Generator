import 'dart:io';
import 'dart:convert';

class FileHandler {
  File _jsonFile;

  FileHandler(this._jsonFile);

  void _createFile(Map<String, dynamic> content) {
    print('creating file...!');
    _jsonFile.createSync();
    _jsonFile.writeAsStringSync(jsonEncode(content));
  }

  void write2File(String key, dynamic value) {
    Map<String, dynamic> content = {key: value};

    bool fexists = _jsonFile.existsSync();

    if (fexists) {
      print('writing to file...!');
      Map<String, dynamic> jsonfcontent =
          jsonDecode(_jsonFile.readAsStringSync());

      jsonfcontent.addAll(content);

      _jsonFile.writeAsStringSync(jsonEncode(jsonfcontent));
      print('Done Writing.');
    } else {
      print('file doesnot exist...!!!');
      _createFile(content);
    }
  }
}
