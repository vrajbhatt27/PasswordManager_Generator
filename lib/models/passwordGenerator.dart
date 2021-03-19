import 'dart:math';

void main() {
  String x = GeneratePassword().generatePassword();
  print('\nPassword Generated: '+x);
}

class GeneratePassword {
  List lowerAlphabets = 'abcdefghijklmnopqrstuvwxyz'.split('');
  List upperAlphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
  List nums = '0123456789'.split('');
  List symbols = "!@#\$%^&*(){}<>.?/;:[]".split('');

  List pwd = [];
  List freq = [4, 2, 4, 2];
  List names = ['la', 'ua', 'nums', 'symbols'];
  Map temp = {};


  List getIdentifierList(String text) {
    switch (text) {
      case 'la':
        return lowerAlphabets;
      case 'ua':
        return upperAlphabets;
      case 'nums':
        return nums;
      case 'symbols':
        return symbols;
      default:
        return [];
    }
  }

  String generatePassword() {
    for (var i = 0; i < 4; i++) {
      temp[names[i]] = freq.removeLast();
      freq.shuffle();
    }
    temp.forEach((key, value) {
      List name = getIdentifierList(key);
      int rint;
      for (var i = 0; i < value; i++) {
        rint = Random.secure().nextInt(name.length);
        pwd.add(name[rint]);
      }
    });
    pwd.shuffle();
    return pwd.join();
  }
}
