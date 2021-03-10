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

  String _addId(app) {
    String uniqId = DateTime.now().toString();
    var lst = uniqId.split('');
    lst = lst.where((e) {
      if (e == '-' || e == '.' || e == ':' || e == ' ') {
        return false;
      }
      return true;
    }).toList();
    String id = '';
    for (var e in lst) {
      id += e;
    }

    return app + id;
  }

  void _addData() {
    List<String> keys = ['app', 'email', 'userId', 'password', 'mobile no'];
    List<String> values = [
      _appCtrl.text,
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

    String appId = _addId(_appCtrl.text);

    print(appInfo);

    widget._callWrite2File(appId, appInfo);

    Navigator.of(context).pop();
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
