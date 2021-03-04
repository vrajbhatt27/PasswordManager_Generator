// import './widgets/NewData.dart';
import 'dart:io';
import 'dart:convert';
// ignore: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController pwdCtrl = TextEditingController();

  File jsonFile;

  Directory dir;

  String fname = 'data.json';

  bool fexists = false;

  Map<String, dynamic> fcontent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = File(dir.path + '/' + fname);
      fexists = jsonFile.existsSync();
      if (fexists) {
        print('exist in init state');
        this.setState(() {
          fcontent = jsonDecode(jsonFile.readAsStringSync());
        });
      }
    });
  }

  void createFile(Map<String, dynamic> content) {
    print('creating file...!');
    File file = new File(dir.path + '/' + fname);
    file.createSync();
    fexists = true;
    file.writeAsStringSync(jsonEncode(content));
  }

  void write2File(String key, String value) {
    print('writing to file...!');
    Map<String, dynamic> content = {key: value};

    if (fexists) {
      print('file exists.');
      Map<String, dynamic> jsonfcontent =
          jsonDecode(jsonFile.readAsStringSync());

      jsonfcontent.addAll(content);

      jsonFile.writeAsStringSync(jsonEncode(jsonfcontent));
    } else {
      print('file doesnot exist');
      createFile(content);
    }

    this.setState(() {
      fcontent = jsonDecode(jsonFile.readAsStringSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Json Demo'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'email'),
                controller: emailCtrl,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: pwdCtrl,
                decoration: InputDecoration(labelText: 'password'),
              ),
              ElevatedButton(
                onPressed: () => write2File(emailCtrl.text, pwdCtrl.text),
                child: Text('Store'),
                // color: Colors.blue,
                // textColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.blue,
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  child: Text(
                    fcontent.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// 'SingleChildScrollView(
//           child: Column(
//             children: [
//               NewData(),
//             ],
//           ),
//         )'
