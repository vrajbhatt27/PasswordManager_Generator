import 'dart:io';

import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:path_provider/path_provider.dart';

// If not present creates new file key.pem and sets a key. If file is present then used to set new key.
Future<bool> createFile() async {
  Directory dir;
  File file;

  dir = await getApplicationDocumentsDirectory();
  file = File(dir.path + '/' + 'key.pem');
  if (!file.existsSync()) {
    file.createSync();
  }

  final cryptor = new PlatformStringCryptor();
  final String key = await cryptor.generateRandomKey();
  file.writeAsStringSync(key);

  return true;
}

// Encrypts the given password
Future<String> encrypt(String pwd) async {
  Directory dir;
  await getApplicationDocumentsDirectory().then((Directory directory) {
    dir = directory;
  });
  final cryptor = new PlatformStringCryptor();
  File file = File(dir.path + '/' + 'key.pem');
  String key = file.readAsStringSync();
  String cipher = await cryptor.encrypt(pwd, key);
  return cipher;
}

// Decrypts the given password
Future<String> decrypt(String cipher) async {
  Directory dir;
  await getApplicationDocumentsDirectory().then((Directory directory) {
    dir = directory;
  });
  final cryptor = new PlatformStringCryptor();
  File file = File(dir.path + '/' + 'key.pem');
  String key = file.readAsStringSync();
  String pwd;
  try {
    pwd = await cryptor.decrypt(cipher, key);
  } catch (e) {}

  return pwd;
}
