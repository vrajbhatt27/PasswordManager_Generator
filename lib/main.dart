import 'dart:io';
import 'dart:ui';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import './models/hiveHandler.dart';
import './models/passwordGenerator.dart';
import './providers/credentials.dart';
import './providers/notes.dart';
import './view/settingsPage.dart';
import './view/widgets/newNote.dart';
import './view/widgets/setPassword.dart';
import './view/other/styles.dart';
import './view/HomePage.dart';
import './models/Security.dart';
import './models/backup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Credential()),
        ChangeNotifierProvider(create: (ctx) => Notes()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Calculator(),
        routes: {
          HomePage.routeName: (ctx) => HomePage(),
          SettingsPage.routeName: (ctx) => SettingsPage(),
          NewNote.routeName: (ctx) => NewNote(),
        },
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _globalKey = GlobalKey<ScaffoldState>();
  String _exp = '';
  String _ans = '';
  bool _isEvaluated = false;
  String _p1, _p2;

  @override
  void initState() {
    super.initState();
    Provider.of<Credential>(context, listen: false).fetchAndSetData();
    Provider.of<Notes>(context, listen: false).fetchAndSetNotesData();
    _fetchAndSetPwds();
    Backup.initDir();
  }

  // Sets the p1(main password) and p2(drawer).
  Future<void> _fetchAndSetPwds() async {
    HiveHandler h = HiveHandler('login');

    // If the user is newly installed then dialog is shown to set p1 and p2.
    if (await h.hiveEmpty()) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SetPassword();
        },
      );
    }

    Map<String, dynamic> data = await h.read();
    _p1 = await decrypt(data['p1']);
    _p2 = await decrypt(data['p2']);
  }

  // Evaluates the expression from calculator and returns the ans.
  String _evaluate() {
    String inp = _exp.replaceAll(RegExp(r'x'), '*');
    String val;

    try {
      Parser p = Parser();
      Expression expression = p.parse(inp);
      ContextModel cm = ContextModel();
      val = (expression.evaluate(EvaluationType.REAL, cm)).toString();
    } catch (e) {
      val = 'Error';
    }

    if (val.endsWith('.0')) {
      val = val.split('.')[0];
    }

    return val;
  }

  // Specifies action for each button on calculator.
  void _actionOnButtonPressed(String text) {
    if (_isEvaluated) {
      _isEvaluated = false;
      setState(() {
        if (text == '/' ||
            text == 'x' ||
            text == '+' ||
            text == '-' ||
            text == ' mod ') {
          _exp = _ans;
        } else {
          _exp = '';
        }
        _ans = '';
      });
    }

    if (text == "AC") {
      setState(() {
        _exp = '';
        _ans = '';
      });
    } else if (text == "C") {
      if (_exp.isNotEmpty) {
        var lst = _exp.split('');
        lst.removeLast();
        setState(() {
          _exp = lst.join();
        });
      } else {
        setState(() {
          _ans = '';
        });
      }
    } else if (text == "=") {
      _isEvaluated = true;
      if (_exp == _p1) {
        // Opens the HomePage.
        // Navigator.of(context).pushNamed(HomePage.routeName);
        Navigator.of(context).popAndPushNamed(HomePage.routeName);
      } else if (_exp == _p2) {
        setState(() {
          _ans = '';
          _exp = '';
        });
        // Opens the drawer for direct password access.
        _globalKey.currentState.openEndDrawer();
      } else if (_exp.contains("mod")) {
        var lst = _exp.split(' ');
        int n1 = int.parse(lst[0]);
        int n2 = int.parse(lst[2]);
        var res = n1 % n2;
        setState(() {
          _ans = res.toString();
        });
        // exp = '';
      } else {
        setState(() {
          _ans = _evaluate();
        });
        // exp = '';
      }
    } else {
      setState(() {
        _exp += text;
      });
    }
  }

  // Builds buttons for calculator.
  Widget _customButton(String text) {
    return InkWell(
      onTap: () => _actionOnButtonPressed(text),
      child: Container(
        margin: EdgeInsets.all(6.0),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: AppColors.bgtColor),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 26.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      endDrawer: Drawer(
        //Opens the drawer for direct password access.
        child: BackdropFilter(
          child: DrawerContent(),
          filter: ImageFilter.blur(
            sigmaX: 10,
            sigmaY: 10,
          ),
        ),
        elevation: 30,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: Container(), flex: 6),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 5,
                        child: Text(
                          _exp,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _ans,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  // color: Colors.black,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(flex: 1, child: _customButton("AC")),
                              Flexible(flex: 1, child: _customButton("C")),
                              Flexible(flex: 1, child: _customButton(" mod ")),
                              Flexible(flex: 1, child: _customButton("/"))
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(flex: 1, child: _customButton("7")),
                              Flexible(flex: 1, child: _customButton("8")),
                              Flexible(flex: 1, child: _customButton("9")),
                              Flexible(flex: 1, child: _customButton("x"))
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(flex: 1, child: _customButton("4")),
                              Flexible(flex: 1, child: _customButton("5")),
                              Flexible(flex: 1, child: _customButton("6")),
                              Flexible(flex: 1, child: _customButton("-"))
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(flex: 1, child: _customButton("1")),
                              Flexible(flex: 1, child: _customButton("2")),
                              Flexible(flex: 1, child: _customButton("3")),
                              Flexible(flex: 1, child: _customButton("+"))
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: new Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(flex: 2, child: _customButton("0")),
                              Flexible(flex: 1, child: _customButton(".")),
                              Flexible(flex: 1, child: _customButton("=")),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Class that shows the drawer content.
class DrawerContent extends StatefulWidget {
  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Images/drawerbg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Consumer<Credential>(
        builder: (ctx, credential, _) => ListView.builder(
          itemBuilder: (ctx, index) {
            String appId = credential.data.keys
                .elementAt(index); //extract the appId from data.
            String app =
                credential.data[appId]['app']; //extract app name from data
            String subtitle;

            // Here for subtitle in listtile, email is shown if it is present else mobile no is shown if it is present else nothing is shown.
            if (credential.data[appId].containsKey('email')) {
              subtitle = credential.data[appId]['email'];
            } else if (credential.data[appId].containsKey('mobile no')) {
              subtitle = credential.data[appId]['mobile no'];
            } else {
              subtitle = '';
            }

            if (credential.data[appId].containsKey('password')) {
              return Card(
                color: Colors.transparent,
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                child: ListTile(
                  title: Text(
                    app,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                    ),
                  ),
                  trailing: IconButton(
                    color: Colors.white60,
                    icon: Icon(Icons.copy),
                    onPressed: () async {
                      String pwd =
                          await decrypt(credential.data[appId]['password']);
                      FlutterClipboard.copy(pwd);
                      Utils.dispToast('Password copied to clipboard');
                    },
                  ),
                ),
              );
            }

            return Container();
          },
          itemCount: credential.data.length,
        ),
      ),
    );
  }
}