import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/credentials.dart';
import '../other/styles.dart';
import '../../models/Security.dart';

class NewData extends StatefulWidget {
  final String appId;

  NewData({this.appId = ''});
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
  FocusNode _appFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _unameFocusNode = FocusNode();
  FocusNode _pwdFocusNode = FocusNode();
  FocusNode _mnoFocusNode = FocusNode();
  FocusNode _otherFocusNode = FocusNode();
  Map<String, dynamic> _appInfo = {};
  bool update = false;
  bool validated = true;
  List<Widget> textFields = [];

  // Used for buttons in bottom sheet. If the textField is present , then to remove it and Vice Versa.
  Map isPressed = {
    'Email': false,
    'userId': false,
    'Password': false,
    'Mobile No': false,
    'Other': false,
  };

  // Checks that if the modal sheet if to be opened for updating data.
  @override
  initState() {
    if (widget.appId.isNotEmpty) {
      update = true;
      _forUpdateData();
    } else {
      _appFocusNode.requestFocus();
    }
    super.initState();
  }

  dispose() {
    _appCtrl.dispose();
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _unameCtrl.dispose();
    _mnoCtrl.dispose();
    _otherCtrl.dispose();

    _appFocusNode.dispose();
    _emailFocusNode.dispose();
    _unameFocusNode.dispose();
    _pwdFocusNode.dispose();
    _mnoFocusNode.dispose();
    _otherFocusNode.dispose();
    super.dispose();
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

  // It calls the _addData of HiveHandler of main.dart. Here first appInfo is set and then appId and appInfo are passed as arg to above function. Here if it is called for update operation then new id is not calculated.
  void _addData({String id = ''}) async {
    String pwd = _pwdCtrl.text;
    String encPwd;

    if (pwd.isNotEmpty) {
      encPwd = await encrypt(pwd);
    } else {
      encPwd = '';
    }

    // Validation for first letter of App name to be capital.
    _appCtrl.text = (_appCtrl.text)
        .replaceRange(0, 1, _appCtrl.text.split('')[0].toUpperCase());

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
      encPwd,
      _mnoCtrl.text,
      _otherCtrl.text,
    ];

    for (var i = 0; i < values.length; i++) {
      if (values[i].isNotEmpty) {
        _appInfo[keys[i]] = values[i];
      }
    }

    String appId = id.isEmpty ? _addId(_appCtrl.text) : id;
    Provider.of<Credential>(context, listen: false).addData({appId: _appInfo});
    Navigator.of(context).pop();
  }

  // It sets the pwCtrl.text to decrypted password so that it can be filled on textField. It is used when operation is update. Here decrypt() is called.
  void _getDecryptedPassword(String cipher) async {
    String pwd = await decrypt(cipher);
    _pwdCtrl.text = pwd;
  }

  // When the modal sheet is used for updating the data this method is called. It creates the textFields with filled content for editing purpose.
  void _forUpdateData() {
    Map info = Provider.of<Credential>(context, listen: false)
        .data[widget.appId]; // contains the map of values.
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
      textFields
          .add(buildTextField(fillContentNames[i], fillContentCtrl[i], null));
      isPressed[fillContentNames[i]] = true;
    }
  }

  // Used to display text on bottom sheet. Widget that returns Text.
  Widget showText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  // Widget that returns TextField.
  Widget buildTextField(String lbl, TextEditingController ctrl, FocusNode fn) {
    TextInputType keyboard;
    if (lbl == 'Email') {
      keyboard = TextInputType.emailAddress;
    } else if (lbl == 'Mobile No') {
      keyboard = TextInputType.phone;
    }

    return TextField(
      key: Key(lbl),
      focusNode: fn,
      controller: ctrl,
      keyboardType: (keyboard == null) ? null : keyboard,
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

  // It is used to build the buttons in bottom sheet for opening textField.
  List<Widget> buildButtons() {
    var icons = [
      Icons.email,
      Icons.account_circle_outlined,
      Icons.security,
      Icons.phone,
      Icons.more_horiz
    ];

    var names = ['Email', 'userId', 'Password', 'Mobile No', 'Other'];
    List<Widget> widLst = [];
    FocusNode fn;

    for (var i = 0; i < 5; i++) {
      widLst.add(
        InkWell(
          onTap: () {
            String name;
            TextEditingController ctrl;
            if (names[i] == 'Email') {
              name = names[i];
              ctrl = _emailCtrl;
              fn = _emailFocusNode;
            } else if (names[i] == 'userId') {
              name = names[i];
              ctrl = _unameCtrl;
              fn = _unameFocusNode;
            } else if (names[i] == 'Password') {
              name = names[i];
              ctrl = _pwdCtrl;
              fn = _pwdFocusNode;
            } else if (names[i] == 'Mobile No') {
              name = names[i];
              ctrl = _mnoCtrl;
              fn = _mnoFocusNode;
            } else if (names[i] == 'Other') {
              name = names[i];
              ctrl = _otherCtrl;
              fn = _otherFocusNode;
            }

            if (isPressed[name] == false)
              add2List(name, ctrl, fn);
            else {
              setState(() {
                ctrl.text = '';
              });
              removeFromList(name);
            }
          },
          child: CircleAvatar(
            child: Icon(
              icons[i],
              //! ### App icon colors
              color: AppColors.backgroundColor,
            ),
            backgroundColor: Color(0xffffe5b4),
          ),
        ),
      );
    }

    return widLst;
  }

  // On button press it adds the respective textfield in the list.
  void add2List(String lbl, TextEditingController ctrl, FocusNode fn) {
    setState(() {
      isPressed[lbl] = true;
      textFields.add(buildTextField(lbl, ctrl, fn));
      fn.requestFocus();
    });
  }

  // On pressing the button if the textField is already present, then this removes it from sheet.
  void removeFromList(String lbl) {
    setState(() {
      isPressed[lbl] = false;
      textFields.removeWhere((e) => e.key == Key(lbl));
    });
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: mediaQueryData.viewInsets,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  showText('App: '),
                  SizedBox(width: 5),
                  Expanded(
                    child: TextField(
                      controller: _appCtrl,
                      focusNode: _appFocusNode,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        hintText: validated ? null : 'Please Enter App Name',
                        hintStyle: TextStyle(color: Colors.red, fontSize: 22),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: update
                        ? () => _addData(id: widget.appId)
                        : () {
                            if (_appCtrl.text.isNotEmpty) {
                              _addData();
                            } else {
                              setState(() {
                                validated = false;
                              });
                            }
                          },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        //! ### Color for text: Add
                        color: AppColors.backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(primary: Color(0xffffe5b4)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
