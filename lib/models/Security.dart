import 'package:encrypt/encrypt.dart' as crypto;
import 'package:test_app/models/hiveHandler.dart';

// If not present creates new key and iv and then calls write2file of FileHandler and creates new file.
Future<bool> createFile() async {
  final key = crypto.Key.fromUtf8('#E6@O`Xp9fD4T(,!^"w:l!V81sMFca2l');
  final iv = crypto.IV.fromLength(16);

  Map<String, dynamic> data = {'key': key.base64, 'iv': iv.base64};

  HiveHandler h = HiveHandler('data');
  await h.add(data);
  return true;
}

// Encrypts the given password
Future encrypt(String pwd) async {
  HiveHandler h = HiveHandler('data');

  Map<String, dynamic> data = await h.read();

  if (data.isEmpty) {
    await createFile();
  }

  data = await h.read();

  print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
  print(data);
  print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");

  final key = crypto.Key.fromBase64(data['key']);
  final iv = crypto.IV.fromBase64(data['iv']);

  final encryptor = crypto.Encrypter(crypto.AES(key));

  String cipher = encryptor.encrypt(pwd, iv: iv).base64;
  print(cipher);
  return cipher;
}

// Decrypts the given password
Future decrypt(String cipher) async {
  HiveHandler h = HiveHandler('data');

  Map<String, dynamic> data = await h.read();

  final key = crypto.Key.fromBase64(data['key']);
  final iv = crypto.IV.fromBase64(data['iv']);

  final encryptor = crypto.Encrypter(crypto.AES(key));

  crypto.Encrypted e = crypto.Encrypted.fromBase64(cipher);

  String pwd = encryptor.decrypt(e, iv: iv);
  print(pwd);
  return pwd;
}

// For secret message.
Future<String> encryptMsg(String msg) async {
  final key =
      crypto.Key.fromBase64("I0U2QE9gWHA5ZkQ0VCgsIV4idzpsIVY4MXNNRmNhMmw=");
  final iv = crypto.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
  final encryptor = crypto.Encrypter(crypto.AES(key));
  String cipher = encryptor.encrypt(msg, iv: iv).base64;
  return cipher;
}

Future<String> decryptMsg(String cipher) async {
  final key =
      crypto.Key.fromBase64("I0U2QE9gWHA5ZkQ0VCgsIV4idzpsIVY4MXNNRmNhMmw=");
  final iv = crypto.IV.fromBase64("AAAAAAAAAAAAAAAAAAAAAA==");
  final encryptor = crypto.Encrypter(crypto.AES(key));
  crypto.Encrypted e = crypto.Encrypted.fromBase64(cipher);
  String msg = encryptor.decrypt(e, iv: iv);
  return msg;
}
