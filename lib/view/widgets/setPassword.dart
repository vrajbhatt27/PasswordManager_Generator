// Contains Dialog to set password for calc screen.
import 'package:flutter/material.dart';
import 'package:test_app/models/Security.dart';
import 'package:test_app/models/hiveHandler.dart';
import 'package:test_app/view/other/styles.dart';

class SetPassword extends StatefulWidget {
  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final TextEditingController _mainPwdCtrl = TextEditingController();

  final TextEditingController _drawerPwdCtrl = TextEditingController();

  _savePasswords() async {
    String p1 = await encrypt(_mainPwdCtrl.text);
    String p2 = await encrypt(_drawerPwdCtrl.text);

    Map<String, dynamic> pwd = {'p1': p1, 'p2': p2};
    HiveHandler _h = HiveHandler('data');

    Map<String, dynamic> data = await _h.read();
    data.addAll(pwd);

    await _h.add(data);

    print(await _h.read());

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        "Set The Passwords",
        style: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 5,
      backgroundColor: AppColors.popUpCardColor,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            controller: _mainPwdCtrl,
            keyboardType: TextInputType.number,
            style: TextStyle(color: AppColors.backgroundColor, fontSize: 18),
            decoration: InputDecoration(
              labelText: "Password-1 (login)",
              labelStyle: TextStyle(color: Colors.black54, fontSize: 18),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.backgroundColor),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: TextField(
            controller: _drawerPwdCtrl,
            keyboardType: TextInputType.number,
            style: TextStyle(color: AppColors.backgroundColor, fontSize: 18),
            decoration: InputDecoration(
              labelText: "Password-2 (shortcut)",
              labelStyle: TextStyle(color: Colors.black54, fontSize: 18),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.backgroundColor),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: ElevatedButton(
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                    primary: AppColors.backgroundColor),
                onPressed: () async {
                  await _savePasswords();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
