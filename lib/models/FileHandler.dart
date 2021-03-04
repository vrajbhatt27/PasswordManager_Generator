import 'dart:io';
import 'dart:convert';

class FileHandler {
  File jsonFile;
  Map<String, dynamic> data;

  FileHandler(this.jsonFile);

  void createFile(Map<String, dynamic> content) {
    print('creating file...!');
    jsonFile.createSync();
    jsonFile.writeAsStringSync(jsonEncode(content));
  }

  void write2File(String key, dynamic value) {
    Map<String, dynamic> content = {key: value};

    bool fexists = jsonFile.existsSync();

    if (fexists) {
      print('writing to file...!');
      Map<String, dynamic> jsonfcontent =
          jsonDecode(jsonFile.readAsStringSync());

      jsonfcontent.addAll(content);

      jsonFile.writeAsStringSync(jsonEncode(jsonfcontent));
      print('Done Writing.');
    } else {
      print('file doesnot exist...!!!');
      createFile(content);
    }
  }
}
