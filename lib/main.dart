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
  final globalKey = GlobalKey<ScaffoldState>();
  String exp = '';
  String ans = '';
  bool isEvaluated = false;
  String p1, p2;

  @override
  void initState() {
    super.initState();
    Provider.of<Credential>(context, listen: false).fetchAndSetData();
    Provider.of<Notes>(context, listen: false).fetchAndSetNotesData();
    fetchAndSetPwds();
    Backup.initDir();
  }

  // Sets the p1(main password) and p2(drawer).
  Future<void> fetchAndSetPwds() async {
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
    p1 = await decrypt(data['p1']);
    p2 = await decrypt(data['p2']);
  }

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
      if (exp == p1) {
        // Opens the HomePage.
        // Navigator.of(context).pushNamed(HomePage.routeName);
        Navigator.of(context).popAndPushNamed(HomePage.routeName);
      } else if (exp == p2) {
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
      key: globalKey,
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