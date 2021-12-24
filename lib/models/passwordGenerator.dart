import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import '../view/other/styles.dart';

class Utils {
  List _lowerAlphabets = 'abcdefghijklmnopqrstuvwxyz'.split('');
  List _upperAlphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  List _nums = '0123456789'.split('');
  List _symbols = "!@#\$%^&*(){}<>.?/;:[]".split('');

  List _pwd = [];
  List _freq = [4, 2, 4, 2];
  List _names = ['la', 'ua', 'nums', 'symbols'];
  Map _temp = {};

  List _getIdentifierList(String text) {
    switch (text) {
      case 'la':
        return _lowerAlphabets;
      case 'ua':
        return _upperAlphabets;
      case 'nums':
        return _nums;
      case 'symbols':
        return _symbols;
      default:
        return [];
    }
  }

  String generatePassword() {
    for (var i = 0; i < 4; i++) {
      _temp[_names[i]] = _freq.removeLast();
      _freq.shuffle();
    }
    _temp.forEach((key, value) {
      List name = _getIdentifierList(key);
      int rint;
      for (var i = 0; i < value; i++) {
        rint = Random.secure().nextInt(name.length);
        _pwd.add(name[rint]);
      }
    });
    _pwd.shuffle();
    return _pwd.join();
  }

  static void dispToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.popUpCardColor,
      textColor: AppColors.backgroundColor,
      fontSize: 16.0,
    );
  }
}
