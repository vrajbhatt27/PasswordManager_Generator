import 'dart:io';
import 'dart:convert';
import 'dart:ui';
// ignore: unused_import
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:clipboard/clipboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import './other/styles.dart';
import './screens/HomePage.dart';
import './models/Security.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
			theme: ThemeData.dark(),
      home: Calculator(),
      routes: {
        HomePage.routeName: (ctx) => HomePage(),
      },
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final globalKey = GlobalKey<ScaffoldState>();
  String exp = '';
  String ans = '';
  bool isEvaluated = false;

	// Evaluates the expression from calculator and returns the ans.
  String evaluate() {
    String inp = exp.replaceAll(RegExp(r'x'), '*');
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
  void actionOnButtonPressed(String text) {
    if (isEvaluated) {
      isEvaluated = false;
      setState(() {
        if (text == '/' ||
            text == 'x' ||
            text == '+' ||
            text == '-' ||
            text == ' mod ') {
          exp = ans;
        } else {
          exp = '';
        }
        ans = '';
      });
    }

    if (text == "AC") {
      setState(() {
        exp = '';
        ans = '';
      });
    } else if (text == "C") {
      if (exp.isNotEmpty) {
        var lst = exp.split('');
        lst.removeLast();
        setState(() {
          exp = lst.join();
        });
      } else {
        setState(() {
          ans = '';
        });
      }
    } else if (text == "=") {
      isEvaluated = true;
      if (exp == "55") { 
				// Opens the HomePage.
        // Navigator.of(context).pushNamed(HomePage.routeName);
        Navigator.of(context).popAndPushNamed(HomePage.routeName);
      } else if (exp == '00') {
        setState(() {
          ans = '';
          exp = '';
        });
				// Opens the drawer for direct password access.
        globalKey.currentState.openEndDrawer();
      } else if (exp.contains("mod")) {
        var lst = exp.split(' ');
        int n1 = int.parse(lst[0]);
        int n2 = int.parse(lst[2]);
        var res = n1 % n2;
        setState(() {
          ans = res.toString();
        });
        // exp = '';
      } else {
        setState(() {
          ans = evaluate();
        });
        // exp = '';
      }
    } else {
      setState(() {
        exp += text;
      });
    }
  }

	// Builds buttons for calculator.
  Widget customButton(String text) {
    return InkWell(
      onTap: () => actionOnButtonPressed(text),
      child: Container(
        margin: EdgeInsets.all(6.0),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            color: Colors.white30),
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
      key: globalKey,
      endDrawer: Drawer( //Opens the drawer for direct password access.
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
        color: Colors.grey[900],
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
                  color: Colors.grey[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(child: Container(), flex: 6),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 5,
                        child: Text(
                          exp,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          ans,
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
                              Flexible(flex: 1, child: customButton("AC")),
                              Flexible(flex: 1, child: customButton("C")),
                              Flexible(flex: 1, child: customButton(" mod ")),
                              Flexible(flex: 1, child: customButton("/"))
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
                              Flexible(flex: 1, child: customButton("7")),
                              Flexible(flex: 1, child: customButton("8")),
                              Flexible(flex: 1, child: customButton("9")),
                              Flexible(flex: 1, child: customButton("x"))
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
                              Flexible(flex: 1, child: customButton("4")),
                              Flexible(flex: 1, child: customButton("5")),
                              Flexible(flex: 1, child: customButton("6")),
                              Flexible(flex: 1, child: customButton("-"))
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
                              Flexible(flex: 1, child: customButton("1")),
                              Flexible(flex: 1, child: customButton("2")),
                              Flexible(flex: 1, child: customButton("3")),
                              Flexible(flex: 1, child: customButton("+"))
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
                              Flexible(flex: 2, child: customButton("0")),
                              Flexible(flex: 1, child: customButton(".")),
                              Flexible(flex: 1, child: customButton("=")),
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
  File _jsonFile;
  Directory _dir;
  bool _fexists = false;
  String _fname = 'data.json';
  Map<String, dynamic> _data = {};

  // Instantiate the _dir and _file and reads data from jsonFile that are shown on screen.
  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      _dir = directory;
      _jsonFile = File(_dir.path + '/' + _fname);
      _fexists = _jsonFile.existsSync();
      if (_fexists) {
        setState(() {
          _data = jsonDecode(_jsonFile.readAsStringSync());
        });
      }
    });
  }

	// Display the toast message when password copied.
  void dispToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.popUpCardColor,
      textColor: AppColors.backgroundColor,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/Images/drawerbg.png"), fit: BoxFit.cover),
      ),
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          String appId =
              _data.keys.elementAt(index); //extract the appId from data.
          String app = _data[appId]['app']; //extract app name from data
          String subtitle;

          // Here for subtitle in listtile, email is shown if it is present else mobile no is shown if it is present else nothing is shown.
          if (_data[appId].containsKey('email')) {
            subtitle = _data[appId]['email'];
          } else if (_data[appId].containsKey('mobile no')) {
            subtitle = _data[appId]['mobile no'];
          } else {
            subtitle = '';
          }

          if (_data[appId].containsKey('password')) {
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
                    String pwd = await decrypt(_data[appId]['password']);
                    FlutterClipboard.copy(pwd);
                    dispToast('Password copied to clipboard');
                  },
                ),
              ),
            );
          }

          return Container();
        },
        itemCount: _data.length,
      ),
    );
  }
}
