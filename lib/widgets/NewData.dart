import 'package:flutter/material.dart';
import '../models/Security.dart';

class NewData extends StatefulWidget {
  final Function _callWrite2File;
  final data;
  final String appId;

  NewData(this._callWrite2File, {this.data = '', this.appId = ''});
  @override
  _NewData createState() => _NewData();
}

class _NewData extends State<NewData> {
  TextEditingController _appCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _unameCtrl = TextEditingController();
  TextEditingController _pwdCtrl = TextEditingController();
  TextEditingController _mnoCtrl = TextEditingController();
  TextEditingController _otherCtrl = TextEditingController();

  Map<String, String> _appInfo = {};
  bool update = false;
  List<Widget> textFields = [];
  Map isPressed = {
    'Email': false,
    'userId': false,
    'Password': false,
    'Mobile No': false,
    'Other': false,
  };

  @override
  initState() {
    if (widget.appId.isNotEmpty) {
      update = true;
      _forUpdateData();
    }
    super.initState();
  }

  // returns a unique id for appId:appInfo in jsonFile. This acts as appId.
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

  // It calls the _callWrite2File() of main.dart. Here first appInfo is set and then appId and appInfo are passed as arg to above function. Here if it is called for update operation then new id is not calculated.
  void _addData({String id = ''}) async {
    String pwd = _pwdCtrl.text;
    String encPwd;
    if (pwd.isNotEmpty) encPwd = await encrypt(pwd);

    print('(In NewData)cipher text--> ' + encPwd.toString());

    List<String> keys = [
      'app',
      'email',
      'userId',
      'password',
      'mobile no',
      'other',
    ];
    List<String> values = [
      _appCtrl.text,
      _emailCtrl.text,
      _unameCtrl.text,
      if (encPwd != null) encPwd,
      _mnoCtrl.text,
      _otherCtrl.text,
    ];

    for (var i = 0; i < values.length; i++) {
      if (values[i].isNotEmpty) {
        _appInfo[keys[i]] = values[i];
      }
    }

    String appId = id.isEmpty ? _addId(_appCtrl.text) : id;

    widget._callWrite2File(appId, _appInfo);
    print('-------------\n');
    print(appId);
    print(_appInfo);
    print('-------------\n');
    Navigator.of(context).pop();
  }

  // It sets the pwCtrl.text to decrypted password so that it can be filled on textField. It is used when operation is update. Here decrypt() is called.
  void _getDecryptedPassword(String cipher) async {
    String pwd = await decrypt(cipher);
    _pwdCtrl.text = pwd;
  }

  void _forUpdateData() {
    Map info = widget.data[widget.appId]; // contains the map of values.
    _appCtrl.text = info['app'];

    List<String> fillContentNames = [];
    List<TextEditingController> fillContentCtrl = [];
    if (info.containsKey('email')) {
      _emailCtrl.text = info['email'];
      fillContentNames.add('Email');
      fillContentCtrl.add(_emailCtrl);
    }
    if (info.containsKey('userId')) {
      _unameCtrl.text = info['userId'];
      fillContentNames.add('userId');
      fillContentCtrl.add(_unameCtrl);
    }
    if (info.containsKey('password')) {
      _getDecryptedPassword(info['password']);
      fillContentNames.add('Password');
      fillContentCtrl.add(_pwdCtrl);
    }
    if (info.containsKey('mobile no')) {
      _mnoCtrl.text = info['mobile no'];
      fillContentNames.add('Mobile No');
      fillContentCtrl.add(_mnoCtrl);
    }
    if (info.containsKey('other')) {
      _otherCtrl.text = info['other'];
      fillContentNames.add('Other');
      fillContentCtrl.add(_otherCtrl);
    }

    for (var i = 0; i < fillContentNames.length; i++) {
      textFields.add(buildTextField(fillContentNames[i], fillContentCtrl[i]));
      isPressed[fillContentNames[i]] = true;
    }
  }

  Widget showText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget buildTextField(String lbl, TextEditingController ctrl) {
    return TextField(
      key: Key(lbl),
      controller: ctrl,
      style: TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: lbl,
        labelStyle: TextStyle(color: Colors.white, fontSize: 18),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> buildButtons() {
    var icons = [
      Icons.email,
      Icons.account_circle_outlined,
      Icons.lock_outline,
      Icons.phone,
      Icons.more_horiz
    ];

    var names = ['Email', 'userId', 'Password', 'Mobile No', 'Other'];
    List<Widget> widLst = [];

    for (var i = 0; i < 5; i++) {
      widLst.add(InkWell(
        onTap: () {
          String name;
          TextEditingController ctrl;
          if (names[i] == 'Email') {
            name = names[i];
            ctrl = _emailCtrl;
          } else if (names[i] == 'userId') {
            name = names[i];
            ctrl = _unameCtrl;
          } else if (names[i] == 'Password') {
            name = names[i];
            ctrl = _pwdCtrl;
          } else if (names[i] == 'Mobile No') {
            name = names[i];
            ctrl = _mnoCtrl;
          } else if (names[i] == 'Other') {
            name = names[i];
            ctrl = _otherCtrl;
          }

          if (isPressed[name] == false)
            add2List(name, ctrl);
          else {
            setState(() {
              ctrl.text = '';
            });
            removeFromList(name);
          }
        },
        child: CircleAvatar(
          child: Icon(icons[i]),
          backgroundColor: Color(0xffffe5b4),
        ),
      ));
    }

    return widLst;
  }

  void add2List(String lbl, TextEditingController ctrl) {
    setState(() {
      isPressed[lbl] = true;
      textFields.add(buildTextField(lbl, ctrl));
    });
  }

  void removeFromList(String lbl) {
    setState(() {
      isPressed[lbl] = false;
      textFields.removeWhere((e) => e.key == Key(lbl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              showText('App: '),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: _appCtrl,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buildButtons(),
          ),
          Divider(
            color: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: textFields,
              ),
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          ElevatedButton(
            onPressed: update ? () => _addData(id: widget.appId) : _addData,
            child: Text(
              'Add',
              style: TextStyle(
                color: Color(0xff1F2426),
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(primary: Color(0xffffe5b4)),
          ),
        ],
      ),
    );
  }
}