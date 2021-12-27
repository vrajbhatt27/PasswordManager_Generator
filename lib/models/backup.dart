import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import './passwordGenerator.dart';

class Backup {
  static Directory directory;

  // This method is for initializing external directory.
  static Future<bool> initDir() async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.example.TheCalc/files
          String newPath = "";
          List<String> folders = directory.path.split("/");
          for (var i = 1; i < folders.length; i++) {
            var folder = folders[i];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Calcy";
          directory = Directory(newPath);
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } catch (e) {
      Utils.dispToast('Something Went Wrong !!!');
    }

    if (directory != null) {
      return true;
    }

    return false;
  }

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.restricted) {
        Permission pm2 = Permission.storage;
        result = await pm2.request();
      }
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // Used to save hive data to storage.
  static Future<void> backup(String fname, Map<String, dynamic> content) async {
    try {
      File file;
      if (fname == 'data') {
        file = File(directory.path + '/' + '.' + fname + '.json');
      } else {
        file = File(directory.path + '/' + fname + '.json');
      }
      if (await file.exists()) {
        await file.writeAsString(jsonEncode(content));
      } else {
        await file.create();
        await file.writeAsString(jsonEncode(content));
      }
    } catch (e) {
      Utils.dispToast('Error Occured While Taking Backup');
    }
  }

  // Used to restore all the files from storage to hive.
  static Future restore(String fname) async {
    File file;
    if (fname == 'data') {
      file = File(directory.path + '/' + '.' + fname + '.json');
    } else {
      file = File(directory.path + '/' + fname + '.json');
    }
    if (await file.exists()) {
      return jsonDecode(await file.readAsString());
    }
    return null;
  }
}
