import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Backup {
  static Directory directory;

  // This method is for initializing external directory.
  static Future<void> initDir() async {
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.manageExternalStorage)) {
          directory = await getExternalStorageDirectory();
          // /storage/emulated/0/Android/data/com.example.clinic/files
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
          newPath = newPath + "/TheCalc";
          directory = Directory(newPath);
          print("VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV");
          print(directory.path);
        } else {
          return false;
        }
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    print("Here 1");
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

  static Future<void> backup(String fname, Map<String, dynamic> content) async {
    if (content.isNotEmpty) {
      try {
        File file = File(directory.path + '/' + fname + '.json');
        if (await file.exists()) {
          await file.writeAsString(jsonEncode(content));
          print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
          print("Backup Done");
        } else {
          await file.create();
          print("-----------------Backup File created.....");
          await file.writeAsString(jsonEncode(content));
          print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
          print("Backup Done");
        }
      } catch (e) {
        print(e);
      }
    }
  }

  static Future restore(String fname) async {
    File file = File(directory.path + '/' + fname + '.json');
    if (await file.exists()) {
      return jsonDecode(await file.readAsString());
    }
    return null;
  }
}
