import 'package:flutter/material.dart';

class NewData extends StatefulWidget {
  final Function callWrite2File;
  final data;
  final String appId;

  NewData(this.callWrite2File, {this.data = '', this.appId = ''});
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

  void _addData({String id = ''}) {
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

    String appId =  id.isEmpty ? _addId(_appCtrl.text) : id;

    widget.callWrite2File(appId, appInfo);

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

  List<Widget> get forNewData {
    return [
      _inputDataTextField('App', _appCtrl),
      _inputDataTextField('email', _emailCtrl),
      _inputDataTextField('user name', _unameCtrl),
      _inputDataTextField('password', _pwdCtrl),
      _inputDataTextField('Mobile Number', _mnoCtrl),
    ];
  }

  List<Widget> get forUpdateData {
    Map info = widget.data[widget.appId]; // contains the map of values.
    _appCtrl.text = info['app'];
    if (info.containsKey('email')) _emailCtrl.text = info['email'];
		if (info.containsKey('userId')) _unameCtrl.text = info['userId'];
		if (info.containsKey('password')) _pwdCtrl.text = info['password'];
		if (info.containsKey('mobile no')) _mnoCtrl.text = info['mobile no'];

    return [
      _inputDataTextField('App', _appCtrl),
      _inputDataTextField('email', _emailCtrl),
      _inputDataTextField('user name', _unameCtrl),
      _inputDataTextField('password', _pwdCtrl),
      _inputDataTextField('Mobile Number', _mnoCtrl),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool update = false;

    if (widget.appId.isNotEmpty) {
      update = true;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
					
					if(update)
						...forUpdateData
					else
						...forNewData
					,
					
          ElevatedButton(
            onPressed: update ? () => _addData(id: widget.appId) : _addData,
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
