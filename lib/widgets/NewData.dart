import 'package:flutter/material.dart';

class NewData extends StatefulWidget {
  final Function _callWrite2File;
  NewData(this._callWrite2File);
  @override
  _NewData createState() => _NewData();
}

class _NewData extends State<NewData> {
  TextEditingController _appCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _unameCtrl = TextEditingController();
  TextEditingController _pwdCtrl = TextEditingController();
  TextEditingController _mnoCtrl = TextEditingController();

  Map<String, String> appInfo = {};

  void _addData() {
    List<String> keys = ['email', 'userId', 'password', 'mobile no'];
    List<String> values = [
      _emailCtrl.text,
      _unameCtrl.text,
      _pwdCtrl.text,
      _mnoCtrl.text
    ];

    for (var i = 0; i < values.length; i++) {
      if (values[i].isNotEmpty) {
        appInfo[keys[i]] = values[i];
      }
    }

    print(appInfo);
    widget._callWrite2File(_appCtrl.text, appInfo);
  }

  Widget _inputDataTextField(String lbl, TextEditingController ctrl) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: TextField(
        decoration: InputDecoration(
          labelText: lbl,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        controller: ctrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _inputDataTextField('App', _appCtrl),
          _inputDataTextField('email', _emailCtrl),
          _inputDataTextField('user name', _unameCtrl),
          _inputDataTextField('password', _pwdCtrl),
          _inputDataTextField('Mobile Number', _mnoCtrl),
          ElevatedButton(
            onPressed: _addData,
            child: Text(
              'Save',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
